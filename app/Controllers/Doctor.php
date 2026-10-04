<?php
namespace App\Controllers;

use CodeIgniter\Controller;
use CodeIgniter\Exceptions\PageNotFoundException;

class Doctor extends Controller
{
    private function legacy(string $file): void
    {
        $path = APPPATH . '../legacy/hms/doctor/' . $file;
        if (!is_file($path)) {
            throw PageNotFoundException::forPageNotFound('Doctor page not found: ' . $file);
        }
        chdir(dirname($path));
        include $path;
    }

    public function login()
    {
        session();
        $this->legacy('index.php');
    }

    public function dashboard()
    {
        session();
        require_once APPPATH . '../legacy/hms/include/config.php';
        $GLOBALS['con'] = $con;

        $doctorId = 0;
        $doctorEmail = '';

        // The login page creates a signed, short-lived doctor_auth handoff.
        $ticket = function_exists('hms_get_doctor_ticket') ? hms_get_doctor_ticket() : null;
        if ($ticket !== null) {
            $check = mysqli_prepare($con, 'SELECT id, docEmail FROM doctors WHERE id = ? AND docEmail = ? LIMIT 1');
            if ($check) {
                $checkId = (int) $ticket['id'];
                $checkEmail = (string) $ticket['username'];
                mysqli_stmt_bind_param($check, 'is', $checkId, $checkEmail);
                mysqli_stmt_execute($check);
                mysqli_stmt_store_result($check);
                if (mysqli_stmt_num_rows($check) === 1) {
                    $doctorId = $checkId;
                    $doctorEmail = $checkEmail;
                }
                mysqli_stmt_close($check);
            }
        }

        // Direct dashboard access may use the already-established session.
        if ($doctorId <= 0) {
            $s = session();
            $doctorId = (int) $s->get('id');
            $doctorEmail = (string) $s->get('login');
            if ($doctorId <= 0 || $s->get('role') !== 'doctor') {
                $doctorId = isset($_SESSION['id']) ? (int) $_SESSION['id'] : 0;
                $doctorEmail = isset($_SESSION['login']) ? (string) $_SESSION['login'] : '';
                if ($doctorId <= 0 || (isset($_SESSION['role']) ? $_SESSION['role'] : '') !== 'doctor') {
                    header('Location: ' . base_url('hms/doctor/index.php'));
                    exit;
                }
            }
        }

        // Establish the normal session before rendering the legacy dashboard.
        $s = session();
        $s->set(['id' => $doctorId, 'login' => $doctorEmail, 'dlogin' => $doctorEmail, 'role' => 'doctor']);
        $_SESSION['id'] = $doctorId;
        $_SESSION['login'] = $doctorEmail;
        $_SESSION['dlogin'] = $doctorEmail;
        $_SESSION['role'] = 'doctor';

        // Tell the legacy dashboard that this controller has already verified the doctor.
        define('HMS_DOCTOR_AUTH_VERIFIED', true);
        $this->legacy('dashboard.php');
    }

    /**
     * Serve authenticated legacy doctor pages through the same CI4 session.
     * This keeps sidebar links such as appointment-history.php,
     * availability.php, prescriptions.php, manage-patient.php, search.php,
     * profile/password pages, etc. inside the authenticated doctor area.
     */
    public function page(string $page = 'dashboard.php')
    {
        session();
        require_once APPPATH . '../legacy/hms/include/config.php';
        $GLOBALS['con'] = $con;

        // Only allow PHP pages that actually belong to the doctor module.
        $allowed = [
            'dashboard.php', 'appointment-history.php', 'availability.php',
            'prescriptions.php', 'search.php', 'manage-patient.php',
            'view-patient.php', 'edit-profile.php', 'change-password.php',
            'edit-patient.php', 'add-patient.php', 'check_availability.php',
            'forgot-password.php', 'reset-password.php'
        ];
        if (!in_array($page, $allowed, true)) {
            throw PageNotFoundException::forPageNotFound('Doctor page not found: ' . $page);
        }

        $s = session();
        $doctorId = (int) $s->get('id');
        $doctorEmail = (string) $s->get('login');

        if ($doctorId <= 0 || $s->get('role') !== 'doctor') {
            $doctorId = isset($_SESSION['id']) ? (int) $_SESSION['id'] : 0;
            $doctorEmail = isset($_SESSION['login']) ? (string) $_SESSION['login'] : '';
        }

        // A doctor_auth ticket/cookie can restore the session if this is the
        // first navigation after login. The login/dashboard controller already
        // creates these values, but this fallback makes every doctor menu link
        // robust on its own as well.
        if ($doctorId <= 0 && function_exists('hms_get_doctor_ticket')) {
            $ticket = hms_get_doctor_ticket();
            if ($ticket !== null) {
                $doctorId = (int) $ticket['id'];
                $doctorEmail = (string) $ticket['username'];
            }
        }
        if ($doctorId <= 0 && function_exists('hms_get_doctor_auth_cookie')) {
            $auth = hms_get_doctor_auth_cookie();
            if ($auth !== null) {
                $doctorId = (int) $auth['id'];
                $doctorEmail = (string) $auth['username'];
            }
        }

        // If the CI4/native session is not available on this request, restore
        // the doctor identity from the signed authentication cookie.
        if (($doctorId <= 0 || $doctorEmail === '') && function_exists('hms_get_doctor_auth_cookie')) {
            $auth = hms_get_doctor_auth_cookie();
            if ($auth !== null) {
                $doctorId = (int) $auth['id'];
                $doctorEmail = (string) $auth['username'];
            }
        }

        if ($doctorId <= 0 || $doctorEmail === '') {
            header('Location: ' . base_url('hms/doctor/index.php'));
            exit;
        }

        // Verify the doctor against the database before exposing any page.
        $check = mysqli_prepare($con, 'SELECT id, docEmail FROM doctors WHERE id = ? AND docEmail = ? LIMIT 1');
        $valid = false;
        if ($check) {
            mysqli_stmt_bind_param($check, 'is', $doctorId, $doctorEmail);
            mysqli_stmt_execute($check);
            mysqli_stmt_store_result($check);
            $valid = mysqli_stmt_num_rows($check) === 1;
            mysqli_stmt_close($check);
        }
        if (!$valid) {
            $s->destroy();
            header('Location: ' . base_url('hms/doctor/index.php'));
            exit;
        }

        $s->set([
            'id' => $doctorId,
            'login' => $doctorEmail,
            'dlogin' => $doctorEmail,
            'role' => 'doctor'
        ]);
        $_SESSION['id'] = $doctorId;
        $_SESSION['login'] = $doctorEmail;
        $_SESSION['dlogin'] = $doctorEmail;
        $_SESSION['role'] = 'doctor';

        // The legacy pages call hms_require_role(); make the shared PHP session
        // authoritative and then include the requested page.
        $path = APPPATH . '../legacy/hms/doctor/' . $page;
        chdir(dirname($path));
        include $path;
    }

    public function logout()
    {
        session();
        $this->legacy('logout.php');
    }
}
