<?php
// Doctor-facing patient picker: reuse appointment/queue records; do not create duplicate tblpatient rows.
session();
include 'include/config.php';
hms_require_role('doctor', 'logout.php');

$doctorId = (int)($_SESSION['id'] ?? 0);
$visits = hms_fetch_all($con,
    "SELECT v.id AS visit_id, v.registration_no, v.queue_no, v.visit_date, v.visit_type,
            v.poli, v.status, v.source, v.appointment_id, p.PatientName, p.PatientContno,
            p.PatientEmail, p.medical_record_no, a.appointmentDate, a.appointmentTime, a.status AS appointment_status
     FROM hms_patient_visits v
     JOIN tblpatient p ON p.ID=v.patient_id
     LEFT JOIN appointment a ON a.id=v.appointment_id
     WHERE v.doctor_id=? AND v.visit_type='RAWAT_JALAN'
       AND v.status IN ('DIPANGGIL','DILAYANI')
     ORDER BY v.visit_date DESC, v.id DESC LIMIT 300",
    'i', array($doctorId));

hms_layout_header('Pilih Pasien untuk RME', 'doctor', 'patients');
?>
<div class="hms-page-title">
    <div>
        <h1>Pilih Pasien untuk RME / SOAP</h1>
        <p class="text-muted mb-0">Pasien diambil dari janji temu dan antrean rawat jalan dokter. Tidak membuat pasien baru atau menggandakan data pasien.</p>
    </div>
    <a class="btn btn-light" href="visit-queue.php">Kembali ke Antrean</a>
</div>
<div class="hms-card p-4">
    <?php if (!$visits) { ?>
        <div class="alert alert-info mb-0">Belum ada pasien pada antrean yang berstatus DIPANGGIL atau DILAYANI. Panggil pasien terlebih dahulu dari menu Antrean Pasien Saya.</div>
    <?php } else { ?>
    <form method="post" action="outpatient.php" id="rmeVisitPicker">
        <?php echo hms_csrf_field(); ?>
        <input type="hidden" name="action" value="create">
        <div class="mb-3">
            <label for="visitSearch" class="form-label">Cari pasien (nama, RM, nomor registrasi, antrean, poli)</label>
            <input type="search" class="form-control" id="visitSearch" placeholder="Ketik untuk mencari..." autocomplete="off">
        </div>
        <div class="mb-3">
            <label for="visit_id" class="form-label">Nama Pasien / Kunjungan</label>
            <select class="form-select" name="visit_id" id="visit_id" size="8" required>
                <option value="">-- Pilih pasien dari antrean --</option>
                <?php foreach ($visits as $v) {
                    $label = ($v['medical_record_no'] ?: 'RM-'.$v['visit_id']) . ' | ' . $v['PatientName'] . ' | ' . ($v['registration_no'] ?: '-') . ' | Antrean ' . ($v['queue_no'] ?: '-') . ' | ' . ($v['poli'] ?: '-') . ' | ' . $v['visit_date'] . ' | ' . $v['status'];
                ?>
                    <option value="<?php echo (int)$v['visit_id']; ?>" data-search="<?php echo hms_e(strtolower($label)); ?>">
                        <?php echo hms_e($label); ?>
                    </option>
                <?php } ?>
            </select>
            <div class="form-text">Daftar ini menggunakan kunjungan yang sudah DIPANGGIL atau DILAYANI dan hanya milik dokter yang login.</div>
        </div>
        <button type="submit" class="btn btn-primary"><i class="bi bi-clipboard2-pulse me-1"></i> Buka SOAP / RME Pasien</button>
    </form>
    <?php } ?>
</div>
<script>
(function(){
 const search=document.getElementById('visitSearch');
 const select=document.getElementById('visit_id');
 if(!search||!select)return;
 search.addEventListener('input',function(){
   const q=this.value.trim().toLowerCase();
   Array.from(select.options).forEach(function(opt,index){
     if(index===0){opt.hidden=false;return;}
     opt.hidden=!(opt.dataset.search||opt.text.toLowerCase()).includes(q);
   });
 });
})();
</script>
<?php hms_layout_footer(); ?>
