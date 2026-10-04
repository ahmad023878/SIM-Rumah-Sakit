<?php
session();
include 'include/config.php';

if (isset($_POST['submit'])) {
    // Login is a credential endpoint. Keep the login flow usable even when an
    // old/stale browser session contains a CSRF token from a previous build.
    // All authenticated state-changing doctor pages continue to require CSRF.
    $email = hms_post('username');
    $password = isset($_POST['password']) ? (string) $_POST['password'] : '';
    $doctor = hms_fetch_one($con, 'SELECT * FROM doctors WHERE docEmail = ?', 's', array($email));
    $ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';

    if ($doctor && hms_password_matches($password, $doctor['password'])) {
        // Gunakan session service CodeIgniter sebagai sumber utama.
        // Hal ini penting karena dashboard memeriksa session()->get().
        $session = session();
        $session->regenerate(true);
        // Hapus konteks autentikasi lama sebelum menetapkan dokter yang baru login.
        $session->remove(['dlogin', 'login', 'id', 'role']);
        unset($_SESSION['dlogin'], $_SESSION['login'], $_SESSION['id'], $_SESSION['role']);
        $session->set([
            'dlogin' => $email,
            'login'  => $email,
            'id'     => (int) $doctor['id'],
            'role'   => 'doctor',
        ]);

        // Pertahankan kompatibilitas dengan kode legacy yang membaca $_SESSION.
        $_SESSION['dlogin'] = $email;
        $_SESSION['login'] = $email;
        $_SESSION['id'] = (int) $doctor['id'];
        $_SESSION['role'] = 'doctor';
        hms_set_doctor_auth_cookie((int) $doctor['id'], $email);

        if (hms_password_needs_upgrade($doctor['password'])) {
            hms_upgrade_password($con, 'doctors', 'id', (int) $doctor['id'], $password);
        }

        hms_execute($con, 'INSERT INTO doctorslog(uid, username, userip, status) VALUES(?, ?, ?, ?)', 'issi', array((int) $doctor['id'], $email, $ip, 1));
        $ticket = hms_make_doctor_ticket((int) $doctor['id'], $email);
        hms_redirect(rtrim(base_url(), '/') . '/hms/doctor/dashboard.php?doctor_auth=' . rawurlencode($ticket));
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
