<?php
/** M3 AdaBoost Regression - additive module; legacy clinical workflows are not modified. */
session(); include('../include/config.php'); require_once __DIR__.'/module_bootstrap.php';
hms_module_require_roles(array('admin'));
$root=dirname(__DIR__,4); $mlDir=$root.'/writable/ml'; $script=$root.'/tools/ml/train_adaboost.py';
if(!is_dir($mlDir)) @mkdir($mlDir,0775,true);
$csvPath=$mlDir.'/m3_service_duration_dataset.csv'; $metricsPath=$mlDir.'/m3_metrics.json';
function m3e($v){return htmlspecialchars((string)$v,ENT_QUOTES,'UTF-8');}
function m3_rows($con){
 $sql="SELECT v.id,v.visit_date,COALESCE(NULLIF(v.poli,''),'Tidak diketahui') poli,v.doctor_id,COALESCE(v.source,'OFFLINE') source,COALESCE(v.visit_type,'RAWAT_JALAN') visit_type,v.queue_no,v.served_at,v.completed_at,ROUND(TIMESTAMPDIFF(SECOND,v.served_at,v.completed_at)/60,2) service_minutes FROM hms_patient_visits v WHERE v.visit_type='RAWAT_JALAN' AND v.status='SELESAI' AND v.served_at IS NOT NULL AND v.completed_at IS NOT NULL AND v.completed_at>v.served_at AND TIMESTAMPDIFF(SECOND,v.served_at,v.completed_at) BETWEEN 60 AND 28800 ORDER BY v.visit_date ASC,v.served_at ASC,v.id ASC";
 $res=mysqli_query($con,$sql); if(!$res)return array(); $out=array(); while($r=mysqli_fetch_assoc($res))$out[]=$r; mysqli_free_result($res); return $out;
}
function m3_csv($path,$rows){
 $fp=fopen($path,'w'); if(!$fp)throw new RuntimeException('Tidak dapat menulis writable/ml. Periksa izin folder.'); fwrite($fp,"\xEF\xBB\xBF");
 fputcsv($fp,array('visit_date','poli','doctor_id','source','visit_type','weekday','month','day','hour','queue_position','service_minutes'));
 foreach($rows as $r){$ts=strtotime($r['served_at']);$q=preg_replace('/[^0-9]/','',(string)$r['queue_no']);fputcsv($fp,array($r['visit_date'],$r['poli'],$r['doctor_id']?:'',$r['source'],$r['visit_type'],date('N',strtotime($r['visit_date'])),date('n',strtotime($r['visit_date'])),date('j',strtotime($r['visit_date'])),$ts?date('G',$ts):'',$q!==''?(int)$q:'',$r['service_minutes']));} fclose($fp);
}
$rows=m3_rows($con); $message=''; $error='';
if(isset($_GET['action'])&&$_GET['action']==='export'){
 try{m3_csv($csvPath,$rows);header('Content-Type: text/csv; charset=utf-8');header('Content-Disposition: attachment; filename="m3_service_duration_dataset.csv"');header('Content-Length: '.filesize($csvPath));readfile($csvPath);exit;}catch(Throwable $e){http_response_code(500);exit(m3e($e->getMessage()));}
}
if($_SERVER['REQUEST_METHOD']==='POST'){
 hms_module_csrf();
 try{
  if(count($rows)<10)throw new RuntimeException('Data pelayanan valid baru '.count($rows).' baris. Minimal 10 untuk uji awal; disarankan 100–200+ kunjungan selesai.');
  m3_csv($csvPath,$rows);
  if(!function_exists('shell_exec'))throw new RuntimeException('shell_exec tidak aktif. Jalankan training manual sesuai README M3.');
  $py=trim((string)($_POST['python_cmd']??'python'));if(!in_array($py,array('python','py -3','python3'),true))$py='python';
  $cmd=$py.' '.escapeshellarg($script).' --input '.escapeshellarg($csvPath).' --output-dir '.escapeshellarg($mlDir).' 2>&1';$output=shell_exec($cmd);$result=json_decode((string)$output,true);
  if(!is_array($result)||($result['status']??'')!=='success'){$detail=is_array($result)?($result['message']??'Output training tidak valid.'):trim((string)$output);throw new RuntimeException('Training belum berhasil. '.($detail?:'Pastikan Python dan dependensi terpasang.'));}
  $message='Training berhasil: '.(int)$result['dataset_rows'].' data. Model terbaik: '.$result['best_model'].'.';
  if(function_exists('hms_module_audit'))hms_module_audit($con,'model_trained','M3_AdaBoost','hms_patient_visits',null,$message);
 }catch(Throwable $e){$error=$e->getMessage();}
}
$metrics=is_file($metricsPath)?json_decode((string)file_get_contents($metricsPath),true):null;if(!is_array($metrics))$metrics=null;
$preview=array_slice(array_reverse($rows),0,12);
hms_layout_header('M3 AdaBoost Regression','admin','m3');
?>
<div class="hms-page-title"><div><h1>M3 — AdaBoost Regression</h1><div class="text-muted">Prediksi durasi pelayanan rawat jalan berbasis data aktual SIMRS dan evaluasi komparatif model regresi.</div></div><a class="btn btn-outline-secondary" href="operations_dashboard.php"><i class="bi bi-arrow-left me-1"></i>Modul Pelayanan</a></div>
<?php if ($message) { ?>
<div class="alert alert-success"><?php echo m3e($message); ?></div>
<?php } ?>
<?php if ($error) { ?>
<div class="alert alert-warning"><strong>Perhatian:</strong> <?php echo m3e($error); ?></div>
<?php } ?>
<div class="row g-3 mb-4">
 <div class="col-md-4"><div class="hms-card hms-stat"><span class="icon"><i class="bi bi-database"></i></span><div class="value"><?php echo number_format(count($rows));?></div><div class="label">Data pelayanan valid tersedia</div></div></div>
 <div class="col-md-4"><div class="hms-card hms-stat"><span class="icon"><i class="bi bi-cpu"></i></span><div class="value" style="font-size:22px"><?php echo $metrics?m3e($metrics['best_model']):'Belum dilatih';?></div><div class="label">Model terbaik berdasarkan MAE data uji</div></div></div>
 <div class="col-md-4"><div class="hms-card hms-stat"><span class="icon"><i class="bi bi-clock-history"></i></span><div class="value" style="font-size:18px"><?php echo $metrics?m3e($metrics['trained_at']):'—';?></div><div class="label">Training terakhir</div></div></div>
</div>
<div class="hms-card p-3 mb-4"><h2 class="h5">1. Dataset Service Duration</h2>
<p class="text-muted">Sumber: <code>hms_patient_visits</code>. Hanya rawat jalan berstatus SELESAI dengan waktu mulai dan selesai yang valid. Target dihitung dari <code>completed_at − served_at</code> dalam menit. Nama pasien dan nomor rekam medis tidak diekspor.</p>
<a class="btn btn-outline-primary mb-3" href="?action=export"><i class="bi bi-download me-1"></i>Unduh Dataset CSV</a>
<div class="table-responsive"><table class="table table-sm"><thead><tr><th>Variabel</th><th>Jenis</th><th>Definisi</th></tr></thead><tbody>
<tr><td>poli</td><td>Kategorikal</td><td>Poliklinik tujuan.</td></tr><tr><td>doctor_id</td><td>Kategorikal</td><td>ID dokter yang dijadwalkan; diperlakukan sebagai kategori, bukan besaran numerik.</td></tr><tr><td>source</td><td>Kategorikal</td><td>Sumber registrasi ONLINE/OFFLINE.</td></tr><tr><td>visit_type</td><td>Kategorikal</td><td>Jenis kunjungan; dataset difokuskan RAWAT_JALAN.</td></tr><tr><td>weekday, month, day, hour</td><td>Numerik</td><td>Hari, bulan, tanggal dan jam saat pelayanan dimulai.</td></tr><tr><td>queue_position</td><td>Numerik</td><td>Nomor urut antrean.</td></tr><tr class="table-success"><td><strong>service_minutes</strong></td><td><strong>Target (Y)</strong></td><td><strong>Durasi aktual; tidak menjadi predictor.</strong></td></tr>
</tbody></table></div><div class="alert alert-info mb-0"><strong>Pencegahan data leakage:</strong> completed_at hanya digunakan untuk menghitung target. Target service_minutes tidak dimasukkan sebagai fitur. Fitur waktu berasal dari saat pelayanan dimulai.</div></div>
<div class="hms-card p-3 mb-4"><h2 class="h5">2. Preprocessing dan Training</h2><ul><li>Validasi dan pembersihan durasi kosong, nol/negatif, serta durasi di atas 8 jam.</li><li>Imputasi median (numerik) dan modus (kategorikal).</li><li>One-hot encoding fitur kategorikal dan scaling fitur numerik.</li><li>Split kronologis 80:20, tanpa pengacakan.</li><li>TimeSeriesSplit untuk cross-validation pada data train.</li></ul>
<form method="post" class="d-flex flex-wrap gap-2 align-items-end"><?php echo hms_csrf_field();?><div><label class="form-label" for="python_cmd">Perintah Python</label><select class="form-select" name="python_cmd" id="python_cmd"><option value="python">python</option><option value="py -3">py -3 (Windows)</option><option value="python3">python3</option></select></div><button class="btn btn-primary" type="submit" <?php echo count($rows)<10?'disabled':'';?>><i class="bi bi-play-fill me-1"></i>Jalankan Training & Benchmark</button></form>
<small class="text-muted d-block mt-2">Instal Python 3.9+ dan paket dari <code>tools/ml/requirements.txt</code>. Hasil disimpan pada <code>writable/ml/</code>.</small></div>
<div class="hms-card p-3 mb-4"><h2 class="h5">3. Benchmark Model</h2>
<?php if(!$metrics){?><p class="text-muted mb-0">Belum ada hasil training. Jalankan training setelah data mencukupi.</p><?php }else{?>
<div class="small text-muted mb-2">Data: <?php echo (int)$metrics['dataset_rows'];?> | Train: <?php echo (int)$metrics['train_rows'];?> | Test: <?php echo (int)$metrics['test_rows'];?> | <?php echo m3e($metrics['split_method']);?></div>
<div class="table-responsive"><table class="table table-hover"><thead><tr><th>Model</th><th>MAE (menit)</th><th>RMSE (menit)</th><th>R²</th><th>Hasil</th></tr></thead><tbody><?php foreach(($metrics['models']??array()) as $m){$best=$m['model']===$metrics['best_model'];?><tr class="<?php echo $best?'table-success':'';?>"><td><?php echo m3e($m['model']);?></td><td><?php echo number_format((float)$m['mae'],2);?></td><td><?php echo number_format((float)$m['rmse'],2);?></td><td><?php echo $m['r2']===null?'—':number_format((float)$m['r2'],3);?></td><td><?php echo $best?'<span class="badge text-bg-success">MAE terendah</span>':'—';?></td></tr><?php }?></tbody></table></div>
<h3 class="h6 mt-3">Time-series cross-validation (MAE)</h3><div class="table-responsive"><table class="table table-sm"><thead><tr><th>Model</th><th>Fold</th><th>Rata-rata MAE</th><th>Std. MAE</th></tr></thead><tbody><?php foreach(($metrics['time_series_cv']??array()) as $name=>$cv){?><tr><td><?php echo m3e($name);?></td><td><?php echo (int)$cv['folds'];?></td><td><?php echo number_format((float)$cv['mean_mae'],2);?></td><td><?php echo number_format((float)$cv['std_mae'],2);?></td></tr><?php }?></tbody></table></div><p class="small text-muted mb-0"><?php echo m3e($metrics['notes']??'');?></p><?php }?></div>
<div class="hms-card p-3"><h2 class="h5">4. Preview data pelayanan terbaru</h2><div class="table-responsive"><table class="table table-sm table-hover"><thead><tr><th>Tanggal</th><th>Poli</th><th>Dokter ID</th><th>Sumber</th><th>Mulai</th><th>Selesai</th><th>Durasi (menit)</th></tr></thead><tbody><?php if(!$preview){?><tr><td colspan="7" class="text-center text-muted">Belum ada data pelayanan selesai dengan timestamp lengkap.</td></tr><?php } foreach($preview as $r){?><tr><td><?php echo m3e($r['visit_date']);?></td><td><?php echo m3e($r['poli']);?></td><td><?php echo m3e($r['doctor_id']?:'—');?></td><td><?php echo m3e($r['source']);?></td><td><?php echo m3e($r['served_at']);?></td><td><?php echo m3e($r['completed_at']);?></td><td><?php echo number_format((float)$r['service_minutes'],2);?></td></tr><?php }?></tbody></table></div></div>
<?php hms_layout_footer(); ?>
