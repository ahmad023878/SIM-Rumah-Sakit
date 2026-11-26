<?php
// Shared bootstrap for the additive Hospital-SIM modules.
// Keeps legacy modules intact while adding security/integrity helpers.
if (!function_exists('hms_set_flash') && function_exists('hms_flash')) {
    function hms_set_flash($type, $message) { return hms_flash($type, $message); }
}

if (!function_exists('hms_module_query_safe')) {
    function hms_module_query_safe($con, $sql)
    {
        try {
            return @mysqli_query($con, $sql);
        } catch (Throwable $e) {
            // Schema hardening must never take down the application page.
            // The caller can continue; compatible constraints are retried on a later run.
            return false;
        }
    }
}

if (!function_exists('hms_module_bootstrap')) {
    function hms_module_bootstrap($con)
    {
        $queries = array(
"CREATE TABLE IF NOT EXISTS hms_module_sequences (code_key VARCHAR(80) PRIMARY KEY, next_value BIGINT UNSIGNED NOT NULL DEFAULT 0) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_audit_events (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 actor_id INT NULL, actor_role VARCHAR(40) NULL, actor_name VARCHAR(150) NULL,
 action_name VARCHAR(80) NOT NULL, module_name VARCHAR(80) NOT NULL,
 table_name VARCHAR(80) NULL, record_id BIGINT NULL, description VARCHAR(500) NULL,
 old_data JSON NULL, new_data JSON NULL, ip_address VARCHAR(45) NULL,
 user_agent VARCHAR(500) NULL, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX idx_audit_created(created_at), INDEX idx_audit_actor(actor_id,actor_role), INDEX idx_audit_record(table_name,record_id), INDEX idx_audit_action(action_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_patient_visits (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, patient_id INT NULL, registration_no VARCHAR(40) NOT NULL UNIQUE, visit_date DATE NOT NULL,
 visit_type ENUM('RAWAT_JALAN','IGD','RAWAT_INAP') NOT NULL DEFAULT 'RAWAT_JALAN', poli VARCHAR(120) NULL, doctor_id INT NULL,
 queue_no VARCHAR(20) NULL, source ENUM('ONLINE','OFFLINE') NOT NULL DEFAULT 'OFFLINE', status ENUM('MENUNGGU','DILAYANI','SELESAI','BATAL') NOT NULL DEFAULT 'MENUNGGU',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME NULL, INDEX(patient_id), INDEX(visit_date), INDEX(status), INDEX(visit_date,poli,queue_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_igd_visits (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, visit_id INT NULL, patient_id INT NULL, registration_no VARCHAR(40) NOT NULL,
 arrival_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, triage_level ENUM('MERAH','KUNING','HIJAU','HITAM') NOT NULL DEFAULT 'HIJAU', chief_complaint TEXT NULL,
 vital_signs TEXT NULL, emergency_action TEXT NULL, doctor_id INT NULL, disposition ENUM('RAWAT_INAP','PULANG','RUJUK','OBSERVASI') NOT NULL DEFAULT 'OBSERVASI',
 disposition_note TEXT NULL, status ENUM('AKTIF','SELESAI') NOT NULL DEFAULT 'AKTIF', created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX(patient_id), INDEX(visit_id), INDEX(triage_level), INDEX(disposition)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_beds (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, room_no VARCHAR(30) NOT NULL, bed_no VARCHAR(30) NOT NULL, class_name VARCHAR(60) NOT NULL,
 ward VARCHAR(100) NOT NULL, daily_rate DECIMAL(14,2) NOT NULL DEFAULT 0, status ENUM('TERSEDIA','TERISI','DIBERSIHKAN','NONAKTIF') NOT NULL DEFAULT 'TERSEDIA',
 UNIQUE KEY uq_bed(room_no,bed_no), INDEX(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_admissions (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, visit_id INT UNSIGNED NULL, patient_id INT NULL, admission_no VARCHAR(40) NOT NULL UNIQUE,
 bed_id INT NULL, admission_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, discharge_date DATETIME NULL, class_name VARCHAR(60) NULL,
 attending_doctor_id INT NULL, status ENUM('DIRAWAT','PINDAH','PULANG') NOT NULL DEFAULT 'DIRAWAT', discharge_note TEXT NULL,
 INDEX(patient_id), INDEX(bed_id), INDEX(visit_id), INDEX(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_bed_movements (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, admission_id INT NOT NULL, from_bed_id INT NULL, to_bed_id INT NULL, reason VARCHAR(255) NULL,
 moved_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, INDEX(admission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_cppt (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, patient_id INT NULL, visit_id INT NULL, admission_id INT NULL,
 author_type ENUM('DOKTER','PERAWAT','ADMIN','REKAM_MEDIS') NOT NULL DEFAULT 'DOKTER', author_id INT NULL,
 note_type ENUM('SOAP','CPPT','KEPERAWATAN','OBSERVASI','RESUME') NOT NULL DEFAULT 'CPPT', subjective TEXT NULL, objective TEXT NULL,
 assessment TEXT NULL, plan TEXT NULL, diagnosis_code VARCHAR(20) NULL, diagnosis_name VARCHAR(255) NULL, action_text TEXT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, INDEX(patient_id), INDEX(visit_id), INDEX(admission_id), INDEX(author_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_referrals (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, patient_id INT NULL, visit_id INT UNSIGNED NULL, referral_date DATE NOT NULL, destination VARCHAR(255) NOT NULL,
 diagnosis VARCHAR(255) NULL, reason TEXT NULL, status ENUM('DRAFT','DIKIRIM','DITERIMA','SELESAI') NOT NULL DEFAULT 'DRAFT', created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX(patient_id), INDEX(visit_id), INDEX(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_bills (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, patient_id INT NULL, visit_id INT UNSIGNED NULL, admission_id INT UNSIGNED NULL, invoice_no VARCHAR(50) NOT NULL UNIQUE,
 bill_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, payer_type ENUM('TUNAI','BPJS','ASURANSI','PERUSAHAAN') NOT NULL DEFAULT 'TUNAI', payer_name VARCHAR(150) NULL,
 subtotal DECIMAL(14,2) NOT NULL DEFAULT 0, discount DECIMAL(14,2) NOT NULL DEFAULT 0, total DECIMAL(14,2) NOT NULL DEFAULT 0,
 status ENUM('BELUM_LUNAS','SEBAGIAN','LUNAS','BATAL') NOT NULL DEFAULT 'BELUM_LUNAS', INDEX(patient_id), INDEX(visit_id), INDEX(admission_id), INDEX(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_bill_items (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, bill_id INT UNSIGNED NOT NULL, service_type VARCHAR(80) NOT NULL, description VARCHAR(255) NOT NULL,
 qty DECIMAL(10,2) NOT NULL DEFAULT 1, unit_price DECIMAL(14,2) NOT NULL DEFAULT 0, amount DECIMAL(14,2) NOT NULL DEFAULT 0, INDEX(bill_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_payments (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, bill_id INT UNSIGNED NOT NULL, payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 amount DECIMAL(14,2) NOT NULL DEFAULT 0, method ENUM('TUNAI','TRANSFER','KARTU','BPJS','ASURANSI','PERUSAHAAN') NOT NULL DEFAULT 'TUNAI',
 reference_no VARCHAR(100) NULL, notes VARCHAR(255) NULL, INDEX(bill_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
,"CREATE TABLE IF NOT EXISTS hms_icd10 (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, code VARCHAR(20) NOT NULL UNIQUE, description VARCHAR(255) NOT NULL, category VARCHAR(120) NULL, is_active TINYINT(1) NOT NULL DEFAULT 1, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, INDEX(category), INDEX(is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_service_catalog (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, service_code VARCHAR(40) NOT NULL UNIQUE, service_name VARCHAR(180) NOT NULL, service_type VARCHAR(80) NOT NULL, unit VARCHAR(40) NULL, price DECIMAL(14,2) NOT NULL DEFAULT 0, is_active TINYINT(1) NOT NULL DEFAULT 1, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, INDEX(service_type), INDEX(is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_clinical_charges (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, patient_id INT NULL, visit_id INT UNSIGNED NULL, admission_id INT UNSIGNED NULL, cppt_id INT UNSIGNED NULL, igd_id INT UNSIGNED NULL, service_id INT UNSIGNED NULL, service_type VARCHAR(80) NOT NULL, description VARCHAR(255) NOT NULL, qty DECIMAL(10,2) NOT NULL DEFAULT 1, unit_price DECIMAL(14,2) NOT NULL DEFAULT 0, amount DECIMAL(14,2) NOT NULL DEFAULT 0, bill_id INT UNSIGNED NULL, status ENUM('POSTED','BILLED','CANCELLED') NOT NULL DEFAULT 'POSTED', created_by INT NULL, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, INDEX(patient_id), INDEX(visit_id), INDEX(admission_id), INDEX(cppt_id), INDEX(igd_id), INDEX(service_id), INDEX(bill_id), INDEX(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_workflow_events (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, patient_id INT NULL, visit_id INT NULL, admission_id INT NULL, igd_id INT NULL, event_type VARCHAR(80) NOT NULL, event_status VARCHAR(40) NULL, description VARCHAR(500) NULL, actor_id INT NULL, actor_role VARCHAR(40) NULL, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, INDEX(patient_id), INDEX(visit_id), INDEX(admission_id), INDEX(igd_id), INDEX(event_type), INDEX(created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
"CREATE TABLE IF NOT EXISTS hms_outpatient_encounters (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, visit_id INT UNSIGNED NOT NULL UNIQUE, patient_id INT NOT NULL, doctor_id INT NULL, poli VARCHAR(120) NOT NULL, anamnesis TEXT NULL, physical_exam TEXT NULL, assessment TEXT NULL, plan TEXT NULL, diagnosis_code VARCHAR(20) NULL, diagnosis_name VARCHAR(255) NULL, action_text TEXT NULL, referral_id INT NULL, status ENUM('TERDAFTAR','DIPANGGIL','DILAYANI','SELESAI','BATAL') NOT NULL DEFAULT 'TERDAFTAR', started_at DATETIME NULL, completed_at DATETIME NULL, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME NULL, INDEX(patient_id), INDEX(doctor_id), INDEX(poli), INDEX(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
        );
        foreach ($queries as $q) { hms_module_query_safe($con, $q); }
        // Stage 2 workflow columns; additive and safe for existing installations.
        $columns = array(
            array('hms_igd_visits','admission_id','ALTER TABLE hms_igd_visits ADD COLUMN admission_id INT NULL AFTER doctor_id'),
            array('hms_clinical_charges','created_by','ALTER TABLE hms_clinical_charges ADD COLUMN created_by INT NULL AFTER status'),
            array('tblpatient','medical_record_no',"ALTER TABLE tblpatient ADD COLUMN medical_record_no VARCHAR(30) NULL AFTER ID"),
            array('hms_patient_visits','registration_counter',"ALTER TABLE hms_patient_visits ADD COLUMN registration_counter VARCHAR(40) NULL AFTER source"),
            array('hms_patient_visits','appointment_id',"ALTER TABLE hms_patient_visits ADD COLUMN appointment_id INT NULL AFTER doctor_id"),
            array('hms_patient_visits','mr_type',"ALTER TABLE hms_patient_visits ADD COLUMN mr_type ENUM('BARU','LAMA') NOT NULL DEFAULT 'LAMA' AFTER patient_id"),
            array('hms_patient_visits','online_booking_token',"ALTER TABLE hms_patient_visits ADD COLUMN online_booking_token VARCHAR(80) NULL AFTER source"),
            array('hms_patient_visits','arrived_at',"ALTER TABLE hms_patient_visits ADD COLUMN arrived_at DATETIME NULL AFTER created_at"),
            array('hms_patient_visits','called_at',"ALTER TABLE hms_patient_visits ADD COLUMN called_at DATETIME NULL AFTER status"),
            array('hms_patient_visits','served_at',"ALTER TABLE hms_patient_visits ADD COLUMN served_at DATETIME NULL AFTER called_at"),
            array('hms_patient_visits','completed_at',"ALTER TABLE hms_patient_visits ADD COLUMN completed_at DATETIME NULL AFTER served_at")
        );
        foreach ($columns as $col) {
            if (hms_table_exists($con,$col[0]) && !hms_column_exists($con,$col[0],$col[1])) { hms_module_query_safe($con,$col[2]); }
        }
        // Ensure the queue lifecycle enum includes DIPANGGIL. The previous
        // implementation checked for a non-existent queue_status column, so
        // existing installations could retain the old enum and reject calls.
        if (hms_table_exists($con,'hms_patient_visits') && hms_column_exists($con,'hms_patient_visits','status')) {
            $visitStatusType = (string)hms_scalar($con, "SELECT COLUMN_TYPE FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='hms_patient_visits' AND column_name='status' LIMIT 1");
            if (stripos($visitStatusType, 'DIPANGGIL') === false) {
                hms_module_query_safe($con, "ALTER TABLE hms_patient_visits MODIFY status ENUM('MENUNGGU','DIPANGGIL','DILAYANI','SELESAI','BATAL') NOT NULL DEFAULT 'MENUNGGU'");
            }
        }
        // Backfill automatic medical record numbers for legacy patients.
        if (hms_table_exists($con,'tblpatient') && hms_column_exists($con,'tblpatient','medical_record_no')) {
            hms_module_query_safe($con, "UPDATE tblpatient SET medical_record_no=CONCAT('RM', DATE_FORMAT(COALESCE(CreationDate,CURDATE()),'%Y'), LPAD(ID,6,'0')) WHERE medical_record_no IS NULL OR medical_record_no=''");
            // Idempotent: do not recreate the unique index on every page load.
            // The unique index is intentionally NOT created during every page request.
            // It must be created once by the migration/DB administrator; this runtime bootstrap
            // only backfills missing MR numbers and never alters the index structure.
        }
        // Safe additive indexes/relations for installations that already created the tables.
        $indexes = array(
            array('hms_patient_visits','idx_visit_patient_date','ADD INDEX idx_visit_patient_date (patient_id,visit_date)'),
            array('hms_igd_visits','idx_igd_visit_patient','ADD INDEX idx_igd_visit_patient (visit_id,patient_id)'),
            array('hms_admissions','idx_admission_patient_status','ADD INDEX idx_admission_patient_status (patient_id,status)'),
            array('hms_cppt','idx_cppt_patient_created','ADD INDEX idx_cppt_patient_created (patient_id,created_at)'),
            array('hms_referrals','idx_referral_patient_date','ADD INDEX idx_referral_patient_date (patient_id,referral_date)'),
            array('hms_bills','idx_bill_patient_status','ADD INDEX idx_bill_patient_status (patient_id,status)')
        );
        foreach ($indexes as $ix) {
            $exists = (int)hms_scalar($con, 'SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema=DATABASE() AND table_name=? AND index_name=?', 'ss', array($ix[0],$ix[1]));
            if ($exists === 0) hms_module_query_safe($con, 'ALTER TABLE '.$ix[0].' '.$ix[2]);
        }
        $fks = array(
            array('hms_bill_items','fk_hms_bill_items_bill','FOREIGN KEY (bill_id) REFERENCES hms_bills(id) ON DELETE CASCADE ON UPDATE CASCADE'),
            array('hms_payments','fk_hms_payments_bill','FOREIGN KEY (bill_id) REFERENCES hms_bills(id) ON DELETE RESTRICT ON UPDATE CASCADE')
        );
        foreach ($fks as $fk) {
            $exists = (int)hms_scalar($con, 'SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema=DATABASE() AND table_name=? AND constraint_name=?', 'ss', array($fk[0],$fk[1]));
            if ($exists === 0) hms_module_query_safe($con, 'ALTER TABLE '.$fk[0].' ADD CONSTRAINT '.$fk[1].' '.$fk[2]);
        }
        // Stage 2 database integrity: add only when existing data has no orphan references.
        hms_module_add_fk_if_safe($con,'hms_patient_visits','fk_visit_doctor','FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE SET NULL ON UPDATE CASCADE','doctor_id','doctors','id');
        hms_module_add_fk_if_safe($con,'hms_patient_visits','fk_visit_patient','FOREIGN KEY (patient_id) REFERENCES tblpatient(ID) ON DELETE RESTRICT ON UPDATE CASCADE','patient_id','tblpatient','ID');
        hms_module_add_fk_if_safe($con,'hms_igd_visits','fk_igd_patient','FOREIGN KEY (patient_id) REFERENCES tblpatient(ID) ON DELETE RESTRICT ON UPDATE CASCADE','patient_id','tblpatient','ID');
        hms_module_add_fk_if_safe($con,'hms_igd_visits','fk_igd_visit','FOREIGN KEY (visit_id) REFERENCES hms_patient_visits(id) ON DELETE SET NULL ON UPDATE CASCADE','visit_id','hms_patient_visits');
        hms_module_add_fk_if_safe($con,'hms_admissions','fk_admission_patient','FOREIGN KEY (patient_id) REFERENCES tblpatient(ID) ON DELETE RESTRICT ON UPDATE CASCADE','patient_id','tblpatient','ID');
        hms_module_add_fk_if_safe($con,'hms_admissions','fk_admission_visit','FOREIGN KEY (visit_id) REFERENCES hms_patient_visits(id) ON DELETE SET NULL ON UPDATE CASCADE','visit_id','hms_patient_visits');
        hms_module_add_fk_if_safe($con,'hms_admissions','fk_admission_bed','FOREIGN KEY (bed_id) REFERENCES hms_beds(id) ON DELETE SET NULL ON UPDATE CASCADE','bed_id','hms_beds');
        hms_module_add_fk_if_safe($con,'hms_admissions','fk_admission_doctor','FOREIGN KEY (attending_doctor_id) REFERENCES doctors(id) ON DELETE SET NULL ON UPDATE CASCADE','attending_doctor_id','doctors','id');
        hms_module_add_fk_if_safe($con,'hms_bed_movements','fk_move_admission','FOREIGN KEY (admission_id) REFERENCES hms_admissions(id) ON DELETE CASCADE ON UPDATE CASCADE','admission_id','hms_admissions');
        hms_module_add_fk_if_safe($con,'hms_bed_movements','fk_move_from_bed','FOREIGN KEY (from_bed_id) REFERENCES hms_beds(id) ON DELETE SET NULL ON UPDATE CASCADE','from_bed_id','hms_beds');
        hms_module_add_fk_if_safe($con,'hms_bed_movements','fk_move_to_bed','FOREIGN KEY (to_bed_id) REFERENCES hms_beds(id) ON DELETE SET NULL ON UPDATE CASCADE','to_bed_id','hms_beds');
        hms_module_add_fk_if_safe($con,'hms_cppt','fk_cppt_patient','FOREIGN KEY (patient_id) REFERENCES tblpatient(ID) ON DELETE RESTRICT ON UPDATE CASCADE','patient_id','tblpatient','ID');
        hms_module_add_fk_if_safe($con,'hms_cppt','fk_cppt_visit','FOREIGN KEY (visit_id) REFERENCES hms_patient_visits(id) ON DELETE SET NULL ON UPDATE CASCADE','visit_id','hms_patient_visits');
        hms_module_add_fk_if_safe($con,'hms_cppt','fk_cppt_admission','FOREIGN KEY (admission_id) REFERENCES hms_admissions(id) ON DELETE SET NULL ON UPDATE CASCADE','admission_id','hms_admissions');
        hms_module_add_fk_if_safe($con,'hms_referrals','fk_referral_patient','FOREIGN KEY (patient_id) REFERENCES tblpatient(ID) ON DELETE RESTRICT ON UPDATE CASCADE','patient_id','tblpatient','ID');
        hms_module_add_fk_if_safe($con,'hms_referrals','fk_referral_visit','FOREIGN KEY (visit_id) REFERENCES hms_patient_visits(id) ON DELETE SET NULL ON UPDATE CASCADE','visit_id','hms_patient_visits');
        hms_module_add_fk_if_safe($con,'hms_bills','fk_bill_patient','FOREIGN KEY (patient_id) REFERENCES tblpatient(ID) ON DELETE RESTRICT ON UPDATE CASCADE','patient_id','tblpatient','ID');
        hms_module_add_fk_if_safe($con,'hms_bills','fk_bill_visit','FOREIGN KEY (visit_id) REFERENCES hms_patient_visits(id) ON DELETE SET NULL ON UPDATE CASCADE','visit_id','hms_patient_visits');
        hms_module_add_fk_if_safe($con,'hms_bills','fk_bill_admission','FOREIGN KEY (admission_id) REFERENCES hms_admissions(id) ON DELETE SET NULL ON UPDATE CASCADE','admission_id','hms_admissions');
        hms_module_add_fk_if_safe($con,'hms_clinical_charges','fk_charge_patient','FOREIGN KEY (patient_id) REFERENCES tblpatient(ID) ON DELETE RESTRICT ON UPDATE CASCADE','patient_id','tblpatient','ID');
        hms_module_add_fk_if_safe($con,'hms_clinical_charges','fk_charge_visit','FOREIGN KEY (visit_id) REFERENCES hms_patient_visits(id) ON DELETE SET NULL ON UPDATE CASCADE','visit_id','hms_patient_visits');
        hms_module_add_fk_if_safe($con,'hms_clinical_charges','fk_charge_admission','FOREIGN KEY (admission_id) REFERENCES hms_admissions(id) ON DELETE SET NULL ON UPDATE CASCADE','admission_id','hms_admissions');
        hms_module_add_fk_if_safe($con,'hms_clinical_charges','fk_charge_service','FOREIGN KEY (service_id) REFERENCES hms_service_catalog(id) ON DELETE SET NULL ON UPDATE CASCADE','service_id','hms_service_catalog');
        hms_module_add_fk_if_safe($con,'hms_clinical_charges','fk_charge_bill','FOREIGN KEY (bill_id) REFERENCES hms_bills(id) ON DELETE SET NULL ON UPDATE CASCADE','bill_id','hms_bills');
        $seed=array(
          array('CONSULT','KONSULTASI DOKTER','KONSULTASI',150000),
          array('TINDAKAN','TINDAKAN MEDIS','TINDAKAN',100000),
          array('IGD','TINDAKAN IGD','IGD',150000),
          array('VISITE','VISITE DOKTER','RAWAT_INAP',100000),
          array('KAMAR','KAMAR RAWAT INAP','KAMAR',0)
        );
        $icdSeed=array(
          array('R50.9','Fever, unspecified','Gejala'),
          array('J06.9','Acute upper respiratory infection, unspecified','Respirasi'),
          array('I10','Essential (primary) hypertension','Kardiovaskular'),
          array('E11.9','Type 2 diabetes mellitus without complications','Endokrin'),
          array('A09','Infectious gastroenteritis and colitis, unspecified','Pencernaan'),
          array('J18.9','Pneumonia, unspecified organism','Respirasi'),
          array('K30','Functional dyspepsia','Pencernaan'),
          array('M54.5','Low back pain','Muskuloskeletal')
        );
        foreach($icdSeed as $ic){ @mysqli_query($con,"INSERT IGNORE INTO hms_icd10(code,description,category) VALUES('".mysqli_real_escape_string($con,$ic[0])."','".mysqli_real_escape_string($con,$ic[1])."','".mysqli_real_escape_string($con,$ic[2])."')"); }
        foreach($seed as $sv){ @mysqli_query($con,"INSERT IGNORE INTO hms_service_catalog(service_code,service_name,service_type,price) VALUES('".mysqli_real_escape_string($con,$sv[0])."','".mysqli_real_escape_string($con,$sv[1])."','".mysqli_real_escape_string($con,$sv[2])."',".(float)$sv[3].")"); }
    }

    function hms_module_add_fk_if_safe($con, $table, $constraint, $definition, $childColumn, $parentTable, $parentColumn='id') {
        if (!hms_table_exists($con,$table) || !hms_table_exists($con,$parentTable)) return false;

        // Prevent MySQL 1005/errno 150 on legacy installations by verifying
        // engine and exact column type/unsignedness before attempting the FK.
        $childMeta = hms_fetch_one($con,
            "SELECT COLUMN_TYPE, DATA_TYPE, IS_NULLABLE FROM information_schema.columns
             WHERE table_schema=DATABASE() AND table_name=? AND column_name=? LIMIT 1",
            'ss', array($table,$childColumn));
        $parentMeta = hms_fetch_one($con,
            "SELECT COLUMN_TYPE, DATA_TYPE, IS_NULLABLE FROM information_schema.columns
             WHERE table_schema=DATABASE() AND table_name=? AND column_name=? LIMIT 1",
            'ss', array($parentTable,$parentColumn));
        if (!$childMeta || !$parentMeta) return false;
        if (strtolower((string)$childMeta['DATA_TYPE']) !== strtolower((string)$parentMeta['DATA_TYPE'])) return false;
        if (strtolower((string)$childMeta['COLUMN_TYPE']) !== strtolower((string)$parentMeta['COLUMN_TYPE'])) return false;

        $engChild = strtolower((string)hms_scalar($con,
            "SELECT ENGINE FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name=?",
            's', array($table)));
        $engParent = strtolower((string)hms_scalar($con,
            "SELECT ENGINE FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name=?",
            's', array($parentTable)));
        if ($engChild !== 'innodb' || $engParent !== 'innodb') return false;

        $exists=(int)hms_scalar($con,'SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema=DATABASE() AND table_name=? AND constraint_name=?','ss',array($table,$constraint));
        if($exists>0) return true;

        $orphan=(int)hms_scalar($con,"SELECT COUNT(*) FROM {$table} c LEFT JOIN {$parentTable} p ON p.{$parentColumn}=c.{$childColumn} WHERE c.{$childColumn} IS NOT NULL AND p.{$parentColumn} IS NULL");
        if($orphan>0) return false;

        return hms_module_query_safe($con,'ALTER TABLE '.$table.' ADD CONSTRAINT '.$constraint.' '.$definition);
    }

    function hms_module_workflow_event($con,$patientId,$visitId=null,$admissionId=null,$igdId=null,$eventType,$status='SELESAI',$description='') {
        session();
        $actor=(int)($_SESSION['id']??0); $role=(string)($_SESSION['role']??'');
        $st=mysqli_prepare($con,'INSERT INTO hms_workflow_events(patient_id,visit_id,admission_id,igd_id,event_type,event_status,description,actor_id,actor_role) VALUES(?,?,?,?,?,?,?,?,?)');
        if(!$st) return false;
        mysqli_stmt_bind_param($st,'iiiisssis',$patientId,$visitId,$admissionId,$igdId,$eventType,$status,$description,$actor,$role);
        $ok=mysqli_stmt_execute($st); mysqli_stmt_close($st); return $ok;
    }

    function hms_module_get_or_create_bill($con,$patientId,$visitId=null,$admissionId=null,$payerType='TUNAI',$payerName='') {
        $sql="SELECT * FROM hms_bills WHERE patient_id=? AND status IN ('BELUM_LUNAS','SEBAGIAN') AND (visit_id <=> ?) AND (admission_id <=> ?) ORDER BY id DESC LIMIT 1 FOR UPDATE";
        $bill=hms_fetch_one($con,$sql,'iii',array($patientId,$visitId,$admissionId));
        if($bill) return (int)$bill['id'];
        $code=hms_module_next_code($con,'hms_bills','INV','id');
        $st=mysqli_prepare($con,'INSERT INTO hms_bills(patient_id,visit_id,admission_id,invoice_no,payer_type,payer_name) VALUES(?,?,?,?,?,?)');
        if(!$st) throw new RuntimeException('Gagal membuat invoice.');
        mysqli_stmt_bind_param($st,'iiisss',$patientId,$visitId,$admissionId,$code,$payerType,$payerName);
        if(!mysqli_stmt_execute($st)){mysqli_stmt_close($st);throw new RuntimeException('Gagal membuat invoice.');}
        $id=mysqli_insert_id($con); mysqli_stmt_close($st); return $id;
    }

    function hms_module_post_charge($con,$patientId,$visitId=null,$admissionId=null,$cpptId=null,$igdId=null,$serviceId=null,$serviceType='TINDAKAN',$description='',$qty=1,$unitPrice=0,$payerType='TUNAI',$payerName='') {
        if($patientId<=0 || $qty<=0 || $unitPrice<0 || trim($description)==='') throw new InvalidArgumentException('Charge layanan tidak valid.');
        mysqli_begin_transaction($con);
        try {
            if($cpptId && $serviceId){
                $dupe=(int)hms_scalar($con,'SELECT COUNT(*) FROM hms_clinical_charges WHERE cppt_id=? AND service_id=? AND status<>\'CANCELLED\'','ii',array($cpptId,$serviceId));
                if($dupe>0) throw new RuntimeException('Layanan untuk CPPT tersebut sudah ditagihkan.');
            }
            $amount=round($qty*$unitPrice,2);
            $billId=hms_module_get_or_create_bill($con,$patientId,$visitId,$admissionId,$payerType,$payerName);
            $st=mysqli_prepare($con,'INSERT INTO hms_clinical_charges(patient_id,visit_id,admission_id,cppt_id,igd_id,service_id,service_type,description,qty,unit_price,amount,bill_id,status,created_by) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,\'BILLED\',?)');
            if(!$st) throw new RuntimeException('Gagal menyimpan charge.');
            session(); $actor=(int)($_SESSION['id']??0);
            mysqli_stmt_bind_param($st,'iiiiisssdddii',$patientId,$visitId,$admissionId,$cpptId,$igdId,$serviceId,$serviceType,$description,$qty,$unitPrice,$amount,$billId,$actor);
            if(!mysqli_stmt_execute($st)){mysqli_stmt_close($st);throw new RuntimeException('Gagal menyimpan charge.');}
            $chargeId=mysqli_stmt_insert_id($st); mysqli_stmt_close($st);
            hms_execute($con,'INSERT INTO hms_bill_items(bill_id,service_type,description,qty,unit_price,amount) VALUES(?,?,?,?,?,?)','issddd',array($billId,$serviceType,$description,$qty,$unitPrice,$amount));
            hms_execute($con,'UPDATE hms_bills SET subtotal=(SELECT COALESCE(SUM(amount),0) FROM hms_bill_items WHERE bill_id=?), total=(SELECT COALESCE(SUM(amount),0) FROM hms_bill_items WHERE bill_id=?)-discount WHERE id=?','iii',array($billId,$billId,$billId));
            mysqli_commit($con);
            hms_module_audit($con,'CREATE','BILLING','hms_clinical_charges',$chargeId,'Charge klinis otomatis masuk billing',null,array('bill_id'=>$billId,'patient_id'=>$patientId,'service_type'=>$serviceType,'description'=>$description,'amount'=>$amount));
            return array('charge_id'=>$chargeId,'bill_id'=>$billId,'amount'=>$amount);
        } catch(Throwable $e) { mysqli_rollback($con); throw $e; }
    }

    function hms_module_current_role() {
        session();
        $role = isset($_SESSION['role']) ? strtolower(trim((string)$_SESSION['role'])) : '';
        return $role;
    }

    function hms_module_require_roles($roles, $redirect='logout.php') {
        $roles = array_map('strtolower', (array)$roles);
        $current = hms_module_current_role();
        if ($current !== '' && in_array($current, $roles, true)) {
            // Re-run the legacy bridge for the selected role to preserve its auth checks.
            return hms_require_role($current, $redirect);
        }
        // No trusted role in session: try admin first, then doctor. The legacy helper
        // may establish a role through its signed authentication bridge.
        foreach ($roles as $role) {
            if ($role === 'admin' || $role === 'doctor') {
                $ticket = $role === 'admin' && function_exists('hms_get_admin_ticket') ? hms_get_admin_ticket() : null;
                if ($ticket === null && $role === 'doctor' && function_exists('hms_get_doctor_ticket')) {
                    $ticket = hms_get_doctor_ticket();
                }
                if ($ticket !== null) return hms_require_role($role, $redirect);
            }
        }
        hms_redirect($redirect);
        return false;
    }

    function hms_module_csrf() { hms_verify_csrf(); }

    function hms_module_next_code($con, $table, $prefix, $column) {
        if (!preg_match('/^[A-Za-z0-9_]+$/', $table) || !preg_match('/^[A-Za-z0-9_]+$/', $column)) {
            throw new InvalidArgumentException('Invalid sequence target.');
        }
        $key = $prefix . date('Ymd');
        $sql = "INSERT INTO hms_module_sequences(code_key,next_value) VALUES(?,1) ON DUPLICATE KEY UPDATE next_value=LAST_INSERT_ID(next_value+1)";
        $st = mysqli_prepare($con, $sql);
        if (!$st) throw new RuntimeException('Gagal membuat sequence.');
        mysqli_stmt_bind_param($st, 's', $key);
        if (!mysqli_stmt_execute($st)) { mysqli_stmt_close($st); throw new RuntimeException('Gagal membuat nomor transaksi.'); }
        $n = mysqli_insert_id($con);
        mysqli_stmt_close($st);
        if ($n < 1) $n = (int)hms_scalar($con, 'SELECT next_value FROM hms_module_sequences WHERE code_key=?', 's', array($key));
        return $prefix . date('Ymd') . str_pad((string)$n, 4, '0', STR_PAD_LEFT);
    }

    function hms_module_next_queue($con, $poli='', $serviceDate=null) {
        $queueDate = ($serviceDate && preg_match('/^\d{4}-\d{2}-\d{2}$/', (string)$serviceDate)) ? date('Ymd', strtotime($serviceDate)) : date('Ymd');
        $key = 'QUEUE|' . $queueDate . '|' . strtoupper(trim($poli));
        $st = mysqli_prepare($con, 'INSERT INTO hms_module_sequences(code_key,next_value) VALUES(?,1) ON DUPLICATE KEY UPDATE next_value=LAST_INSERT_ID(next_value+1)');
        if (!$st) throw new RuntimeException('Gagal membuat nomor antrean.');
        mysqli_stmt_bind_param($st, 's', $key);
        if (!mysqli_stmt_execute($st)) { mysqli_stmt_close($st); throw new RuntimeException('Gagal membuat nomor antrean.'); }
        $n = mysqli_insert_id($con); mysqli_stmt_close($st);
        if ($n < 1) $n = (int)hms_scalar($con, 'SELECT next_value FROM hms_module_sequences WHERE code_key=?', 's', array($key));
        $prefix = $poli !== '' ? strtoupper(substr(preg_replace('/[^A-Za-z0-9]/','',$poli),0,1)) : 'A';
        if ($prefix === '') $prefix = 'A';
        return $prefix . str_pad((string)$n, 3, '0', STR_PAD_LEFT);
    }

    function hms_module_audit($con, $action, $module, $table=null, $recordId=null, $description='', $old=null, $new=null) {
        session();
        $actorId = isset($_SESSION['id']) ? (int)$_SESSION['id'] : 0;
        $role = isset($_SESSION['role']) ? (string)$_SESSION['role'] : '';
        $name = isset($_SESSION['login']) ? (string)$_SESSION['login'] : '';
        $ip = isset($_SERVER['REMOTE_ADDR']) ? (string)$_SERVER['REMOTE_ADDR'] : '';
        $ua = isset($_SERVER['HTTP_USER_AGENT']) ? substr((string)$_SERVER['HTTP_USER_AGENT'], 0, 500) : '';
        $oldJson = $old === null ? null : json_encode($old, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
        $newJson = $new === null ? null : json_encode($new, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
        $sql = 'INSERT INTO hms_audit_events(actor_id,actor_role,actor_name,action_name,module_name,table_name,record_id,description,old_data,new_data,ip_address,user_agent) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)';
        $st = mysqli_prepare($con, $sql);
        if (!$st) return false;
        mysqli_stmt_bind_param($st, 'isssssisssss', $actorId,$role,$name,$action,$module,$table,$recordId,$description,$oldJson,$newJson,$ip,$ua);
        $ok = mysqli_stmt_execute($st);
        mysqli_stmt_close($st);
        return $ok;
    }
}
hms_module_bootstrap($con);
?>
