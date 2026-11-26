<?php
// Additive integration layer. It never drops/rewrites legacy tables.
if (!function_exists('hms_int_bootstrap')) {
    function hms_int_table_exists($con, $table) {
        $st = mysqli_prepare($con, 'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name=?');
        if (!$st) return false;
        mysqli_stmt_bind_param($st, 's', $table);
        mysqli_stmt_execute($st);
        mysqli_stmt_bind_result($st, $n);
        mysqli_stmt_fetch($st);
        mysqli_stmt_close($st);
        return ((int)$n) > 0;
    }

    function hms_int_column_exists($con, $table, $column) {
        $st = mysqli_prepare($con, 'SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name=? AND column_name=?');
        if (!$st) return false;
        mysqli_stmt_bind_param($st, 'ss', $table, $column);
        mysqli_stmt_execute($st);
        mysqli_stmt_bind_result($st, $n);
        mysqli_stmt_fetch($st);
        mysqli_stmt_close($st);
        return ((int)$n) > 0;
    }

    function hms_int_ensure_column($con, $table, $column, $definition) {
        // Identifiers and definitions are internal constants, never request input.
        if (!hms_int_table_exists($con, $table) || hms_int_column_exists($con, $table, $column)) return true;
        return @mysqli_query($con, "ALTER TABLE `".$table."` ADD COLUMN `".$column."` ".$definition) === true;
    }

    function hms_int_bootstrap($con) {
        $queries = array(
            "CREATE TABLE IF NOT EXISTS hms_master_poli (
                id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                poli_code VARCHAR(30) NOT NULL UNIQUE,
                poli_name VARCHAR(120) NOT NULL UNIQUE,
                is_active TINYINT(1) NOT NULL DEFAULT 1,
                created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME NULL,
                INDEX idx_poli_active(is_active)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS hms_doctor_schedules (
                id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                poli_id INT UNSIGNED NOT NULL,
                doctor_id INT NOT NULL,
                day_of_week TINYINT UNSIGNED NOT NULL,
                available_date DATE NULL,
                start_time TIME NOT NULL,
                end_time TIME NOT NULL,
                quota INT UNSIGNED NOT NULL DEFAULT 1,
                is_active TINYINT(1) NOT NULL DEFAULT 1,
                created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME NULL,
                INDEX idx_schedule_poli_day(poli_id,day_of_week,is_active),
                INDEX idx_schedule_doctor_day(doctor_id,day_of_week,is_active),
                INDEX idx_schedule_date(available_date,is_active)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS hms_visit_schedules (
                id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                visit_id INT UNSIGNED NOT NULL UNIQUE,
                schedule_id INT UNSIGNED NOT NULL,
                service_date DATE NOT NULL,
                quota_snapshot INT UNSIGNED NOT NULL DEFAULT 0,
                created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                INDEX idx_visit_schedule_date(service_date,schedule_id)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
        );
        foreach ($queries as $sql) { @mysqli_query($con, $sql); }
        // Optional display/slot metadata; appointment availability still uses the canonical time range and quota.
        hms_int_ensure_column($con, 'hms_doctor_schedules', 'slot_duration_minutes', 'INT NOT NULL DEFAULT 30');

        // Backward-compatible schema repair:
        // older installations created this same master table with columns `code` and `name`.
        // Keep one table and expose the canonical column names used by current modules.
        if (hms_int_table_exists($con, 'hms_master_poli')) {
            hms_int_ensure_column($con, 'hms_master_poli', 'poli_code', 'VARCHAR(30) NULL');
            hms_int_ensure_column($con, 'hms_master_poli', 'poli_name', 'VARCHAR(120) NULL');
            hms_int_ensure_column($con, 'hms_master_poli', 'is_active', 'TINYINT(1) NOT NULL DEFAULT 1');
            hms_int_ensure_column($con, 'hms_master_poli', 'created_at', 'DATETIME NULL DEFAULT CURRENT_TIMESTAMP');
            hms_int_ensure_column($con, 'hms_master_poli', 'updated_at', 'DATETIME NULL');

            if (hms_int_column_exists($con, 'hms_master_poli', 'name')) {
                @mysqli_query($con, "UPDATE hms_master_poli SET poli_name=COALESCE(NULLIF(poli_name,''),name) WHERE poli_name IS NULL OR poli_name=''");
            }
            if (hms_int_column_exists($con, 'hms_master_poli', 'code')) {
                @mysqli_query($con, "UPDATE hms_master_poli SET poli_code=COALESCE(NULLIF(poli_code,''),code) WHERE poli_code IS NULL OR poli_code=''");
                // Legacy `code` is retained for backward compatibility but made nullable,
                // so new records can be written through the canonical poli_code column.
                @mysqli_query($con, "ALTER TABLE hms_master_poli MODIFY code VARCHAR(30) NULL");
            }
            if (hms_int_column_exists($con, 'hms_master_poli', 'name')) {
                @mysqli_query($con, "ALTER TABLE hms_master_poli MODIFY name VARCHAR(120) NULL");
            }
            // Generate codes only for rows that do not have a code yet; preserve existing values.
            $rsFix = @mysqli_query($con, "SELECT id,poli_name FROM hms_master_poli WHERE poli_code IS NULL OR poli_code=''");
            if ($rsFix) {
                while ($fix = mysqli_fetch_assoc($rsFix)) {
                    $nm = trim((string)($fix['poli_name'] ?? ''));
                    $cd = strtoupper(trim(preg_replace('/[^A-Za-z0-9]+/', '-', $nm), '-'));
                    if ($cd === '') $cd = 'POLI-'.$fix['id'];
                    $cd = substr($cd, 0, 24).'-'.(int)$fix['id'];
                    $stFix = mysqli_prepare($con, "UPDATE hms_master_poli SET poli_code=? WHERE id=?");
                    if ($stFix) { $idFix=(int)$fix['id']; mysqli_stmt_bind_param($stFix, 'si', $cd, $idFix); @mysqli_stmt_execute($stFix); mysqli_stmt_close($stFix); }
                }
                mysqli_free_result($rsFix);
            }
        }

        // Seed only missing master poli values from existing visits. Legacy data is untouched.
        if (hms_int_table_exists($con, 'hms_master_poli') && hms_int_table_exists($con, 'hms_patient_visits')) {
            $rs = @mysqli_query($con, "SELECT DISTINCT TRIM(poli) AS poli_name FROM hms_patient_visits WHERE poli IS NOT NULL AND TRIM(poli)<>'' LIMIT 100");
            if ($rs) {
                while ($r = mysqli_fetch_assoc($rs)) {
                    $name = trim((string)$r['poli_name']);
                    if ($name === '') continue;
                    $code = strtoupper(preg_replace('/[^A-Za-z0-9]+/', '-', $name));
                    $code = trim($code, '-');
                    if ($code === '') $code = 'POLI';
                    $code = substr($code, 0, 30);
                    $st = mysqli_prepare($con, 'INSERT IGNORE INTO hms_master_poli(poli_code,poli_name) VALUES(?,?)');
                    if ($st) { mysqli_stmt_bind_param($st, 'ss', $code, $name); @mysqli_stmt_execute($st); mysqli_stmt_close($st); }
                }
                mysqli_free_result($rs);
            }
        }
        // If there are no existing poli values, provide a safe starter master. These are only master rows.
        $count = (int)hms_scalar($con, 'SELECT COUNT(*) FROM hms_master_poli');
        if ($count === 0) {
            $seed = array(
                array('UMUM','Poli Umum'), array('ANAK','Poli Anak'), array('DALAM','Poli Penyakit Dalam'),
                array('BEDAH','Poli Bedah'), array('KANDUNGAN','Poli Kandungan'), array('MATA','Poli Mata'),
                array('THT','Poli THT'), array('GIGI','Poli Gigi')
            );
            foreach ($seed as $p) {
                $st = mysqli_prepare($con, 'INSERT IGNORE INTO hms_master_poli(poli_code,poli_name) VALUES(?,?)');
                if ($st) { mysqli_stmt_bind_param($st, 'ss', $p[0], $p[1]); @mysqli_stmt_execute($st); mysqli_stmt_close($st); }
            }
        }
    }

    function hms_int_day_name($day) {
        $names = array(0=>'Minggu',1=>'Senin',2=>'Selasa',3=>'Rabu',4=>'Kamis',5=>'Jumat',6=>'Sabtu');
        return $names[(int)$day] ?? '-';
    }

    function hms_int_capacity($con, $scheduleId, $date, $quota) {
        $used = (int)hms_scalar($con,
            "SELECT COUNT(*) FROM hms_visit_schedules vs JOIN hms_patient_visits v ON v.id=vs.visit_id
             WHERE vs.schedule_id=? AND vs.service_date=? AND v.status<>'BATAL'",
            'is', array((int)$scheduleId, $date));
        return max(0, (int)$quota - $used);
    }
}
