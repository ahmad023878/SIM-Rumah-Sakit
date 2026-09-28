<?php

namespace App\Controllers;

use CodeIgniter\Controller;
use CodeIgniter\Exceptions\PageNotFoundException;

class Legacy extends Controller
{
    public function page(string $path = '')
    {
        // Gunakan session CodeIgniter 4
        session();

        // Normalisasi path
        $path = str_replace('\\', '/', $path);
        $path = trim($path, '/');

        // URL /hms/ → legacy/hms/index.php
        if ($path === '') {
            $path = 'index.php';
        }

        // Jika path menunjuk folder:
        // /hms/admin/ → legacy/hms/admin/index.php
        else {
            $candidateDirectory = APPPATH . '../legacy/hms/' . $path;

            if (is_dir($candidateDirectory)) {
                $path .= '/index.php';
            } elseif (!str_ends_with(strtolower($path), '.php')) {
                $path .= '.php';
            }
        }

        // Keamanan path
        if (str_contains($path, '..')) {
            return $this->response
                ->setStatusCode(400)
                ->setBody('Invalid path');
        }

        $legacy = APPPATH . '../legacy/hms/' . $path;

        // Pastikan file benar-benar ada
        if (!is_file($legacy)) {
            throw PageNotFoundException::forPageNotFound(
                'Legacy page not found: ' . $path
            );
        }

        // Penting untuk file Legacy yang menggunakan include relatif
        chdir(dirname($legacy));

        // Jalankan halaman PHP Legacy
        include $legacy;
    }
}