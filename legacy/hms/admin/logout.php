<?php

$session = session();
$session->destroy();

if (function_exists('hms_clear_admin_auth_cookie')) {
    hms_clear_admin_auth_cookie();
}

header('Location: ../../index.php');
exit;
