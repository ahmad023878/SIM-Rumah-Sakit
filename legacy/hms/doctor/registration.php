<?php
session();
include_once 'include/config.php';

if (isset($_POST['submit'])) {
    hms_verify_csrf();
    $name = hms_post('full_name');
    $address = hms_post('address');
    $city = hms_post('city');
    $gender = hms_post('gender');
    $email = hms_post('email');
    $password = isset($_POST['password']) ? (string) $_POST['password'] : '';
    $confirmPassword = isset($_POST['password_again']) ? (string) $_POST['password_again'] : '';

    if ($name === '' || !filter_var($email, FILTER_VALIDATE_EMAIL) || $password === '') {
        hms_flash('danger', 'Please enter all required registration details.');
    } elseif ($password !== $confirmPassword) {
        hms_flash('danger', 'Kata sandi dan konfirmasi kata sandi tidak cocok.');
    } elseif ((int) hms_scalar($con, 'SELECT COUNT(*) FROM users WHERE email = ?', 's', array($email)) > 0) {
        hms_flash('danger', 'Email ini sudah terdaftar.');
    } else {
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $created = hms_execute(
            $con,
            'INSERT INTO users(fullname, address, city, gender, email, password) VALUES(?, ?, ?, ?, ?, ?)',
            'ssssss',
            array($name, $address, $city, $gender, $email, $hash)
        );
        hms_flash($created !== false ? 'success' : 'danger', $created !== false ? 'Pendaftaran berhasil. Pasien sekarang dapat masuk.' : 'Unable to complete registration.');
        if ($created !== false) {
            hms_redirect('../user-login.php');
        }
    }
}

hms_auth_header('Pendaftaran Pasien', 'Buat Akun Pasien', 'Daftarkan akun pasien dengan penyimpanan kata sandi yang aman.', '../../index.php');
?>
<form method="post" class="mt-4">
    <?php echo hms_csrf_field(); ?>
    <div class="row g-3">
        <div class="col-12">
            <label class="form-label" for="full_name">Nama lengkap</label>
            <input type="text" class="form-control" id="full_name" name="full_name" required>
        </div>
        <div class="col-12">
            <label class="form-label" for="address">Alamat</label>
            <input type="text" class="form-control" id="address" name="address" required>
        </div>
        <div class="col-md-6">
            <label class="form-label" for="city">Kota</label>
            <input type="text" class="form-control" id="city" name="city" required>
        </div>
        <div class="col-md-6">
            <label class="form-label" for="gender">Gender</label>
            <select class="form-select" id="gender" name="gender" required>
                <option value="">Pilih jenis kelamin</option>
                <option value="female">Perempuan</option>
                <option value="male">Laki-laki</option>
                <option value="other">Lainnya</option>
            </select>
        </div>
        <div class="col-12">
            <label class="form-label" for="email">Alamat Email</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <div class="col-md-6">
            <label class="form-label" for="password">Kata Sandi</label>
            <input type="password" class="form-control" id="password" name="password" minlength="6" required>
        </div>
        <div class="col-md-6">
            <label class="form-label" for="password_again">Konfirmasi kata sandi</label>
            <input type="password" class="form-control" id="password_again" name="password_again" minlength="6" required>
        </div>
    </div>
    <button type="submit" class="btn btn-primary w-100 mt-4" name="submit">
        <i class="bi bi-person-plus me-1"></i>Buat Akun
    </button>
    <p class="text-center auth-muted mt-4 mb-0">
        <a href="index.php">Kembali to admin login</a>
    </p>
</form>
<?php hms_auth_footer(); ?>
