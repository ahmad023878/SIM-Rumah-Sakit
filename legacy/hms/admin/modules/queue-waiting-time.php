<?php
session(); include('../include/config.php'); require_once __DIR__.'/module_bootstrap.php';
hms_module_require_roles(array('admin','rekam_medis','doctor','perawat'));
$from = isset($_GET['from']) && preg_match('/^\d{4}-\d{2}-\d{2}$/',$_GET['from']) ? $_GET['from'] : date('Y-m-d');
$to = isset($_GET['to']) && preg_match('/^\d{4}-\d{2}-\d{2}$/',$_GET['to']) ? $_GET['to'] : date('Y-m-d');
$poli = trim($_GET['poli'] ?? '');
$where = "v.visit_date BETWEEN ? AND ? AND v.visit_type='RAWAT_JALAN' AND v.status<>'BATAL'";
$params = array($from,$to); $types='ss';
if($poli!==''){ $where .= " AND v.poli=?"; $params[]=$poli; $types.='s'; }
$summary = hms_fetch_one($con,
 "SELECT COUNT(*) total,
 SUM(v.arrived_at IS NOT NULL) arrived_count,
 SUM(v.arrived_at IS NULL) missing_arrival_count,
 SUM(v.appointment_id IS NOT NULL) linked_appointment_count,
 SUM(v.source='ONLINE' AND v.appointment_id IS NULL) online_unlinked_count,
 SUM(v.served_at IS NOT NULL) served_count, SUM(v.completed_at IS NOT NULL) completed_count,
 SUM(v.arrived_at IS NOT NULL AND v.called_at IS NOT NULL AND v.called_at>=v.arrived_at) valid_call_count,
 SUM(v.arrived_at IS NOT NULL AND v.served_at IS NOT NULL AND v.served_at>=v.arrived_at) valid_wait_count,
 SUM(v.served_at IS NOT NULL AND v.completed_at IS NOT NULL AND v.completed_at>=v.served_at) valid_service_count,
 SUM((v.arrived_at IS NOT NULL AND v.called_at IS NOT NULL AND v.called_at<v.arrived_at) OR
 (v.arrived_at IS NOT NULL AND v.served_at IS NOT NULL AND v.served_at<v.arrived_at) OR
 (v.served_at IS NOT NULL AND v.completed_at IS NOT NULL AND v.completed_at<v.served_at) OR
 (v.completed_at IS NOT NULL AND v.served_at IS NOT NULL AND TIMESTAMPDIFF(HOUR,v.served_at,v.completed_at)>24) OR
 (v.served_at IS NOT NULL AND v.arrived_at IS NOT NULL AND TIMESTAMPDIFF(HOUR,v.arrived_at,v.served_at)>24)) anomaly_count
 FROM hms_patient_visits v WHERE $where", $types,$params);
$rows = hms_fetch_all($con,
 "SELECT v.id,v.appointment_id,v.visit_date,v.registration_no,v.queue_no,v.poli,v.source,v.status,v.created_at,v.arrived_at,v.called_at,v.served_at,v.completed_at,
 p.PatientName,
 CASE WHEN v.arrived_at IS NOT NULL AND v.called_at IS NOT NULL AND v.called_at>=v.arrived_at THEN ROUND(TIMESTAMPDIFF(SECOND,v.arrived_at,v.called_at)/60,1) END call_minutes,
 CASE WHEN v.arrived_at IS NOT NULL AND v.served_at IS NOT NULL AND v.served_at>=v.arrived_at THEN ROUND(TIMESTAMPDIFF(SECOND,v.arrived_at,v.served_at)/60,1) END wait_minutes,
 CASE WHEN v.served_at IS NOT NULL AND v.completed_at IS NOT NULL AND v.completed_at>=v.served_at THEN ROUND(TIMESTAMPDIFF(SECOND,v.served_at,v.completed_at)/60,1) END service_minutes,
 CASE WHEN v.arrived_at IS NOT NULL AND v.completed_at IS NOT NULL AND v.completed_at>=v.arrived_at THEN ROUND(TIMESTAMPDIFF(SECOND,v.arrived_at,v.completed_at)/60,1) END total_minutes,
 CASE WHEN (v.arrived_at IS NOT NULL AND v.called_at IS NOT NULL AND v.called_at<v.arrived_at) OR
 (v.arrived_at IS NOT NULL AND v.served_at IS NOT NULL AND v.served_at<v.arrived_at) OR
 (v.served_at IS NOT NULL AND v.completed_at IS NOT NULL AND v.completed_at<v.served_at) OR
 (v.served_at IS NOT NULL AND v.completed_at IS NOT NULL AND TIMESTAMPDIFF(HOUR,v.served_at,v.completed_at)>24) OR
 (v.arrived_at IS NOT NULL AND v.served_at IS NOT NULL AND TIMESTAMPDIFF(HOUR,v.arrived_at,v.served_at)>24) THEN 1 ELSE 0 END anomaly_flag
 FROM hms_patient_visits v LEFT JOIN tblpatient p ON p.ID=v.patient_id
 WHERE $where ORDER BY v.visit_date DESC,v.poli,v.id DESC LIMIT 500", $types,$params);
$wait_values=array(); $service_values=array(); $call_values=array(); $total_values=array(); foreach($rows as $rr){ if($rr['wait_minutes']!==null) $wait_values[]=(float)$rr['wait_minutes']; if($rr['service_minutes']!==null) $service_values[]=(float)$rr['service_minutes']; if($rr['call_minutes']!==null) $call_values[]=(float)$rr['call_minutes']; if($rr['total_minutes']!==null) $total_values[]=(float)$rr['total_minutes']; }
function m2_percentile($vals,$p){ if(!$vals)return null; sort($vals,SORT_NUMERIC); $idx=(int)ceil($p*count($vals))-1; return $vals[max(0,min(count($vals)-1,$idx))]; }
$median_wait=m2_percentile($wait_values,.5); $p90_wait=m2_percentile($wait_values,.9); $summary['avg_wait']=$wait_values?array_sum($wait_values)/count($wait_values):null; $summary['avg_service']=$service_values?array_sum($service_values)/count($service_values):null; $summary['avg_to_call']=$call_values?array_sum($call_values)/count($call_values):null; $summary['avg_total']=$total_values?array_sum($total_values)/count($total_values):null;
$polis = hms_fetch_all($con,"SELECT DISTINCT poli FROM hms_patient_visits WHERE visit_type='RAWAT_JALAN' AND poli<>'' ORDER BY poli");
$role=hms_module_current_role(); hms_layout_header('M2 Queue & Waiting-Time Instrumentation',$role,'operations');
function m2_minutes($v){ return $v===null || $v==='' ? '—' : number_format((float)$v,1,',','.').' menit'; }
?>
<div class="hms-page-title"><div><h1>M2 Queue & Waiting-Time Instrumentation</h1><div class="text-muted">Pemantauan waktu registrasi, pemanggilan, mulai pelayanan, penyelesaian, dan durasi tunggu rawat jalan.</div></div></div>
<div class="hms-card p-3 mb-4">
<form method="get" class="row g-2 align-items-end">
 <div class="col-md-3"><label class="form-label">Tanggal awal</label><input class="form-control" type="date" name="from" value="<?php echo hms_e($from); ?>"></div>
 <div class="col-md-3"><label class="form-label">Tanggal akhir</label><input class="form-control" type="date" name="to" value="<?php echo hms_e($to); ?>"></div>
 <div class="col-md-3"><label class="form-label">Poliklinik</label><select class="form-select" name="poli"><option value="">Semua poli</option><?php foreach($polis as $po){ ?><option value="<?php echo hms_e($po['poli']); ?>" <?php echo $poli===$po['poli']?'selected':''; ?>><?php echo hms_e($po['poli']); ?></option><?php } ?></select></div>
 <div class="col-md-3"><button class="btn btn-primary">Terapkan Filter</button> <a class="btn btn-outline-secondary" href="queue-waiting-time.php">Hari ini</a></div>
</form></div>
<div class="row g-3 mb-4">
<?php $metrics=array(
 array('Jumlah kunjungan',(int)($summary['total']??0),'bi-people'),
 array('Rata-rata sampai dipanggil',m2_minutes($summary['avg_to_call']??null),'bi-bell'),
 array('Rata-rata tunggu',m2_minutes($summary['avg_wait']??null),'bi-hourglass-split'),
 array('Rata-rata pelayanan',m2_minutes($summary['avg_service']??null),'bi-activity'),
 array('Rata-rata total kunjungan',m2_minutes($summary['avg_total']??null),'bi-stopwatch'),
 array('Median waktu tunggu',m2_minutes($median_wait),'bi-bar-chart'),
 array('P90 waktu tunggu',m2_minutes($p90_wait),'bi-graph-up')
); foreach($metrics as $m){ ?>
<div class="col-md-6 col-xl-3"><div class="hms-card hms-stat p-3"><span class="icon"><i class="bi <?php echo hms_e($m[2]); ?>"></i></span><div class="value"><?php echo hms_e((string)$m[1]); ?></div><div class="label"><?php echo hms_e($m[0]); ?></div></div></div>
<?php } ?>
</div>
<div class="hms-card p-3 mb-3"><h2 class="h5">Validasi kualitas instrumentasi M2</h2><div class="row g-2"><div class="col-md-3"><div class="border rounded p-2">Kedatangan tercatat: <strong><?php echo (int)($summary['arrived_count']??0); ?></strong></div></div><div class="col-md-3"><div class="border rounded p-2">Arrived NULL: <strong><?php echo (int)($summary['missing_arrival_count']??0); ?></strong></div></div><div class="col-md-3"><div class="border rounded p-2">Appointment-linked: <strong><?php echo (int)($summary['linked_appointment_count']??0); ?></strong></div></div><div class="col-md-3"><div class="border rounded p-2">Online tanpa link appointment: <strong><?php echo (int)($summary['online_unlinked_count']??0); ?></strong></div></div><div class="col-md-3"><div class="border rounded p-2">Waiting-time valid: <strong><?php echo count($wait_values); ?></strong></div></div><div class="col-md-3"><div class="border rounded p-2">Service-duration valid: <strong><?php echo count($service_values); ?></strong></div></div><div class="col-md-3"><div class="border rounded p-2">Anomali timestamp: <strong><?php echo (int)($summary['anomaly_count']??0); ?></strong></div></div></div><p class="small text-muted mt-2 mb-0">Kriteria: waiting-time hanya arrived_at→served_at; service-duration hanya served_at→completed_at. Timestamp NULL, negatif, atau tidak berurutan tidak masuk perhitungan aktual. Appointment ID NULL tetap sah untuk walk-in; indikator online-unlinked adalah kontrol kualitas untuk sumber ONLINE.</p></div>
<div class="hms-card p-3 mb-3"><h2 class="h5">Definisi indikator M2</h2>
<div class="table-responsive"><table class="table table-sm"><thead><tr><th>Indikator</th><th>Rumus</th><th>Makna</th></tr></thead><tbody>
<tr><td>Waktu menuju panggilan</td><td>called_at − waktu kedatangan</td><td>Durasi dari pasien tiba/check-in sampai dipanggil.</td></tr>
<tr><td>Waktu tunggu (utama)</td><td>served_at − waktu kedatangan</td><td>Durasi sampai pelayanan dokter dimulai.</td></tr>
<tr><td>Durasi pelayanan</td><td>completed_at − served_at</td><td>Lama pelayanan setelah dimulai.</td></tr>
<tr><td>Total siklus kunjungan</td><td>completed_at − waktu kedatangan</td><td>Total waktu pasien berada dalam alur layanan.</td></tr>
</tbody></table></div>
<div class="small text-muted">Waktu aktual tidak menggunakan created_at sebagai pengganti arrived_at. Pasien online harus check-in agar arrived_at tercatat. Appointment ID boleh NULL pada walk-in dan tidak dipaksakan.</div></div>
<div class="hms-card p-3"><h2 class="h5">Rincian antrean (maksimal 500 kunjungan)</h2><div class="table-responsive"><table class="table table-hover table-sm"><thead><tr><th>Tanggal</th><th>Registrasi / Antrean</th><th>Appointment ID</th><th>Pasien</th><th>Poli</th><th>Sumber</th><th>Status</th><th>Tiba</th><th>Dipanggil</th><th>Mulai</th><th>Selesai</th><th>Tunggu</th><th>Pelayanan</th><th>Total</th><th>Validasi</th></tr></thead><tbody>
<?php if(!$rows){ ?><tr><td colspan="15" class="text-center text-muted">Belum ada data pada periode ini.</td></tr><?php } foreach($rows as $r){ ?>
<tr><td><?php echo hms_e($r['visit_date']); ?></td><td><?php echo hms_e($r['registration_no'].' / '.$r['queue_no']); ?></td><td><?php echo hms_e($r['appointment_id']===null?'—':(string)$r['appointment_id']); ?></td><td><?php echo hms_e($r['PatientName']??'-'); ?></td><td><?php echo hms_e($r['poli']); ?></td><td><?php echo hms_e($r['source']); ?></td><td><?php echo hms_status_badge($r['status']); ?></td><td><?php echo hms_e($r['arrived_at']?:$r['created_at']); ?></td><td><?php echo hms_e($r['called_at']?:'—'); ?></td><td><?php echo hms_e($r['served_at']?:'—'); ?></td><td><?php echo hms_e($r['completed_at']?:'—'); ?></td><td><?php echo m2_minutes($r['wait_minutes']); ?></td><td><?php echo m2_minutes($r['service_minutes']); ?></td><td><?php echo m2_minutes($r['total_minutes']); ?></td><td><?php echo $r['anomaly_flag']?'Periksa anomali':(($r['arrived_at']===null)?'Arrived NULL':'OK'); ?></td></tr>
<?php } ?></tbody></table></div></div>
<?php hms_layout_footer(); ?>
