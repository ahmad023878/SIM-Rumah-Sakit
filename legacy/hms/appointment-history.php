<?php

session();
include 'include/config.php';

$GLOBALS['con'] = $con;

hms_require_role('patient', 'user-login.php');

$patientId = (int) session()->get('id');
$statusExpr = hms_appointment_status_expr($con, 'a');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    hms_verify_csrf();

    $appointmentId = hms_int(hms_post('appointment_id'));

    $appointment = hms_fetch_one(
        $con,
        'SELECT id, doctorId
         FROM appointment
         WHERE id = ?
           AND userId = ?
         LIMIT 1',
        'ii',
        array($appointmentId, $patientId)
    );

    if (!$appointment) {
        hms_flash('danger', 'Janji temu tidak ditemukan.');
        hms_redirect('appointment-history.php');
    }

    $currentStatus = hms_scalar(
        $con,
        'SELECT ' . $statusExpr . '
         FROM appointment a
         WHERE a.id = ?
         LIMIT 1',
        'i',
        array($appointmentId)
    );

    if (in_array($currentStatus, array('Completed', 'Cancelled'), true)) {
        hms_flash('danger', 'Janji temu ini tidak dapat dibatalkan.');
        hms_redirect('appointment-history.php');
    }

    hms_set_appointment_status(
        $con,
        $appointmentId,
        'Cancelled',
        'patient',
        $patientId
    );

    hms_notify(
        $con,
        'doctor',
        (int) $appointment['doctorId'],
        'Appointment cancelled',
        'Patient cancelled appointment #' . $appointmentId . '.'
    );

    hms_notify(
        $con,
        'admin',
        null,
        'Appointment cancelled',
        'Patient cancelled appointment #' . $appointmentId . '.'
    );

    hms_flash('success', 'Janji temu berhasil dibatalkan.');
    hms_redirect('appointment-history.php');
}

$appointments = hms_fetch_all(
    $con,
    'SELECT
        a.id,
        a.doctorSpecialization,
        a.consultancyFees,
        a.appointmentDate,
        a.appointmentTime,
        a.postingDate,
        ' . $statusExpr . ' AS status_name,
        d.doctorName
     FROM appointment a
     JOIN doctors d ON d.id = a.doctorId
     WHERE a.userId = ?
     ORDER BY a.appointmentDate DESC,
              a.appointmentTime DESC,
              a.id DESC',
    'i',
    array($patientId)
);

hms_layout_header(
    'Riwayat Janji Temu',
    'patient',
    'appointments'
);
?>

<div class="hms-page-title">
    <div>
        <h1>Janji Temu</h1>
        <div class="text-muted">
            Pantau status janji temu dan batalkan permintaan yang masih aktif.
        </div>
    </div>

    <a class="btn btn-primary" href="book-appointment.php">
        <i class="bi bi-calendar-plus me-1"></i>
        Buat Janji Temu
    </a>
</div>

<div class="hms-card p-3">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead>
            <tr>
                <th>#</th>
                <th>Dokter</th>
                <th>Tanggal / Waktu</th>
                <th>Biaya</th>
                <th>Status</th>
                <th class="text-end">Aksi</th>
            </tr>
            </thead>

            <tbody>
            <?php foreach ($appointments as $appointment) { ?>
                <tr>
                    <td><?php echo hms_e($appointment['id']); ?></td>

                    <td>
                        <div class="fw-semibold">
                            <?php echo hms_e($appointment['doctorName']); ?>
                        </div>

                        <div class="small text-muted">
                            <?php echo hms_e($appointment['doctorSpecialization']); ?>
                        </div>
                    </td>

                    <td>
                        <?php echo hms_e($appointment['appointmentDate']); ?>
                        <?php echo hms_e($appointment['appointmentTime']); ?>
                    </td>

                    <td>
                        Rp
                        <?php
                        echo hms_e(
                            number_format(
                                (int) $appointment['consultancyFees'],
                                0,
                                ',',
                                '.'
                            )
                        );
                        ?>
                    </td>

                    <td>
                        <?php echo hms_status_badge($appointment['status_name']); ?>
                    </td>

                    <td class="text-end">
                        <?php
                        if (
                            !in_array(
                                $appointment['status_name'],
                                array('Completed', 'Cancelled'),
                                true
                            )
                        ) {
                        ?>
                            <form method="post" class="d-inline">
                                <?php echo hms_csrf_field(); ?>

                                <input
                                    type="hidden"
                                    name="appointment_id"
                                    value="<?php echo hms_e($appointment['id']); ?>"
                                >

                                <button
                                    type="submit"
                                    class="btn btn-sm btn-outline-danger"
                                    onclick="return confirm('Batalkan janji temu ini?');"
                                >
                                    Batalkan
                                </button>
                            </form>
                        <?php } ?>
                    </td>
                </tr>
            <?php } ?>

            <?php if (!$appointments) { ?>
                <tr>
                    <td colspan="6" class="text-center text-muted py-4">
                        Belum ada janji temu.
                    </td>
                </tr>
            <?php } ?>
            </tbody>
        </table>
    </div>
</div>

<?php hms_layout_footer(); ?>
