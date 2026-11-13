<?php
session();
include 'include/config.php';
hms_require_role('admin', 'logout.php');
require_once __DIR__ . '/modules/simrs_integration_bootstrap.php';
hms_int_bootstrap($con);

$doctorId = hms_int(hms_get('id'));
$doctor = hms_fetch_one($con, 'SELECT * FROM doctors WHERE id = ?', 'i', array($doctorId));

if (!$doctor) {
    hms_flash('danger', 'Dokter tidak ditemukan.');
    hms_redirect('manage-doctors.php');
}

if (isset($_POST['submit'])) {
    hms_verify_csrf();
    $specialization = hms_post('Doctorspecialization');
    $name = hms_post('docname');
    $address = hms_post('clinicaddress');
    $fees = hms_post('docfees');
    $contact = hms_post('doccontact');
    $email = hms_post('docemail');

    $validPoli = $specialization !== '' && (
        (int) hms_scalar($con,
            'SELECT COUNT(*) FROM hms_master_poli WHERE poli_name = ? AND is_active = 1',
            's', array($specialization)) > 0
        || strcasecmp($specialization, (string)$doctor['specilization']) === 0
    );
    if (!$validPoli || $name === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        hms_flash('danger', 'Pilih spesialisasi dari Master Poli yang aktif dan lengkapi data dokter.');
    } else {
        $updated = hms_execute(
            $con,
            'UPDATE doctors SET specilization = ?, doctorName = ?, address = ?, docFees = ?, contactno = ?, docEmail = ?, updationDate = NOW() WHERE id = ?',
            'ssssssi',
            array($specialization, $name, $address, $fees, $contact, $email, $doctorId)
        );
        if ($updated !== false) {
            hms_log_audit($con, 'admin', (int) $_SESSION['id'], 'doctor_updated', 'doctors', $doctorId, 'Doctor updated: ' . $name);
            hms_flash('success', 'Data dokter berhasil diperbarui.');
            hms_redirect('manage-doctors.php');
        }
        hms_flash('danger', 'Unable to update doctor.');
    }
    $doctor = hms_fetch_one($con, 'SELECT * FROM doctors WHERE id = ?', 'i', array($doctorId));
}

$specializations = hms_fetch_all($con, 'SELECT poli_name FROM hms_master_poli WHERE is_active = 1 ORDER BY poli_name ASC');
$currentSpecializationExists = false;
foreach ($specializations as $specializationRow) {
    if (strcasecmp((string)$specializationRow['poli_name'], (string)$doctor['specilization']) === 0) {
        $currentSpecializationExists = true;
        break;
    }
}

hms_layout_header('Edit Dokter', 'admin', 'doctors');
?>
<div class="hms-page-title">
    <div>
        <h1>Edit Dokter</h1>
        <p class="text-muted mb-0">Perbarui profil, kontak, dan biaya konsultasi dokter.</p>
    </div>
    <a class="btn btn-light" href="manage-doctors.php">Kembali ke Dokter</a>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="hms-card p-4">
            <form method="post">
                <?php echo hms_csrf_field(); ?>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label" for="Doctorspecialization">Spesialisasi</label>
                        <select class="form-select" id="Doctorspecialization" name="Doctorspecialization" required>
                            <?php if (!$currentSpecializationExists && trim((string)$doctor['specilization']) !== '') { ?>
                                <option value="<?php echo hms_e($doctor['specilization']); ?>" selected><?php echo hms_e($doctor['specilization']); ?> (data lama)</option>
                            <?php } ?>
                            <?php foreach ($specializations as $row) { ?>
                                <option value="<?php echo hms_e($row['poli_name']); ?>" <?php echo strcasecmp((string)$row['poli_name'], (string)$doctor['specilization']) === 0 ? 'selected' : ''; ?>><?php echo hms_e($row['poli_name']); ?></option>
                            <?php } ?>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="docname">Nama Dokter</label>
                        <input type="text" class="form-control" id="docname" name="docname" value="<?php echo hms_e($doctor['doctorName']); ?>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="docfees">Biaya Konsultasi</label>
                        <input type="number" min="0" step="0.01" class="form-control" id="docfees" name="docfees" value="<?php echo hms_e($doctor['docFees']); ?>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="doccontact">Nomor Kontak</label>
                        <input type="text" class="form-control" id="doccontact" name="doccontact" value="<?php echo hms_e($doctor['contactno']); ?>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="docemail">Email</label>
                        <input type="email" class="form-control" id="docemail" name="docemail" value="<?php echo hms_e($doctor['docEmail']); ?>" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label" for="clinicaddress">Alamat Klinik</label>
                        <textarea class="form-control" id="clinicaddress" name="clinicaddress" rows="4"><?php echo hms_e($doctor['address']); ?></textarea>
                    </div>
                </div>
                <button type="submit" name="submit" class="btn btn-primary mt-4">
                    <i class="bi bi-save me-1"></i>Perbarui Dokter
                </button>
            </form>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="hms-card p-4">
            <h2 class="h5">Aktivitas Profil</h2>
            <dl class="mb-0">
                <dt class="text-muted small mt-3">Created</dt>
                <dd><?php echo hms_e($doctor['creationDate']); ?></dd>
                <dt class="text-muted small mt-3">Terakhir diperbarui</dt>
                <dd><?php echo hms_e($doctor['updationDate'] ?: 'Not updated'); ?></dd>
            </dl>
        </div>
    </div>
</div>
<?php hms_layout_footer(); ?>
