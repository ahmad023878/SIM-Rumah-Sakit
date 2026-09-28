<?php

namespace Config;

$routes = Services::routes();

$routes->setDefaultNamespace('App\Controllers');
$routes->setDefaultController('Home');
$routes->setDefaultMethod('index');
$routes->setTranslateURIDashes(false);

$routes->get('/', 'Home::index');
$routes->get('index.php', 'Home::index');

// Hospital Legacy
$routes->match(['get', 'post'], 'hms', 'Legacy::page');
$routes->match(['get', 'post'], 'hms/', 'Legacy::page');
$routes->match(['get', 'post'], 'hms/admin', 'Admin::page');
$routes->match(['get', 'post'], 'hms/admin/', 'Admin::page');
$routes->match(['get', 'post'], 'hms/admin/(:any)', 'Admin::page/$1');
$routes->match(['get', 'post'], 'hms/(:any)', 'Legacy::page/$1');