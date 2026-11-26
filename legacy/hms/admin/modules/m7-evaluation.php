<?php
/**
 * M7 Evaluation — scheduling comparison and ablation.
 * Read-only evaluation. Source timestamps: arrived_at (check-in proxy), served_at (service-start proxy).
 * Experimental arm comparison is enabled only after hms_scheduling_evaluation is populated.
 */
session(); include('../include/config.php');
require_once __DIR__ . '/module_bootstrap.php';
hms_module_require_roles(array('admin'));
if (!function_exists('m7_e')) { function m7_e($v){ return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8'); } }
if (!function_exists('m7_fmt')) { function m7_fmt($v,$digits=1){ return $v===null?'—':number_format((float)$v,$digits,',','.'); } }

$projectRoot=dirname(__DIR__,2);
$defaultFrom=date('Y-m-d',strtotime('-29 days'));
$from=isset($_GET['from'])&&preg_match('/^\d{4}-\d{2}-\d{2}$/',$_GET['from'])?$_GET['from']:$defaultFrom;
$to=isset($_GET['to'])&&preg_match('/^\d{4}-\d{2}-\d{2}$/',$_GET['to'])?$_GET['to']:date('Y-m-d');
if($from>$to){$tmp=$from;$from=$to;$to=$tmp;}

$requiredTables=array('hms_patient_visits','appointment','hms_doctor_schedules');
$tableStatus=array();foreach($requiredTables as $t){$tableStatus[$t]=hms_table_exists($con,$t);}
$hasExperimentTable=hms_table_exists($con,'hms_scheduling_evaluation');
$visitColumns=array('id','visit_date','doctor_id','appointment_id','status','arrived_at','served_at','completed_at');
$visitColumnStatus=array();foreach($visitColumns as $c){$visitColumnStatus[$c]=hms_column_exists($con,'hms_patient_visits',$c);}
$visitReady=$tableStatus['hms_patient_visits']&&!in_array(false,$visitColumnStatus,true);

$visits=array();$queryError='';
if($visitReady){
  $apptJoin=$tableStatus['appointment']?'LEFT JOIN appointment a ON a.id=v.appointment_id':'LEFT JOIN (SELECT NULL id,NULL status,NULL reschedule_reason,NULL cancel_reason) a ON 1=0';
  $apptFields=$tableStatus['appointment']?',a.status AS appointment_status,a.reschedule_reason,a.cancel_reason':',NULL AS appointment_status,NULL AS reschedule_reason,NULL AS cancel_reason';
  try{$visits=hms_fetch_all($con,"SELECT v.id,v.visit_date,v.doctor_id,v.appointment_id,v.status,v.arrived_at,v.served_at,v.completed_at {$apptFields} FROM hms_patient_visits v {$apptJoin} WHERE v.visit_type='RAWAT_JALAN' AND v.visit_date BETWEEN ? AND ? ORDER BY v.visit_date,v.doctor_id,v.served_at",'ss',array($from,$to));}
  catch(Throwable $e){$queryError='Query kunjungan gagal: '.$e->getMessage();}
}

// Main outcome: service_started_at - checked_in_at; in the supplied HMS schema these map to served_at - arrived_at.
$waits=array();$validWaitVisitIds=array();$serviceRows=array();$cancelled=0;$rescheduled=0;
foreach($visits as $v){
  $isCancelled=(($v['status']??'')==='BATAL'||($v['appointment_status']??'')==='Cancelled');
  if($isCancelled)$cancelled++;
  if(!empty($v['reschedule_reason']))$rescheduled++;
  if(!empty($v['arrived_at'])&&!empty($v['served_at'])){
    $a=strtotime($v['arrived_at']);$b=strtotime($v['served_at']);
    if($a!==false&&$b!==false&&$b>=$a&&($b-$a)<=86400){$mins=($b-$a)/60;$waits[]=$mins;$validWaitVisitIds[(int)$v['id']]=true;}
  }
  if(!empty($v['served_at'])&&!empty($v['completed_at'])){
    $s=strtotime($v['served_at']);$e=strtotime($v['completed_at']);
    if($s!==false&&$e!==false&&$e>$s&&($e-$s)<=14400){$serviceRows[]=$v+array('_start'=>$s,'_end'=>$e,'_duration'=>($e-$s)/60);}
  }
}
$sortWaits=$waits;sort($sortWaits);
$median=null;$p90=null;$mean=null;$n=count($sortWaits);
if($n){$mid=(int)floor(($n-1)/2);$median=($n%2)?$sortWaits[$mid]:($sortWaits[$mid]+$sortWaits[$mid+1])/2;$p90=$sortWaits[(int)ceil(.90*$n)-1];$mean=array_sum($sortWaits)/$n;}

// Secondary operational measures: doctor idle gap between sequential completed/started services,
// overtime after scheduled end, and service minutes / scheduled minutes.
$idleMinutes=0.0;$overtimeMinutes=0.0;$serviceMinutes=0.0;$scheduledMinutes=0.0;$doctorDays=0;
if($tableStatus['hms_doctor_schedules']){
 try{
  $sched=hms_fetch_all($con,"SELECT doctor_id,DATE(available_date) AS work_date,MIN(start_time) AS start_time,MAX(end_time) AS end_time FROM hms_doctor_schedules WHERE is_active=1 AND DATE(available_date) BETWEEN ? AND ? GROUP BY doctor_id,DATE(available_date)",'ss',array($from,$to));
  $byDay=array();foreach($serviceRows as $r){if(empty($r['doctor_id']))continue;$k=$r['visit_date'].'|'.$r['doctor_id'];$byDay[$k][]=$r;}
  foreach($sched as $sc){$k=$sc['work_date'].'|'.$sc['doctor_id'];$st=strtotime($sc['work_date'].' '.$sc['start_time']);$en=strtotime($sc['work_date'].' '.$sc['end_time']);if(!$st||!$en||$en<=$st)continue;$scheduledMinutes+=($en-$st)/60;$doctorDays++;
    $rows=$byDay[$k]??array();usort($rows,function($x,$y){return $x['_start']<=>$y['_start'];});$prevEnd=null;$lastEnd=null;
    foreach($rows as $r){$serviceMinutes+=$r['_duration'];if($prevEnd!==null&&$r['_start']>$prevEnd)$idleMinutes+=($r['_start']-$prevEnd)/60;$prevEnd=max($prevEnd??0,$r['_end']);$lastEnd=max($lastEnd??0,$r['_end']);}
    if($lastEnd!==null&&$lastEnd>$en)$overtimeMinutes+=($lastEnd-$en)/60;
  }
 }catch(Throwable $e){$queryError=trim($queryError.' '.$e->getMessage());}
}
$utilization=$scheduledMinutes>0?($serviceMinutes/$scheduledMinutes)*100:null;

// Arm-specific comparison is intentionally not inferred from appointment status.
// It requires explicit prospective assignment records from the migration table.
$arms=array(
 'STATIC'=>array('label'=>'Existing / Static Scheduling','waits'=>array(),'cancelled'=>0,'rescheduled'=>0,'shown'=>0,'accepted'=>0,'acceptance'=>null,'assignments'=>0),
 'FUZZY_ONLY'=>array('label'=>'Fuzzy-only','waits'=>array(),'cancelled'=>0,'rescheduled'=>0,'shown'=>0,'accepted'=>0,'acceptance'=>null,'assignments'=>0),
 'ADABOOST'=>array('label'=>'AdaBoost-based Scheduling','waits'=>array(),'cancelled'=>0,'rescheduled'=>0,'shown'=>0,'accepted'=>0,'acceptance'=>null,'assignments'=>0),
 'HYBRID'=>array('label'=>'Hybrid AdaBoost–Fuzzy','waits'=>array(),'cancelled'=>0,'rescheduled'=>0,'shown'=>0,'accepted'=>0,'acceptance'=>null,'assignments'=>0)
);
$assignmentCount=0;$armQueryReady=false;
if($hasExperimentTable&&$visitReady){
 try{
  $assignments=hms_fetch_all($con,"SELECT e.visit_id,e.experiment_arm,e.recommendation_shown,e.recommendation_accepted,v.arrived_at,v.served_at,v.status, a.status AS appointment_status,a.reschedule_reason FROM hms_scheduling_evaluation e LEFT JOIN hms_patient_visits v ON v.id=e.visit_id LEFT JOIN appointment a ON a.id=COALESCE(e.appointment_id,v.appointment_id) WHERE v.visit_date BETWEEN ? AND ?",'ss',array($from,$to));
  $armQueryReady=true;
  foreach($assignments as $a){$arm=$a['experiment_arm'];if(!isset($arms[$arm]))continue;$assignmentCount++;$arms[$arm]['assignments']++;$w=null;if(!empty($a['arrived_at'])&&!empty($a['served_at'])){$x=strtotime($a['arrived_at']);$y=strtotime($a['served_at']);if($x!==false&&$y!==false&&$y>=$x&&($y-$x)<=86400)$w=($y-$x)/60;}if($w!==null)$arms[$arm]['waits'][]=$w;
   if(($a['status']??'')==='BATAL'||($a['appointment_status']??'')==='Cancelled')$arms[$arm]['cancelled']++;
   if(!empty($a['reschedule_reason']))$arms[$arm]['rescheduled']++;
   if((int)$a['recommendation_shown']===1){$arms[$arm]['shown']++;if((int)$a['recommendation_accepted']===1)$arms[$arm]['accepted']++;}
  }
  foreach($arms as &$armData){$armData['acceptance']=$armData['shown']>0?100*$armData['accepted']/$armData['shown']:null;$armData['median']=null;$armData['p90']=null;$arr=$armData['waits'];sort($arr);$nn=count($arr);if($nn){$mi=(int)floor(($nn-1)/2);$armData['median']=($nn%2)?$arr[$mi]:($arr[$mi]+$arr[$mi+1])/2;$armData['p90']=$arr[(int)ceil(.90*$nn)-1];}}
  unset($armData);
 }catch(Throwable $e){$armQueryReady=false;$queryError=trim($queryError.' '.$e->getMessage());}
}

hms_layout_header('M7 — Evaluation & Ablation','admin','operations');
?>
<div class="hms-page-title"><div><h1>M7 — Evaluation & Ablation</h1><div class="text-muted">Evaluasi outcome operasional dan perbandingan empat pendekatan appointment scheduling.</div></div><a class="btn btn-outline-secondary" href="operations_dashboard.php"><i class="bi bi-arrow-left"></i> Kembali ke Modul Pelayanan</a></div>
<!--<div class="alert alert-info"><strong>Outcome utama:</strong> in-clinic waiting time = service_started_at − checked_in_at. Pada skema hms.sql yang diperiksa, padanan kolom aktual adalah <code>served_at - arrived_at</code> pada <code>hms_patient_visits</code>. Perhitungan hanya memakai pasangan timestamp valid dan tidak mengubah data sumber.</div>
-->
<form class="hms-card p-3 mb-3" method="get"><div class="row g-3 align-items-end"><div class="col-md-3"><label class="form-label">Tanggal awal</label><input class="form-control" type="date" name="from" value="<?php echo m7_e($from);?>"></div><div class="col-md-3"><label class="form-label">Tanggal akhir</label><input class="form-control" type="date" name="to" value="<?php echo m7_e($to);?>"></div><div class="col-md-3"><button class="btn btn-primary">Terapkan filter</button> <a class="btn btn-outline-secondary" href="m7-evaluation.php">Reset</a></div></div></form>
<?php if($queryError){?><div class="alert alert-danger">Pemeriksaan query: <?php echo m7_e($queryError);?></div><?php }?>
<!--<div class="hms-card p-3 mb-3"><h2 class="h5">Pemeriksaan sumber data</h2><div class="table-responsive"><table class="table table-sm align-middle"><tbody>
<?php foreach($tableStatus as $t=>$ok){?><tr><th><?php echo m7_e($t);?></th><td><?php echo $ok?'<span class="badge text-bg-success">Ditemukan</span>':'<span class="badge text-bg-danger">Tidak ditemukan</span>';?></td></tr><?php }?>
<tr><th>Tabel penugasan eksperimen <code>hms_scheduling_evaluation</code></th><td><?php echo $hasExperimentTable?'<span class="badge text-bg-success">Ditemukan</span>':'<span class="badge text-bg-warning">Belum dibuat — perlu migrasi</span>';?></td></tr>
<tr><th>Kolom timestamp outcome</th><td><?php echo $visitReady?'<span class="badge text-bg-success">arrived_at dan served_at tersedia</span>':'<span class="badge text-bg-danger">Kolom kunjungan tidak lengkap</span>';?></td></tr>
</tbody></table><p class="small text-muted mb-0">Pemetaan timestamp ini mengikuti nama kolom yang benar-benar tersedia pada hms.sql. Untuk implementasi berikutnya, nama service_started_at dan checked_in_at dapat dipertahankan sebagai istilah konseptual dalam laporan penelitian.</p></div></div>
<h2 class="h5 mb-3">Outcome utama — In-clinic waiting time</h2><div class="row g-3 mb-3">
<?php $tiles=array(array('Jumlah observasi valid',$n,'bi-clipboard-check'),array('Mean waiting time',$mean===null?'—':m7_fmt($mean).' menit','bi-hourglass'),array('Median waiting time',$median===null?'—':m7_fmt($median).' menit','bi-stopwatch'),array('P90 waiting time',$p90===null?'—':m7_fmt($p90).' menit','bi-speedometer2'));foreach($tiles as $t){?><div class="col-6 col-xl-3"><div class="hms-card hms-stat"><span class="icon"><i class="bi <?php echo $t[2];?>"></i></span><div class="value fs-3"><?php echo m7_e($t[1]);?></div><div class="label"><?php echo m7_e($t[0]);?></div></div></div><?php }?>
</div>-->
<h2 class="h5 mb-3">Perbandingan / ablation empat pendekatan</h2><div class="hms-card p-3 mb-3"><p class="small text-muted">Angka per arm hanya ditampilkan dari assignment eksperimen eksplisit. Sistem tidak menganggap seluruh appointment historis sebagai static, dan tidak mengarang label Fuzzy-only, AdaBoost, atau Hybrid.</p><div class="table-responsive"><table class="table table-striped align-middle"><thead><tr><th>Metode</th><th>Assignment</th><th>Valid waiting time</th><th>Median (menit)</th><th>P90 (menit)</th><th>Cancellation</th><th>Reschedule</th><th>Acceptance</th></tr></thead><tbody>
<?php foreach($arms as $code=>$a){?><tr><td><strong><?php echo m7_e($a['label']);?></strong></td><td><?php echo $hasExperimentTable&&$armQueryReady?$a['assignments']:'—';?></td><td><?php echo $hasExperimentTable&&$armQueryReady?count($a['waits']):'—';?></td><td><?php echo $hasExperimentTable&&$armQueryReady?m7_fmt($a['median']):'—';?></td><td><?php echo $hasExperimentTable&&$armQueryReady?m7_fmt($a['p90']):'—';?></td><td><?php echo $hasExperimentTable&&$armQueryReady?$a['cancelled']:'—';?></td><td><?php echo $hasExperimentTable&&$armQueryReady?$a['rescheduled']:'—';?></td><td><?php echo $hasExperimentTable&&$armQueryReady?($a['acceptance']===null?'—':m7_fmt($a['acceptance']).'%'):'—';?></td></tr><?php }?>
</tbody></table></div><?php if(!$hasExperimentTable){?><div class="alert alert-warning mb-0"><strong>Perbandingan per metode belum dapat dihitung.</strong> Jalankan migrasi <code>tools/sql/m7_evaluation_schema.sql</code>, lalu catat arm eksperimen untuk setiap kunjungan prospektif. Data historis tanpa label metode tidak boleh diklasifikasikan secara retrospektif sebagai Fuzzy-only, AdaBoost, atau Hybrid.</div><?php }elseif(!$armQueryReady){?><div class="alert alert-warning mb-0">Tabel assignment tersedia, tetapi pembacaan data eksperimen belum berhasil. Periksa relasi visit_id dan appointment_id.</div><?php }elseif($assignmentCount===0){?><div class="alert alert-secondary mb-0">Belum ada assignment eksperimen pada rentang tanggal ini.</div><?php }?></div>
<h2 class="h5 mb-3">Outcome tambahan — operasional klinik</h2><div class="row g-3 mb-3">
<?php $secondary=array(array('Physician idle time',m7_fmt($idleMinutes).' menit','bi-pause-circle'),array('Overtime',m7_fmt($overtimeMinutes).' menit','bi-clock-history'),array('Slot utilization',$utilization===null?'—':m7_fmt($utilization).'%','bi-speedometer'),array('Cancellation',$cancelled,'bi-calendar-x'),array('Reschedule',$rescheduled,'bi-calendar2-week'),array('Recommendation acceptance',$hasExperimentTable&&$armQueryReady?'Per arm':'Belum tercatat','bi-hand-thumbs-up'));foreach($secondary as $t){?><div class="col-6 col-md-4"><div class="hms-card hms-stat"><span class="icon"><i class="bi <?php echo $t[2];?>"></i></span><div class="value fs-4"><?php echo m7_e($t[1]);?></div><div class="label"><?php echo m7_e($t[0]);?></div></div></div><?php }?>
</div>
<div class="hms-card p-3 mb-3"><h2 class="h5">Definisi operasional dan keterbatasan pengukuran</h2><div class="table-responsive"><table class="table table-sm"><thead><tr><th>Outcome</th><th>Definisi / sumber</th><th>Status</th></tr></thead><tbody>
<tr><td>In-clinic waiting time</td><td><code>arrived_at</code> sampai <code>served_at</code>; dipetakan ke checked_in_at sampai service_started_at.</td><td>Terukur bila kedua timestamp valid.</td></tr>
<tr><td>Median dan P90</td><td>Persentil dari observasi waiting time valid pada rentang tanggal.</td><td><?php echo $n?'Dihitung':'Belum ada observasi valid';?></td></tr>
<tr><td>Physician idle time</td><td>Jeda antara selesai satu pelayanan dan mulai pelayanan berikutnya pada dokter/tanggal yang sama; estimasi dari completed_at dan served_at.</td><td>Estimasi, bergantung kelengkapan timestamp dan jadwal.</td></tr>
<tr><td>Overtime</td><td>Waktu selesai pelayanan terakhir melewati end_time jadwal dokter.</td><td>Estimasi per dokter-hari.</td></tr>
<tr><td>Slot utilization</td><td>Total menit pelayanan aktual dibagi total menit jadwal aktif.</td><td>Estimasi; dapat melebihi 100% bila overtime.</td></tr>
<tr><td>Cancellation / reschedule</td><td>Status kunjungan BATAL atau appointment Cancelled; reschedule_reason pada appointment.</td><td>Histori hanya terukur jika dicatat pada sumber.</td></tr>
<tr><td>Recommendation acceptance</td><td>recommendation_accepted / recommendation_shown dari tabel assignment eksperimen.</td><td>Memerlukan pencatatan prospektif.</td></tr>
</tbody></table></div><div class="alert alert-info mb-0"><strong>Catatan validitas:</strong> physician idle time dan slot utilization pada halaman ini merupakan estimasi agregat dari timestamp dan jadwal yang tersedia. Untuk analisis kausal per kelompok, unit eksperimen sebaiknya ditetapkan sejak awal (misalnya pasien atau dokter-hari) dan assignment tidak boleh berubah di tengah periode. Jangan menyimpulkan satu metode lebih baik tanpa jumlah observasi memadai dan rancangan pembanding yang seimbang.</div></div>
<?php hms_layout_footer(); ?>
