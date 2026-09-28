<?php
session();
include 'include/config.php';

if (isset($_POST['submit'])) {
    hms_verify_csrf();
    $username = hms_post('username');
    $password = isset($_POST['password']) ? (string) $_POST['password'] : '';
    $admin = hms_fetch_one($con, 'SELECT * FROM admin WHERE username = ?', 's', array($username));

    if ($admin && hms_password_matches($password, $admin['password'])) {
        session()->regenerate(true);
        session()->set([
            'login' => $username,
            'id'    => (int) $admin['id'],
            'role'  => 'admin',
        ]);

        // Legacy pages and CI4 must see the same authentication state.
        $_SESSION['login'] = $username;
        $_SESSION['id'] = (int) $admin['id'];
        $_SESSION['role'] = 'admin';

        hms_set_admin_auth_cookie((int) $admin['id'], $username);

        // Keep a short-lived signed handoff in the redirect URL so the first
        // dashboard request can authenticate even if an old browser/session
        // cookie is stale or the CI4 session was regenerated.
        $adminTicket = hms_make_admin_ticket((int) $admin['id'], $username);

        if (hms_password_needs_upgrade($admin['password'])) {
            hms_upgrade_password($con, 'admin', 'id', (int) $admin['id'], $password);
        }

        hms_log_audit($con, 'admin', (int) $admin['id'], 'admin_login', 'admin', (int) $admin['id'], 'Admin logged in.');
        hms_redirect(base_url('hms/admin/dashboard.php?auth=' . rawurlencode($adminTicket)));
    }

    hms_flash('danger', 'Nama pengguna atau kata sandi tidak valid.');
    hms_redirect('index.php');
}

hms_auth_header('Login Admin', 'Login Admin', 'Kelola janji temu, dokter, laporan, notifikasi, dan log audit.', '../../index.php');
?>
<form method="post" class="mt-4">
    <?php echo hms_csrf_field(); ?>
    <div class="mb-3">
        <label class="form-label" for="username">Nama Pengguna</label>
        <div class="input-group">
            <span class="input-group-text"><i class="bi bi-person"></i></span>
            <input type="text" class="form-control" id="username" name="username" autocomplete="username" required>
        </div>
    </div>
    <div class="mb-4">
        <label class="form-label" for="password">Kata Sandi</label>
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
