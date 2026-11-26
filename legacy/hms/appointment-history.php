<?php
session();
include('include/config.php');
include('include/checklogin.php');
check_login();
hms_require_role('patient', 'logout.php');
require_once __DIR__ . '/admin/modules/module_bootstrap.php';
require_once __DIR__ . '/admin/modules/simrs_integration_bootstrap.php';
hms_module_bootstrap($con);
hms_int_bootstrap($con);

$userId = (int) $_SESSION['id'];
$statusExpr = hms_appointment_status_expr($con, 'a');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    hms_verify_csrf();
    $action = hms_post('action');
    $appointmentId = hms_int(hms_post('appointment_id'));
    $appointment = hms_fetch_one($con, 'SELECT * FROM appointment WHERE id = ? AND userId = ?', 'ii', array($appointmentId, $userId));

    if (!$appointment) {
        hms_flash('error', 'Janji Temu not found.');
        hms_redirect('appointment-history.php');
    }

    $linkedVisit = hms_fetch_one($con, 'SELECT id,status,arrived_at FROM hms_patient_visits WHERE appointment_id=? LIMIT 1', 'i', array($appointmentId));
    if (in_array($action, array('cancel','reschedule'), true) && $linkedVisit && ($linkedVisit['status'] !== 'MENUNGGU' || !empty($linkedVisit['arrived_at']))) {
        hms_flash('error', 'Janji temu tidak dapat diubah karena proses kunjungan sudah dimulai.');
        hms_redirect('appointment-history.php');
    }

    if ($action === 'cancel') {
        hms_set_appointment_status($con, $appointmentId, 'Cancelled', 'patient', $userId);
        hms_notify($con, 'admin', null, 'Janji Temu cancelled', 'Patient cancelled appointment #' . $appointmentId . '.');
        hms_notify($con, 'doctor', (int) $appointment['doctorId'], 'Janji Temu cancelled', 'Patient cancelled appointment #' . $appointmentId . '.');
        hms_flash('success', 'Janji Temu cancelled.');
        hms_redirect('appointment-history.php');
    }

    if ($action === 'reschedule') {
        $newDate = hms_post('appointment_date');
        $newTime = hms_normalize_time(hms_post('appointment_time'));
        require_once __DIR__ . '/include/appointment_queue_bridge.php';
        $poli = hms_fetch_one($con, 'SELECT id FROM hms_master_poli WHERE poli_name=? AND is_active=1 LIMIT 1', 's', array((string)$appointment['doctorSpecialization']));
        $reason = '';
        if (!$poli || !hms_bridge_validate_schedule($con, (int)$poli['id'], (int)$appointment['doctorId'], $newDate, $newTime, $appointmentId, $reason)) {
            hms_flash('error', $poli ? $reason : 'Poli janji temu tidak lagi tersedia pada Master Poli. Hubungi admin untuk pemetaan poli.');
            hms_redirect('appointment-history.php');
        }

        $fields = array('appointmentDate = ?', 'appointmentTime = ?', 'userStatus = 1', 'doctorStatus = 1');
        $types = 'ss';
        $params = array($newDate, $newTime);
        if (hms_column_exists($con, 'appointment', 'status')) {
            $fields[] = 'status = "Pending"';
        }
        if (hms_column_exists($con, 'appointment', 'reschedule_reason')) {
            $fields[] = 'reschedule_reason = ?';
            $types .= 's';
            $params[] = hms_post('reason');
        }
        $types .= 'i';
        $params[] = $appointmentId;
        mysqli_begin_transaction($con);
        try {
            hms_execute($con, 'UPDATE appointment SET ' . implode(', ', $fields) . ' WHERE id = ?', $types, $params);
            hms_bridge_sync_rescheduled_appointment($con, $appointmentId, (int)$poli['id']);
            mysqli_commit($con);
        } catch (Throwable $syncError) {
            mysqli_rollback($con);
            throw $syncError;
        }
        hms_log_audit($con, 'patient', $userId, 'appointment_rescheduled', 'appointment', $appointmentId, 'Rescheduled to ' . $newDate . ' ' . $newTime);
        hms_notify($con, 'admin', null, 'Janji Temu rescheduled', 'Patient requested a new time for appointment #' . $appointmentId . '.');
        hms_notify($con, 'doctor', (int) $appointment['doctorId'], 'Janji Temu rescheduled', 'Janji Temu #' . $appointmentId . ' was moved to ' . $newDate . ' ' . $newTime . '.');
        hms_flash('success', 'Janji Temu rescheduled and moved back to pending review.');
        hms_redirect('appointment-history.php');
    }
}

$appointments = hms_fetch_all(
    $con,
    'SELECT a.id, a.doctorSpecialization, a.consultancyFees, a.appointmentDate, a.appointmentTime, a.postingDate, ' . $statusExpr . ' AS status_name, d.doctorName, d.id AS doctor_id,
            v.registration_no,v.queue_no,v.poli,v.status AS visit_status,v.arrived_at
     FROM appointment a
     JOIN doctors d ON d.id = a.doctorId
     LEFT JOIN hms_patient_visits v ON v.appointment_id=a.id
     WHERE a.userId = ?
     ORDER BY a.appointmentDate DESC, a.id DESC',
    'i',
    array($userId)
);

$prescriptionByAppointment = array();
if ($appointments && hms_table_exists($con, 'prescriptions')) {
    $ids = array_map('intval', array_column($appointments, 'id'));
    $placeholders = implode(',', array_fill(0, count($ids), '?'));
    $prescriptions = hms_fetch_all(
        $con,
        'SELECT id, appointment_id FROM prescriptions WHERE patient_user_id = ? AND appointment_id IN (' . $placeholders . ')',
        'i' . str_repeat('i', count($ids)),
        array_merge(array($userId), $ids)
    );
    foreach ($prescriptions as $prescription) {
        $prescriptionByAppointment[(int) $prescription['appointment_id']] = (int) $prescription['id'];
    }
}

hms_layout_header('Janji Temu Saya', 'patient', 'appointments');
?>
<div class="hms-page-title">
    <div>
        <h1>Janji Temu Saya</h1>
        <div class="text-muted">Pantau status, jadwalkan ulang kunjungan, batalkan bila diperlukan, dan unduh resep.</div>
    </div>
    <a class="btn btn-primary" href="book-appointment.php"><i class="bi bi-calendar-plus me-1"></i>Book Janji Temu</a>
</div>

<div class="hms-card p-3">
    <div class="d-flex flex-wrap gap-2 justify-content-between align-items-center mb-3">
        <h2 class="h5 mb-0">Riwayat Janji Temu</h2>
        <input class="form-control form-control-sm" style="max-width:260px" placeholder="Cari appointments" data-table-search="#appointmentTable">
    </div>
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0" id="appointmentTable" data-sortable>
            <thead>
            <tr>
                <th data-sort>#</th>
                <th data-sort>Doctor</th>
                <th data-sort>Tanggal / Waktu</th>
                <th data-sort>Status</th>
                <th class="text-end">Aksi</th>
            </tr>
            </thead>
            <tbody>
            <?php foreach ($appointments as $appointment) {
                $isClosed = in_array($appointment['status_name'], array('Cancelled', 'Completed'), true) || (!empty($appointment['visit_status']) && ($appointment['visit_status'] !== 'MENUNGGU' || !empty($appointment['arrived_at'])));
                ?>
                <tr>
                    <td><?php echo hms_e($appointment['id']); ?></td>
                    <td>
                        <div class="fw-semibold"><?php echo hms_e($appointment['doctorName']); ?></div>
                        <div class="small text-muted"><?php echo hms_e($appointment['doctorSpecialization']); ?> | Fee: <?php echo hms_e($appointment['consultancyFees']); ?></div>
                    </td>
                    <td><?php echo hms_e($appointment['appointmentDate']); ?> <?php echo hms_e($appointment['appointmentTime']); ?></td>
                    <td><?php echo hms_status_badge($appointment['status_name']); ?>
                        <?php if(!empty($appointment['registration_no'])){ ?>
                          <div class="small text-muted mt-1">Antrean <?php echo hms_e($appointment['queue_no']?:'-'); ?> · <?php echo hms_e($appointment['poli']?:'-'); ?></div>
                          <div class="small">Status kunjungan: <?php echo hms_status_badge($appointment['visit_status']); ?></div>
                        <?php } ?>
                    </td>
                    <td class="text-end">
                        <div class="d-inline-flex flex-wrap gap-2 justify-content-end">
                            <?php if (isset($prescriptionByAppointment[(int) $appointment['id']])) { ?>
                                <a class="btn btn-sm btn-outline-success" href="prescription-download.php?id=<?php echo hms_e($prescriptionByAppointment[(int) $appointment['id']]); ?>"><i class="bi bi-download"></i></a>
                            <?php } ?>
                            <?php if (!$isClosed) { ?>
                                <button class="btn btn-sm btn-outline-primary" type="button" data-bs-toggle="modal" data-bs-target="#reschedule<?php echo hms_e($appointment['id']); ?>">Jadwalkan Ulang</button>
                                <form method="post" class="d-inline" onsubmit="return confirm('Batal this appointment?');">
                                    <?php echo hms_csrf_field(); ?>
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="appointment_id" value="<?php echo hms_e($appointment['id']); ?>">
                                    <button class="btn btn-sm btn-outline-secondary" type="submit">Batal</button>
                                </form>
                            <?php } ?>
                        </div>
                    </td>
                </tr>
            <?php } ?>
            <?php if (!$appointments) { ?>
                <tr><td colspan="5" class="text-center text-muted py-4">No appointments found.</td></tr>
            <?php } ?>
            </tbody>
        </table>
    </div>
</div>

<?php foreach ($appointments as $appointment) {
    if (in_array($appointment['status_name'], array('Cancelled', 'Completed'), true)) {
        continue;
    }
    ?>
    <div class="modal fade" id="reschedule<?php echo hms_e($appointment['id']); ?>" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <form class="modal-content" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Jadwalkan Ulang Janji Temu</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
                </div>
                <div class="modal-body">
                    <?php echo hms_csrf_field(); ?>
                    <input type="hidden" name="action" value="reschedule">
                    <input type="hidden" name="appointment_id" value="<?php echo hms_e($appointment['id']); ?>">
                    <div class="mb-3">
                        <label class="form-label">Ketersediaan Dokter</label>
                        <div class="form-text"><?php echo hms_e(hms_availability_summary($con, (int) $appointment['doctor_id'])); ?></div>
                    </div>
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <label class="form-label">Tanggal Baru</label>
                            <input class="form-control" type="date" name="appointment_date" value="<?php echo hms_e($appointment['appointmentDate']); ?>" min="<?php echo date('Y-m-d'); ?>" required>
                        </div>
                        <div class="col-sm-6">
                            <label class="form-label">Waktu Baru</label>
                            <input class="form-control" type="time" name="appointment_time" value="<?php echo hms_e(substr($appointment['appointmentTime'], 0, 5)); ?>" required>
                        </div>
                    </div>
                    <div class="mt-3">
                        <label class="form-label">Alasan</label>
                        <textarea class="form-control" name="reason" rows="3" maxlength="255"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Tutup</button>
                    <button type="submit" class="btn btn-primary">Kirim</button>
                </div>
            </form>
        </div>
    </div>
<?php } ?>
<?php hms_layout_footer(); ?>
