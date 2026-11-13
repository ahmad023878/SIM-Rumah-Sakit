<?php
/**
 * Portal publik Registrasi Pasien & Ambil Nomor Antrean.
 *
 * File baru/additive: tidak mengubah modul registrasi/admin lama,
 * appointment lama, maupun alur pelayanan yang sudah ada.
 */
session();
require_once __DIR__ . '/include/config.php';
require_once __DIR__ . '/admin/modules/module_bootstrap.php';
require_once __DIR__ . '/admin/modules/simrs_integration_bootstrap.php';
hms_int_bootstrap($con);

$flash = hms_get_flash();
$registered = null;
$queueTicket = null;

function public_clean_phone($value)
{
    return preg_replace('/\D+/', '', (string)$value);
}

function public_normalize_name($value)
{
    return trim(preg_replace('/\s+/', ' ', (string)$value));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    hms_verify_csrf();
    $action = $_POST['action'] ?? '';

    try {
        if ($action === 'register_patient') {
            $name = public_normalize_name($_POST['patient_name'] ?? '');
            $nik = preg_replace('/\D+/', '', (string)($_POST['nik'] ?? ''));
            $phone = public_clean_phone($_POST['phone'] ?? '');
            $email = trim($_POST['email'] ?? '');
            $gender = trim($_POST['gender'] ?? '');
            $age = (int)($_POST['age'] ?? 0);
            $address = trim($_POST['address'] ?? '');

            if ($name === '') {
                throw new RuntimeException('Nama pasien wajib diisi.');
            }
            if ($phone === '' || strlen($phone) < 8) {
                throw new RuntimeException('Nomor HP wajib diisi dengan benar.');
            }
            if ($email !== '' && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
                throw new RuntimeException('Format email tidak valid.');
            }
            if (!in_array($gender, array('', 'male', 'female', 'other'), true)) {
                $gender = '';
            }
            if ($age < 0 || $age > 120) {
                throw new RuntimeException('Umur pasien tidak valid.');
            }

            // Cegah pendaftaran ganda berdasarkan NIK bila NIK diisi.
            if ($nik !== '') {
                $dup = hms_fetch_one(
                    $con,
                    "SELECT ID,PatientName,medical_record_no FROM tblpatient
                     WHERE PatientMedhis LIKE ? LIMIT 1",
                    's',
                    array('%NIK: ' . $nik . '%')
                );
                if ($dup) {
                    throw new RuntimeException(
                        'NIK sudah terdaftar sebagai pasien ' .
                        ($dup['PatientName'] ?: '') . '. Gunakan menu Ambil Nomor Antrean.'
                    );
                }
            }

            $medhis = $nik !== '' ? 'NIK: ' . $nik : '';
            $phoneNum = (int)$phone;

            mysqli_begin_transaction($con);
            $st = mysqli_prepare(
                $con,
                'INSERT INTO tblpatient(Docid,PatientName,PatientContno,PatientEmail,PatientGender,PatientAdd,PatientAge,PatientMedhis,CreationDate)
                 VALUES(NULL,?,?,?,?,?,?,?,NOW())'
            );
            if (!$st) {
                throw new RuntimeException('Gagal menyiapkan pendaftaran pasien.');
            }
            mysqli_stmt_bind_param(
                $st,
                'sisssis',
                $name,
                $phoneNum,
                $email,
                $gender,
                $address,
                $age,
                $medhis
            );
            if (!mysqli_stmt_execute($st)) {
                mysqli_stmt_close($st);
                throw new RuntimeException('Gagal menyimpan pasien baru.');
            }
            $pid = mysqli_stmt_insert_id($st);
            mysqli_stmt_close($st);

            $mrn = 'RM' . date('Y') . str_pad((string)$pid, 6, '0', STR_PAD_LEFT);
            hms_execute(
                $con,
                'UPDATE tblpatient SET medical_record_no=? WHERE ID=?',
                'si',
                array($mrn, $pid)
            );

            mysqli_commit($con);

            hms_module_audit(
                $con,
                'CREATE',
                'REGISTRASI_PUBLIK',
                'tblpatient',
                $pid,
                'Pasien baru mendaftar melalui portal publik',
                null,
                array('medical_record_no' => $mrn, 'name' => $name)
            );

            $registered = array(
                'name' => $name,
                'mrn' => $mrn,
                'phone' => $phone
            );
            hms_set_flash(
                'success',
                'Registrasi pasien berhasil. No. RM: ' . $mrn .
                '. Simpan No. RM tersebut untuk mengambil nomor antrean.'
            );
        }

        if ($action === 'take_queue') {
            $mrn = strtoupper(trim($_POST['medical_record_no'] ?? ''));
            $phone = public_clean_phone($_POST['phone'] ?? '');
            $scheduleId = (int)($_POST['schedule_id'] ?? 0);
            $serviceDate = trim($_POST['service_date'] ?? date('Y-m-d'));

            if ($mrn === '' || $phone === '' || strlen($phone) < 8) {
                throw new RuntimeException('No. RM dan nomor HP wajib diisi.');
            }
            if ($scheduleId <= 0 || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $serviceDate)) {
                throw new RuntimeException('Tanggal dan jadwal dokter wajib dipilih.');
            }
            if ($serviceDate < date('Y-m-d')) {
                throw new RuntimeException('Tanggal pelayanan tidak boleh sebelum hari ini.');
            }

            $patient = hms_fetch_one(
                $con,
                'SELECT ID,PatientName,medical_record_no,PatientContno FROM tblpatient WHERE medical_record_no=? AND PatientContno=? LIMIT 1',
                'si', array($mrn, (int)$phone)
            );
            if (!$patient) throw new RuntimeException('Data pasien tidak ditemukan. Periksa No. RM dan nomor HP.');

            $day = (int)date('w', strtotime($serviceDate));
            mysqli_begin_transaction($con);
            $schedule = hms_fetch_one($con,
                "SELECT s.*,COALESCE(NULLIF(p.poli_name,''),d.specilization,'Poli Umum') AS poli_name,d.doctorName FROM hms_doctor_schedules s
                 LEFT JOIN hms_master_poli p ON p.id=s.poli_id
                 JOIN doctors d ON d.id=s.doctor_id
                 WHERE s.id=? AND s.is_active=1 AND (p.id IS NULL OR p.is_active=1)
                   AND (
                       (s.available_date IS NOT NULL AND DATE(s.available_date)=?)
                       OR ((s.available_date IS NULL OR DATE(s.available_date)='0000-00-00') AND s.day_of_week=?)
                   )
                 FOR UPDATE",
                'isi', array($scheduleId,$serviceDate,$day)
            );
            if (!$schedule) throw new RuntimeException('Jadwal dokter tidak aktif atau tidak tersedia pada tanggal tersebut.');

            $used = (int)hms_scalar($con,
                "SELECT COUNT(*) FROM hms_visit_schedules vs JOIN hms_patient_visits v ON v.id=vs.visit_id
                 WHERE vs.schedule_id=? AND vs.service_date=? AND v.status<>'BATAL'",
                'is', array($scheduleId,$serviceDate)
            );
            if ($used >= (int)$schedule['quota']) throw new RuntimeException('Kuota jadwal dokter sudah penuh. Silakan pilih jadwal lain.');

            $existing = hms_fetch_one($con,
                "SELECT v.id,v.registration_no,v.queue_no,v.poli,v.status
                 FROM hms_patient_visits v JOIN hms_visit_schedules vs ON vs.visit_id=v.id
                 WHERE v.patient_id=? AND vs.schedule_id=? AND vs.service_date=?
                   AND v.status IN ('MENUNGGU','DIPANGGIL','DILAYANI') LIMIT 1",
                'iis', array((int)$patient['ID'],$scheduleId,$serviceDate)
            );
            if ($existing) {
                mysqli_commit($con);
                $queueTicket = array('registration_no'=>$existing['registration_no'],'queue_no'=>$existing['queue_no'],
                    'poli'=>$existing['poli'],'patient_name'=>$patient['PatientName'],'mrn'=>$patient['medical_record_no'],'existing'=>true);
                hms_set_flash('warning','Pasien sudah memiliki antrean aktif pada jadwal tersebut: '.$existing['queue_no']);
            } else {
                $regNo = hms_module_next_code($con, 'hms_patient_visits', 'REG', 'id');
                $queueNo = hms_module_next_queue($con, $schedule['poli_name'], $serviceDate);
                $mrType = 'LAMA'; $doctorId = (int)$schedule['doctor_id']; $poliName = (string)$schedule['poli_name'];
                $st = mysqli_prepare($con,
                    "INSERT INTO hms_patient_visits
                    (patient_id,mr_type,registration_no,visit_date,visit_type,poli,doctor_id,queue_no,source,status,registration_counter,arrived_at)
                    VALUES(?,?,?,?,'RAWAT_JALAN',?,?,?,'ONLINE','MENUNGGU','Portal Publik',NULL)"
                );
                if (!$st) throw new RuntimeException('Gagal menyiapkan nomor antrean.');
                $patientId = (int)$patient['ID'];
                mysqli_stmt_bind_param($st,'issssis',$patientId,$mrType,$regNo,$serviceDate,$poliName,$doctorId,$queueNo);
                if (!mysqli_stmt_execute($st)) { mysqli_stmt_close($st); throw new RuntimeException('Nomor antrean gagal dibuat.'); }
                $visitId = mysqli_stmt_insert_id($st); mysqli_stmt_close($st);
                $st = mysqli_prepare($con,'INSERT INTO hms_visit_schedules(visit_id,schedule_id,service_date,quota_snapshot) VALUES(?,?,?,?)');
                if (!$st) throw new RuntimeException('Gagal mengaitkan antrean dengan jadwal dokter.');
                $quotaSnapshot = (int)$schedule['quota'];
                mysqli_stmt_bind_param($st,'iisi',$visitId,$scheduleId,$serviceDate,$quotaSnapshot);
                if (!mysqli_stmt_execute($st)) { mysqli_stmt_close($st); throw new RuntimeException('Relasi antrean dan jadwal gagal disimpan.'); }
                mysqli_stmt_close($st);
                mysqli_commit($con);
                hms_module_audit($con,'CREATE','ANTREAN_PUBLIK','hms_patient_visits',$visitId,'Antrean publik dibuat dari jadwal dokter.',null,
                    array('registration_no'=>$regNo,'queue_no'=>$queueNo,'poli'=>$poliName,'doctor_id'=>$doctorId,'schedule_id'=>$scheduleId,'service_date'=>$serviceDate));
                hms_module_workflow_event($con,(int)$patient['ID'],$visitId,null,null,'ANTRIAN','MENUNGGU','Antrean '.$queueNo.' dibuat untuk '.$schedule['doctorName'].'.');
                $queueTicket = array('registration_no'=>$regNo,'queue_no'=>$queueNo,'poli'=>$poliName,
                    'patient_name'=>$patient['PatientName'],'mrn'=>$patient['medical_record_no'],'existing'=>false);
                hms_set_flash('success','Nomor antrean '.$queueNo.' berhasil dibuat untuk '.$schedule['doctorName'].' pada '.$serviceDate.'.');
            }
        }
    } catch (Throwable $e) {
        if ($con && mysqli_get_connection_stats($con) !== false) {
            // Rollback is harmless if no transaction is active.
            @mysqli_rollback($con);
        }
        hms_set_flash('danger', $e->getMessage());
    }

    $flash = hms_get_flash();
}

$publicSchedules = hms_fetch_all($con,
    "SELECT s.id,s.poli_id,s.doctor_id,s.day_of_week,
            CASE WHEN s.available_date IS NULL OR DATE(s.available_date)='0000-00-00' THEN '' ELSE DATE_FORMAT(s.available_date,'%Y-%m-%d') END AS available_date,
            s.start_time,s.end_time,s.quota,
            COALESCE(NULLIF(p.poli_name,''), NULLIF(d.specilization,''), 'Poli belum dipetakan') AS poli_name,
            d.doctorName,d.specilization
     FROM hms_doctor_schedules s
     LEFT JOIN hms_master_poli p ON p.id=s.poli_id
     INNER JOIN doctors d ON d.id=s.doctor_id
     WHERE s.is_active=1 AND (p.id IS NULL OR p.is_active=1)
     ORDER BY s.id ASC,poli_name,s.day_of_week,s.start_time,d.doctorName");

// Riwayat sinkronisasi lama dapat meninggalkan beberapa baris jadwal yang identik.
// Tampilkan satu pilihan per kombinasi dokter/poli/tanggal/hari/jam/kuota; data DB tidak dihapus.
$publicScheduleUnique = array();
foreach ($publicSchedules as $scheduleRow) {
    // Identitas poli berdasarkan nama yang tampil, bukan hanya poli_id.
    // Data sinkronisasi lama bisa memiliki poli_id NULL dan poli_id terisi,
    // padahal keduanya mewakili poli/dokter/jam yang sama.
    $uniqueKey = implode('|', array(
        strtolower(trim((string)($scheduleRow['poli_name'] ?? ''))),
        (string)$scheduleRow['doctor_id'],
        (string)$scheduleRow['day_of_week'],
        (string)($scheduleRow['available_date'] ?? ''),
        substr((string)$scheduleRow['start_time'], 0, 8),
        substr((string)$scheduleRow['end_time'], 0, 8),
        (string)$scheduleRow['quota']
    ));
    if (!isset($publicScheduleUnique[$uniqueKey])) $publicScheduleUnique[$uniqueKey] = $scheduleRow;
}
$publicSchedules = array_values($publicScheduleUnique);
?>
<!doctype html>
<html lang="id">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Registrasi Pasien & Antrean - SIMRS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<style>
body{background:#f5f8fb;color:#17324d}
.public-top{background:#fff;border-bottom:1px solid #dce6ee}
.brand{font-weight:700;color:#17324d}
.hero-mini{background:linear-gradient(135deg,#e9fbfb,#f8fbff);padding:42px 0}
.card-soft{border:1px solid #d9e5ed;border-radius:18px;box-shadow:0 10px 28px rgba(16,55,80,.06)}
.icon-box{width:48px;height:48px;border-radius:12px;background:#e6fffb;color:#127c8a;display:flex;align-items:center;justify-content:center;font-size:22px}
.queue-number{font-size:4rem;font-weight:800;letter-spacing:2px;color:#127c8a}
.small-muted{color:#667085}
</style>
</head>
<body>
<nav class="navbar public-top">
<div class="container py-2">
    <a class="navbar-brand brand" href="../">
        <i class="bi bi-hospital me-2"></i>SIMRS
        <small class="d-block text-muted" style="font-size:.72rem">Sistem Informasi Manajemen Rumah Sakit</small>
    </a>
    <div class="d-flex gap-2">
        <a class="btn btn-outline-primary" href="../">Beranda</a>
        <a class="btn btn-outline-secondary" href="user-login.php">Login Pasien</a>
    </div>
</div>
</nav>

<header class="hero-mini">
<div class="container">
    <div class="row align-items-center g-4">
        <div class="col-lg-8">
            <div class="text-uppercase small fw-bold text-primary mb-2">Layanan Publik</div>
            <h1 class="display-6 fw-bold">Registrasi Pasien & Ambil Nomor Antrean</h1>
            <p class="lead mb-0"></p></div>
        <div class="col-lg-4 text-lg-end">
            <a href="#registrasi" class="btn btn-primary me-1">Registrasi Pasien</a>
            <a href="#antrian" class="btn btn-outline-primary">Ambil Antrean</a>
        </div>
    </div>
</div>
</header>

<main class="container py-5">
<?php if ($flash) { ?>
    <div class="alert alert-<?php echo hms_e($flash['type'] === 'error' ? 'danger' : $flash['type']); ?> alert-dismissible fade show">
        <?php echo hms_e($flash['message']); ?>
        <button class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<?php } ?>

<?php if ($registered) { ?>
<div class="alert alert-success card-soft" role="alert">
    <strong>Registrasi berhasil.</strong><br>
    Nama: <?php echo hms_e($registered['name']); ?><br>
    <strong>No. RM: <?php echo hms_e($registered['mrn']); ?></strong>
    <div class="mt-2">Simpan No. RM ini. Anda dapat langsung mengambil nomor antrean di bawah.</div>
    <a class="btn btn-success mt-2" href="#antrian">Lanjut Ambil Antrean</a>
</div>
<?php } ?>

<section id="registrasi" class="mb-5">
<div class="row g-4">
<div class="col-lg-7">
<div class="card card-soft p-4">
<div class="d-flex gap-3 align-items-start mb-3">
    <div class="icon-box"><i class="bi bi-person-plus"></i></div>
    <div><h2 class="h4 mb-1">Registrasi Pasien Baru</h2><div class="small-muted">Nomor Rekam Medis dibuat otomatis.</div></div>
</div>
<form method="post">
<?php echo hms_csrf_field(); ?>
<input type="hidden" name="action" value="register_patient">
<div class="row g-3">
<div class="col-md-6"><label class="form-label">Nama Lengkap *</label><input name="patient_name" class="form-control" required></div>
<div class="col-md-6"><label class="form-label">NIK</label><input name="nik" class="form-control" inputmode="numeric" maxlength="16"></div>
<div class="col-md-6"><label class="form-label">Nomor HP *</label><input name="phone" class="form-control" inputmode="numeric" required></div>
<div class="col-md-6"><label class="form-label">Email</label><input name="email" type="email" class="form-control"></div>
<div class="col-md-4"><label class="form-label">Jenis Kelamin</label><select name="gender" class="form-select"><option value="">Pilih</option><option value="male">Laki-laki</option><option value="female">Perempuan</option><option value="other">Lainnya</option></select></div>
<div class="col-md-4"><label class="form-label">Umur</label><input name="age" type="number" min="0" max="120" class="form-control"></div>
<div class="col-md-4"><label class="form-label">Alamat</label><input name="address" class="form-control"></div>
<div class="col-12"><button class="btn btn-primary"><i class="bi bi-person-plus me-1"></i>Simpan Registrasi Pasien</button></div>
</div>
</form>
</div>
</div>
<div class="col-lg-5">
<div class="card card-soft p-4 h-100">
<h2 class="h5">Setelah Registrasi</h2>
<ol class="mb-0">
<li class="mb-2">Pasien memperoleh <strong>No. RM</strong>.</li>
<li class="mb-2">Masuk ke bagian <strong>Ambil Nomor Antrean</strong>.</li>
<li class="mb-2">Masukkan No. RM dan nomor HP.</li>
<li>Pilih poli lalu sistem membuat nomor antrean.</li>
</ol>
</div>
</div>
</div>
</section>

<section id="antrian" class="mb-5">
<div class="card card-soft p-4">
<div class="d-flex gap-3 align-items-start mb-3">
    <div class="icon-box"><i class="bi bi-ticket-perforated"></i></div>
    <div><h2 class="h4 mb-1">Ambil Nomor Antrean Rawat Jalan</h2><div class="small-muted">Khusus kunjungan rawat jalan/poliklinik.</div></div>
</div>
<form method="post">
<?php echo hms_csrf_field(); ?>
<input type="hidden" name="action" value="take_queue">
<div class="row g-3">
<div class="col-md-4"><label class="form-label">No. RM *</label><input name="medical_record_no" class="form-control" value="<?php echo hms_e($_GET['mrn'] ?? ''); ?>" required></div>
<div class="col-md-4"><label class="form-label">Nomor HP *</label><input name="phone" class="form-control" value="<?php echo hms_e($_GET['phone'] ?? ($registered['phone'] ?? '')); ?>" required></div>
<div class="col-md-3"><label class="form-label">Tanggal Kunjungan *</label><input type="date" name="service_date" id="publicServiceDate" class="form-control" min="<?php echo date('Y-m-d'); ?>" value="<?php echo date('Y-m-d'); ?>" required></div><div class="col-md-5"><label class="form-label">Poli / Dokter / Jadwal *</label><select name="schedule_id" id="publicSchedule" class="form-select" required><option value="">Pilih jadwal dokter</option><?php foreach($publicSchedules as $sc){ ?><option value="<?php echo (int)$sc['id']; ?>" data-day="<?php echo (int)$sc['day_of_week']; ?>" data-date="<?php echo hms_e($sc['available_date']??''); ?>"><?php echo hms_e($sc['poli_name'] . ' — ' . $sc['doctorName'] . ' (' . substr($sc['start_time'],0,5) . '-' . substr($sc['end_time'],0,5) . ') | Kuota ' . $sc['quota']); ?></option><?php } ?></select><div class="form-text">Jadwal ditampilkan dari master jadwal dokter yang aktif.</div></div>
<div class="col-12"><button class="btn btn-success btn-lg"><i class="bi bi-ticket-perforated me-1"></i>Ambil Nomor Antrean</button></div>
</div>
</form>
</div>
</section>

<?php if ($queueTicket) { ?>
<section class="mb-4">
<div class="card card-soft p-4 text-center">
    <div class="text-uppercase small fw-bold text-muted">Nomor Antrean Anda</div>
    <div class="queue-number"><?php echo hms_e($queueTicket['queue_no']); ?></div>
    <h2 class="h5"><?php echo hms_e($queueTicket['poli']); ?></h2>
    <div><?php echo hms_e($queueTicket['patient_name']); ?> · <?php echo hms_e($queueTicket['mrn']); ?></div>
    <div class="small-muted mt-2">No. Registrasi: <?php echo hms_e($queueTicket['registration_no']); ?></div>
    <?php if ($queueTicket['existing']) { ?>
        <div class="alert alert-warning mt-3 mb-0">Antrean aktif yang sudah ada ditampilkan kembali. Sistem tidak membuat antrean ganda.</div>
    <?php } else { ?>
        <div class="alert alert-success mt-3 mb-0">Antrean berhasil dibuat. Silakan datang sesuai arahan rumah sakit.</div>
    <?php } ?>
    <div class="mt-3"><button class="btn btn-outline-secondary" onclick="window.print()"><i class="bi bi-printer me-1"></i>Cetak Bukti Antrean</button></div>
</div>
</section>
<?php } ?>
</main>

<footer class="border-top bg-white py-4">
<div class="container d-flex flex-column flex-md-row justify-content-between gap-2">
    <span class="small-muted">SIMRS · Registrasi Pasien & Antrean</span>
    <a href="../" class="small">Kembali ke Beranda</a>
</div>
</footer>
<script>
(function(){
 const date=document.getElementById('publicServiceDate'), select=document.getElementById('publicSchedule');
 if(!date||!select)return;
 const options=Array.from(select.options).slice(1);
 const placeholder=select.options[0];
 function filter(){
   const value=(date.value||'').slice(0,10);
   const d=value ? new Date(value+'T00:00:00').getDay() : -1;
   let visible=0;
   const seenLabels=new Set();
   options.forEach(o=>{
     // MySQL DATE/DATETIME may arrive as YYYY-MM-DD or YYYY-MM-DD 00:00:00.
     // Normalize before comparing so date-specific slots are not hidden accidentally.
     const specific=String(o.dataset.date||'').trim().slice(0,10);
     const dayMatch=Number(o.dataset.day)===d;
     const dateMatch=Boolean(value) && (specific!=='' ? specific===value : dayMatch);
     // Hide identical displayed choices for the selected service date. This
     // catches legacy duplicates even when their poli_id is NULL vs populated.
     const label=String(o.textContent||'').replace(/\s+/g,' ').trim().toLowerCase();
     const duplicate=dateMatch && seenLabels.has(label);
     const match=dateMatch && !duplicate;
     if(dateMatch && !duplicate) seenLabels.add(label);
     o.hidden=!match;
     o.disabled=!match;
     if(match) visible++;
   });
   if(select.selectedOptions.length && select.selectedOptions[0] && select.selectedOptions[0].hidden)select.value='';
   if(placeholder){
     placeholder.textContent=visible ? 'Pilih jadwal dokter' : 'Tidak ada jadwal aktif pada tanggal ini';
   }
   select.disabled=(visible===0);
 }
 date.addEventListener('change',filter);filter();
})();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
