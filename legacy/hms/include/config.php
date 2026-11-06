<?php

$hmsEnv = static function (string $key, $default = null) {
    if (function_exists('env')) {
        $value = env($key);
        if ($value !== null && $value !== '') {
            return $value;
        }
    }

    if (isset($_ENV[$key]) && $_ENV[$key] !== '') {
        return $_ENV[$key];
    }

    if (isset($_SERVER[$key]) && $_SERVER[$key] !== '') {
        return $_SERVER[$key];
    }

    $value = getenv($key);

    return ($value !== false && $value !== '')
        ? $value
        : $default;
};

if (!defined('DB_SERVER')) {
    define(
        'DB_SERVER',
        (string) $hmsEnv('database.default.hostname', 'localhost')
    );

    define(
        'DB_USER',
        (string) $hmsEnv('database.default.username', '')
    );

    define(
        'DB_PASS',
        (string) $hmsEnv('database.default.password', '')
    );

    define(
        'DB_NAME',
        (string) $hmsEnv('database.default.database', '')
    );

    define(
        'DB_PORT',
        (int) $hmsEnv('database.default.port', 3306)
    );
}

$con = mysqli_connect(
    DB_SERVER,
    DB_USER,
    DB_PASS,
    DB_NAME,
    DB_PORT
);

if (!$con) {
    throw new RuntimeException('Failed to connect to the SIMRS database.');
}

mysqli_set_charset($con, 'utf8mb4');

require_once __DIR__ . '/hms_helpers.php';
