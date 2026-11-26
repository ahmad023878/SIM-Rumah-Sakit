<?php
/**
 * Shared outpatient workflow helpers.
 * Keeps both appointment-based and walk-in registrations on hms_patient_visits.
 */
if (!function_exists('hms_workflow_ensure_outpatient_encounter')) {
    function hms_workflow_ensure_outpatient_encounter($con, $visitId, $doctorId = 0)
    {
        $visitId = (int)$visitId;
        $visit = hms_fetch_one($con, "SELECT * FROM hms_patient_visits WHERE id=? AND visit_type='RAWAT_JALAN' LIMIT 1", 'i', array($visitId));
        if (!$visit) {
            throw new RuntimeException('Kunjungan rawat jalan tidak ditemukan.');
        }

        $selectedDoctor = (int)$doctorId > 0 ? (int)$doctorId : (int)($visit['doctor_id'] ?? 0);
        $existing = hms_fetch_one($con, 'SELECT id FROM hms_outpatient_encounters WHERE visit_id=? LIMIT 1', 'i', array($visitId));
        if ($existing) {
            $existingId = (int)$existing['id'];
            if ($selectedDoctor > 0) {
                hms_execute($con, "UPDATE hms_outpatient_encounters
                                   SET status=IF(status='TERDAFTAR','DILAYANI',status),
                                       doctor_id=IF(doctor_id IS NULL OR doctor_id=0,?,doctor_id),
                                       started_at=COALESCE(started_at,NOW()),updated_at=NOW()
                                   WHERE id=? AND status<>'SELESAI'",
                    'ii', array($selectedDoctor, $existingId));
            } else {
                hms_execute($con, "UPDATE hms_outpatient_encounters
                                   SET status=IF(status='TERDAFTAR','DILAYANI',status),
                                       started_at=COALESCE(started_at,NOW()),updated_at=NOW()
                                   WHERE id=? AND status<>'SELESAI'",
                    'i', array($existingId));
            }
            return $existingId;
        }

        $patientId = (int)$visit['patient_id'];
        if ($patientId <= 0) {
            throw new RuntimeException('Kunjungan belum terhubung dengan data pasien.');
        }

        $poli = trim((string)($visit['poli'] ?? ''));
        if ($poli === '') {
            $poli = 'Poli Umum';
        }

        $st = mysqli_prepare($con, "INSERT INTO hms_outpatient_encounters(visit_id,patient_id,doctor_id,poli,status,started_at)
                                    VALUES(?,?,?,?, 'DILAYANI', NOW())");
        if (!$st) {
            throw new RuntimeException('Gagal menyiapkan pelayanan rawat jalan.');
        }
        mysqli_stmt_bind_param($st, 'iiis', $visitId, $patientId, $selectedDoctor, $poli);
        if (!mysqli_stmt_execute($st)) {
            mysqli_stmt_close($st);
            // A concurrent request may have created the unique encounter.
            $again = hms_fetch_one($con, 'SELECT id FROM hms_outpatient_encounters WHERE visit_id=? LIMIT 1', 'i', array($visitId));
            if ($again) return (int)$again['id'];
            throw new RuntimeException('Pelayanan rawat jalan gagal dibuat.');
        }
        $encounterId = (int)mysqli_stmt_insert_id($st);
        mysqli_stmt_close($st);

        hms_module_workflow_event($con, $patientId, $visitId, null, null, 'RAWAT_JALAN', 'DILAYANI', 'Pelayanan rawat jalan dimulai.');
        hms_module_audit($con, 'CREATE', 'RAWAT_JALAN', 'hms_outpatient_encounters', $encounterId, 'Encounter dibuat otomatis dari antrean dokter.');
        return $encounterId;
    }
}

if (!function_exists('hms_workflow_has_soap')) {
    function hms_workflow_has_soap($con, $visitId)
    {
        return (int)hms_scalar(
            $con,
            "SELECT COUNT(*) FROM hms_cppt
             WHERE visit_id=? AND note_type='SOAP'
               AND (COALESCE(TRIM(subjective),'')<>'' OR COALESCE(TRIM(objective),'')<>''
                 OR COALESCE(TRIM(assessment),'')<>'' OR COALESCE(TRIM(plan),'')<>''
                 OR COALESCE(TRIM(diagnosis_name),'')<>'' OR COALESCE(TRIM(action_text),'')<>'')",
            'i',
            array((int)$visitId)
        ) > 0;
    }
}
