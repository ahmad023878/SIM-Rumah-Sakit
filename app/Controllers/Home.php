<?php
namespace App\Controllers;
use CodeIgniter\Controller;
class Home extends Controller
{
    public function index()
    {
        // Start the CodeIgniter-managed session before loading legacy PHP.
        session();
        $legacy = APPPATH . '../legacy/index.php';
        if (!is_file($legacy)) throw new \RuntimeException('Legacy homepage not found.');
        chdir(dirname($legacy));
        include $legacy;
    }
}
