<?php
/**
 * M5 Hybrid DSS: AdaBoost Regression -> Predicted Service Duration -> Fuzzy Mamdani
 * -> Slot Suitability -> Appointment Recommendation.
 * Read-only decision support: does not create bookings or modify SIMRS records.
 */
session(); include('../include/config.php');
require_once __DIR__ . '/module_bootstrap.php';
require_once __DIR__ . '/hybrid_dss_engine.php';
hms_module_require_roles(array('admin'));
if (!function_exists('m5_e')) { function m5_e($v){ return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8'); } }
$projectRoot = dirname(__DIR__, 2);
$selectedDate = isset($_GET['date']) && preg_match('/^\d{4}-\d{2}-\d{2}$/',$_GET['date']) ? $_GET['date'] : date('Y-m-d',strtotime('+1 day'));
$selectedPoli = isset($_GET['poli_id']) ? (int)$_GET['poli_id'] : 0;
$selectedDoctor = isset($_GET['doctor_id']) ? (int)$_GET['doctor_id'] : 0;
$polis = hms_fetch_all($con,"SELECT id,poli_name FROM hms_master_poli WHERE is_active=1 ORDER BY poli_name");
$doctors = hms_fetch_all($con,"SELECT id,doctorName FROM doctors ORDER BY doctorName");
$metricsPath=$projectRoot.'/tools/ml/output/m3_model_metrics.json';
$artifactPath=$projectRoot.'/tools/ml/output/m3_model_artifact.json';
$metrics=is_file($metricsPath)?json_decode(file_get_contents($metricsPath),true):null;
$artifact=is_file($artifactPath)?json_decode(file_get_contents($artifactPath),true):null;
$modelReady=is_array($metrics)&&($metrics['status']??'')==='trained'&&is_array($artifact)&&($artifact['status']??'')==='ready';
$pythonCandidates=array('python','python3'); $python=null;
if(function_exists('exec')){ foreach($pythonCandidates as $candidate){ $v=array(); $rc=1; @exec(escapeshellarg($candidate).' --version 2>&1',$v,$rc); if($rc===0){$python=$candidate;break;} }}
$schedules=array();
$sql="SELECT ds.id AS schedule_id,ds.poli_id,mp.poli_name,ds.doctor_id,d.doctorName,DATE(ds.available_date) AS schedule_date,
 ds.start_time,ds.end_time,ds.quota,ds.slot_duration_minutes
 FROM hms_doctor_schedules ds
 LEFT JOIN hms_master_poli mp ON mp.id=ds.poli_id
 LEFT JOIN doctors d ON d.id=ds.doctor_id
 WHERE ds.is_active=1 AND DATE(ds.available_date)=?";
$types='s';$params=array($selectedDate);
if($selectedPoli>0){$sql.=' AND ds.poli_id=?';$types.='i';$params[]=$selectedPoli;}
if($selectedDoctor>0){$sql.=' AND ds.doctor_id=?';$types.='i';$params[]=$selectedDoctor;}
$sql.=' ORDER BY mp.poli_name,d.doctorName,ds.start_time,ds.id';
$scheduleRows=hms_fetch_all($con,$sql,$types,$params);
// Collapse duplicate schedule windows to avoid double-counting quota/candidate slots.
$unique=array(); foreach($scheduleRows as $s){$k=(int)$s['doctor_id'].'|'.(int)$s['poli_id'].'|'.$s['start_time'].'|'.$s['end_time']; if(!isset($unique[$k])||(int)$s['quota']>(int)$unique[$k]['quota'])$unique[$k]=$s;}
$recommendations=array();$warnings=array();$totalCandidates=0;
$weekday=(int)date('w',strtotime($selectedDate));$month=(int)date('n',strtotime($selectedDate));
foreach($unique as $s){
 $durationSlot=max(5,(int)$s['slot_duration_minutes']);$quota=max(0,(int)$s['quota']);
 $start=strtotime($selectedDate.' '.$s['start_time']);$end=strtotime($selectedDate.' '.$s['end_time']);
 if(!$start||!$end||$end<=$start)continue;
 $visits=hms_fetch_all($con,"SELECT id,status,created_at,served_at,completed_at FROM hms_patient_visits WHERE visit_date=? AND visit_type='RAWAT_JALAN' AND doctor_id=? AND (poli=? OR poli LIKE CONCAT('%',?,'%')) AND status<>'BATAL' ORDER BY created_at",'siss',array($selectedDate,(int)$s['doctor_id'],$s['poli_name'],$s['poli_name']));
 $booked=count($visits);$queue=0;$doneMinutes=0.0;$active=0;
 foreach($visits as $v){if(in_array($v['status'],array('MENUNGGU','DIPANGGIL'),true))$queue++;if($v['status']==='DILAYANI'&&!empty($v['served_at'])&&empty($v['completed_at']))$active++;if(!empty($v['served_at'])&&!empty($v['completed_at'])){$d=(strtotime($v['completed_at'])-strtotime($v['served_at']))/60;if($d>0&&$d<=240)$doneMinutes+=$d;}}
 $slotCount=(int)floor(($end-$start)/($durationSlot*60)); if($slotCount<1)$slotCount=max(1,$quota);
 $free=max(0,$quota-$booked);$occupancy=$quota>0?min(100,($booked/$quota)*100):100;$availability=$quota>0?max(0,100-$occupancy):0;
 $utilization=min(100,(($doneMinutes+$active*$durationSlot)/max(1,(($end-$start)/60)))*100);
 for($t=$start;$t+$durationSlot*60<=$end;$t+=$durationSlot*60){
   $totalCandidates++;$hour=(int)date('G',$t);
   $candidateQueue=$queue;
   $features=array('poli'=>(string)$s['poli_name'],'doctor_id'=>(string)$s['doctor_id'],'source'=>'ONLINE','registration_hour'=>$hour,'weekday'=>$weekday,'month'=>$month,'queue_ahead_count'=>$candidateQueue,'slot_duration_minutes'=>$durationSlot);
   $pred=null;$modelName='';
   if($modelReady&&$python&&function_exists('proc_open')){$cmd=escapeshellarg($python).' '.escapeshellarg($projectRoot.'/tools/ml/predict_m3_duration.py');$spec=array(0=>array('pipe','r'),1=>array('pipe','w'),2=>array('pipe','w'));$proc=@proc_open($cmd,$spec,$pipes,$projectRoot);if(is_resource($proc)){fwrite($pipes[0],json_encode($features));fclose($pipes[0]);$out=stream_get_contents($pipes[1]);fclose($pipes[1]);$err=stream_get_contents($pipes[2]);fclose($pipes[2]);$rc=proc_close($proc);$res=json_decode($out,true);if($rc===0&&is_array($res)&&($res['status']??'')==='ok'){$pred=(float)$res['predicted_minutes'];$modelName=(string)$res['model_name'];}else{$warnings[]='Inferensi model gagal: '.($res['message']??$err);}}}
   $durationSource='Model M3';
   if($pred===null){$durationSource='Belum ada prediksi M3 aktif';continue;}
   $delay=min(240,$candidateQueue*$pred);
   $fuzzy=hms_fuzzy_infer(array('duration'=>hms_fuzzy_clamp($pred,0,120),'queue'=>hms_fuzzy_clamp($candidateQueue,0,40),'utilization'=>hms_fuzzy_clamp($utilization,0,100),'occupancy'=>hms_fuzzy_clamp($occupancy,0,100),'availability'=>hms_fuzzy_clamp($availability,0,100),'delay'=>hms_fuzzy_clamp($delay,0,240)));
   $suitability=100-(float)$fuzzy['crisp'];
   $recommendations[]=array('date'=>$selectedDate,'time'=>date('H:i',$t),'doctor'=>$s['doctorName']?:('Dokter #'.$s['doctor_id']),'doctor_id'=>(int)$s['doctor_id'],'poli'=>$s['poli_name']?:'Poli tidak terpetakan','predicted'=>$pred,'suitability'=>$suitability,'pressure'=>$fuzzy['category'],'active_rules'=>$fuzzy['active_rules'],'queue'=>$candidateQueue,'booked'=>$booked,'quota'=>$quota,'free'=>$free,'utilization'=>$utilization,'occupancy'=>$occupancy,'model'=>$modelName,'schedule_id'=>(int)$s['schedule_id']);
 }
}
usort($recommendations,function($a,$b){if($a['suitability']==$b['suitability'])return strcmp($a['time'],$b['time']);return $a['suitability']<$b['suitability']?1:-1;});
$top=array_slice($recommendations,0,15);
hms_layout_header('M5 Hybrid DSS','admin','operations');
?>
<div class="hms-page-title"><div><h1>M5 — Hybrid Decision Support System</h1><div class="text-muted">Integrasi prediksi durasi AdaBoost Regression, inferensi Fuzzy Mamdani, penilaian kelayakan slot, dan rekomendasi appointment.</div></div><a class="btn btn-outline-secondary" href="operations_dashboard.php"><i class="bi bi-arrow-left me-1"></i>Kembali ke Modul Pelayanan</a></div>
<!--<div class="alert alert-info"><strong>Arsitektur penelitian:</strong> AdaBoost Regression → Predicted Service Duration → Fuzzy Mamdani → Slot Suitability → Appointment Recommendation. Modul ini bersifat baca-saja; tidak membuat atau mengubah appointment.</div>
-->
<form class="hms-card p-3 mb-3" method="get"><div class="row g-3 align-items-end"><div class="col-md-3"><label class="form-label">Tanggal kunjungan</label><input class="form-control" type="date" name="date" value="<?php echo m5_e($selectedDate); ?>"></div><div class="col-md-3"><label class="form-label">Poli</label><select class="form-select" name="poli_id"><option value="0">Semua poli</option><?php foreach($polis as $p){?><option value="<?php echo (int)$p['id'];?>" <?php echo $selectedPoli===(int)$p['id']?'selected':'';?>><?php echo m5_e($p['poli_name']);?></option><?php }?></select></div><div class="col-md-3"><label class="form-label">Dokter</label><select class="form-select" name="doctor_id"><option value="0">Semua dokter</option><?php foreach($doctors as $d){?><option value="<?php echo (int)$d['id'];?>" <?php echo $selectedDoctor===(int)$d['id']?'selected':'';?>><?php echo m5_e($d['doctorName']);?></option><?php }?></select></div><div class="col-md-3"><button class="btn btn-primary" type="submit"><i class="bi bi-funnel me-1"></i>Analisis slot</button> <a class="btn btn-outline-secondary" href="m5-hybrid-dss.php">Reset</a></div></div></form>
<?php if(!$modelReady){?><div class="alert alert-warning"><strong>Model M3 belum siap digunakan.</strong> Status training: <?php echo m5_e($metrics['status']??'belum ada hasil'); ?>. Jalankan ekspor dataset aktual dan <code>python tools/ml/train_m3_adaboost.py</code> setelah jumlah data valid memenuhi syarat. M5 tidak mengganti prediksi ML dengan angka buatan.</div><?php } elseif(!$python){?><div class="alert alert-warning">Python tidak terdeteksi oleh proses PHP. Pastikan Python tersedia di PATH akun web server.</div><?php } ?>
<?php if($warnings){?><div class="alert alert-warning"><?php echo m5_e(implode(' | ',array_unique($warnings)));?></div><?php } ?>
<div class="row g-3 mb-3"><div class="col-md-3"><div class="hms-card hms-stat"><div class="value"><?php echo count($unique);?></div><div class="label">Jadwal unik</div></div></div><div class="col-md-3"><div class="hms-card hms-stat"><div class="value"><?php echo $totalCandidates;?></div><div class="label">Slot kandidat diperiksa</div></div></div><div class="col-md-3"><div class="hms-card hms-stat"><div class="value"><?php echo count($recommendations);?></div><div class="label">Slot berhasil dinilai</div></div></div><div class="col-md-3"><div class="hms-card hms-stat"><div class="value fs-5"><?php echo $modelReady?m5_e($artifact['model_name']??'Model aktif'):'Belum tersedia';?></div><div class="label">Model M3 terpilih</div></div></div></div>
<div class="hms-card p-3 mb-3"><h2 class="h5">Rekomendasi appointment — <?php echo m5_e(date('d-m-Y',strtotime($selectedDate)));?></h2><p class="small text-muted">Peringkat diurutkan berdasarkan Slot Suitability tertinggi (100 − indeks tekanan Fuzzy). Rekomendasi ini merupakan dukungan keputusan, bukan konfirmasi booking.</p>
<?php if(!$recommendations){?><div class="alert alert-secondary mb-0"><?php echo $modelReady?'Tidak ada slot yang dapat dinilai. Periksa jadwal aktif, kuota, dan kesesuaian poli/dokter.':'Belum ada rekomendasi karena model M3 belum siap atau prediksi tidak dapat dijalankan.';?></div><?php }else{?><div class="table-responsive"><table class="table table-striped align-middle"><thead><tr><th>Rank</th><th>Waktu</th><th>Poli / Dokter</th><th>Prediksi durasi</th><th>Queue</th><th>Kuota tersisa</th><th>Indeks Fuzzy</th><th>Slot Suitability</th><th>Keputusan</th></tr></thead><tbody><?php foreach($top as $i=>$r){$decision=$r['suitability']>=65?'Direkomendasikan':($r['suitability']>=40?'Alternatif':'Kurang sesuai');?><tr><td><?php echo $i+1;?></td><td><strong><?php echo m5_e($r['time']);?></strong></td><td><?php echo m5_e($r['poli']);?><div class="small text-muted"><?php echo m5_e($r['doctor']);?></div></td><td><?php echo number_format($r['predicted'],1,',','.');?> menit<div class="small text-muted"><?php echo m5_e($r['model']);?></div></td><td><?php echo (int)$r['queue'];?></td><td><?php echo (int)$r['free'];?> / <?php echo (int)$r['quota'];?></td><td><?php echo m5_e($r['pressure']);?></td><td><strong><?php echo number_format($r['suitability'],1,',','.');?> / 100</strong></td><td><span class="badge text-bg-<?php echo $r['suitability']>=65?'success':($r['suitability']>=40?'warning':'secondary');?>"><?php echo $decision;?></span></td></tr><?php }?></tbody></table></div><?php }?></div>
<div class="hms-card p-3"><h2 class="h5">Metode dan batasan interpretasi</h2><ol class="mb-2"><li><strong>AdaBoost Regression:</strong> M5 memakai model AdaBoost Regression yang dilatih pada seluruh data valid. Hasil benchmark M3 (Linear Regression, Random Forest, AdaBoost) tetap ditampilkan terpisah dan pemenangnya ditentukan oleh MAE data uji.</li><li><strong>Predicted Service Duration:</strong> diprediksi per kandidat slot menggunakan poli, dokter, sumber ONLINE, jam, hari, bulan, antrean berjalan, dan durasi slot.</li><li><strong>Fuzzy Mamdani:</strong> memakai enam input dan basis aturan 3⁶ = 729 aturan yang sama dengan M4. Indeks tekanan lebih rendah menghasilkan kesesuaian slot lebih tinggi.</li><li><strong>Slot Suitability:</strong> dihitung sebagai 100 dikurangi indeks tekanan Fuzzy.</li><li><strong>Appointment Recommendation:</strong> mengurutkan kandidat slot dengan nilai kesesuaian tertinggi.</li></ol><div class="small text-muted">Catatan: skor dan ambang rekomendasi adalah parameter operasional awal, perlu validasi pakar/dokter dan evaluasi historis. Sistem belum melakukan booking otomatis; konfirmasi tetap melalui alur appointment resmi.</div></div>
<?php hms_layout_footer(); ?>
