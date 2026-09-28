<?php
session();
include('include/config.php');
hms_require_role('doctor', 'logout.php');

$doctorId = (int) $_SESSION['id'];
$patientId = hms_int(hms_get('viewid'));
$patient = hms_fetch_one($con, 'SELECT * FROM tblpatient WHERE ID = ? AND Docid = ?', 'ii', array($patientId, $doctorId));
if (!$patient) {
    hms_flash('error', 'Rekam pasien tidak ditemukan.');
    hms_redirect('manage-patient.php');
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    hms_verify_csrf();
    $bp = hms_post('bp');
    $bs = hms_post('bs');
    $weight = hms_post('weight');
    $temp = hms_post('temp');
    $pres = hms_post('pres');
    hms_execute(
        $con,
        'INSERT INTO tblmedicalhistory(PatientID, BloodPressure, BloodSugar, Berat Badan, Suhu Tubuh, MedicalPres) VALUES(?, ?, ?, ?, ?, ?)',
        'isssss',
        array($patientId, $bp, $bs, $weight, $temp, $pres)
    );
    hms_log_audit($con, 'doctor', $doctorId, 'medical_history_added', 'tblpatient', $patientId, 'Riwayat medis berhasil ditambahkan.');
    hms_flash('success', 'Riwayat medis berhasil ditambahkan.');
    hms_redirect('view-patient.php?viewid=' . $patientId);
}

$history = hms_fetch_all($con, 'SELECT * FROM tblmedicalhistory WHERE PatientID = ? ORDER BY CreationDate DESC, ID DESC', 'i', array($patientId));
hms_layout_header('Detail Pasien', 'doctor', 'patients');
?>
<div class="hms-page-title">
    <div>
        <h1>Detail Pasien</h1>
        <div class="text-muted">Diagnosis, treatment notes, and medical history timeline.</div>
    </div>
    <button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#historyModal">Tambah History</button>
</div>

<div class="row g-3">
    <div class="col-lg-4">
        <div class="hms-card p-3">
            <h2 class="h5 mb-3"><?php echo hms_e($patient['PatientName']); ?></h2>
            <div class="mb-2"><span class="text-muted">Email</span><div><?php echo hms_e($patient['PatientEmail']); ?></div></div>
            <div class="mb-2"><span class="text-muted">Contact</span><div><?php echo hms_e($patient['PatientContno']); ?></div></div>
            <div class="mb-2"><span class="text-muted">Jenis Kelamin / Usia</span><div><?php echo hms_e($patient['PatientGender']); ?> / <?php echo hms_e($patient['PatientAge']); ?></div></div>
            <div class="mb-2"><span class="text-muted">Alamat</span><div><?php echo hms_e($patient['PatientAdd']); ?></div></div>
            <div><span class="text-muted">Riwayat Awal</span><div><?php echo nl2br(hms_e($patient['PatientMedhis'])); ?></div></div>
        </div>
    </div>
    <div class="col-lg-8">
        <div class="hms-card p-3">
            <h2 class="h5 mb-3">Riwayat Medis</h2>
            <div class="timeline">
                <?php foreach ($history as $item) { ?>
                    <div class="timeline-item">
                        <div class="fw-semibold"><?php echo hms_e($item['CreationDate']); ?></div>
                        <div class="small text-muted">BP: <?php echo hms_e($item['BloodPressure']); ?> | Sugar: <?php echo hms_e($item['BloodSugar']); ?> | Berat Badan: <?php echo hms_e($item['Berat Badan']); ?> | Temp: <?php echo hms_e($item['Suhu Tubuh']); ?></div>
                        <div><?php echo nl2br(hms_e($item['MedicalPres'])); ?></div>
                    </div>
                <?php } ?>
                <?php if (!$history) { ?>
                    <div class="text-muted">Belum ada riwayat medis yang ditambahkan.</div>
                <?php } ?>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="historyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" method="post">
            <div class="modal-header">
                <h5 class="modal-title">Tambah Riwayat Medis</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
            </div>
            <div class="modal-body">
                <?php echo hms_csrf_field(); ?>
                <div class="row g-3">
                    <div class="col-sm-6"><label class="form-label">Tekanan Darah</label><input class="form-control" name="bp" required></div>
                    <div class="col-sm-6"><label class="form-label">Gula Darah</label><input class="form-control" name="bs" required></div>
                    <div class="col-sm-6"><label class="form-label">Berat Badan</label><input class="form-control" name="weight" required></div>
                    <div class="col-sm-6"><label class="form-label">Suhu Tubuh</label><input class="form-control" name="temp" required></div>
                </div>
                <div class="mt-3"><label class="form-label">Resep / Catatan</label><textarea class="form-control" name="pres" rows="5" required></textarea></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Tutup</button>
                <button class="btn btn-primary" type="submit">Save</button>
            </div>
        </form>
    </div>
</div>
<?php hms_layout_footer(); ?>
