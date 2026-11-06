<?php

session();
include 'include/config.php';

$GLOBALS['con'] = $con;

hms_require_role('patient', 'user-login.php');

$patientId = (int) session()->get('id');

$patient = hms_fetch_one(
    $con,
    'SELECT id, fullName, email, city, gender, regDate
     FROM users
     WHERE id = ?
     LIMIT 1',
    'i',
    array($patientId)
);

if (!$patient) {
    session()->destroy();
    hms_redirect('user-login.php');
}

$totalAppointments = (int) hms_scalar(
    $con,
    'SELECT COUNT(*)
     FROM appointment
     WHERE userId = ?',
    'i',
    array($patientId)
);

$nextAppointment = hms_fetch_one(
    $con,
    'SELECT a.id,
            a.appointmentDate,
            a.appointmentTime,
            a.doctorSpecialization,
            d.doctorName
     FROM appointment a
     LEFT JOIN doctors d ON d.id = a.doctorId
     WHERE a.userId = ?
       AND a.appointmentDate >= CURDATE()
     ORDER BY a.appointmentDate ASC, a.appointmentTime ASC
     LIMIT 1',
    'i',
    array($patientId)
);

hms_layout_header('Dasbor Pasien', 'patient', 'dashboard');
?>

<div class="hms-page-title">
    <div>
        <h1>Dasbor Pasien</h1>
        <div class="text-muted">
            Pantau akun dan janji temu pelayanan rawat jalan.
        </div>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-12 col-md-6">
        <div class="hms-card p-4">
            <div class="small text-muted">Pasien</div>
            <div class="fs-4 fw-semibold">
                <?php echo hms_e($patient['fullName']); ?>
            </div>
            <div class="text-muted">
                <?php echo hms_e($patient['email']); ?>
            </div>
        </div>
    </div>

    <div class="col-12 col-md-6">
        <div class="hms-card p-4">
            <div class="small text-muted">Total Janji Temu</div>
            <div class="display-6 fw-semibold">
                <?php echo hms_e($totalAppointments); ?>
            </div>
        </div>
    </div>
</div>

<div class="hms-card p-4">
    <h2 class="h5">Janji Temu Berikutnya</h2>

    <?php if ($nextAppointment) { ?>
        <div class="mt-3">
            <div class="fw-semibold">
                <?php echo hms_e($nextAppointment['doctorName'] ?: 'Dokter'); ?>
            </div>

            <div>
                <?php echo hms_e($nextAppointment['doctorSpecialization']); ?>
            </div>

            <div class="text-muted">
                <?php echo hms_e($nextAppointment['appointmentDate']); ?>
                ·
                <?php echo hms_e($nextAppointment['appointmentTime']); ?>
            </div>
        </div>
    <?php } else { ?>
        <div class="text-muted mt-3">
            Belum ada janji temu berikutnya.
        </div>
    <?php } ?>
</div>

<?php hms_layout_footer(); ?>
