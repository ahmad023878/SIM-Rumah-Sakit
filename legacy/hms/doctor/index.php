<?php
session();
include 'include/config.php';

if (isset($_POST['submit'])) {
    hms_verify_csrf();
    $email = hms_post('username');
    $password = isset($_POST['password']) ? (string) $_POST['password'] : '';
    $doctor = hms_fetch_one($con, 'SELECT * FROM doctors WHERE docEmail = ?', 's', array($email));
    $ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';

    if ($doctor && hms_password_matches($password, $doctor['password'])) {
        session()->regenerate(true);
        $_SESSION['dlogin'] = $email;
        $_SESSION['id'] = (int) $doctor['id'];
        $_SESSION['role'] = 'doctor';

        if (hms_password_needs_upgrade($doctor['password'])) {
            hms_upgrade_password($con, 'doctors', 'id', (int) $doctor['id'], $password);
        }

        hms_execute($con, 'INSERT INTO doctorslog(uid, username, userip, status) VALUES(?, ?, ?, ?)', 'issi', array((int) $doctor['id'], $email, $ip, 1));
        hms_redirect('dashboard.php');
    }

    hms_execute($con, 'INSERT INTO doctorslog(username, userip, status) VALUES(?, ?, ?)', 'ssi', array($email, $ip, 0));
    hms_flash('danger', 'Email atau kata sandi tidak valid.');
    hms_redirect('index.php');
}

hms_auth_header('Login Dokter', 'Login Dokter', 'Tinjau janji temu hari ini, resep, dan rekam perawatan pasien.', '../../index.php');
?>
<form method="post" class="mt-4">
    <?php echo hms_csrf_field(); ?>
    <div class="mb-3">
        <label class="form-label" for="username">Alamat Email</label>
        <div class="input-group">
            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
            <input type="email" class="form-control" id="username" name="username" autocomplete="email" required>
        </div>
    </div>
    <div class="mb-3">
        <div class="d-flex justify-content-between gap-3">
            <label class="form-label" for="password">Kata Sandi</label>
            <a class="small" href="forgot-password.php">Lupa kata sandi?</a>
        </div>
        <div class="input-group">
            <span class="input-group-text"><i class="bi bi-lock"></i></span>
            <input type="password" class="form-control" id="password" name="password" autocomplete="current-password" required>
        </div>
    </div>
    <button type="submit" class="btn btn-primary w-100" name="submit">
        <i class="bi bi-box-arrow-in-right me-1"></i>Masuk
    </button>
    <p class="text-center auth-muted mt-4 mb-0">
        <a href="../../index.php">Kembali ke situs</a>
    </p>
</form>
<?php hms_auth_footer(); ?>
