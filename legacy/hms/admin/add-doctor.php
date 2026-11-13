<?php
session();
include 'include/config.php';
hms_require_role('admin', 'logout.php');
require_once __DIR__ . '/modules/simrs_integration_bootstrap.php';
hms_int_bootstrap($con);

if (isset($_POST['submit'])) {
    hms_verify_csrf();
    $specialization = hms_post('Doctorspecialization');
    $name = hms_post('docname');
    $address = hms_post('clinicaddress');
    $fees = hms_post('docfees');
    $contact = hms_post('doccontact');
    $email = hms_post('docemail');
    $password = isset($_POST['npass']) ? (string) $_POST['npass'] : '';
    $confirm = isset($_POST['cfpass']) ? (string) $_POST['cfpass'] : '';

    $validPoli = $specialization !== '' && (int) hms_scalar($con,
        'SELECT COUNT(*) FROM hms_master_poli WHERE poli_name = ? AND is_active = 1',
        's', array($specialization)) > 0;
    if (!$validPoli || $name === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        hms_flash('danger', 'Pilih spesialisasi dari Master Poli yang aktif dan lengkapi data dokter.');
    } elseif ($password === '' || $password !== $confirm) {
        hms_flash('danger', 'Kata sandi dan konfirmasi kata sandi harus sama.');
    } elseif ((int) hms_scalar($con, 'SELECT COUNT(*) FROM doctors WHERE docEmail = ?', 's', array($email)) > 0) {
        hms_flash('danger', 'This doctor email is already registered.');
    } else {
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $created = hms_execute(
            $con,
            'INSERT INTO doctors(specilization, doctorName, address, docFees, contactno, docEmail, password) VALUES(?, ?, ?, ?, ?, ?, ?)',
            'sssssss',
            array($specialization, $name, $address, $fees, $contact, $email, $hash)
        );
        if ($created !== false) {
            hms_log_audit($con, 'admin', (int) $_SESSION['id'], 'doctor_created', 'doctors', mysqli_insert_id($con), 'Doctor created: ' . $name);
            hms_flash('success', 'Doctor added successfully.');
            hms_redirect('manage-doctors.php');
        }
        hms_flash('danger', 'Unable to add doctor.');
    }
}

$specializations = hms_fetch_all($con, 'SELECT poli_name FROM hms_master_poli WHERE is_active = 1 ORDER BY poli_name ASC');

hms_layout_header('Tambah Dokter', 'admin', 'doctors');
?>
<div class="hms-page-title">
    <div>
        <h1>Tambah Dokter</h1>
        <p class="text-muted mb-0">Buat akun login dan profil dokter.</p>
    </div>
    <a class="btn btn-light" href="manage-doctors.php">Kembali ke Dokter</a>
</div>

<div class="hms-card p-4">
    <form method="post">
        <?php echo hms_csrf_field(); ?>
        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label" for="Doctorspecialization">Spesialisasi</label>
                <select class="form-select" id="Doctorspecialization" name="Doctorspecialization" required>
                    <option value="">Pilih spesialisasi</option>
                    <?php foreach ($specializations as $row) { ?>
                        <option value="<?php echo hms_e($row['poli_name']); ?>"><?php echo hms_e($row['poli_name']); ?></option>
                    <?php } ?>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="docname">Nama Dokter</label>
                <input type="text" class="form-control" id="docname" name="docname" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="docfees">Biaya Konsultasi</label>
                <input type="number" min="0" step="0.01" class="form-control" id="docfees" name="docfees" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="doccontact">Contact number</label>
                <input type="text" class="form-control" id="doccontact" name="doccontact" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="docemail">Email</label>
                <input type="email" class="form-control" id="docemail" name="docemail" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="npass">Kata Sandi</label>
                <input type="password" class="form-control" id="npass" name="npass" minlength="6" required>
            </div>
            <div class="col-md-6">
                <label class="form-label" for="cfpass">Konfirmasi kata sandi</label>
                <input type="password" class="form-control" id="cfpass" name="cfpass" minlength="6" required>
            </div>
            <div class="col-12">
                <label class="form-label" for="clinicaddress">Alamat Klinik</label>
                <textarea class="form-control" id="clinicaddress" name="clinicaddress" rows="4" required></textarea>
            </div>
        </div>
        <button type="submit" name="submit" class="btn btn-primary mt-4">
            <i class="bi bi-person-plus me-1"></i>Tambah Dokter
        </button>
    </form>
</div>
<?php hms_layout_footer(); ?>
