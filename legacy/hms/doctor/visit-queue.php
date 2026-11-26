<?php
session();
require_once __DIR__ . '/../include/config.php';
require_once __DIR__ . '/../admin/modules/module_bootstrap.php';
require_once __DIR__ . '/../admin/modules/visit_workflow_helpers.php';
hms_require_role('doctor', 'index.php');
hms_module_bootstrap($con);

$doctorId = (int)($_SESSION['id'] ?? 0);
$today = trim($_GET['date'] ?? date('Y-m-d'));
if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $today)) $today = date('Y-m-d');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    hms_module_csrf();
    $visitId = (int)($_POST['visit_id'] ?? 0);
    $action = trim((string)($_POST['action'] ?? ''));
    try {
        mysqli_begin_transaction($con);
        $visit = hms_fetch_one(
            $con,
            "SELECT v.*,a.status AS appointment_status
             FROM hms_patient_visits v
             LEFT JOIN appointment a ON a.id=v.appointment_id
             WHERE v.id=? AND v.doctor_id=? AND v.visit_type='RAWAT_JALAN'
             FOR UPDATE",
            'ii',
            array($visitId, $doctorId)
        );
        if (!$visit) throw new RuntimeException('Kunjungan tidak ditemukan atau bukan antrean dokter ini.');

        if ($action === 'call') {
            if ($visit['status'] !== 'MENUNGGU') throw new RuntimeException('Pasien hanya dapat dipanggil dari status MENUNGGU.');
            if (!empty($visit['appointment_id']) && $visit['appointment_status'] !== 'Approved') {
                throw new RuntimeException('Janji temu harus disetujui admin/dokter sebelum pasien dipanggil.');
            }
            if ($visit['source'] === 'ONLINE' && empty($visit['arrived_at'])) {
                throw new RuntimeException('Pasien online belum check-in. Minta petugas admin mencatat check-in terlebih dahulu.');
            }
            hms_execute($con, "UPDATE hms_patient_visits SET status='DIPANGGIL',called_at=COALESCE(called_at,NOW()),updated_at=NOW() WHERE id=? AND status='MENUNGGU'", 'i', array($visitId));
            hms_module_workflow_event($con, (int)$visit['patient_id'], $visitId, null, null, 'ANTRIAN', 'DIPANGGIL', 'Dokter memanggil pasien.');
            hms_module_audit($con, 'STATUS_CHANGE', 'ANTREAN_DOKTER', 'hms_patient_visits', $visitId, 'Pasien dipanggil dokter.');
            hms_set_flash('success', 'Pasien berhasil dipanggil.');
        } elseif ($action === 'start') {
            if ($visit['status'] !== 'DIPANGGIL') throw new RuntimeException('Pasien harus dipanggil terlebih dahulu sebelum pemeriksaan dimulai.');
            if (!empty($visit['appointment_id']) && $visit['appointment_status'] !== 'Approved') {
                throw new RuntimeException('Janji temu belum disetujui.');
            }
            hms_execute($con, "UPDATE hms_patient_visits SET status='DILAYANI',served_at=COALESCE(served_at,NOW()),updated_at=NOW() WHERE id=? AND status='DIPANGGIL'", 'i', array($visitId));
            hms_workflow_ensure_outpatient_encounter($con, $visitId, $doctorId);
            hms_module_workflow_event($con, (int)$visit['patient_id'], $visitId, null, null, 'PEMERIKSAAN', 'DILAYANI', 'Pemeriksaan rawat jalan dimulai oleh dokter.');
            hms_module_audit($con, 'STATUS_CHANGE', 'ANTREAN_DOKTER', 'hms_patient_visits', $visitId, 'Pemeriksaan dokter dimulai.');
            hms_set_flash('success', 'Pemeriksaan dimulai. Silakan isi SOAP/RME pada menu Rawat Jalan.');
        } elseif ($action === 'complete') {
            if ($visit['status'] !== 'DILAYANI') throw new RuntimeException('Kunjungan belum berstatus DILAYANI.');
            $encounter = hms_fetch_one($con, 'SELECT id,status FROM hms_outpatient_encounters WHERE visit_id=? LIMIT 1', 'i', array($visitId));
            if (!$encounter) throw new RuntimeException('Encounter rawat jalan belum dibuat.');
            if (!hms_workflow_has_soap($con, $visitId)) throw new RuntimeException('Pemeriksaan belum memiliki catatan SOAP/RME. Simpan SOAP sebelum menyelesaikan kunjungan.');
            hms_execute($con, "UPDATE hms_outpatient_encounters SET status='SELESAI',completed_at=COALESCE(completed_at,NOW()),updated_at=NOW() WHERE id=?", 'i', array((int)$encounter['id']));
            hms_execute($con, "UPDATE hms_patient_visits SET status='SELESAI',completed_at=COALESCE(completed_at,NOW()),updated_at=NOW() WHERE id=? AND status='DILAYANI'", 'i', array($visitId));
            if (!empty($visit['appointment_id']) && function_exists('hms_set_appointment_status')) {
                hms_set_appointment_status($con, (int)$visit['appointment_id'], 'Completed', 'doctor', $doctorId);
            }
            hms_module_workflow_event($con, (int)$visit['patient_id'], $visitId, null, null, 'PEMERIKSAAN', 'SELESAI', 'Pemeriksaan rawat jalan selesai dan SOAP tersimpan.');
            hms_module_audit($con, 'STATUS_CHANGE', 'ANTREAN_DOKTER', 'hms_patient_visits', $visitId, 'Pemeriksaan selesai.');
            hms_set_flash('success', 'Pemeriksaan selesai. Status kunjungan dan encounter sudah SELESAI.');
        } else {
            throw new RuntimeException('Aksi antrean tidak dikenal.');
        }
        mysqli_commit($con);
    } catch (Throwable $e) {
        @mysqli_rollback($con);
        hms_set_flash('danger', $e->getMessage());
    }
    header('Location: visit-queue.php?date=' . urlencode($today));
    exit;
}

$rows = hms_fetch_all($con,
    "SELECT v.id,v.registration_no,v.queue_no,v.visit_date,v.poli,v.status,v.source,
            v.arrived_at,v.called_at,v.served_at,v.completed_at,p.PatientName,p.medical_record_no,
            a.appointmentTime,a.status AS appointment_status,o.id AS encounter_id,o.status AS encounter_status,
            (SELECT COUNT(*) FROM hms_cppt c WHERE c.visit_id=v.id AND c.note_type='SOAP') AS soap_count
     FROM hms_patient_visits v
     LEFT JOIN tblpatient p ON p.ID=v.patient_id
     LEFT JOIN appointment a ON a.id=v.appointment_id
     LEFT JOIN hms_outpatient_encounters o ON o.visit_id=v.id
     WHERE v.doctor_id=? AND v.visit_date=? AND v.visit_type='RAWAT_JALAN'
     ORDER BY FIELD(v.status,'DIPANGGIL','DILAYANI','MENUNGGU','SELESAI','BATAL'),v.queue_no,v.id",
    'is', array($doctorId,$today));
hms_layout_header('Antrean Pasien Dokter','doctor','visit-queue');
?>
<div class="hms-page-title">
  <div><h1>Antrean Pasien Saya</h1><div class="text-muted">Panggil pasien, mulai pemeriksaan, buka SOAP/RME, lalu selesaikan kunjungan.</div></div>
  <form method="get" class="d-flex gap-2"><input type="date" name="date" class="form-control" value="<?php echo hms_e($today); ?>"><button class="btn btn-primary">Tampilkan</button></form>
</div>
<div class="hms-card p-3"><div class="table-responsive"><table class="table table-hover align-middle">
<thead><tr><th>Antrean</th><th>Pasien / No. RM</th><th>Poli</th><th>Jadwal</th><th>Status</th><th>Waktu</th><th>Aksi</th></tr></thead><tbody>
<?php if(!$rows){ ?><tr><td colspan="7" class="text-center text-muted py-4">Belum ada antrean untuk dokter ini pada tanggal tersebut.</td></tr><?php } foreach($rows as $r){ ?>
<tr>
<td><strong><?php echo hms_e($r['queue_no']?:'-'); ?></strong><div class="small text-muted"><?php echo hms_e($r['registration_no']); ?></div></td>
<td><?php echo hms_e($r['PatientName']?:'Pasien belum terpetakan'); ?><div class="small text-muted"><?php echo hms_e($r['medical_record_no']?:'-'); ?></div></td>
<td><?php echo hms_e($r['poli']?:'-'); ?></td>
<td><?php echo hms_e($r['appointmentTime']?:'-'); ?><div class="small text-muted"><?php echo hms_e($r['source']); ?></div></td>
<td><?php echo hms_status_badge($r['status']); ?>
<?php if(!empty($r['appointment_status']) && $r['appointment_status']!=='Approved' && !empty($r['appointment_id'])){ ?><div class="small text-warning">Janji temu belum disetujui</div><?php } ?>
</td>
<td><div class="small">Dipanggil: <?php echo hms_e($r['called_at']?:'-'); ?></div><div class="small">Mulai: <?php echo hms_e($r['served_at']?:'-'); ?></div><div class="small">Selesai: <?php echo hms_e($r['completed_at']?:'-'); ?></div></td>
<td class="text-nowrap">
<?php if($r['status']==='MENUNGGU' && ($r['source']!=='ONLINE' || !empty($r['arrived_at'])) && (empty($r['appointment_id']) || $r['appointment_status']==='Approved')){ ?>
<form method="post" class="d-inline"><?php echo hms_csrf_field(); ?><input type="hidden" name="visit_id" value="<?php echo (int)$r['id']; ?>"><input type="hidden" name="action" value="call"><button class="btn btn-sm btn-outline-primary">Panggil</button></form>
<?php } elseif($r['status']==='MENUNGGU' && $r['source']==='ONLINE' && empty($r['arrived_at'])){ ?><span class="small text-warning">Menunggu check-in petugas</span>
<?php } elseif($r['status']==='MENUNGGU' && !empty($r['appointment_id']) && $r['appointment_status']!=='Approved'){ ?><span class="small text-warning">Menunggu persetujuan janji temu</span>
<?php } elseif($r['status']==='DIPANGGIL'){ ?>
<form method="post" class="d-inline"><?php echo hms_csrf_field(); ?><input type="hidden" name="visit_id" value="<?php echo (int)$r['id']; ?>"><input type="hidden" name="action" value="start"><button class="btn btn-sm btn-primary">Mulai Periksa</button></form>
<?php } elseif($r['status']==='DILAYANI'){ ?>
<a class="btn btn-sm btn-outline-success" href="outpatient.php">Buka SOAP / RME</a>
<?php if((int)$r['soap_count']>0){ ?><form method="post" class="d-inline" onsubmit="return confirm('Selesaikan pemeriksaan pasien ini?');"><?php echo hms_csrf_field(); ?><input type="hidden" name="visit_id" value="<?php echo (int)$r['id']; ?>"><input type="hidden" name="action" value="complete"><button class="btn btn-sm btn-success">Selesai</button></form><?php } else { ?><div class="small text-muted mt-1">Isi SOAP sebelum selesai</div><?php } ?>
<?php } elseif($r['status']==='SELESAI'){ ?><span class="text-success small fw-semibold">Sudah selesai</span><?php } ?>
</td></tr>
<?php } ?></tbody></table></div></div>
<?php hms_layout_footer(); ?>
