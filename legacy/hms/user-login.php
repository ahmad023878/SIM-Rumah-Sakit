<?php
session();
include 'include/config.php';

if (isset($_GET['captcha_refresh'])) {
    hms_captcha_refresh('patient');
    hms_redirect(basename(__FILE__));
}

if (isset($_POST['submit'])) {
    if (!hms_verify_captcha('patient')) {
        hms_redirect('user-login.php');
    }
    hms_verify_csrf();
    $email = hms_post('username');
    $password = isset($_POST['password']) ? (string) $_POST['password'] : '';
    $user = hms_fetch_one($con, 'SELECT * FROM users WHERE email = ?', 's', array($email));
    $ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';

    if ($user && hms_password_matches($password, $user['password'])) {
        // Sinkronkan sesi CI4 dan sesi native PHP. Seluruh halaman legacy
        // dan controller CI4 membaca identitas dari sumber sesi yang sama.
        $session = session();
        $session->regenerate(true);
        $session->remove(['login', 'id', 'role', 'dlogin']);
        $session->set([
            'login' => $email,
            'id'    => (int) $user['id'],
            'role'  => 'patient',
        ]);
        $_SESSION['login'] = $email;
        $_SESSION['id'] = (int) $user['id'];
        $_SESSION['role'] = 'patient';
        unset($_SESSION['dlogin']);

        if (hms_password_needs_upgrade($user['password'])) {
            hms_upgrade_password($con, 'users', 'id', (int) $user['id'], $password);
        }

        hms_execute($con, 'INSERT INTO userlog(uid, username, userip, status) VALUES(?, ?, ?, ?)', 'issi', array((int) $user['id'], $email, $ip, 1));
        hms_redirect('dashboard.php');
    }

    hms_execute($con, 'INSERT INTO userlog(username, userip, status) VALUES(?, ?, ?)', 'ssi', array($email, $ip, 0));
    hms_flash('danger', 'Email atau kata sandi tidak valid.');
    hms_redirect('user-login.php');
}

$captchaQuestion = hms_captcha_question('patient');

hms_auth_header('Login Pasien', 'Login Pasien', 'Akses janji temu, resep, dan riwayat medis Anda.', '../index.php');
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
    <div class="mb-3">
        <label class="form-label" for="captcha">Kode CAPTCHA</label>
        <div style="display:flex;align-items:stretch;gap:8px;max-width:390px;">
            <?php echo hms_captcha_image('patient'); ?>
            <?php echo hms_captcha_refresh_button('patient'); ?>
        </div>
        <div class="mt-2" style="max-width:390px;"><?php echo hms_captcha_field('patient'); ?></div>
        <div class="form-text">Ketik kode yang terlihat pada gambar CAPTCHA.</div>
    </div>
    <button type="submit" class="btn btn-primary w-100" name="submit">
        <i class="bi bi-box-arrow-in-right me-1"></i>Masuk
    </button>
    <p class="text-center auth-muted mt-4 mb-0">
        Pasien baru? <a href="registration.php">Buat akun</a>
    </p>
</form>
<?php hms_auth_footer(); ?>
