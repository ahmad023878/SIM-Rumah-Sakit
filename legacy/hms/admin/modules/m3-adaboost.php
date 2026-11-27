<?php
// M3 AdaBoost Regression: audit, profiling, actual-data export, and evaluation.
session();
include('../include/config.php');
require_once __DIR__ . '/module_bootstrap.php';
hms_module_require_roles(array('admin'));

if (!function_exists('m3_e')) {
    function m3_e($v) { return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8'); }
}
$projectRoot = dirname(__DIR__, 2); // root aplikasi hms; tools/ml berada di dalam root ini.
$from = isset($_GET['from']) && preg_match('/^\d{4}-\d{2}-\d{2}$/', $_GET['from']) ? $_GET['from'] : date('Y-m-01');
$to = isset($_GET['to']) && preg_match('/^\d{4}-\d{2}-\d{2}$/', $_GET['to']) ? $_GET['to'] : date('Y-m-d');
if ($from > $to) { $tmp = $from; $from = $to; $to = $tmp; }
$action = isset($_GET['action']) ? $_GET['action'] : '';

$baseWhere = "v.visit_type='RAWAT_JALAN' AND v.status<>'BATAL' AND v.visit_date BETWEEN ? AND ?";
$params = array($from, $to);
$types = 'ss';

// Read-only data quality audit. No timestamp or source row is modified.
$quality = hms_fetch_one($con,
 "SELECT COUNT(*) AS total_visits,
  SUM(v.served_at IS NULL) AS missing_start,
  SUM(v.served_at IS NOT NULL AND v.completed_at IS NULL) AS missing_end,
  SUM(v.served_at IS NULL AND v.completed_at IS NOT NULL) AS end_without_start,
  SUM(v.served_at IS NOT NULL AND v.completed_at IS NOT NULL AND v.completed_at<=v.served_at) AS invalid_order,
  SUM(v.served_at IS NOT NULL AND v.completed_at IS NOT NULL AND v.completed_at>v.served_at
      AND TIMESTAMPDIFF(SECOND,v.served_at,v.completed_at)>86400) AS over_24h,
  SUM(v.served_at IS NOT NULL AND v.completed_at IS NOT NULL AND v.completed_at>v.served_at
      AND TIMESTAMPDIFF(SECOND,v.served_at,v.completed_at)<=86400) AS valid_duration
  FROM hms_patient_visits v WHERE $baseWhere", $types, $params);

$validRows = hms_fetch_all($con,
 "SELECT v.id AS visit_id,v.visit_date,v.poli,v.doctor_id,v.source,v.queue_no,v.created_at,
         v.served_at,v.completed_at,
         HOUR(v.created_at) AS registration_hour,
         WEEKDAY(v.visit_date)+1 AS weekday,
         MONTH(v.visit_date) AS month,
         (SELECT COUNT(*) FROM hms_patient_visits q
            WHERE q.visit_type='RAWAT_JALAN' AND q.status<>'BATAL'
              AND q.visit_date=v.visit_date AND q.poli <=> v.poli
              AND q.created_at < v.created_at
              AND (q.served_at IS NULL OR q.served_at > v.created_at)) AS queue_ahead_count,
         (SELECT ds.slot_duration_minutes FROM hms_doctor_schedules ds
            WHERE ds.doctor_id=v.doctor_id AND ds.is_active=1
              AND DATE(ds.available_date)=v.visit_date
            ORDER BY ds.available_date DESC,ds.id DESC LIMIT 1) AS slot_duration_minutes,
         TIMESTAMPDIFF(SECOND,v.served_at,v.completed_at)/60 AS service_duration_minutes
  FROM hms_patient_visits v
  WHERE $baseWhere AND v.served_at IS NOT NULL AND v.completed_at IS NOT NULL
    AND v.completed_at>v.served_at
    AND TIMESTAMPDIFF(SECOND,v.served_at,v.completed_at)<=86400
  ORDER BY v.visit_date ASC,v.served_at ASC,v.id ASC",
 $types, $params);

$issues = hms_fetch_all($con,
 "SELECT v.id,v.visit_date,v.registration_no,v.poli,v.status,v.served_at,v.completed_at,
  CASE
   WHEN v.served_at IS NULL AND v.completed_at IS NOT NULL THEN 'SELESAI TANPA WAKTU MULAI'
   WHEN v.served_at IS NULL THEN 'WAKTU MULAI KOSONG'
   WHEN v.completed_at IS NULL THEN 'WAKTU SELESAI KOSONG'
   WHEN v.completed_at<=v.served_at THEN 'URUTAN WAKTU TIDAK VALID'
   WHEN TIMESTAMPDIFF(SECOND,v.served_at,v.completed_at)>86400 THEN 'DURASI LEBIH DARI 24 JAM'
   ELSE 'VALID'
  END AS quality_status,
  CASE WHEN v.served_at IS NOT NULL AND v.completed_at IS NOT NULL
       THEN ROUND(TIMESTAMPDIFF(SECOND,v.served_at,v.completed_at)/60,2) END AS duration_minutes
  FROM hms_patient_visits v
  WHERE $baseWhere AND (
    v.served_at IS NULL OR v.completed_at IS NULL OR v.completed_at<=v.served_at OR
    (v.served_at IS NOT NULL AND v.completed_at IS NOT NULL AND TIMESTAMPDIFF(SECOND,v.served_at,v.completed_at)>86400)
  )
  ORDER BY v.visit_date DESC,v.id DESC LIMIT 200",
 $types, $params);

$durations = array();
foreach ($validRows as $r) $durations[] = (float)$r['service_duration_minutes'];
sort($durations);
$n = count($durations);
$mean = $n ? array_sum($durations)/$n : null;
$median = null;
if ($n) {
    $mid = (int)floor($n/2);
    $median = ($n % 2) ? $durations[$mid] : (($durations[$mid-1]+$durations[$mid])/2);
}
$profile = array(
 'valid_rows'=>$n, 'mean_minutes'=>$mean, 'median_minutes'=>$median,
 'min_minutes'=>$n ? min($durations) : null, 'max_minutes'=>$n ? max($durations) : null
);

if ($action === 'csv') {
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename="m3_service_duration_actual.csv"');
    $out = fopen('php://output', 'w');
    fprintf($out, chr(0xEF).chr(0xBB).chr(0xBF));
    fputcsv($out, array('visit_id','visit_date','poli','doctor_id','source','registration_hour','weekday','month','queue_ahead_count','slot_duration_minutes','service_duration_minutes'));
    foreach ($validRows as $r) {
        $created = !empty($r['created_at']) ? strtotime($r['created_at']) : false;
        $dateTs = strtotime($r['visit_date']);
        $row = array(
            (int)$r['visit_id'], $r['visit_date'], $r['poli'],
            $r['doctor_id'] === null ? '' : (int)$r['doctor_id'],
            $r['source'],
            $created ? (int)date('G', $created) : '',
            $dateTs ? (int)date('N', $dateTs) : '',
            $dateTs ? (int)date('n', $dateTs) : '',
            (int)($r['queue_ahead_count'] ?? 0),
            $r['slot_duration_minutes'] === null ? '' : (int)$r['slot_duration_minutes'],
            round((float)$r['service_duration_minutes'], 4)
        );
        // Prevent spreadsheet formula injection in text cells.
        foreach ($row as $k=>$v) if (is_string($v) && preg_match('/^[=+\-@]/', $v)) $row[$k] = "'".$v;
        fputcsv($out, $row);
    }
    fclose($out);
    exit;
}

$metricsFile = $projectRoot . '/tools/ml/output/m3_model_metrics.json';
$profileFile = $projectRoot . '/tools/ml/output/m3_data_profile.json';
$metrics = is_file($metricsFile) ? json_decode(file_get_contents($metricsFile), true) : null;
$pythonProfile = is_file($profileFile) ? json_decode(file_get_contents($profileFile), true) : null;

hms_layout_header('M3 AdaBoost Regression','admin','operations');
?>
<div class="hms-page-title">
 <div><h1>M3 — AdaBoost Regression</h1><div class="text-muted">Audit data aktual, instrumentasi durasi pelayanan, profiling, training dan evaluasi model.</div></div>
 <a class="btn btn-outline-secondary" href="operations_dashboard.php"><i class="bi bi-arrow-left me-1"></i>Kembali ke Modul Pelayanan</a>
</div>

<!-- <div class="alert alert-info">
 <strong>Target penelitian:</strong> service duration = <code>completed_at − served_at</code>, dalam menit.
 Audit bersifat baca-saja. Data sumber SIMRS tidak diubah atau dihapus.
</div>-->

<div class="hms-card p-3 mb-3">
 <form method="get" class="row g-2 align-items-end">
  <div class="col-md-3"><label class="form-label">Tanggal awal</label><input class="form-control" type="date" name="from" value="<?php echo m3_e($from); ?>"></div>
  <div class="col-md-3"><label class="form-label">Tanggal akhir</label><input class="form-control" type="date" name="to" value="<?php echo m3_e($to); ?>"></div>
  <div class="col-md-3"><button class="btn btn-primary">Terapkan filter</button> <a class="btn btn-outline-secondary" href="m3-adaboost.php">Reset</a></div>
  <div class="col-md-3"><a class="btn btn-success" href="m3-adaboost.php?action=csv&amp;from=<?php echo m3_e($from); ?>&amp;to=<?php echo m3_e($to); ?>"><i class="bi bi-download me-1"></i>Unduh dataset aktual</a></div>
 </form>
</div>

<h2 class="h5 mb-3">M3.1 — Audit kualitas data aktual</h2>
<div class="row g-3 mb-3">
<?php
$cards = array(
 array('Total kunjungan', (int)($quality['total_visits']??0), 'bi-clipboard-data','primary'),
 array('Durasi valid ≤ 24 jam', (int)($quality['valid_duration']??0), 'bi-check-circle','success'),
 array('Waktu mulai kosong', (int)($quality['missing_start']??0), 'bi-hourglass','warning'),
 array('Waktu selesai kosong', (int)($quality['missing_end']??0), 'bi-clock','warning'),
 array('Selesai tanpa mulai', (int)($quality['end_without_start']??0), 'bi-exclamation-circle','danger'),
 array('Urutan waktu tidak valid', (int)($quality['invalid_order']??0), 'bi-arrow-left-right','danger'),
 array('Durasi > 24 jam', (int)($quality['over_24h']??0), 'bi-alarm','warning')
);
foreach($cards as $c){ ?>
<div class="col-6 col-md-4 col-xl-3"><div class="hms-card hms-stat p-3"><span class="icon"><i class="bi <?php echo m3_e($c[2]); ?>"></i></span><div class="value"><?php echo m3_e($c[1]); ?></div><div class="label"><?php echo m3_e($c[0]); ?></div></div></div>
<?php } ?>
</div>

<div class="hms-card p-3 mb-3">
 <h2 class="h5">Daftar data yang perlu ditinjau</h2>
 <p class="small text-muted">Daftar ini tidak mengubah rekam kunjungan. Untuk kasus durasi panjang, periksa riwayat pelayanan sebelum menentukan apakah pencatatan perlu dikoreksi melalui prosedur resmi.</p>
 <div class="table-responsive"><table class="table table-sm table-hover">
 <thead><tr><th>ID</th><th>Tanggal</th><th>Registrasi</th><th>Poli</th><th>Status</th><th>Mulai</th><th>Selesai</th><th>Durasi menit</th><th>Hasil audit</th></tr></thead><tbody>
 <?php if(!$issues){ ?><tr><td colspan="9" class="text-center text-muted">Tidak ditemukan masalah timestamp pada rentang tanggal ini.</td></tr><?php } ?>
 <?php foreach($issues as $r){ ?><tr><td><?php echo (int)$r['id']; ?></td><td><?php echo m3_e($r['visit_date']); ?></td><td><?php echo m3_e($r['registration_no']); ?></td><td><?php echo m3_e($r['poli']); ?></td><td><?php echo m3_e($r['status']); ?></td><td><?php echo m3_e($r['served_at']?:'—'); ?></td><td><?php echo m3_e($r['completed_at']?:'—'); ?></td><td><?php echo $r['duration_minutes']===null?'—':number_format((float)$r['duration_minutes'],2,',','.'); ?></td><td><?php echo m3_e($r['quality_status']); ?></td></tr><?php } ?>
 </tbody></table></div>
</div>

<!--<h2 class="h5 mb-3">M3.2 — Instrumentasi waktu pelayanan</h2>
<div class="hms-card p-3 mb-3">
 <p class="mb-2">Pemeriksaan kode sumber menunjukkan alur dokter yang sudah ada mencatat:</p>
 <ul class="mb-2">
  <li><code>called_at</code> ketika dokter menekan Panggil.</li>
  <li><code>served_at</code> ketika dokter menekan Mulai Periksa.</li>
  <li><code>completed_at</code> ketika kunjungan diselesaikan setelah SOAP/RME tersimpan.</li>
 </ul>
 <p class="small text-muted mb-0">Pencatatan juga tersedia pada alur modul Rawat Jalan Admin. Timestamp menggunakan waktu database <code>NOW()</code> dan pola <code>COALESCE</code> agar waktu awal tidak ditimpa. Untuk data baru, gunakan alur Panggil → Mulai Periksa → Simpan SOAP/RME → Selesai. M2 tidak diubah.</p>
</div>-->

<h2 class="h5 mb-3">M3.3 — Data profiling dataset aktual</h2>
<div class="row g-3 mb-3">
<?php
$profileCards = array(
 array('Baris valid',$profile['valid_rows'],'bi-database-check'),
 array('Rata-rata durasi',$profile['mean_minutes']===null?'—':number_format($profile['mean_minutes'],2,',','.').' menit','bi-graph-up'),
 array('Median durasi',$profile['median_minutes']===null?'—':number_format($profile['median_minutes'],2,',','.').' menit','bi-bar-chart'),
 array('Durasi minimum',$profile['min_minutes']===null?'—':number_format($profile['min_minutes'],2,',','.').' menit','bi-arrow-down'),
 array('Durasi maksimum',$profile['max_minutes']===null?'—':number_format($profile['max_minutes'],2,',','.').' menit','bi-arrow-up')
);
foreach($profileCards as $c){ ?>
<div class="col-6 col-md-4 col-xl-3"><div class="hms-card hms-stat p-3"><span class="icon"><i class="bi <?php echo m3_e($c[2]); ?>"></i></span><div class="value"><?php echo m3_e($c[1]); ?></div><div class="label"><?php echo m3_e($c[0]); ?></div></div></div>
<?php } ?>
</div>

<?php if(is_array($pythonProfile)){ ?>
<div class="hms-card p-3 mb-3">
 <h2 class="h5">Hasil profiling preprocessing Python</h2>
 <div class="row g-2">
  <div class="col-md-3"><strong><?php echo (int)($pythonProfile['rows_before_cleaning']??0); ?></strong><div class="small text-muted">Baris sebelum cleaning</div></div>
  <div class="col-md-3"><strong><?php echo (int)($pythonProfile['rows_after_cleaning']??0); ?></strong><div class="small text-muted">Baris setelah cleaning</div></div>
  <div class="col-md-3"><strong><?php echo m3_e($pythonProfile['target_summary']['median']??'—'); ?></strong><div class="small text-muted">Median durasi (menit)</div></div>
  <div class="col-md-3"><strong><?php echo m3_e($pythonProfile['generated_at']??'—'); ?></strong><div class="small text-muted">Waktu profiling</div></div>
 </div>
 <p class="small text-muted mt-2 mb-0">Profiling berasal dari dataset CSV aktual terakhir yang diproses. Ekspor ulang dan jalankan script kembali setelah rentang tanggal berubah.</p>
</div>
<?php } ?>
<!--ass="hms-card p-3 mb-3">
 <h2 class="h5">Variabel penelitian dan pencegahan data leakage</h2>
 <div class="table-responsive"><table class="table table-sm table-striped">
 <thead><tr><th>Variabel</th><th>Sumber database</th><th>Peran</th><th>Penjelasan</th></tr></thead><tbody>
 <tr><td>poli</td><td>hms_patient_visits.poli</td><td>Predictor kategorikal</td><td>Poliklinik yang ditetapkan sebelum pelayanan</td></tr>
 <tr><td>doctor_id</td><td>hms_patient_visits.doctor_id</td><td>Predictor kategorikal</td><td>Dokter yang ditetapkan sebelum pelayanan</td></tr>
 <tr><td>source</td><td>hms_patient_visits.source</td><td>Predictor kategorikal</td><td>ONLINE / OFFLINE</td></tr>
 <tr><td>registration_hour</td><td>HOUR(created_at)</td><td>Predictor numerik</td><td>Jam pendaftaran</td></tr>
 <tr><td>weekday, month</td><td>visit_date</td><td>Predictor numerik</td><td>Hari dan bulan kunjungan</td></tr>
 <tr><td>queue_ahead_count</td><td>Hitung kunjungan poli/tanggal yang mendaftar lebih dahulu dan belum mulai dilayani</td><td>Predictor numerik</td><td>Estimasi antrean di waktu pendaftaran</td></tr>
 <tr><td>slot_duration_minutes</td><td>hms_doctor_schedules.slot_duration_minutes</td><td>Predictor numerik</td><td>Durasi slot jadwal aktif; nilai kosong diimputasi saat preprocessing</td></tr>
 <tr><td>service_duration_minutes</td><td>completed_at − served_at</td><td><strong>Target Y</strong></td><td>Durasi aktual pelayanan dalam menit</td></tr>
 </tbody></table></div>
 <p class="small text-muted mb-0">ID kunjungan hanya sebagai referensi baris, bukan fitur. patient_id, diagnosis, status akhir, served_at, completed_at, dan target durasi tidak digunakan sebagai predictor. Seluruh fitur dipilih agar tersedia sebelum pelayanan dimulai.</p>
</div>
-->
<div class="hms-card p-3 mb-3">
 <h2 class="h5">Dataset aktual</h2>
 <p class="small text-muted">Menampilkan 100 baris pertama dari data valid. Data lebih dari 24 jam tetap ada di database sumber, tetapi tidak masuk dataset analitik awal sampai ditinjau.</p>
 <div class="table-responsive"><table class="table table-sm table-hover">
 <thead><tr><th>ID</th><th>Tanggal</th><th>Poli</th><th>Dokter</th><th>Sumber</th><th>Antrean</th><th>Mulai</th><th>Selesai</th><th>Durasi menit</th></tr></thead><tbody>
 <?php if(!$validRows){ ?><tr><td colspan="9" class="text-center text-muted">Belum ada durasi pelayanan valid pada rentang tanggal ini. Lengkapi alur pencatatan pelayanan aktual terlebih dahulu.</td></tr><?php } ?>
 <?php foreach(array_slice($validRows,0,100) as $r){ ?><tr><td><?php echo (int)$r['visit_id']; ?></td><td><?php echo m3_e($r['visit_date']); ?></td><td><?php echo m3_e($r['poli']); ?></td><td><?php echo m3_e($r['doctor_id']); ?></td><td><?php echo m3_e($r['source']); ?></td><td><?php echo m3_e($r['queue_no']); ?></td><td><?php echo m3_e($r['served_at']); ?></td><td><?php echo m3_e($r['completed_at']); ?></td><td><?php echo number_format((float)$r['service_duration_minutes'],2,',','.'); ?></td></tr><?php } ?>
 </tbody></table></div>
</div>

<h2 class="h5 mb-3">M3.4–M3.6 — Preprocessing, training, benchmark, dan evaluasi</h2>
<div class="hms-card p-3 mb-3">
 <p><strong>Alur eksperimen:</strong> dataset aktual → pembersihan target dan fitur → imputasi numerik median → imputasi kategorikal dan One-Hot Encoding → chronological train/test split 80:20 → benchmark tiga model → TimeSeriesSplit.</p>
 <ol>
  <li>Unduh dataset aktual melalui tombol <strong>Unduh dataset aktual</strong> di bagian atas.</li>
  <li>Simpan CSV sebagai <code>tools/ml/data/m3_service_duration_dataset.csv</code> di root aplikasi.</li>
  <li>Jalankan <code>python -m pip install -r tools/ml/requirements.txt</code>.</li>
  <li>Jalankan <code>python tools/ml/train_m3_adaboost.py</code> dari root aplikasi.</li>
  <li>Refresh halaman ini untuk melihat hasil benchmark dan grafik.</li>
 </ol>
 <p class="small text-muted">Script menetapkan minimum 20 observasi valid untuk eksperimen awal. Jika data belum cukup, hanya profiling yang dilaporkan dan model tidak dilatih. Ini mencegah metrik yang tidak dapat dipertanggungjawabkan.</p>
 <?php if(is_array($metrics) && !empty($metrics['status']) && $metrics['status']==='trained'){ ?>
 <div class="alert alert-success">Eksperimen berhasil dijalankan. Data latih: <?php echo (int)($metrics['train_samples']??0); ?>; data uji: <?php echo (int)($metrics['test_samples']??0); ?>. Pembagian: chronological 80:20.</div>
 <p><strong>Model dengan MAE data uji terendah:</strong> <?php echo m3_e($metrics['best_model_by_holdout_MAE']??'Belum ditentukan'); ?>. <?php echo m3_e($metrics['best_model_note']??''); ?></p>
 <div class="table-responsive"><table class="table table-sm table-bordered"><thead><tr><th>Model</th><th>MAE (menit) ↓</th><th>RMSE (menit) ↓</th><th>R² ↑</th></tr></thead><tbody>
 <?php foreach(($metrics['models']??array()) as $name=>$m){ ?><tr><td><?php echo m3_e($name); ?></td><td><?php echo number_format((float)$m['MAE'],3); ?></td><td><?php echo number_format((float)$m['RMSE'],3); ?></td><td><?php echo $m['R2']===null?'N/A':number_format((float)$m['R2'],3); ?></td></tr><?php } ?>
 </tbody></table></div>
 <?php if(!empty($metrics['cross_validation'])){ ?><h3 class="h6 mt-3">Validasi silang kronologis — TimeSeriesSplit (MAE)</h3><div class="table-responsive"><table class="table table-sm"><thead><tr><th>Model</th><th>Rata-rata MAE</th><th>Standar deviasi</th></tr></thead><tbody><?php foreach($metrics['cross_validation'] as $name=>$m){ ?><tr><td><?php echo m3_e($name); ?></td><td><?php echo number_format((float)$m['TimeSeriesSplit_MAE_mean'],3); ?></td><td><?php echo number_format((float)$m['TimeSeriesSplit_MAE_std'],3); ?></td></tr><?php } ?></tbody></table></div><?php } ?>
 <div class="row g-3 mt-2">
  <?php $m3ChartCount = 0; foreach(array('m3_model_comparison.png'=>'Perbandingan MAE dan RMSE','m3_actual_vs_predicted.png'=>'Aktual vs prediksi') as $img=>$label){ $imgPath=$projectRoot.'/tools/ml/output/'.$img; if(is_file($imgPath)){ $m3ChartCount++; ?>
   <div class="col-lg-6"><div class="border rounded p-2"><strong><?php echo m3_e($label); ?></strong><img class="img-fluid mt-2" src="../../tools/ml/output/<?php echo m3_e($img); ?>?v=<?php echo (int)@filemtime($imgPath); ?>" alt="<?php echo m3_e($label); ?>"></div></div>
  <?php }} if($m3ChartCount===0){ ?>
   <div class="col-12"><div class="alert alert-info mb-0"><strong>Grafik belum tersedia.</strong> Grafik regresi baru dibuat setelah script training berhasil dijalankan dengan data yang mencukupi. Data aktual pada filter saat ini belum memenuhi syarat eksperimen; jangan menggunakan grafik/angka contoh dari luar dataset SIMRS sebagai hasil penelitian.</div></div>
  <?php } ?>
 </div>
 <p class="small text-muted mt-2 mb-0">Waktu training: <?php echo m3_e($metrics['generated_at']??'-'); ?>. Nilai MAE/RMSE lebih kecil lebih baik; R² lebih besar lebih baik. Hasil terbaik ditentukan dari data uji, bukan diasumsikan AdaBoost.</p>
 <?php } elseif(is_array($metrics) && !empty($metrics['status'])) { ?>
 <div class="alert alert-warning mb-0"><?php echo m3_e($metrics['message']??'Model belum dapat dilatih.'); ?><?php if(isset($metrics['sample_count'])){ ?> Jumlah sampel valid: <strong><?php echo (int)$metrics['sample_count']; ?></strong>.<?php } ?></div>
 <?php } else { ?>
 <div class="alert alert-warning mb-0">Belum ada hasil eksperimen. Ekspor dataset aktual, jalankan script Python, lalu refresh halaman ini.</div>
 <?php } ?>
</div>
<?php hms_layout_footer(); ?>
