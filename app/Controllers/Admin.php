<?php

namespace App\Controllers;

use CodeIgniter\Controller;
use CodeIgniter\Exceptions\PageNotFoundException;

class Admin extends Controller
{
    public function page(string $path = '')
    {
        session();

        $path = str_replace('\\', '/', $path);
        $path = trim($path, '/');

        if ($path === '') {
            $path = 'index.php';
        } elseif (is_dir(APPPATH . '../legacy/hms/admin/' . $path)) {
            $path .= '/index.php';
        } elseif (!str_ends_with(strtolower($path), '.php')) {
            $path .= '.php';
        }

        if (str_contains($path, '..')) {
            return $this->response->setStatusCode(400)->setBody('Invalid path');
        }

        $legacy = APPPATH . '../legacy/hms/admin/' . $path;
        if (!is_file($legacy)) {
            throw PageNotFoundException::forPageNotFound('Admin page not found: ' . $path);
        }

        // Load the legacy helper/auth bridge before the page is included.
        require_once APPPATH . '../legacy/hms/include/config.php';

        // Login and logout are public endpoints.
        $public = in_array(strtolower(basename($path)), ['index.php', 'logout.php'], true);

        if (!$public) {
            // Authenticate the current request directly from the signed ticket.
            // This makes every admin page independent of a stale/missing CI4
            // session cookie while retaining the signed application cookie.
            $ticket = function_exists('hms_get_admin_ticket') ? hms_get_admin_ticket() : null;
            if ($ticket !== null) {
                session()->set([
                    'login' => $ticket['username'],
                    'id'    => $ticket['id'],
                    'role'  => 'admin',
                ]);
                $_SESSION['login'] = $ticket['username'];
                $_SESSION['id'] = $ticket['id'];
                $_SESSION['role'] = 'admin';
                if (function_exists('hms_set_admin_auth_cookie')) {
                    hms_set_admin_auth_cookie($ticket['id'], $ticket['username']);
                }
            } else {
                $auth = function_exists('hms_get_admin_auth_cookie') ? hms_get_admin_auth_cookie() : null;
                if ($auth !== null) {
                    session()->set([
                        'login' => $auth['username'],
                        'id'    => $auth['id'],
                        'role'  => 'admin',
                    ]);
                    $_SESSION['login'] = $auth['username'];
                    $_SESSION['id'] = $auth['id'];
                    $_SESSION['role'] = 'admin';
                }
            }
        }

        chdir(dirname($legacy));
        include $legacy;
    }
}
