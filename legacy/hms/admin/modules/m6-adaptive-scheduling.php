<?php
/**
 * M6 Adaptive Scheduling
 * Read-only, event-responsive re-ranking of appointment candidates.
 * It never updates, cancels, moves, or confirms an existing appointment.
 */
session(); include('../include/config.php');
require_once __DIR__ . '/module_bootstrap.php';
require_once __DIR__ . '/hybrid_dss_engine.php';
hms_module_require_roles(array('admin'));
if (!function_exists('m6_e')) { function m6_e($v){ return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8'); } }
if (!function_exists('m6_minutes')) { function m6_minutes($v){ return $v===null?'—':number_format((float)$v,1,',','.').' menit'; } }
$projectRoot=dirname(__DIR__,2);
$selectedDate=isset($_GET['date'])&&preg_match('/^\d{4}-\d{2}-\d{2}$/',$_GET['date'])?$_GET['date']:date('Y-m-d',strtotime('+1 day'));
$selectedPoli=isset($_GET['poli_id'])?(int)$_GET['poli_id']:0;
$selectedDoctor=isset($_GET['doctor_id'])?(int)$_GET['doctor_id']:0;
$refreshSeconds=30;
$polis=hms_fetch_all($con,"SELECT id,poli_name FROM hms_master_poli WHERE is_active=1 ORDER BY poli_name");
$doctors=hms_fetch_all($con,"SELECT id,doctorName FROM doctors ORDER BY doctorName");

// Explicit database-access diagnostic: M6 MUST read appointment, but MUST NOT write it.
$appointmentTableExists=function_exists('hms_table_exists') ? hms_table_exists($con,'appointment') : false;
$appointmentReadOk=false;
$appointmentRowCount=null;
$appointmentColumns=array('id','status','appointmentDate','appointmentTime','status_updated_at','reschedule_reason','cancel_reason');
$appointmentColumnStatus=array();
if($appointmentTableExists){
    try {
        $appointmentRowCount=(int)hms_scalar($con,'SELECT COUNT(*) FROM appointment');
        $appointmentReadOk=true;
    } catch (Throwable $e) {
        $appointmentReadOk=false;
    }
    foreach($appointmentColumns as $columnName){
        $appointmentColumnStatus[$columnName]=function_exists('hms_column_exists') ? hms_column_exists($con,'appointment',$columnName) : false;
    }
}
$appointmentColumnsReady=$appointmentTableExists && !in_array(false,$appointmentColumnStatus,true);
$metricsPath=$projectRoot.'/tools/ml/output/m3_model_metrics.json';
$artifactPath=$projectRoot.'/tools/ml/output/m3_model_artifact.json';
$metrics=is_file($metricsPath)?json_decode(file_get_contents($metricsPath),true):null;
$artifact=is_file($artifactPath)?json_decode(file_get_contents($artifactPath),true):null;
$modelReady=is_array($metrics)&&($metrics['status']??'')==='trained'&&is_array($artifact)&&($artifact['status']??'')==='ready';
$python=null;
if(function_exists('exec')){foreach(array('python','python3') as $candidate){$v=array();$rc=1;@exec(escapeshellarg($candidate).' --version 2>&1',$v,$rc);if($rc===0){$python=$candidate;break;}}}

// Pull only live operational state. No writes are performed by this module.
// Optional appointment columns are schema-checked so older installations can still open M6.
$apptSelect=array();
foreach(array('status'=>'appointment_status','appointmentTime'=>'appointmentTime','appointmentDate'=>'appointmentDate','status_updated_at'=>'status_updated_at','reschedule_reason'=>'reschedule_reason','cancel_reason'=>'cancel_reason') as $sourceColumn=>$alias){
    $apptSelect[] = ($appointmentTableExists && !empty($appointmentColumnStatus[$sourceColumn])) ? 'a.`'.$sourceColumn.'` AS `'.$alias.'`' : 'NULL AS `'.$alias.'`';
}
$appointmentJoin=$appointmentTableExists ? ' LEFT JOIN appointment a ON a.id=v.appointment_id ' : ' ';
$visitSql="SELECT v.id,v.appointment_id,v.patient_id,v.poli,v.doctor_id,v.status,v.source,v.created_at,v.arrived_at,v.called_at,v.served_at,v.completed_at,v.queue_no, ".implode(',', $apptSelect)."
 FROM hms_patient_visits v ".$appointmentJoin."
 WHERE v.visit_date=? AND v.visit_type='RAWAT_JALAN'";
$visitTypes='s';$visitParams=array($selectedDate);
if($selectedPoli>0){$visitSql.=' AND EXISTS(SELECT 1 FROM hms_master_poli mp WHERE mp.id=? AND (v.poli=mp.poli_name OR v.poli LIKE CONCAT("%",mp.poli_name,"%")))';$visitTypes.='i';$visitParams[]=$selectedPoli;}
if($selectedDoctor>0){$visitSql.=' AND v.doctor_id=?';$visitTypes.='i';$visitParams[]=$selectedDoctor;}
$visitSql.=' ORDER BY v.created_at';
$visits=hms_fetch_all($con,$visitSql,$visitTypes,$visitParams);

// Operational change counters are derived from current source records/events.
$events=array('appointment_baru'=>0,'cancellation'=>0,'reschedule'=>0,'checkin'=>0,'late_arrival'=>0,'service_delay'=>0,'service_completion'=>0);
$now=time();$visitState=array();
foreach($visits as $v){
 $apptStatus=(string)($v['appointment_status']??'');$status=(string)$v['status'];
 if(!empty($v['appointment_id']) && strtotime((string)$v['created_at'])!==false && date('Y-m-d',strtotime($v['created_at']))===$selectedDate)$events['appointment_baru']++;
 if($status==='BATAL'||$apptStatus==='Cancelled'){$events['cancellation']++;}
 if(!empty($v['arrived_at'])){$events['checkin']++;}
 // Late arrival: check-in >10 minutes after booked time, when appointment time is parseable.
 if(!empty($v['arrived_at'])&&!empty($v['appointmentTime'])){
   $bookedAt=strtotime($selectedDate.' '.$v['appointmentTime']);$arrivedAt=strtotime($v['arrived_at']);
   if($bookedAt!==false&&$arrivedAt!==false&&$arrivedAt>$bookedAt+600)$events['late_arrival']++;
 }
 if(!empty($v['served_at'])&&empty($v['completed_at'])){
   $expectedMinutes=30;
   $elapsed=($now-strtotime($v['served_at']))/60;
   if($elapsed>$expectedMinutes)$events['service_delay']++;
 }
 if(!empty($v['completed_at'])||$status==='SELESAI')$events['service_completion']++;
 $visitState[]=$v;
}
// Reschedule events are read from existing workflow/audit history; no new log table is required.
$reschedWorkflow=(int)hms_scalar($con,"SELECT COUNT(*) FROM hms_workflow_events WHERE created_at>=DATE_SUB(NOW(),INTERVAL 24 HOUR) AND (event_type LIKE '%RESCHED%' OR description LIKE '%reschedule%' OR description LIKE '%jadwal diubah%')");
$reschedAudit=(int)hms_scalar($con,"SELECT COUNT(*) FROM hms_audit_events WHERE created_at>=DATE_SUB(NOW(),INTERVAL 24 HOUR) AND (action_name LIKE '%resched%' OR description LIKE '%reschedule%')");
$events['reschedule']=$reschedWorkflow+$reschedAudit;

$scheduleSql="SELECT ds.id AS schedule_id,ds.poli_id,mp.poli_name,ds.doctor_id,d.doctorName,DATE(ds.available_date) schedule_date,ds.start_time,ds.end_time,ds.quota,ds.slot_duration_minutes
 FROM hms_doctor_schedules ds LEFT JOIN hms_master_poli mp ON mp.id=ds.poli_id LEFT JOIN doctors d ON d.id=ds.doctor_id
 WHERE ds.is_active=1 AND DATE(ds.available_date)=?";
$st='s';$sp=array($selectedDate);if($selectedPoli>0){$scheduleSql.=' AND ds.poli_id=?';$st.='i';$sp[]=$selectedPoli;}if($selectedDoctor>0){$scheduleSql.=' AND ds.doctor_id=?';$st.='i';$sp[]=$selectedDoctor;}
$scheduleSql.=' ORDER BY mp.poli_name,d.doctorName,ds.start_time,ds.id';
$scheduleRows=hms_fetch_all($con,$scheduleSql,$st,$sp);
// Deduplicate repeated schedule windows (same doctor/poli/time).
$unique=array();foreach($scheduleRows as $s){$key=(int)$s['doctor_id'].'|'.(int)$s['poli_id'].'|'.$s['start_time'].'|'.$s['end_time'];if(!isset($unique[$key])||(int)$s['quota']>(int)$unique[$key]['quota'])$unique[$key]=$s;}

$recommendations=array();$warnings=array();$candidateCount=0;$modelCalls=0;
$weekday=(int)date('w',strtotime($selectedDate));$month=(int)date('n',strtotime($selectedDate));
foreach($unique as $s){
 $slotMinutes=max(5,(int)$s['slot_duration_minutes']);$quota=max(0,(int)$s['quota']);
 $start=strtotime($selectedDate.' '.$s['start_time']);$end=strtotime($selectedDate.' '.$s['end_time']);if(!$start||!$end||$end<=$start)continue;
 $matched=array();foreach($visitState as $v){$poliMatch=trim((string)$v['poli'])===trim((string)$s['poli_name'])||stripos((string)$v['poli'],(string)$s['poli_name'])!==false;if((int)$v['doctor_id']===(int)$s['doctor_id']&&$poliMatch)$matched[]=$v;}
 $activeVisits=array_values(array_filter($matched,function($v){return $v['status']!=='BATAL'&&($v['appointment_status']??'')!=='Cancelled';}));
 $queue=0;$checkedIn=0;$late=0;$activeService=0;$completedDurations=array();$serviceDelay=0;$booked=count($activeVisits);$doneMinutes=0.0;
 foreach($activeVisits as $v){
   if(in_array($v['status'],array('MENUNGGU','DIPANGGIL'),true))$queue++;
   if(!empty($v['arrived_at']))$checkedIn++;
   if(!empty($v['arrived_at'])&&!empty($v['appointmentTime'])){$bt=strtotime($selectedDate.' '.$v['appointmentTime']);$at=strtotime($v['arrived_at']);if($bt!==false&&$at!==false&&$at>$bt+600)$late++;}
   if($v['status']==='DILAYANI'&&!empty($v['served_at'])&&empty($v['completed_at'])){$activeService++;if(($now-strtotime($v['served_at']))/60>$slotMinutes)$serviceDelay++;}
   if(!empty($v['served_at'])&&!empty($v['completed_at'])){$d=(strtotime($v['completed_at'])-strtotime($v['served_at']))/60;if($d>0&&$d<=240){$doneMinutes+=$d;$completedDurations[]=$d;}}
 }
 $free=max(0,$quota-$booked);$occupancy=$quota>0?min(100,$booked/$quota*100):100;$availability=$quota>0?max(0,100-$occupancy):0;
 $workingMinutes=max(1,($end-$start)/60);$utilization=min(100,(($doneMinutes+$activeService*$slotMinutes)/$workingMinutes)*100);
 $slotCount=(int)floor(($end-$start)/($slotMinutes*60));if($slotCount<1)continue;
 for($t=$start;$t+$slotMinutes*60<=$end;$t+=$slotMinutes*60){
   $candidateCount++;$hour=(int)date('G',$t);
   // Don't recommend past starts when selected date is today.
   if($selectedDate===date('Y-m-d')&&$t<$now)continue;
   // Skip fully booked windows and protect already-confirmed appointments from automatic movement.
   if($free<=0)continue;
   $candidateQueue=max(0,$queue+$late);
   $features=array('poli'=>(string)$s['poli_name'],'doctor_id'=>(string)$s['doctor_id'],'source'=>'ONLINE','registration_hour'=>$hour,'weekday'=>$weekday,'month'=>$month,'queue_ahead_count'=>$candidateQueue,'slot_duration_minutes'=>$slotMinutes);
   $pred=null;$modelName='';
   if($modelReady&&$python&&function_exists('proc_open')){
     $cmd=escapeshellarg($python).' '.escapeshellarg($projectRoot.'/tools/ml/predict_m3_duration.py');$spec=array(0=>array('pipe','r'),1=>array('pipe','w'),2=>array('pipe','w'));$proc=@proc_open($cmd,$spec,$pipes,$projectRoot);
     if(is_resource($proc)){fwrite($pipes[0],json_encode($features));fclose($pipes[0]);$out=stream_get_contents($pipes[1]);fclose($pipes[1]);$err=stream_get_contents($pipes[2]);fclose($pipes[2]);$rc=proc_close($proc);$res=json_decode($out,true);$modelCalls++;if($rc===0&&is_array($res)&&($res['status']??'')==='ok'){$pred=max(1,(float)$res['predicted_minutes']);$modelName=(string)$res['model_name'];}else{$warnings[]='Inferensi M3 gagal: '.($res['message']??$err);}}
   }
   if($pred===null)continue;
   $delay=min(240,($candidateQueue*$pred)+($serviceDelay*$slotMinutes));
   // Late arrivals increase queue pressure; completed visits update utilization/occupancy on each refresh.
   $fuzzy=hms_fuzzy_infer(array('duration'=>hms_fuzzy_clamp($pred,0,120),'queue'=>hms_fuzzy_clamp($candidateQueue,0,40),'utilization'=>hms_fuzzy_clamp($utilization,0,100),'occupancy'=>hms_fuzzy_clamp($occupancy,0,100),'availability'=>hms_fuzzy_clamp($availability,0,100),'delay'=>hms_fuzzy_clamp($delay,0,240)));
   $suitability=max(0,min(100,100-(float)$fuzzy['crisp']));
   $recommendations[]=array('time'=>date('H:i',$t),'doctor'=>$s['doctorName']?:('Dokter #'.$s['doctor_id']),'poli'=>$s['poli_name']?:'Poli tidak terpetakan','predicted'=>$pred,'suitability'=>$suitability,'pressure'=>$fuzzy['category'],'queue'=>$candidateQueue,'checked_in'=>$checkedIn,'late'=>$late,'booked'=>$booked,'quota'=>$quota,'free'=>$free,'utilization'=>$utilization,'occupancy'=>$occupancy,'delay'=>$delay,'model'=>$modelName,'schedule_id'=>(int)$s['schedule_id']);
 }
}
usort($recommendations,function($a,$b){if($a['suitability']==$b['suitability'])return strcmp($a['time'],$b['time']);return $a['suitability']<$b['suitability']?1:-1;});
$top=array_slice($recommendations,0,20);
$eventTotal=array_sum($events);$recomputedAt=date('d-m-Y H:i:s');
// Refresh the page periodically so live changes in appointment/queue state are reflected.
header('Refresh: '.$refreshSeconds.'; url='.basename(__FILE__).'?'.http_build_query(array('date'=>$selectedDate,'poli_id'=>$selectedPoli,'doctor_id'=>$selectedDoctor)));
hms_layout_header('M6 Adaptive Scheduling','admin','operations');
?>
<div class="hms-page-title"><div><h1>M6 — Adaptive Scheduling</h1><div class="text-muted">Rekomendasi slot dihitung ulang dari kondisi appointment, check-in, antrean, keterlambatan, dan penyelesaian pelayanan terkini.</div></div><a class="btn btn-outline-secondary" href="operations_dashboard.php"><i class="bi bi-arrow-left me-1"></i>Kembali ke Modul Pelayanan</a></div>
<!--<div class="alert alert-info"><strong>Prinsip keselamatan:</strong> Adaptive Scheduling hanya memperbarui peringkat rekomendasi. Appointment yang sudah dikonfirmasi tidak dipindahkan, dibatalkan, atau diubah otomatis. Perubahan jadwal tetap melalui proses reschedule resmi dengan persetujuan.</div>
-->
<form class="hms-card p-3 mb-3" method="get"><div class="row g-3 align-items-end"><div class="col-md-3"><label class="form-label">Tanggal layanan</label><input class="form-control" type="date" name="date" value="<?php echo m6_e($selectedDate);?>"></div><div class="col-md-3"><label class="form-label">Poli</label><select class="form-select" name="poli_id"><option value="0">Semua poli</option><?php foreach($polis as $p){?><option value="<?php echo (int)$p['id'];?>" <?php echo $selectedPoli===(int)$p['id']?'selected':'';?>><?php echo m6_e($p['poli_name']);?></option><?php }?></select></div><div class="col-md-3"><label class="form-label">Dokter</label><select class="form-select" name="doctor_id"><option value="0">Semua dokter</option><?php foreach($doctors as $d){?><option value="<?php echo (int)$d['id'];?>" <?php echo $selectedDoctor===(int)$d['id']?'selected':'';?>><?php echo m6_e($d['doctorName']);?></option><?php }?></select></div><div class="col-md-3"><button class="btn btn-primary" type="submit"><i class="bi bi-arrow-repeat me-1"></i>Hitung ulang sekarang</button> <a class="btn btn-outline-secondary" href="m6-adaptive-scheduling.php">Reset</a></div></div></form>
<!--<div class="alert alert-light border d-flex flex-wrap justify-content-between gap-2">
  <span><i class="bi bi-arrow-repeat me-1"></i>Pembaruan otomatis setiap <?php echo $refreshSeconds;?> 
  detik dan saat tombol hitung ulang ditekan.</span><span class="text-muted">Perhitungan halaman: <?php echo m6_e($recomputedAt);?></span></div>
-->
  <!--<div class="hms-card p-3 mb-3">
  <h2 class="h5 mb-3">Pemeriksaan akses database — appointment</h2>
  <div class="table-responsive">
    <table class="table table-sm align-middle mb-2"><tbody>
<tr><th style="width:48%">Keberadaan tabel appointment</th><td><?php echo $appointmentTableExists?'<span class="badge text-bg-success">Ditemukan</span>':'<span class="badge text-bg-danger">Tidak ditemukan</span>';?></td></tr>
<tr><th>Akses baca (SELECT COUNT dan LEFT JOIN)</th><td><?php echo $appointmentReadOk?'<span class="badge text-bg-success">Berhasil</span>':'<span class="badge text-bg-danger">Gagal / tabel tidak tersedia</span>';?></td></tr>

<tr><th>Jumlah record appointment</th><td><?php echo $appointmentReadOk?number_format((int)$appointmentRowCount,0,',','.'): 'Tidak dapat dibaca';?></td></tr>
<tr><th>Kelengkapan kolom yang digunakan M6</th><td><?php echo $appointmentColumnsReady?'<span class="badge text-bg-success">Lengkap</span>':($appointmentTableExists?'<span class="badge text-bg-warning">Sebagian kolom tidak tersedia</span>':'<span class="badge text-bg-secondary">Belum diperiksa</span>');?></td></tr>
<tr><th>Akses tulis otomatis M6</th><td><span class="badge text-bg-success">Tidak digunakan — read-only</span></td></tr>
</tbody></table><p class="small text-muted mb-0">M6 membaca status dan waktu appointment untuk menghitung ulang rekomendasi. Modul tidak menjalankan INSERT, UPDATE, DELETE, atau REPLACE terhadap tabel appointment.</p></div></div>

<?php if(!$modelReady){?><div class="alert alert-warning"><strong>Model M3 belum siap.</strong> Status: <?php echo m6_e($metrics['status']??'belum ada hasil'); ?>. M6 tetap membaca perubahan operasional, tetapi rekomendasi berbasis prediksi belum ditampilkan sampai model M3 valid tersedia.</div><?php }elseif(!$python){?><div class="alert alert-warning">Python tidak terdeteksi pada proses PHP. Pastikan Python tersedia di PATH web server.</div><?php }?>
<?php if($warnings){?><div class="alert alert-warning"><?php echo m6_e(implode(' | ',array_unique($warnings)));?></div><?php }?>
<div class="row g-3 mb-3">
<?php $tiles=array(array('appointment_baru','Appointment baru','bi-calendar-plus'),array('cancellation','Cancellation','bi-calendar-x'),array('reschedule','Reschedule (24 jam)','bi-calendar2-week'),array('checkin','Patient check-in','bi-person-check'),array('late_arrival','Late arrival >10 menit','bi-clock-history'),array('service_delay','Pelayanan aktif >30 menit','bi-hourglass-split'),array('service_completion','Service completion','bi-check-circle'));foreach($tiles as $tile){?><div class="col-6 col-md-3 col-xl"><div class="hms-card hms-stat"><span class="icon"><i class="bi <?php echo m6_e($tile[2]);?>"></i></span><div class="value"><?php echo (int)$events[$tile[0]];?></div><div class="label"><?php echo m6_e($tile[1]);?></div></div></div><?php }?>
</div>
<div class="row g-3 mb-3"><div class="col-md-3"><div class="hms-card hms-stat"><div class="value"><?php echo count($unique);?></div><div class="label">Jadwal dokter aktif</div></div></div><div class="col-md-3"><div class="hms-card hms-stat"><div class="value"><?php echo $candidateCount;?></div><div class="label">Slot kandidat diperiksa</div></div></div><div class="col-md-3"><div class="hms-card hms-stat"><div class="value"><?php echo count($recommendations);?></div><div class="label">Slot berhasil dinilai</div></div></div><div class="col-md-3"><div class="hms-card hms-stat"><div class="value fs-5"><?php echo $modelReady?m6_e($artifact['model_name']??'Model M3 aktif'):'Belum tersedia';?></div><div class="label">Model prediksi</div></div></div></div>
<div class="hms-card p-3 mb-3"><h2 class="h5">Rekomendasi adaptif — <?php echo m6_e(date('d-m-Y',strtotime($selectedDate)));?></h2><p class="small text-muted">Peringkat dihitung dari prediksi durasi M3 dan indeks tekanan M4. Kondisi antrean, check-in terlambat, pelayanan aktif, penyelesaian, serta kuota dibaca ulang pada setiap siklus pembaruan.</p>
<?php if(!$recommendations){?><div class="alert alert-secondary mb-0"><?php echo $modelReady?'Belum ada slot yang memenuhi syarat untuk direkomendasikan. Periksa jadwal aktif, kuota, model M3, dan ketersediaan slot.':'Rekomendasi menunggu model M3 siap dan data operasional valid.';?></div><?php }else{?><div class="table-responsive"><table class="table table-striped align-middle"><thead><tr><th>Rank</th><th>Waktu</th><th>Poli / Dokter</th><th>Prediksi durasi</th><th>Antrean + terlambat</th><th>Check-in</th><th>Kuota tersedia</th><th>Tekanan</th><th>Slot suitability</th><th>Status rekomendasi</th></tr></thead><tbody><?php foreach($top as $i=>$r){$decision=$r['suitability']>=65?'Direkomendasikan':($r['suitability']>=40?'Alternatif':'Kurang sesuai');?><tr><td><?php echo $i+1;?></td><td><strong><?php echo m6_e($r['time']);?></strong></td><td><?php echo m6_e($r['poli']);?><div class="small text-muted"><?php echo m6_e($r['doctor']);?></div></td><td><?php echo m6_minutes($r['predicted']);?><div class="small text-muted"><?php echo m6_e($r['model']);?></div></td><td><?php echo (int)$r['queue'];?> <span class="small text-muted">(late <?php echo (int)$r['late'];?>)</span></td><td><?php echo (int)$r['checked_in'];?></td><td><?php echo (int)$r['free'];?> / <?php echo (int)$r['quota'];?></td><td><?php echo m6_e($r['pressure']);?></td><td><strong><?php echo number_format($r['suitability'],1,',','.');?> / 100</strong></td><td><span class="badge text-bg-<?php echo $r['suitability']>=65?'success':($r['suitability']>=40?'warning':'secondary');?>"><?php echo $decision;?></span></td></tr><?php }?></tbody></table></div><?php }?></div>
<div class="hms-card p-3"><h2 class="h5">Mekanisme adaptasi dan batasan sistem</h2><div class="table-responsive"><table class="table table-sm"><thead><tr><th>Perubahan kondisi</th><th>Respons M6 pada perhitungan berikutnya</th></tr></thead><tbody>
<tr><td>Appointment baru</td><td>Memperbarui jumlah booking, okupansi, kuota tersisa, dan peringkat slot.</td></tr><tr><td>Cancellation</td><td>Appointment/kunjungan berstatus batal tidak dihitung sebagai kapasitas terpakai.</td></tr><tr><td>Reschedule</td><td>Jadwal kunjungan terbaru dibaca dari data sumber; histori reschedule dibaca dari event/audit yang tersedia.</td></tr><tr><td>Patient check-in</td><td>Memperbarui jumlah pasien hadir dan status antrean.</td></tr><tr><td>Late arrival</td><td>Check-in lebih dari 10 menit setelah waktu appointment menambah tekanan antrean.</td></tr><tr><td>Keterlambatan pelayanan</td><td>Pelayanan yang masih aktif melewati estimasi durasi menambah estimasi delay.</td></tr><tr><td>Service completion</td><td>Durasi pelayanan aktual dan utilisasi dokter diperbarui dari served_at/completed_at.</td></tr>
</tbody></table></div><div class="alert alert-warning mb-0"><strong>Perlindungan appointment:</strong> halaman M6 hanya menjalankan query baca dan perhitungan rekomendasi. Akses baca (SELECT) ke tabel appointment digunakan untuk mendeteksi status dan perubahan jadwal. Tidak ada perintah INSERT/UPDATE/DELETE/REPLACE terhadap tabel appointment, hms_patient_visits, atau hms_doctor_schedules. Petugas tetap memproses perubahan melalui alur resmi.</div></div>
-->
<?php hms_layout_footer(); ?>
