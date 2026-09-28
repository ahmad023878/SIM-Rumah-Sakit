<?php
session();
include 'include/config.php';
hms_require_role('admin', 'logout.php');

$id = hms_int(hms_get('id'));
$specialization = hms_fetch_one($con, 'SELECT * FROM doctorSpecilization WHERE id = ?', 'i', array($id));

if (!$specialization) {
    hms_flash('danger', 'Spesialisasi not found.');
    hms_redirect('doctor-specilization.php');
}

if (isset($_POST['submit'])) {
    hms_verify_csrf();
    $name = hms_post('doctorspecilization');
    if ($name === '') {
        hms_flash('danger', 'Please enter a specialization.');
    } else {
        hms_execute($con, 'UPDATE doctorSpecilization SET specilization = ?, updationDate = NOW() WHERE id = ?', 'si', array($name, $id));
        hms_log_audit($con, 'admin', (int) $_SESSION['id'], 'specialization_updated', 'doctorSpecilization', $id, 'Spesialisasi updated: ' . $name);
        hms_flash('success', 'Spesialisasi updated successfully.');
        hms_redirect('doctor-specilization.php');
    }
    $specialization = hms_fetch_one($con, 'SELECT * FROM doctorSpecilization WHERE id = ?', 'i', array($id));
}

hms_layout_header('Edit Spesialisasi', 'admin', 'doctors');
?>
<div class="hms-page-title">
    <div>
        <h1>Edit Spesialisasi</h1>
        <p class="text-muted mb-0">Perbarui the specialization name used in doctor profiles.</p>
    </div>
    <a class="btn btn-light" href="doctor-specilization.php">Kembali to Spesialisasi</a>
</div>

<div class="row">
    <div class="col-lg-6">
        <div class="hms-card p-4">
            <form method="post">
                <?php echo hms_csrf_field(); ?>
                <label class="form-label" for="doctorspecilization">Nama spesialisasi</label>
                <input type="text" class="form-control" id="doctorspecilization" name="doctorspecilization" value="<?php echo hms_e($specialization['specilization']); ?>" required>
                <button type="submit" name="submit" class="btn btn-primary mt-3">
                    <i class="bi bi-save me-1"></i>Perbarui
                </button>
            </form>
        </div>
    </div>
</div>
<?php hms_layout_footer(); ?>
