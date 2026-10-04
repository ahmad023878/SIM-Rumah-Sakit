<?php

namespace Config;

$routes = Services::routes();

$routes->setDefaultNamespace('App\Controllers');
$routes->setDefaultController('Home');
$routes->setDefaultMethod('index');
$routes->setTranslateURIDashes(false);

$routes->get('/', 'Home::index');
$routes->get('index.php', 'Home::index');

// Doctor routes MUST be declared before the generic hms/(:any) route.
// The application uses CodeIgniter 4 as the front controller for /hms/*;
// these routes ensure the doctor login/dashboard handoff is handled by the
// Doctor controller instead of executing the legacy PHP files directly.
$routes->match(['get', 'post'], 'hms/doctor/index.php', 'Doctor::login');
$routes->match(['get', 'post'], 'hms/doctor/dashboard.php', 'Doctor::dashboard');
$routes->get('hms/doctor/logout.php', 'Doctor::logout');
// All other doctor pages are served through Doctor::page so the authenticated
// CI4/legacy session is preserved when clicking the sidebar menu.
$routes->match(['get', 'post'], 'hms/doctor/(:any)', 'Doctor::page/$1');
$routes->match(['get', 'post'], 'hms/doctor', 'Doctor::login');
$routes->match(['get', 'post'], 'hms/doctor/', 'Doctor::login');

// Hospital Legacy
$routes->match(['get', 'post'], 'hms', 'Legacy::page');
$routes->match(['get', 'post'], 'hms/', 'Legacy::page');
$routes->match(['get', 'post'], 'hms/admin', 'Admin::page');
$routes->match(['get', 'post'], 'hms/admin/', 'Admin::page');
$routes->match(['get', 'post'], 'hms/admin/(:any)', 'Admin::page/$1');
$routes->match(['get', 'post'], 'hms/(:any)', 'Legacy::page/$1');