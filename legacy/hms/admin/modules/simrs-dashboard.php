<?php
/**
 * Additive SIMRS Operational Dashboard.
 *
 * This page is intentionally separate from the existing admin/dashboard.php and
 * operations_dashboard.php. It reads existing tables only and does not replace,
 * delete, or rewrite any legacy module. Missing optional tables are displayed as
 * "Belum tersedia" rather than causing the dashboard to fail.
 */
session();
include('../include/config.php');
require_once __DIR__.'/module_bootstrap.php';
hms_require_role('admin','logout.php');

function simrs_exists($con, $table) { return hms_table_exists($con, $table); }
function simrs_scalar($con, $sql, $types=array(), $params=array(), $fallback=0) {
    try { return hms_scalar($con, $sql, $types ? $types : null, $params); } catch (Throwable $e) { return $fallback; }
}
function simrs_rows($con, $sql, $types='', $params=array()) {
    try { return hms_fetch_all($con, $sql, $types, $params); } catch (Throwable $e) { return array(); }
}
function simrs_count($con, $table, $where='', $types='', $params=array()) {
    if (!simrs_exists($con,$table)) return null;
    $sql='SELECT COUNT(*) FROM '.$table.($where?' WHERE '.$where:'');
    return (int)simrs_scalar($con,$sql,$types,$params,0);
}

$checks = array(
    array('Registrasi & Antrean','hms_patient_visits','registration-queue.php'),
    array('Rawat Jalan','hms_outpatient_encounters','outpatient.php'),
    array('IGD','hms_igd_visits','igd.php'),
    array('Rawat Inap','hms_admissions','inpatient.php'),
    array('Bed','hms_beds','inpatient.php'),
    array('RME / CPPT','hms_cppt','rme.php'),
    array('Billing','hms_bills','billing.php'),
    array('Charge Klinis','hms_clinical_charges','billing.php'),
    array('Workflow Event','hms_workflow_events','operations_dashboard.php'),
    array('Rujukan','hms_referrals','referrals.php'),
    array('Audit Legacy','audit_logs','audit-logs.php'),
    array('Audit Modul','hms_audit_events','audit-logs.php'),
);

$stats = array(
    'patients_today' => simrs_count($con,'hms_patient_visits','visit_date=CURDATE()'),
    'queue_waiting' => simrs_count($con,'hms_patient_visits',"visit_date=CURDATE() AND status='MENUNGGU'"),
    'outpatient_served' => simrs_count($con,'hms_outpatient_encounters',"DATE(created_at)=CURDATE() AND status IN ('DILAYANI','SELESAI')"),
    'igd_active' => simrs_count($con,'hms_igd_visits',"status='AKTIF'"),
    'admitted' => simrs_count($con,'hms_admissions',"status='DIRAWAT'"),
    'beds_total' => simrs_count($con,'hms_beds',"status<>'NONAKTIF'"),
    'beds_available' => simrs_count($con,'hms_beds',"status='TERSEDIA'"),
    'cppt_today' => simrs_count($con,'hms_cppt','DATE(created_at)=CURDATE()'),
    'unpaid' => simrs_count($con,'hms_bills',"status IN ('BELUM_LUNAS','SEBAGIAN')"),
);

$stats['occupancy_pct'] = ($stats['beds_total'] !== null && $stats['beds_total'] > 0 && $stats['admitted'] !== null)
    ? min(100, round(($stats['admitted'] / $stats['beds_total']) * 100)) : null;

$revenueToday = null;
if (simrs_exists($con,'hms_payments')) {
    $revenueToday=(float)simrs_scalar($con,"SELECT COALESCE(SUM(amount),0) FROM hms_payments WHERE DATE(payment_date)=CURDATE()",array(),array(),0);
}

$queueRows = simrs_rows($con,"SELECT v.queue_no,v.poli,v.status,v.registration_no,p.PatientName,p.medical_record_no,d.doctorName
    FROM hms_patient_visits v
    LEFT JOIN tblpatient p ON p.ID=v.patient_id
    LEFT JOIN doctors d ON d.id=v.doctor_id
    WHERE v.visit_date=CURDATE() AND v.status IN ('MENUNGGU','DIPANGGIL','DILAYANI')
    ORDER BY CASE v.status WHEN 'DILAYANI' THEN 1 WHEN 'DIPANGGIL' THEN 2 ELSE 3 END, v.id ASC LIMIT 12");

$bedRows = simrs_rows($con,"SELECT b.room_no,b.bed_no,b.class_name,b.ward,b.status,p.PatientName,a.admission_no
    FROM hms_beds b
    LEFT JOIN hms_admissions a ON a.bed_id=b.id AND a.status='DIRAWAT'
    LEFT JOIN tblpatient p ON p.ID=a.patient_id
    ORDER BY FIELD(b.status,'TERISI','TERSEDIA','DIBERSIHKAN','NONAKTIF'), b.ward,b.room_no,b.bed_no LIMIT 12");

$igdRows = simrs_rows($con,"SELECT g.registration_no,g.triage_level,g.arrival_time,g.disposition,p.PatientName,d.doctorName
    FROM hms_igd_visits g
    LEFT JOIN tblpatient p ON p.ID=g.patient_id
    LEFT JOIN doctors d ON d.id=g.doctor_id
    WHERE g.status='AKTIF' ORDER BY FIELD(g.triage_level,'MERAH','KUNING','HIJAU','HITAM'),g.arrival_time ASC LIMIT 8");

$admissionRows = simrs_rows($con,"SELECT a.admission_no,a.admission_date,a.status,p.PatientName,b.room_no,b.bed_no,d.doctorName
    FROM hms_admissions a
    LEFT JOIN tblpatient p ON p.ID=a.patient_id
    LEFT JOIN hms_beds b ON b.id=a.bed_id
    LEFT JOIN doctors d ON d.id=a.attending_doctor_id
    WHERE a.status='DIRAWAT' ORDER BY a.admission_date DESC LIMIT 8");

$billRows = simrs_rows($con,"SELECT b.invoice_no,b.bill_date,b.total,b.status,p.PatientName,
    COALESCE((SELECT SUM(py.amount) FROM hms_payments py WHERE py.bill_id=b.id),0) paid
    FROM hms_bills b LEFT JOIN tblpatient p ON p.ID=b.patient_id
    WHERE b.status IN ('BELUM_LUNAS','SEBAGIAN') ORDER BY b.bill_date DESC LIMIT 8");

$workflowRows = simrs_rows($con,"SELECT event_type,event_status,description,actor_role,created_at
    FROM hms_workflow_events ORDER BY id DESC LIMIT 10");

$trend = array();
for ($i=6; $i>=0; $i--) {
    $date=date('Y-m-d',strtotime('-'.$i.' day'));
    $label=date('d/m',strtotime($date));
    $total=simrs_count($con,'hms_patient_visits','visit_date=?','s',array($date));
    $done=simrs_count($con,'hms_patient_visits',"visit_date=? AND status='SELESAI'",'s',array($date));
    $trend[]=array('label'=>$label,'total'=>(int)$total,'done'=>(int)$done);
}

$appointmentToday=null;
if (simrs_exists($con,'appointment')) {
    $appointmentToday=(int)simrs_scalar($con,'SELECT COUNT(*) FROM appointment WHERE appointmentDate=CURDATE() OR appointmentDate=?','ss',array(date('Y-m-d'),date('d-m-Y')),0);
}

hms_layout_header('Dashboard Operasional SIMRS','admin','dashboard');
?>
<div class="hms-page-title">
  <div>
    <h1>Dashboard Operasional SIMRS</h1>
    <div class="text-muted">Dashboard tambahan yang menggabungkan indikator registrasi, antrean, klinis, IGD, rawat inap, RME dan billing. Modul lama tetap dipertahankan.</div>
  </div>
  <div class="d-flex flex-wrap gap-2">
    <a class="btn btn-outline-primary" href="operations_dashboard.php"><i class="bi bi-grid-3x3-gap me-1"></i>Modul Pelayanan</a>
    <a class="btn btn-primary" href="simrs-dashboard.php"><i class="bi bi-arrow-clockwise me-1"></i>Refresh</a>
  </div>
</div>

<div class="row g-3 mb-4">
<?php
$cards=array(
 array('Pasien Hari Ini',$stats['patients_today'],'bi-person-vcard','primary'),
 array('Antrean Menunggu',$stats['queue_waiting'],'bi-hourglass-split','warning'),
 array('IGD Aktif',$stats['igd_active'],'bi-heart-pulse','danger'),
 array('Rawat Inap',$stats['admitted'],'bi-hospital','success'),
 array('Bed Tersedia',$stats['beds_available'],'bi-bed','info'),
 array('CPPT Hari Ini',$stats['cppt_today'],'bi-journal-medical','secondary'),
 array('Tagihan Belum Lunas',$stats['unpaid'],'bi-receipt','warning'),
 array('Pendapatan Hari Ini', 'Rp '.number_format($revenueToday??0,0,',','.'),'bi-cash-stack','success'),
);
foreach($cards as $c){ ?>
<div class="col-12 col-sm-6 col-xl-3"><div class="hms-card hms-stat h-100"><span class="icon"><i class="bi <?php echo hms_e($c[2]); ?>"></i></span><div class="value" style="font-size:1.65rem"><?php echo hms_e($c[1]===null?'Belum tersedia':$c[1]); ?></div><div class="label"><?php echo hms_e($c[0]); ?></div></div></div>
<?php } ?>
</div>

<div class="row g-3 mb-4">
 <div class="col-xl-8"><div class="hms-card p-3 h-100">
  <div class="d-flex justify-content-between align-items-center mb-3"><div><h2 class="h5 mb-1">Tren Kunjungan 7 Hari</h2><div class="text-muted small">Registrasi pasien dibandingkan dengan kunjungan yang selesai.</div></div><span class="badge text-bg-light">Hari ini <?php echo date('d/m/Y'); ?></span></div>
  <?php $max=1; foreach($trend as $t){$max=max($max,$t['total']);} foreach($trend as $t){$pct=round(($t['total']/$max)*100);$donePct=$t['total']?round(($t['done']/$t['total'])*100):0; ?>
   <div class="mb-3"><div class="d-flex justify-content-between small mb-1"><span><?php echo hms_e($t['label']); ?></span><strong><?php echo (int)$t['total']; ?> kunjungan · <?php echo (int)$t['done']; ?> selesai</strong></div><div style="height:12px;background:#e9eef5;border-radius:20px;overflow:hidden"><div style="width:<?php echo $pct; ?>%;height:100%;background:#127c8a;border-radius:20px"></div></div><div class="small text-muted mt-1">Penyelesaian <?php echo (int)$donePct; ?>%</div></div>
  <?php } ?>
 </div></div>
 <div class="col-xl-4"><div class="hms-card p-3 h-100"><h2 class="h5 mb-3">Kapasitas Rumah Sakit</h2>
   <div class="d-flex justify-content-between py-2 border-bottom"><span class="text-muted">Total bed aktif</span><strong><?php echo hms_e($stats['beds_total']===null?'Belum tersedia':$stats['beds_total']); ?></strong></div>
   <div class="d-flex justify-content-between py-2 border-bottom"><span class="text-muted">Bed tersedia</span><strong><?php echo hms_e($stats['beds_available']===null?'Belum tersedia':$stats['beds_available']); ?></strong></div>
   <div class="d-flex justify-content-between py-2"><span class="text-muted">BOR operasional</span><strong><?php echo $stats['occupancy_pct']===null?'Belum tersedia':$stats['occupancy_pct'].'%'; ?></strong></div>
   <div class="progress mt-2" style="height:12px"><div class="progress-bar" style="width:<?php echo (int)($stats['occupancy_pct']??0); ?>%"></div></div>
   <div class="mt-3 small text-muted">Indikator ini bersifat operasional berdasarkan admission aktif dan bed aktif; bukan BOR laporan akreditasi.</div>
 </div></div>
</div>

<div class="row g-3 mb-4">
 <div class="col-xl-7"><div class="hms-card p-3 h-100"><div class="d-flex justify-content-between align-items-center mb-3"><h2 class="h5 mb-0">Antrean Hari Ini</h2><a class="btn btn-sm btn-outline-primary" href="registration-queue.php">Kelola Antrean</a></div><div class="table-responsive"><table class="table table-hover align-middle mb-0"><thead><tr><th>No</th><th>Pasien</th><th>Poli</th><th>Dokter</th><th>Status</th></tr></thead><tbody><?php if(!$queueRows){ ?><tr><td colspan="5" class="text-muted">Belum ada antrean aktif hari ini.</td></tr><?php } foreach($queueRows as $r){ ?><tr><td><strong><?php echo hms_e($r['queue_no']?:'-'); ?></strong></td><td><?php echo hms_e($r['PatientName']?:'-'); ?><div class="small text-muted"><?php echo hms_e($r['medical_record_no']?:'-'); ?></div></td><td><?php echo hms_e($r['poli']?:'-'); ?></td><td><?php echo hms_e($r['doctorName']?:'-'); ?></td><td><?php echo hms_status_badge($r['status']); ?></td></tr><?php } ?></tbody></table></div></div></div>
 <div class="col-xl-5"><div class="hms-card p-3 h-100"><div class="d-flex justify-content-between align-items-center mb-3"><h2 class="h5 mb-0">IGD Aktif</h2><a class="btn btn-sm btn-outline-danger" href="igd.php">Buka IGD</a></div><div class="table-responsive"><table class="table align-middle mb-0"><thead><tr><th>Pasien</th><th>Triase</th><th>Dokter</th></tr></thead><tbody><?php if(!$igdRows){ ?><tr><td colspan="3" class="text-muted">Tidak ada pasien IGD aktif.</td></tr><?php } foreach($igdRows as $r){ ?><tr><td><?php echo hms_e($r['PatientName']?:'-'); ?><div class="small text-muted"><?php echo hms_e($r['registration_no']); ?></div></td><td><span class="badge <?php echo $r['triage_level']==='MERAH'?'text-bg-danger':($r['triage_level']==='KUNING'?'text-bg-warning':'text-bg-success'); ?>"><?php echo hms_e($r['triage_level']); ?></span></td><td><?php echo hms_e($r['doctorName']?:'Belum ditugaskan'); ?></td></tr><?php } ?></tbody></table></div></div></div>
</div>

<div class="row g-3 mb-4">
 <div class="col-xl-6"><div class="hms-card p-3 h-100"><div class="d-flex justify-content-between align-items-center mb-3"><h2 class="h5 mb-0">Rawat Inap & Bed</h2><a class="btn btn-sm btn-outline-primary" href="inpatient.php">Kelola</a></div><div class="table-responsive"><table class="table align-middle mb-0"><thead><tr><th>Pasien</th><th>Kamar/Bed</th><th>Dokter</th></tr></thead><tbody><?php if(!$admissionRows){ ?><tr><td colspan="3" class="text-muted">Belum ada admission aktif.</td></tr><?php } foreach($admissionRows as $r){ ?><tr><td><?php echo hms_e($r['PatientName']?:'-'); ?><div class="small text-muted"><?php echo hms_e($r['admission_no']); ?></div></td><td><?php echo hms_e(($r['room_no']?:'-').' / '.($r['bed_no']?:'-')); ?></td><td><?php echo hms_e($r['doctorName']?:'-'); ?></td></tr><?php } ?></tbody></table></div></div></div>
 <div class="col-xl-6"><div class="hms-card p-3 h-100"><div class="d-flex justify-content-between align-items-center mb-3"><h2 class="h5 mb-0">Billing Perlu Perhatian</h2><a class="btn btn-sm btn-outline-primary" href="billing.php">Buka Billing</a></div><div class="table-responsive"><table class="table align-middle mb-0"><thead><tr><th>Invoice</th><th>Pasien</th><th>Sisa</th><th>Status</th></tr></thead><tbody><?php if(!$billRows){ ?><tr><td colspan="4" class="text-muted">Tidak ada tagihan belum lunas.</td></tr><?php } foreach($billRows as $r){ $remaining=max(0,(float)$r['total']-(float)$r['paid']); ?><tr><td><?php echo hms_e($r['invoice_no']); ?></td><td><?php echo hms_e($r['PatientName']?:'-'); ?></td><td>Rp <?php echo number_format($remaining,0,',','.'); ?></td><td><?php echo hms_status_badge($r['status']); ?></td></tr><?php } ?></tbody></table></div></div></div>
</div>

<div class="row g-3 mb-4">
 <div class="col-xl-7"><div class="hms-card p-3 h-100"><h2 class="h5 mb-3">Alur Terakhir</h2><div class="list-group list-group-flush"><?php if(!$workflowRows){ ?><div class="text-muted">Belum ada workflow event.</div><?php } foreach($workflowRows as $r){ ?><div class="list-group-item px-0"><div class="d-flex justify-content-between"><strong><?php echo hms_e($r['event_type']); ?> <?php echo hms_e($r['event_status']?:''); ?></strong><small class="text-muted"><?php echo hms_e($r['created_at']); ?></small></div><div><?php echo hms_e($r['description']?:'-'); ?></div><small class="text-muted">Aktor: <?php echo hms_e($r['actor_role']?:'-'); ?></small></div><?php } ?></div></div></div>
 <div class="col-xl-5"><div class="hms-card p-3 h-100"><h2 class="h5 mb-3">Status Integrasi Modul</h2><?php foreach($checks as $c){ $ok=simrs_exists($con,$c[1]); ?><div class="d-flex align-items-center justify-content-between py-2 border-bottom"><span><?php echo hms_e($c[0]); ?></span><span><?php if($ok){ ?><span class="badge text-bg-success">Terhubung</span><?php }else{ ?><span class="badge text-bg-warning">Belum tersedia</span><?php } ?></span></div><?php } ?></div></div>
</div>

<div class="hms-card p-3"><div class="d-flex justify-content-between align-items-center mb-2"><div><h2 class="h5 mb-1">Catatan Integrasi</h2><div class="text-muted small">Dashboard ini hanya membaca data dari modul yang sudah ada. Tidak ada tabel lama yang dihapus atau di-rewrite.</div></div><span class="badge text-bg-light">Non-destructive</span></div><ul class="mb-0"><li>Registrasi menjadi sumber kunjungan dan nomor antrean.</li><li>Visit dapat diteruskan ke Rawat Jalan, IGD atau Rawat Inap.</li><li>RME/CPPT dibaca sebagai aktivitas klinis pasien.</li><li>Charge klinis dan billing ditampilkan sebagai jalur keuangan.</li><li>Admission aktif dan bed dipantau untuk kapasitas.</li><li>Workflow event menjadi jejak perjalanan pelayanan.</li></ul></div>

<?php hms_layout_footer(); ?>
