<?php

$session = session();
$session->destroy();

header('Location: ../../index.php');
exit;
