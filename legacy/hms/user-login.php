<?php

session();
include 'include/config.php';

if (isset($_GET['captcha_refresh'])) {
    hms_captcha_refresh('patient');
    hms_redirect('user-login.php');
}

if (isset($_POST['submit'])) {
    if (!hms_verify_captcha('patient')) {
        hms_redirect('user-login.php');
    }

    hms_verify_csrf();

    $email = hms_post('username');
    $password = isset($_POST['password']) ? (string) $_POST['password'] : '';
    $ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';

    $patient = hms_fetch_one(
        $con,
        'SELECT id, fullName, email, password FROM users WHERE email = ? LIMIT 1',
        's',
        array($email)
    );

    if ($patient && hms_password_matches($password, $patient['password'])) {
        $session = session();
        $session->regenerate(true);
        $session->remove(['login', 'id', 'role', 'dlogin']);

        unset(
            $_SESSION['login'],
            $_SESSION['id'],
            $_SESSION['role'],
            $_SESSION['dlogin']
        );

        $session->set([
            'login' => $email,
            'id'    => (int) $patient['id'],
            'role'  => 'patient',
        ]);

        $_SESSION['login'] = $email;
        $_SESSION['id'] = (int) $patient['id'];
        $_SESSION['role'] = 'patient';

        if (hms_password_needs_upgrade($patient['password'])) {
            hms_upgrade_password(
                $con,
                'users',
                'id',
                (int) $patient['id'],
                $password
            );
        }

        hms_execute(
            $con,
            'INSERT INTO userlog(uid, username, userip, status)
             VALUES(?, ?, ?, ?)',
            'issi',
            array((int) $patient['id'], $email, $ip, 1)
        );

        hms_redirect('dashboard.php');
    }

    hms_execute(
        $con,
        'INSERT INTO userlog(username, userip, status)
         VALUES(?, ?, ?)',
        'ssi',
        array($email, $ip, 0)
    );

    hms_flash('danger', 'Email atau kata sandi tidak valid.');
    hms_redirect('user-login.php');
}

hms_captcha_question('patient');

hms_auth_header(
    'Masuk Pasien',
    'Login Pasien',
    'Kelola janji temu, status pemeriksaan, dan riwayat pelayanan.',
    '../index.php'
);
?>

<form method="post" class="mt-4">
    <?php echo hms_csrf_field(); ?>

    <div class="mb-3">
        <label class="form-label" for="username">Alamat Email</label>
        <div class="input-group">
            <span class="input-group-text">
                <i class="bi bi-envelope"></i>
            </span>
            <input
                type="email"
                class="form-control"
                id="username"
                name="username"
                autocomplete="email"
                required
            >
        </div>
    </div>

    <div class="mb-3">
        <label class="form-label" for="password">Kata Sandi</label>
        <div class="input-group">
            <span class="input-group-text">
                <i class="bi bi-lock"></i>
            </span>
            <input
                type="password"
                class="form-control"
                id="password"
                name="password"
                autocomplete="current-password"
                required
            >
        </div>
    </div>

    <div class="mb-3">
        <label class="form-label" for="captcha">Kode CAPTCHA</label>

        <div style="display:flex;align-items:stretch;gap:8px;max-width:390px;">
            <?php echo hms_captcha_image('patient'); ?>
            <?php echo hms_captcha_refresh_button('patient'); ?>
        </div>

        <div class="mt-2" style="max-width:390px;">
            <?php echo hms_captcha_field('patient'); ?>
        </div>

        <div class="form-text">
            Ketik kode yang terlihat pada gambar CAPTCHA.
        </div>
    </div>

    <button type="submit" class="btn btn-primary w-100" name="submit">
        <i class="bi bi-box-arrow-in-right me-1"></i>Masuk
    </button>

    <p class="text-center auth-muted mt-4 mb-0">
        <a href="../index.php">Kembali ke situs</a>
    </p>
</form>

<?php hms_auth_footer(); ?>
