<?php

session();
include 'include/config.php';

$GLOBALS['con'] = $con;

hms_require_role('patient', 'user-login.php');

$patientId = (int) session()->get('id');

$doctors = hms_fetch_all(
    $con,
    'SELECT id, doctorName, specilization, docFees
     FROM doctors
     ORDER BY doctorName ASC'
);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    hms_verify_csrf();

    $doctorId = hms_int(hms_post('doctor_id'));
    $date = hms_post('appointment_date');
    $time = hms_normalize_time(hms_post('appointment_time'));

    $doctor = hms_fetch_one(
        $con,
        'SELECT id, doctorName, specilization, docFees
         FROM doctors
         WHERE id = ?
         LIMIT 1',
        'i',
        array($doctorId)
    );

    if (!$doctor) {
        hms_flash('danger', 'Dokter tidak ditemukan.');
        hms_redirect('book-appointment.php');
    }

    $reason = '';

    if (!hms_doctor_available($con, $doctorId, $date, $time, $reason)) {
        hms_flash('danger', $reason);
        hms_redirect('book-appointment.php');
    }

    hms_execute(
        $con,
        'INSERT INTO appointment(
            doctorSpecialization,
            doctorId,
            userId,
            consultancyFees,
            appointmentDate,
            appointmentTime,
            userStatus,
            doctorStatus,
            status,
            status_updated_at,
            status_updated_by
        )
        VALUES(?, ?, ?, ?, ?, ?, 1, 1, "Pending", NOW(), ?)',
        'siiisss',
        array(
            (string) $doctor['specilization'],
            (int) $doctor['id'],
            $patientId,
            (int) $doctor['docFees'],
            $date,
            $time,
            'patient:' . $patientId
        )
    );

    $appointmentId = mysqli_insert_id($con);

    hms_log_audit(
        $con,
        'patient',
        $patientId,
        'appointment_created',
        'appointment',
        $appointmentId,
        'Patient created appointment.'
    );

    hms_notify(
        $con,
        'doctor',
        (int) $doctor['id'],
        'New appointment request',
        'A patient booked appointment #' . $appointmentId . '.'
    );

    hms_notify(
        $con,
        'admin',
        null,
        'New appointment request',
        'A patient booked appointment #' . $appointmentId . '.'
    );

    hms_flash('success', 'Janji temu berhasil dibuat dan menunggu persetujuan dokter.');
    hms_redirect('appointment-history.php');
}

hms_layout_header('Buat Janji Temu', 'patient', 'book');
?>

<div class="hms-page-title">
    <div>
        <h1>Buat Janji Temu</h1>
        <div class="text-muted">
            Pilih dokter serta tanggal dan waktu sesuai jadwal ketersediaan.
        </div>
    </div>
</div>

<div class="row g-3">
    <div class="col-lg-7">
        <div class="hms-card p-4">
            <form method="post">
                <?php echo hms_csrf_field(); ?>

                <div class="mb-3">
                    <label class="form-label" for="doctor_id">Dokter</label>
                    <select
                        class="form-select"
                        id="doctor_id"
                        name="doctor_id"
                        required
                    >
                        <option value="">Pilih dokter</option>

                        <?php foreach ($doctors as $doctor) { ?>
                            <option value="<?php echo hms_e($doctor['id']); ?>">
                                <?php echo hms_e($doctor['doctorName']); ?>
                                -
                                <?php echo hms_e($doctor['specilization']); ?>
                                -
                                Rp <?php echo hms_e(number_format((int) $doctor['docFees'], 0, ',', '.')); ?>
                            </option>
                        <?php } ?>
                    </select>
                </div>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label" for="appointment_date">
                            Tanggal
                        </label>
                        <input
                            type="date"
                            class="form-control"
                            id="appointment_date"
                            name="appointment_date"
                            min="<?php echo date('Y-m-d'); ?>"
                            required
                        >
                    </div>

                    <div class="col-md-6">
                        <label class="form-label" for="appointment_time">
                            Waktu
                        </label>
                        <input
                            type="time"
                            class="form-control"
                            id="appointment_time"
                            name="appointment_time"
                            required
                        >
                    </div>
                </div>

                <button class="btn btn-primary mt-4" type="submit">
                    <i class="bi bi-calendar-plus me-1"></i>
                    Buat Janji Temu
                </button>
            </form>
        </div>
    </div>

    <div class="col-lg-5">
        <div class="hms-card p-4">
            <h2 class="h5">Jadwal Dokter</h2>

            <?php foreach ($doctors as $doctor) { ?>
                <div class="border-bottom py-3">
                    <div class="fw-semibold">
                        <?php echo hms_e($doctor['doctorName']); ?>
                    </div>

                    <div class="small text-muted">
                        <?php echo hms_e($doctor['specilization']); ?>
                    </div>

                    <div class="small mt-1">
                        <?php
                        echo hms_e(
                            hms_availability_summary(
                                $con,
                                (int) $doctor['id']
                            )
                        );
                        ?>
                    </div>
                </div>
            <?php } ?>
        </div>
    </div>
</div>

<?php hms_layout_footer(); ?>
