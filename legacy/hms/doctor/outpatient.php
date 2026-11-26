<?php
// Stable doctor entry point for SOAP/RME.
$target = dirname(__DIR__) . '/admin/modules/outpatient.php';
if (!is_file($target)) {
    http_response_code(404);
    echo 'SOAP/RME module file missing: ' . htmlspecialchars($target, ENT_QUOTES, 'UTF-8');
    exit;
}
require $target;
