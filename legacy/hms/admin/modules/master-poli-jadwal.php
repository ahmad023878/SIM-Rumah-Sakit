<?php
session(); include('../include/config.php'); require_once __DIR__.'/module_bootstrap.php'; require_once __DIR__.'/simrs_integration_bootstrap.php';
hms_module_require_roles(array('admin'));
hms_int_bootstrap($con);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    hms_module_csrf();
    try {
        $action = $_POST['action'] ?? '';
        if ($action === 'add_poli') {
            $name = trim($_POST['poli_name'] ?? '');
            $code = strtoupper(trim($_POST['poli_code'] ?? ''));
            if ($name === '') throw new RuntimeException('Nama poli wajib diisi.');
            $existingPoli = hms_fetch_one($con, 'SELECT id FROM hms_master_poli WHERE is_active=1 AND LOWER(TRIM(poli_name))=LOWER(TRIM(?)) LIMIT 1', 's', array($name));
            if ($existingPoli) throw new RuntimeException('Nama poli tersebut sudah tersedia. Gunakan data master yang ada agar tidak membuat dropdown ganda.');
            if ($code === '') $code = strtoupper(substr(preg_replace('/[^A-Za-z0-9]+/', '-', $name), 0, 20));
            $st = mysqli_prepare($con, 'INSERT INTO hms_master_poli(poli_code,poli_name) VALUES(?,?)');
            if (!$st) throw new RuntimeException('Gagal menyiapkan master poli.');
            mysqli_stmt_bind_param($st, 'ss', $code, $name);
            if (!mysqli_stmt_execute($st)) { mysqli_stmt_close($st); throw new RuntimeException('Poli sudah ada atau gagal disimpan.'); }
            $id = mysqli_stmt_insert_id($st); mysqli_stmt_close($st);
            hms_module_audit($con,'CREATE','MASTER_POLI','hms_master_poli',$id,'Master poli ditambahkan',null,array('code'=>$code,'name'=>$name));
            hms_set_flash('success','Master poli berhasil ditambahkan.');
        }
        if ($action === 'toggle_poli') {
            $id = (int)($_POST['id'] ?? 0);
            hms_execute($con,'UPDATE hms_master_poli SET is_active=IF(is_active=1,0,1),updated_at=NOW() WHERE id=?','i',array($id));
            hms_set_flash('success','Status poli diperbarui.');
        }
        if ($action === 'add_schedule') {
            $poliId = (int)($_POST['poli_id'] ?? 0);
            $doctorId = (int)($_POST['doctor_id'] ?? 0);
            $day = (int)($_POST['day_of_week'] ?? -1);
            $date = trim($_POST['available_date'] ?? '');
            $start = trim($_POST['start_time'] ?? '');
            $end = trim($_POST['end_time'] ?? '');
            $quota = (int)($_POST['quota'] ?? 0);
            if ($poliId <= 0 || $doctorId <= 0 || $day < 0 || $day > 6 || $start === '' || $end === '' || $quota <= 0) throw new RuntimeException('Poli, dokter, hari, jam dan kuota wajib diisi.');
            if ($end <= $start) throw new RuntimeException('Jam selesai harus lebih besar dari jam mulai.');
            $dateValue = $date !== '' ? $date : null;

            // Cegah jadwal aktif yang identik tersimpan berulang.
            // Perbandingan <=> aman untuk available_date yang bernilai NULL (jadwal mingguan).
            $check = mysqli_prepare($con, 'SELECT id FROM hms_doctor_schedules
                WHERE poli_id=? AND doctor_id=? AND day_of_week=?
                  AND available_date <=> ? AND start_time=? AND end_time=?
                  AND is_active=1
                ORDER BY id ASC LIMIT 1');
            if (!$check) throw new RuntimeException('Gagal memeriksa duplikasi jadwal.');
            mysqli_stmt_bind_param($check, 'iiisss', $poliId, $doctorId, $day, $dateValue, $start, $end);
            if (!mysqli_stmt_execute($check)) { mysqli_stmt_close($check); throw new RuntimeException('Gagal memeriksa jadwal yang sudah ada.'); }
            mysqli_stmt_store_result($check);
            $duplicateExists = mysqli_stmt_num_rows($check) > 0;
            mysqli_stmt_close($check);
            if ($duplicateExists) {
                throw new RuntimeException('Jadwal aktif untuk poli, dokter, hari/tanggal, dan jam tersebut sudah tersedia. Jadwal tidak ditambahkan kembali.');
            }

            $st = mysqli_prepare($con,'INSERT INTO hms_doctor_schedules(poli_id,doctor_id,day_of_week,available_date,start_time,end_time,quota) VALUES(?,?,?,?,?,?,?)');
            if (!$st) throw new RuntimeException('Gagal menyiapkan jadwal.');
            mysqli_stmt_bind_param($st,'iiisssi',$poliId,$doctorId,$day,$dateValue,$start,$end,$quota);
            if (!mysqli_stmt_execute($st)) { mysqli_stmt_close($st); throw new RuntimeException('Jadwal gagal disimpan.'); }
            $id=mysqli_stmt_insert_id($st); mysqli_stmt_close($st);
            hms_module_audit($con,'CREATE','MASTER_JADWAL','hms_doctor_schedules',$id,'Jadwal dokter ditambahkan',null,array('poli_id'=>$poliId,'doctor_id'=>$doctorId,'day'=>$day,'quota'=>$quota));
            hms_set_flash('success','Jadwal dokter dan kuota berhasil ditambahkan.');
        }
        if ($action === 'toggle_schedule') {
            $id = (int)($_POST['id'] ?? 0);
            hms_execute($con,'UPDATE hms_doctor_schedules SET is_active=IF(is_active=1,0,1),updated_at=NOW() WHERE id=?','i',array($id));
            hms_set_flash('success','Status jadwal diperbarui.');
        }
    } catch (Throwable $e) { hms_set_flash('danger',$e->getMessage()); }
}

$polies = hms_fetch_all($con,'SELECT * FROM hms_master_poli ORDER BY is_active DESC,poli_name,id');
$poliesForSelect = hms_fetch_all($con, "SELECT p.id,p.poli_code,p.poli_name
    FROM hms_master_poli p
    WHERE p.is_active=1
      AND p.id=(
        SELECT p2.id FROM hms_master_poli p2
        WHERE p2.is_active=1
          AND LOWER(TRIM(p2.poli_name))=LOWER(TRIM(p.poli_name))
        ORDER BY
          (SELECT COUNT(*) FROM hms_doctor_schedules ds WHERE ds.poli_id=p2.id AND ds.is_active=1) DESC,
          p2.id ASC
        LIMIT 1
      )
    ORDER BY p.poli_name ASC,p.id ASC");
$doctors = hms_fetch_all($con,'SELECT id,doctorName,specilization FROM doctors ORDER BY doctorName');
$schedules = hms_fetch_all($con,"SELECT s.*,p.poli_name,d.doctorName,d.specilization
    FROM hms_doctor_schedules s
    JOIN hms_master_poli p ON p.id=s.poli_id
    LEFT JOIN doctors d ON d.id=s.doctor_id
    ORDER BY s.is_active DESC,s.day_of_week,s.start_time,p.poli_name,d.doctorName,s.id ASC
    LIMIT 1000");

// Tampilkan satu baris untuk setiap kombinasi jadwal yang benar-benar identik.
// Baris database lama tidak dihapus; ini hanya mencegah tampilan berulang.
$uniqueSchedules = array();
$seenScheduleKeys = array();
$duplicateScheduleCount = 0;
foreach ($schedules as $scheduleRow) {
    $scheduleKeyParts = array(
        (string)($scheduleRow['poli_id'] ?? ''),
        (string)($scheduleRow['doctor_id'] ?? ''),
        (string)($scheduleRow['day_of_week'] ?? ''),
        (string)($scheduleRow['available_date'] ?? ''),
        substr((string)($scheduleRow['start_time'] ?? ''), 0, 8),
        substr((string)($scheduleRow['end_time'] ?? ''), 0, 8),
        (string)($scheduleRow['quota'] ?? ''),
        (string)($scheduleRow['is_active'] ?? '')
    );
    $scheduleKey = hash('sha256', implode('|', $scheduleKeyParts));
    if (isset($seenScheduleKeys[$scheduleKey])) {
        $duplicateScheduleCount++;
        continue;
    }
    $seenScheduleKeys[$scheduleKey] = true;
    $uniqueSchedules[] = $scheduleRow;
}
$schedules = $uniqueSchedules;

$role=hms_module_current_role(); hms_layout_header('Master Poli, Dokter & Jadwal',$role,'operations');
?>
<div class="hms-page-title"><div><h1>Master Poli → Dokter → Jadwal → Kuota</h1><div class="text-muted"></div></div></div>
<div class="alert alert-info">Jadwal yang tidak diisi <strong>Tanggal Khusus</strong> berlaku berdasarkan hari. Tanggal khusus dapat dipakai untuk jadwal tertentu. Kuota dihitung otomatis dari antrean aktif pada jadwal tersebut.</div>
<div class="row g-4">
<div class="col-lg-5"><div class="hms-card p-3 mb-4"><h2 class="h5">Tambah Master Poli</h2><form method="post" class="row g-3"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="add_poli"><div class="col-md-5"><label class="form-label">Kode</label><input name="poli_code" class="form-control" placeholder="SARAF"></div><div class="col-md-7"><label class="form-label">Nama Poli *</label><input name="poli_name" class="form-control" required placeholder="Poli Saraf"></div><div class="col-12"><button class="btn btn-primary">Tambah Poli</button></div></form></div>
<div class="hms-card p-3"><h2 class="h5">Master Poli Aktif</h2><div class="table-responsive"><table class="table table-sm"><thead><tr><th>Kode</th><th>Poli</th><th>Status</th><th></th></tr></thead><tbody><?php foreach($polies as $p){ ?><tr><td><?php echo hms_e($p['poli_code']); ?></td><td><?php echo hms_e($p['poli_name']); ?></td><td><?php echo $p['is_active']?'Aktif':'Nonaktif'; ?></td><td><form method="post"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="toggle_poli"><input type="hidden" name="id" value="<?php echo (int)$p['id']; ?>"><button class="btn btn-sm btn-outline-secondary">Ubah</button></form></td></tr><?php } ?></tbody></table></div></div></div>
<div class="col-lg-7"><div class="hms-card p-3"><h2 class="h5">Tambah Jadwal Dokter & Kuota</h2><form method="post" class="row g-3"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="add_schedule"><div class="col-md-6"><label class="form-label">Poli *</label><select name="poli_id" id="schedulePoliSelect" class="form-select" required><option value="">Pilih poli</option><?php foreach($poliesForSelect as $p){ ?><option value="<?php echo (int)$p['id']; ?>"><?php echo hms_e($p['poli_name']); ?></option><?php } ?></select></div><div class="col-md-6"><label class="form-label">Dokter *</label><select name="doctor_id" id="scheduleDoctorSelect" class="form-select" required disabled><option value="">Pilih poli terlebih dahulu</option><?php foreach($doctors as $d){ ?><option value="<?php echo (int)$d['id']; ?>" data-spec="<?php echo hms_e($d['specilization']); ?>"><?php echo hms_e($d['doctorName'].' - '.$d['specilization']); ?></option><?php } ?></select></div><div class="col-md-3"><label class="form-label">Hari *</label><select name="day_of_week" class="form-select" required><?php for($i=0;$i<=6;$i++){ ?><option value="<?php echo $i; ?>"><?php echo hms_e(hms_int_day_name($i)); ?></option><?php } ?></select></div><div class="col-md-3"><label class="form-label">Tanggal Khusus</label><input type="date" name="available_date" class="form-control"></div><div class="col-md-3"><label class="form-label">Mulai *</label><input type="time" name="start_time" class="form-control" required></div><div class="col-md-3"><label class="form-label">Selesai *</label><input type="time" name="end_time" class="form-control" required></div><div class="col-md-3"><label class="form-label">Kuota *</label><input type="number" name="quota" class="form-control" min="1" value="30" required></div><div class="col-12"><button class="btn btn-success">Simpan Jadwal & Kuota</button></div></form></div>
<div class="hms-card p-3 mt-4"><h2 class="h5">Jadwal Aktif</h2><?php if($duplicateScheduleCount>0){ ?><?php } ?><div class="table-responsive"><table class="table table-hover"><thead><tr><th>Poli</th><th>Dokter</th><th>Hari</th><th>Jam</th><th>Tanggal</th><th>Kuota</th><th>Status</th><th></th></tr></thead><tbody><?php foreach($schedules as $s){ ?><tr><td><?php echo hms_e($s['poli_name']); ?></td><td><?php echo hms_e($s['doctorName']??'-'); ?></td><td><?php echo hms_e(hms_int_day_name($s['day_of_week'])); ?></td><td><?php echo hms_e(substr($s['start_time'],0,5).'–'.substr($s['end_time'],0,5)); ?></td><td><?php echo hms_e($s['available_date']?:'Berulang'); ?></td><td><?php echo (int)$s['quota']; ?></td><td><?php echo $s['is_active']?'Aktif':'Nonaktif'; ?></td><td><form method="post"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="toggle_schedule"><input type="hidden" name="id" value="<?php echo (int)$s['id']; ?>"><button class="btn btn-sm btn-outline-secondary">Ubah</button></form></td></tr><?php } if(!$schedules){ ?><tr><td colspan="8" class="text-muted">Belum ada jadwal. Tambahkan jadwal dokter agar registrasi terintegrasi dapat digunakan.</td></tr><?php } ?></tbody></table></div></div></div>
</div>

<script>
(function(){
 const poli=document.getElementById('schedulePoliSelect'), doctor=document.getElementById('scheduleDoctorSelect');
 if(!poli||!doctor)return;
 const all=Array.from(doctor.options).slice(1).map(o=>({value:o.value,text:o.textContent,spec:o.dataset.spec||''}));
 function norm(v){return String(v||'').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g,'').replace(/[^a-z0-9]+/g,'');}
 function matches(spec,name,code){
  const a=norm(spec),b=norm(name),c=norm(code);if(!a)return false;if(a===b||a===c||b.includes(a)||a.includes(b)||c.includes(a))return true;
  const groups=[
   [['pediatrics','pediatric','paediatrics','paediatric'],['anak']],
   [['ent','otorhinolaryngology'],['tht']],
   [['dentalcare','dentistry','dentist'],['gigi','mulut']],
   [['internalmedicine','internist'],['penyakitdalam','penyakitdalem']],
   [['obstetricsandgynecology','obgyn','gynecology','obstetrics'],['kandungan','kebidanan']],
   [['surgery','surgeon','orthopedics','orthopaedics'],['bedah','ortopedi']],
   [['laboratorymedicine','pathology','clinicalpathology','labmedicine'],['instalasilaboratorium','laboratorium']],
   [['ophthalmology','ophthalmologist'],['mata']]
  ];
  return groups.some(([specs,polis])=>specs.map(norm).includes(a)&&polis.map(norm).some(x=>b.includes(x)||c.includes(x)));
 }
 function update(){const opt=poli.options[poli.selectedIndex],name=opt?.textContent||'',code=opt?.dataset?.code||'';doctor.innerHTML='<option value="">Pilih dokter sesuai poli</option>';doctor.disabled=!poli.value;let count=0;all.forEach(d=>{if(matches(d.spec,name,code)){const o=document.createElement('option');o.value=d.value;o.textContent=d.text;doctor.appendChild(o);count++;}});if(poli.value&&!count){const o=document.createElement('option');o.disabled=true;o.textContent='Belum ada dokter dengan spesialisasi yang cocok';doctor.appendChild(o);}}
 Array.from(poli.options).forEach(o=>{const row=<?php echo json_encode($polies,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES); ?>.find(x=>String(x.id)===o.value);if(row)o.dataset.code=row.poli_code;});
 poli.addEventListener('change',update);update();
})();
</script>
<?php hms_layout_footer(); ?>
