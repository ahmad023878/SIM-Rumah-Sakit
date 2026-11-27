<?php
/** Additive bridge between legacy appointment and SIMRS visit/queue workflow. */
if (!function_exists('hms_bridge_ensure_column')) {
    function hms_bridge_ensure_column($con, $table, $column, $definition) {
        if (!hms_column_exists($con, $table, $column)) {
            @mysqli_query($con, "ALTER TABLE `$table` ADD COLUMN `$column` $definition");
        }
    }
    function hms_bridge_ensure_schema($con) {
        require_once __DIR__ . '/../admin/modules/module_bootstrap.php';
        hms_module_bootstrap($con);
        hms_bridge_ensure_column($con, 'hms_patient_visits', 'appointment_id', 'INT NULL');
        hms_bridge_ensure_column($con, 'hms_patient_visits', 'arrived_at', 'DATETIME NULL');
        hms_bridge_ensure_column($con, 'hms_patient_visits', 'called_at', 'DATETIME NULL');
        hms_bridge_ensure_column($con, 'hms_patient_visits', 'served_at', 'DATETIME NULL');
        hms_bridge_ensure_column($con, 'hms_patient_visits', 'completed_at', 'DATETIME NULL');
        @mysqli_query($con, "CREATE TABLE IF NOT EXISTS hms_patient_user_map (
            user_id INT NOT NULL PRIMARY KEY, patient_id INT NOT NULL UNIQUE,
            created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_user_map_patient(patient_id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
        $idx = (int) hms_scalar($con, "SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema=DATABASE() AND table_name='hms_patient_visits' AND index_name='uq_visit_appointment'");
        if (!$idx) @mysqli_query($con, 'ALTER TABLE hms_patient_visits ADD UNIQUE KEY uq_visit_appointment (appointment_id)');
    }
    function hms_bridge_validate_schedule($con, $poliId, $doctorId, $serviceDate, $serviceTime, $excludeAppointmentId = 0, &$reason = null) {
        if (!hms_table_exists($con, 'hms_patient_visits') || !hms_table_exists($con, 'hms_visit_schedules')) {
            hms_bridge_ensure_schema($con);
        }
        require_once __DIR__ . '/../admin/modules/simrs_integration_bootstrap.php';
        if (!hms_int_table_exists($con, 'hms_master_poli') || !hms_int_table_exists($con, 'hms_doctor_schedules') || !hms_int_table_exists($con, 'hms_visit_schedules')) {
            hms_int_bootstrap($con);
        }
        $poliId = (int)$poliId; $doctorId = (int)$doctorId;
        $serviceDate = trim((string)$serviceDate);
        $rawTime = trim((string)$serviceTime);
        if (!preg_match('/^\d{2}:\d{2}(:\d{2})?$/', $rawTime)) {
            $reason = 'Jam janji temu tidak valid.';
            return false;
        }
        $serviceTime = strlen($rawTime) === 5 ? $rawTime . ':00' : $rawTime;
        if ($poliId <= 0 || $doctorId <= 0 || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $serviceDate) || $serviceDate < date('Y-m-d')) {
            $reason = 'Poli, dokter, atau tanggal janji temu tidak valid.';
            return false;
        }
        $day = (int)date('w', strtotime($serviceDate));
        $schedule = hms_fetch_one($con,
            "SELECT s.*,p.poli_name,d.doctorName
             FROM hms_doctor_schedules s
             JOIN hms_master_poli p ON p.id=s.poli_id AND p.is_active=1
             JOIN doctors d ON d.id=s.doctor_id
             WHERE s.poli_id=? AND s.doctor_id=? AND s.is_active=1
               AND ((s.available_date IS NOT NULL AND DATE(s.available_date)=?)
                    OR ((s.available_date IS NULL OR DATE(s.available_date)='0000-00-00') AND s.day_of_week=?))
               AND s.start_time<=? AND s.end_time>?
             ORDER BY (s.available_date IS NOT NULL) DESC,s.start_time,s.id
             LIMIT 1 FOR UPDATE",
            'iisiss', array($poliId,$doctorId,$serviceDate,$day,$serviceTime,$serviceTime)
        );
        if (!$schedule) {
            $reason = 'Dokter tidak memiliki jadwal aktif pada poli, tanggal, dan jam yang dipilih.';
            return false;
        }
        $excludeAppointmentId = (int)$excludeAppointmentId;
        $used = (int)hms_scalar($con,
            "SELECT COUNT(*) FROM hms_visit_schedules vs
             JOIN hms_patient_visits v ON v.id=vs.visit_id
             WHERE vs.schedule_id=? AND vs.service_date=? AND v.status<>'BATAL'
               AND (?=0 OR v.appointment_id IS NULL OR v.appointment_id<>?)",
            'isii', array((int)$schedule['id'],$serviceDate,$excludeAppointmentId,$excludeAppointmentId)
        );
        if ($used >= (int)$schedule['quota']) {
            $reason = 'Kuota jadwal dokter sudah penuh pada tanggal dan jam tersebut.';
            return false;
        }
        $schedule['used_quota'] = $used;
        $schedule['remaining_quota'] = max(0, (int)$schedule['quota'] - $used);
        return $schedule;
    }

    function hms_bridge_sync_rescheduled_appointment($con, $appointmentId, $poliId) {
        if (!hms_table_exists($con, 'hms_patient_visits') || !hms_table_exists($con, 'hms_visit_schedules')) {
            hms_bridge_ensure_schema($con);
        }
        require_once __DIR__ . '/../admin/modules/simrs_integration_bootstrap.php';
        if (!hms_int_table_exists($con, 'hms_master_poli') || !hms_int_table_exists($con, 'hms_doctor_schedules') || !hms_int_table_exists($con, 'hms_visit_schedules')) {
            hms_int_bootstrap($con);
        }
        $a = hms_fetch_one($con,
            'SELECT id,doctorId,doctorSpecialization,appointmentDate,appointmentTime FROM appointment WHERE id=?',
            'i', array((int)$appointmentId)
        );
        if (!$a) throw new RuntimeException('Janji temu tidak ditemukan saat sinkronisasi jadwal baru.');
        $visit = hms_fetch_one($con, 'SELECT * FROM hms_patient_visits WHERE appointment_id=? LIMIT 1', 'i', array((int)$appointmentId));
        if (!$visit) {
            hms_bridge_create_visit_for_appointment($con, (int)$appointmentId);
            $visit = hms_fetch_one($con, 'SELECT * FROM hms_patient_visits WHERE appointment_id=? LIMIT 1', 'i', array((int)$appointmentId));
        }
        if (!$visit) throw new RuntimeException('Kunjungan antrean untuk janji temu belum terbentuk.');
        if ($visit['status'] !== 'MENUNGGU') throw new RuntimeException('Jadwal tidak dapat diubah setelah pasien dipanggil atau pemeriksaan dimulai.');
        $reason = '';
        $schedule = hms_bridge_validate_schedule($con, (int)$poliId, (int)$a['doctorId'], (string)$a['appointmentDate'], (string)$a['appointmentTime'], (int)$appointmentId, $reason);
        if (!$schedule) throw new RuntimeException($reason);
        $newQueue = hms_module_next_queue($con, (string)$schedule['poli_name'], (string)$a['appointmentDate']);
        hms_execute($con,
            "UPDATE hms_patient_visits SET visit_date=?,poli=?,doctor_id=?,queue_no=?,status='MENUNGGU',
             arrived_at=NULL,called_at=NULL,served_at=NULL,completed_at=NULL,updated_at=NOW() WHERE id=?",
            'ssisi', array((string)$a['appointmentDate'],(string)$schedule['poli_name'],(int)$a['doctorId'],$newQueue,(int)$visit['id'])
        );
        hms_execute($con, 'DELETE FROM hms_visit_schedules WHERE visit_id=?', 'i', array((int)$visit['id']));
        hms_execute($con, 'INSERT INTO hms_visit_schedules(visit_id,schedule_id,service_date,quota_snapshot) VALUES(?,?,?,?)',
            'iisi', array((int)$visit['id'],(int)$schedule['id'],(string)$a['appointmentDate'],(int)$schedule['quota']));
        hms_module_workflow_event($con, (int)$visit['patient_id'], (int)$visit['id'], null, null, 'APPOINTMENT_RESCHEDULED', 'MENUNGGU', 'Janji temu dan antrean dipindahkan ke jadwal baru.');
        return (int)$visit['id'];
    }

    function hms_bridge_patient_id($con, $userId) {
        $mapped = hms_fetch_one($con, 'SELECT patient_id FROM hms_patient_user_map WHERE user_id=?', 'i', array((int)$userId));
        if ($mapped) return (int)$mapped['patient_id'];
        $u = hms_fetch_one($con, 'SELECT fullName,email,address,gender FROM users WHERE id=?', 'i', array((int)$userId));
        if (!$u) throw new RuntimeException('Akun pasien tidak ditemukan untuk integrasi kunjungan.');
        $p = hms_fetch_one($con, 'SELECT ID FROM tblpatient WHERE PatientEmail=? ORDER BY ID LIMIT 1', 's', array((string)$u['email']));
        if ($p) $patientId = (int)$p['ID'];
        else {
            $name = trim((string)$u['fullName']); $email = (string)$u['email'];
            $gender = (string)$u['gender']; $address = (string)$u['address']; $age = 0; $phone = 0; $history = 'Dibuat otomatis dari akun portal pasien';
            $st = mysqli_prepare($con, 'INSERT INTO tblpatient(Docid,PatientName,PatientContno,PatientEmail,PatientGender,PatientAdd,PatientAge,PatientMedhis,CreationDate) VALUES(NULL,?,NULL,?,?,?,?,?,NOW())');
            if (!$st) throw new RuntimeException('Gagal menyiapkan master pasien.');
            mysqli_stmt_bind_param($st, 'ssssis', $name, $email, $gender, $address, $age, $history);
            if (!mysqli_stmt_execute($st)) { mysqli_stmt_close($st); throw new RuntimeException('Gagal membuat master pasien untuk appointment.'); }
            $patientId = mysqli_stmt_insert_id($st); mysqli_stmt_close($st);
            $mrn = 'RM' . date('Y') . str_pad((string)$patientId, 6, '0', STR_PAD_LEFT);
            hms_execute($con, 'UPDATE tblpatient SET medical_record_no=? WHERE ID=?', 'si', array($mrn, $patientId));
        }
        hms_execute($con, 'INSERT IGNORE INTO hms_patient_user_map(user_id,patient_id) VALUES(?,?)', 'ii', array((int)$userId, $patientId));
        return $patientId;
    }
    function hms_bridge_create_visit_for_appointment($con, $appointmentId) {
        if (!hms_table_exists($con, 'hms_patient_visits')) hms_bridge_ensure_schema($con);
        $existing = hms_fetch_one($con, 'SELECT id FROM hms_patient_visits WHERE appointment_id=?', 'i', array((int)$appointmentId));
        if ($existing) return (int)$existing['id'];
        $a = hms_fetch_one($con, 'SELECT a.id,a.userId,a.doctorId,a.doctorSpecialization,a.appointmentDate,a.appointmentTime,d.doctorName FROM appointment a LEFT JOIN doctors d ON d.id=a.doctorId WHERE a.id=?', 'i', array((int)$appointmentId));
        if (!$a) throw new RuntimeException('Appointment tidak ditemukan untuk dibuatkan antrean.');
        $pid = hms_bridge_patient_id($con, (int)$a['userId']);
        $date = date('Y-m-d', strtotime((string)$a['appointmentDate']));
        $poli = trim((string)$a['doctorSpecialization']); if ($poli === '') $poli = 'Poli Umum';
        $reg = hms_module_next_code($con, 'hms_patient_visits', 'REG', 'id');
        $queue = hms_module_next_queue($con, $poli, $date);
        $mr = hms_fetch_one($con, 'SELECT medical_record_no FROM tblpatient WHERE ID=?', 'i', array($pid));
        $mrType = !empty($mr['medical_record_no']) ? 'LAMA' : 'BARU';
        $doctorId = (int)$a['doctorId']; $apptId = (int)$appointmentId; $source='ONLINE'; $status='MENUNGGU'; $time = (string)$a['appointmentTime'];
        $st = mysqli_prepare($con, "INSERT INTO hms_patient_visits(patient_id,mr_type,registration_no,visit_date,visit_type,poli,doctor_id,queue_no,source,status,appointment_id,registration_counter) VALUES(?,?,?,?,'RAWAT_JALAN',?,?,?,'ONLINE','MENUNGGU',?,'Appointment Online')");
        if (!$st) throw new RuntimeException('Gagal menyiapkan kunjungan dari appointment.');
        mysqli_stmt_bind_param($st, 'issssisi', $pid, $mrType, $reg, $date, $poli, $doctorId, $queue, $apptId);
        if (!mysqli_stmt_execute($st)) { mysqli_stmt_close($st); $dup = hms_fetch_one($con,'SELECT id FROM hms_patient_visits WHERE appointment_id=?','i',array($apptId)); if($dup)return (int)$dup['id']; throw new RuntimeException('Gagal membuat antrean appointment.'); }
        $visitId = mysqli_stmt_insert_id($st); mysqli_stmt_close($st);
        // If the newer Poli-Dokter-Jadwal master is configured, bind this visit
        // to the exact matching schedule as well (doctor + date/day + time).
        require_once __DIR__ . '/../admin/modules/simrs_integration_bootstrap.php';
        if (!hms_int_table_exists($con, 'hms_master_poli') || !hms_int_table_exists($con, 'hms_doctor_schedules') || !hms_int_table_exists($con, 'hms_visit_schedules')) hms_int_bootstrap($con);
        $day = (int)date('w', strtotime($date));
        $time24 = date('H:i:s', strtotime($time));
        $matchedSchedule = hms_fetch_one($con,
            "SELECT s.id,s.quota,p.poli_name FROM hms_doctor_schedules s
             JOIN hms_master_poli p ON p.id=s.poli_id
             WHERE s.doctor_id=? AND s.is_active=1 AND p.is_active=1
               AND ((s.available_date IS NOT NULL AND DATE(s.available_date)=?) OR ((s.available_date IS NULL OR DATE(s.available_date)='0000-00-00') AND s.day_of_week=?))
               AND p.poli_name=? AND s.start_time<=? AND s.end_time>?
             ORDER BY (s.available_date IS NOT NULL) DESC,s.start_time LIMIT 1",
            'isisss', array($doctorId,$date,$day,$poli,$time24,$time24));
        if ($matchedSchedule) {
            hms_execute($con, 'UPDATE hms_patient_visits SET poli=? WHERE id=?', 'si', array($matchedSchedule['poli_name'],$visitId));
            hms_execute($con, 'INSERT IGNORE INTO hms_visit_schedules(visit_id,schedule_id,service_date,quota_snapshot) VALUES(?,?,?,?)', 'iisi', array($visitId,(int)$matchedSchedule['id'],$date,(int)$matchedSchedule['quota']));
        }
        hms_module_workflow_event($con, $pid, $visitId, null, null, 'APPOINTMENT_TERHUBUNG', 'MENUNGGU', 'Appointment #' . $apptId . ' terhubung ke antrean ' . $queue . '.');
        hms_module_audit($con, 'CREATE', 'APPOINTMENT_BRIDGE', 'hms_patient_visits', $visitId, 'Appointment terhubung ke kunjungan dan antrean.', null, array('appointment_id'=>$apptId,'patient_id'=>$pid,'doctor_id'=>$doctorId,'queue_no'=>$queue,'visit_date'=>$date));
        return (int)$visitId;
    }
    function hms_bridge_sync_appointment_status($con, $appointmentId, $status) {
        if (!hms_table_exists($con, 'hms_patient_visits')) return;
        $visit = hms_fetch_one($con, 'SELECT id FROM hms_patient_visits WHERE appointment_id=?', 'i', array((int)$appointmentId));
        if (!$visit) return;
        if ($status === 'Cancelled') {
            // Cancellation may affect only a visit that has not entered the clinical workflow.
            hms_execute($con, "UPDATE hms_patient_visits SET status='BATAL',updated_at=NOW() WHERE id=? AND status='MENUNGGU' AND arrived_at IS NULL AND served_at IS NULL", 'i', array((int)$visit['id']));
        } elseif ($status === 'Completed') {
            // Booking completion is not clinical completion; only the RME workflow
            // may mark hms_patient_visits as SELESAI.
            if (function_exists('hms_module_workflow_event')) {
                $v = hms_fetch_one($con, 'SELECT patient_id,status FROM hms_patient_visits WHERE id=?', 'i', array((int)$visit['id']));
                if ($v && $v['status'] !== 'SELESAI') {
                    hms_module_workflow_event($con, (int)$v['patient_id'], (int)$visit['id'], null, null, 'APPOINTMENT', 'Completed', 'Janji temu ditutup; status klinis kunjungan tetap mengikuti pemeriksaan dokter.');
                }
            }
        } elseif ($status === 'Approved') {
            hms_execute($con, "UPDATE hms_patient_visits SET status='MENUNGGU',updated_at=NOW() WHERE id=? AND status='BATAL'", 'i', array((int)$visit['id']));
        }
    }
}
