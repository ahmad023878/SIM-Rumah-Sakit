<?php
/**
 * Pengujian Fuzzy Mamdani berbasis data operasional SIMRS.
 * Read-only: tidak mengubah antrean, jadwal, kunjungan, atau data klinis.
 */
session();
include('../include/config.php');
require_once __DIR__ . '/module_bootstrap.php';
hms_module_require_roles(array('admin'));

if (!function_exists('hms_fuzzy_e')) {
    function hms_fuzzy_e($value) { return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8'); }
}
if (!function_exists('hms_fuzzy_clamp')) {
    function hms_fuzzy_clamp($v, $min, $max) { return max($min, min($max, (float)$v)); }
}
if (!function_exists('hms_fuzzy_tri')) {
    function hms_fuzzy_tri($x, $a, $b, $c) {
        if ($x < $a || $x > $c) return 0.0;
        if ($x == $b) return 1.0;
        if ($x < $b) return ($b == $a) ? 1.0 : max(0.0, ($x - $a) / ($b - $a));
        return ($c == $b) ? 1.0 : max(0.0, ($c - $x) / ($c - $b));
    }
}
if (!function_exists('hms_fuzzy_trap')) {
    function hms_fuzzy_trap($x, $a, $b, $c, $d) {
        if ($x < $a || $x > $d) return 0.0;
        if ($x >= $b && $x <= $c) return 1.0;
        if ($x < $b) return ($b == $a) ? 1.0 : max(0.0, ($x - $a) / ($b - $a));
        return ($d == $c) ? 1.0 : max(0.0, ($d - $x) / ($d - $c));
    }
}
if (!function_exists('hms_fuzzy_sets')) {
    function hms_fuzzy_sets($key, $x) {
        // Himpunan disusun dalam tingkat tekanan operasional: rendah, sedang, tinggi.
        switch ($key) {
            case 'duration': return array('rendah'=>hms_fuzzy_trap($x,0,0,15,35),'sedang'=>hms_fuzzy_tri($x,20,45,75),'tinggi'=>hms_fuzzy_trap($x,60,90,120,120));
            case 'queue': return array('rendah'=>hms_fuzzy_trap($x,0,0,4,10),'sedang'=>hms_fuzzy_tri($x,7,15,25),'tinggi'=>hms_fuzzy_trap($x,20,30,40,40));
            case 'utilization': return array('rendah'=>hms_fuzzy_trap($x,0,0,30,50),'sedang'=>hms_fuzzy_tri($x,35,55,75),'tinggi'=>hms_fuzzy_trap($x,65,85,100,100));
            case 'occupancy': return array('rendah'=>hms_fuzzy_trap($x,0,0,30,50),'sedang'=>hms_fuzzy_tri($x,35,55,75),'tinggi'=>hms_fuzzy_trap($x,65,85,100,100));
            // Availability dibalik: ketersediaan rendah berarti tekanan operasional tinggi.
            case 'availability': return array('rendah'=>hms_fuzzy_trap($x,60,80,100,100),'sedang'=>hms_fuzzy_tri($x,30,50,70),'tinggi'=>hms_fuzzy_trap($x,0,0,20,40));
            case 'delay': return array('rendah'=>hms_fuzzy_trap($x,0,0,20,50),'sedang'=>hms_fuzzy_tri($x,30,75,130),'tinggi'=>hms_fuzzy_trap($x,100,160,240,240));
        }
        return array('rendah'=>0.0,'sedang'=>0.0,'tinggi'=>0.0);
    }
}
if (!function_exists('hms_fuzzy_output_mu')) {
    function hms_fuzzy_output_mu($x, $set) {
        if ($set === 'rendah') return hms_fuzzy_trap($x,0,0,20,40);
        if ($set === 'sedang') return hms_fuzzy_tri($x,25,50,75);
        return hms_fuzzy_trap($x,60,80,100,100);
    }
}
if (!function_exists('hms_fuzzy_infer')) {
    function hms_fuzzy_infer($inputs) {
        $keys = array('duration','queue','utilization','occupancy','availability','delay');
        $sets = array();
        foreach ($keys as $key) $sets[$key] = hms_fuzzy_sets($key, $inputs[$key]);
        $names = array('rendah','sedang','tinggi');
        $severity = array('rendah'=>0,'sedang'=>1,'tinggi'=>2);
        $aggregated = array_fill(0,101,0.0);
        $active = 0;
        // Full 3^6 rule base (729 combinations). Consequent follows average pressure level.
        foreach ($names as $a) foreach ($names as $b) foreach ($names as $c)
        foreach ($names as $d) foreach ($names as $e) foreach ($names as $f) {
            $combo = array($a,$b,$c,$d,$e,$f);
            $alpha = min($sets['duration'][$a],$sets['queue'][$b],$sets['utilization'][$c],$sets['occupancy'][$d],$sets['availability'][$e],$sets['delay'][$f]);
            if ($alpha <= 0) continue;
            $active++;
            $avg = ($severity[$a]+$severity[$b]+$severity[$c]+$severity[$d]+$severity[$e]+$severity[$f])/6;
            $out = ($avg <= 0.65) ? 'rendah' : (($avg <= 1.35) ? 'sedang' : 'tinggi');
            for ($x=0;$x<=100;$x++) $aggregated[$x] = max($aggregated[$x], min($alpha,hms_fuzzy_output_mu($x,$out)));
        }
        $num=0.0; $den=0.0;
        foreach ($aggregated as $x=>$mu) { $num += $x*$mu; $den += $mu; }
        $crisp = $den > 0 ? $num/$den : 0.0;
        $category = $crisp < 40 ? 'Rendah' : ($crisp < 65 ? 'Sedang' : 'Tinggi');
        return array('degrees'=>$sets,'aggregated'=>$aggregated,'crisp'=>$crisp,'category'=>$category,'active_rules'=>$active);
    }
}

// Filters: date, clinic, and doctor. Queries below are read-only and use the uploaded HMS schema.
$selectedDate = isset($_GET['date']) && preg_match('/^\d{4}-\d{2}-\d{2}$/', $_GET['date']) ? $_GET['date'] : date('Y-m-d');
$doctorId = isset($_GET['doctor_id']) ? (int)$_GET['doctor_id'] : 0;
$poliId = isset($_GET['poli_id']) ? (int)$_GET['poli_id'] : 0;
$doctors = hms_fetch_all($con, "SELECT id, doctorName FROM doctors ORDER BY doctorName");
$polis = hms_fetch_all($con, "SELECT id, poli_name FROM hms_master_poli WHERE is_active=1 ORDER BY poli_name");
$selectedPoli = null;
foreach ($polis as $p) if ((int)$p['id'] === $poliId) { $selectedPoli = $p['poli_name']; break; }
if ($poliId > 0 && $selectedPoli === null) $poliId = 0;

// Remove duplicate schedule rows with the same doctor/date/time window before calculating capacity.
$scheduleSql = "SELECT ds.doctor_id, MAX(d.doctorName) AS doctor_name, DATE(ds.available_date) AS schedule_date,
                       ds.start_time, ds.end_time, MAX(ds.quota) AS quota,
                       MAX(ds.slot_duration_minutes) AS slot_duration_minutes
                FROM hms_doctor_schedules ds LEFT JOIN doctors d ON d.id=ds.doctor_id
                WHERE ds.is_active=1 AND DATE(ds.available_date)=?";
$scheduleTypes = 's'; $scheduleParams = array($selectedDate);
if ($doctorId > 0) { $scheduleSql .= " AND ds.doctor_id=?"; $scheduleTypes .= 'i'; $scheduleParams[] = $doctorId; }
if ($poliId > 0) { $scheduleSql .= " AND ds.poli_id=?"; $scheduleTypes .= 'i'; $scheduleParams[] = $poliId; }
$scheduleSql .= " GROUP BY ds.doctor_id, DATE(ds.available_date), ds.start_time, ds.end_time ORDER BY doctor_name, ds.start_time";
$schedules = hms_fetch_all($con, $scheduleSql, $scheduleTypes, $scheduleParams);
$totalQuota=0; $scheduledMinutes=0; $scheduleDoctors=array(); $slotDurations=array();
foreach ($schedules as $s) {
    $quota=(int)$s['quota']; $totalQuota += $quota;
    $start=strtotime($s['start_time']); $end=strtotime($s['end_time']);
    if ($start && $end && $end>$start) $scheduledMinutes += (int)(($end-$start)/60);
    $scheduleDoctors[(int)$s['doctor_id']] = true;
    if ((int)$s['slot_duration_minutes']>0) $slotDurations[]=(int)$s['slot_duration_minutes'];
}
$activeDoctorCount = count($scheduleDoctors);

$visitSql = "SELECT v.id,v.doctor_id,v.poli,v.status,v.created_at,v.called_at,v.served_at,v.completed_at,v.registration_no
             FROM hms_patient_visits v WHERE v.visit_date=? AND v.visit_type='RAWAT_JALAN'";
$visitTypes='s'; $visitParams=array($selectedDate);
if ($doctorId>0) { $visitSql .= " AND v.doctor_id=?"; $visitTypes.='i'; $visitParams[]=$doctorId; }
if ($selectedPoli!==null) { $visitSql .= " AND (v.poli=? OR v.poli LIKE CONCAT('%',?,'%'))"; $visitTypes.='ss'; $visitParams[]=$selectedPoli; $visitParams[]=$selectedPoli; }
$visits = hms_fetch_all($con, $visitSql, $visitTypes, $visitParams);
$queueCount=0; $bookedCount=0; $completedServiceMinutes=0; $activeServing=0;
foreach ($visits as $v) {
    if ($v['status'] !== 'BATAL') $bookedCount++;
    if (in_array($v['status'],array('MENUNGGU','DIPANGGIL'),true)) $queueCount++;
    if ($v['status']==='DILAYANI' && !empty($v['served_at']) && empty($v['completed_at'])) $activeServing++;
    if (!empty($v['served_at']) && !empty($v['completed_at'])) {
        $duration=(strtotime($v['completed_at'])-strtotime($v['served_at']))/60;
        if ($duration>0 && $duration<=240) $completedServiceMinutes += $duration;
    }
}

// Historical median duration: only plausible completed observations (1–240 minutes) are used.
$historyWhere = "visit_type='RAWAT_JALAN' AND served_at IS NOT NULL AND completed_at IS NOT NULL
                 AND completed_at>served_at AND TIMESTAMPDIFF(SECOND,served_at,completed_at) BETWEEN 60 AND 14400";
$historyTypes=''; $historyParams=array();
if ($doctorId>0) { $historyWhere .= " AND doctor_id=?"; $historyTypes.='i'; $historyParams[]=$doctorId; }
if ($selectedPoli!==null) { $historyWhere .= " AND (poli=? OR poli LIKE CONCAT('%',?,'%'))"; $historyTypes.='ss'; $historyParams[]=$selectedPoli; $historyParams[]=$selectedPoli; }
$historyRows = hms_fetch_all($con,
    "SELECT TIMESTAMPDIFF(SECOND,served_at,completed_at)/60 AS duration_minutes
     FROM hms_patient_visits WHERE $historyWhere
     ORDER BY duration_minutes ASC LIMIT 500", $historyTypes, $historyParams);
$historyDurations=array(); foreach($historyRows as $r) $historyDurations[]=(float)$r['duration_minutes'];
$durationSource='Median durasi aktual SIMRS sesuai filter (1–240 menit)';
// If the selected doctor/poli has no valid observations, fall back to the hospital-wide median.
if (!$historyDurations && ($doctorId>0 || $selectedPoli!==null)) {
    $historyRows = hms_fetch_all($con,
        "SELECT TIMESTAMPDIFF(SECOND,served_at,completed_at)/60 AS duration_minutes
         FROM hms_patient_visits
         WHERE visit_type='RAWAT_JALAN' AND served_at IS NOT NULL AND completed_at IS NOT NULL
           AND completed_at>served_at AND TIMESTAMPDIFF(SECOND,served_at,completed_at) BETWEEN 60 AND 14400
         ORDER BY duration_minutes ASC LIMIT 500");
    foreach($historyRows as $r) $historyDurations[]=(float)$r['duration_minutes'];
    if ($historyDurations) $durationSource='Fallback median durasi aktual seluruh poli/dokter (1–240 menit)';
}
sort($historyDurations); $historyCount=count($historyDurations);
if ($historyCount) {
    $mid=(int)floor($historyCount/2);
    $predictedDuration=($historyCount%2)?$historyDurations[$mid]:(($historyDurations[$mid-1]+$historyDurations[$mid])/2);
} elseif ($slotDurations) {
    sort($slotDurations); $predictedDuration=$slotDurations[(int)floor((count($slotDurations)-1)/2)];
    $durationSource='Fallback: median slot_duration_minutes dari jadwal aktif';
} else {
    $predictedDuration=30.0; $durationSource='Fallback konfigurasi 30 menit; belum ada durasi aktual/jadwal yang dapat digunakan';
}
$predictedDuration=hms_fuzzy_clamp($predictedDuration,0,120);
$doctorUtilization = $scheduledMinutes>0 ? (($completedServiceMinutes + $activeServing*$predictedDuration)/$scheduledMinutes)*100 : 0;
$doctorUtilization=hms_fuzzy_clamp($doctorUtilization,0,100);
$slotOccupancy = $totalQuota>0 ? ($bookedCount/$totalQuota)*100 : 0;
$slotOccupancy=hms_fuzzy_clamp($slotOccupancy,0,100);
$availability = $totalQuota>0 ? (max(0,$totalQuota-$bookedCount)/$totalQuota)*100 : 0;
$availability=hms_fuzzy_clamp($availability,0,100);
$estimatedDelay = $queueCount*$predictedDuration/max(1,$activeDoctorCount);
$estimatedDelay=hms_fuzzy_clamp($estimatedDelay,0,240);
$inputs=array(
    'duration'=>$predictedDuration,
    'queue'=>hms_fuzzy_clamp($queueCount,0,40),
    'utilization'=>$doctorUtilization,
    'occupancy'=>$slotOccupancy,
    'availability'=>$availability,
    'delay'=>$estimatedDelay
);
$fuzzy=hms_fuzzy_infer($inputs);

$recommendation = $fuzzy['category']==='Rendah'
    ? 'Beban operasional relatif terkendali. Pertahankan jadwal dan pantau perubahan antrean.'
    : ($fuzzy['category']==='Sedang'
        ? 'Perlu pemantauan. Tinjau distribusi slot, antrean, dan utilisasi dokter untuk mencegah penumpukan.'
        : 'Tekanan operasional tinggi. Evaluasi penambahan slot, redistribusi jadwal/dokter, atau penyesuaian kapasitas layanan.');
$inputLabels=array('Predicted service duration','Current queue/load','Doctor utilization','Slot occupancy','Availability','Estimated delay');
$normalized=array(
    round($inputs['duration']/120*100,2), round($inputs['queue']/40*100,2),
    round($inputs['utilization'],2), round($inputs['occupancy'],2),
    round($inputs['availability'],2), round($inputs['delay']/240*100,2)
);
$degreeRows=array();
foreach(array('duration','queue','utilization','occupancy','availability','delay') as $k) $degreeRows[$k]=$fuzzy['degrees'][$k];
$chartCurve=array_values($fuzzy['aggregated']);
$chartJsonFlags=JSON_HEX_TAG|JSON_HEX_APOS|JSON_HEX_AMP|JSON_HEX_QUOT;

hms_layout_header('Pengujian Fuzzy Mamdani','admin','operations');
?>
<div class="hms-page-title">
 <div><h1>Pengujian Fuzzy Mamdani</h1><div class="text-muted">Inferensi Mamdani berbasis antrean, durasi pelayanan, utilisasi dokter, dan kapasitas jadwal dari database SIMRS.</div></div>
 <a class="btn btn-outline-secondary" href="operations_dashboard.php"><i class="bi bi-arrow-left me-1"></i>Kembali ke Modul Pelayanan</a>
</div>
<!--<div class="alert alert-info"><strong>Mode baca-saja.</strong> Data diambil dari database SIMRS. Pengujian ini tidak mengubah data pasien, antrean, jadwal, maupun rekam medis. Output merupakan indeks tekanan operasional untuk membantu evaluasi, bukan keputusan klinis otomatis.</div>
-->
<div class="hms-card p-3 mb-3">
 <form method="get" class="row g-2 align-items-end">
  <div class="col-md-3"><label class="form-label">Tanggal operasional</label><input class="form-control" type="date" name="date" value="<?php echo hms_fuzzy_e($selectedDate); ?>"></div>
  <div class="col-md-3"><label class="form-label">Poli</label><select class="form-select" name="poli_id"><option value="0">Semua poli</option><?php foreach($polis as $p){ ?><option value="<?php echo (int)$p['id']; ?>" <?php echo $poliId===(int)$p['id']?'selected':''; ?>><?php echo hms_fuzzy_e($p['poli_name']); ?></option><?php } ?></select></div>
  <div class="col-md-3"><label class="form-label">Dokter</label><select class="form-select" name="doctor_id"><option value="0">Semua dokter</option><?php foreach($doctors as $d){ ?><option value="<?php echo (int)$d['id']; ?>" <?php echo $doctorId===(int)$d['id']?'selected':''; ?>><?php echo hms_fuzzy_e($d['doctorName']); ?></option><?php } ?></select></div>
  <div class="col-md-3"><button class="btn btn-primary" type="submit"><i class="bi bi-funnel me-1"></i>Terapkan filter</button> <a class="btn btn-outline-secondary" href="fuzzy-mamdani.php">Reset</a></div>
 </form>
</div>
<div class="row g-3 mb-3">
 <?php $metricCards=array(
  array('Durasi pelayanan prediksi',number_format($predictedDuration,1,',','.').' menit','bi-stopwatch'),
  array('Antrean aktif',number_format($queueCount,0,',','.').' pasien','bi-people'),
  array('Utilisasi dokter',number_format($doctorUtilization,1,',','.').'%','bi-person-workspace'),
  array('Keterisian slot',number_format($slotOccupancy,1,',','.').'%','bi-calendar-check'),
  array('Ketersediaan slot',number_format($availability,1,',','.').'%','bi-calendar2-check'),
  array('Estimasi keterlambatan',number_format($estimatedDelay,1,',','.').' menit','bi-clock-history')
 ); foreach($metricCards as $m){ ?>
 <div class="col-6 col-md-4 col-xl-2"><div class="hms-card hms-stat h-100"><span class="icon"><i class="bi <?php echo hms_fuzzy_e($m[2]); ?>"></i></span><div class="value fs-4"><?php echo hms_fuzzy_e($m[1]); ?></div><div class="label"><?php echo hms_fuzzy_e($m[0]); ?></div></div></div>
 <?php } ?>
</div>
<div class="row g-3 mb-3">
 <div class="col-xl-5"><div class="hms-card p-3 h-100"><h2 class="h5">Hasil inferensi Fuzzy Mamdani</h2>
  <div class="display-4 fw-bold mb-1"><?php echo number_format($fuzzy['crisp'],2,',','.'); ?><span class="fs-6 text-muted"> / 100</span></div>
  <div class="h4 mb-3">Kategori tekanan: <span class="badge text-bg-<?php echo $fuzzy['category']==='Tinggi'?'danger':($fuzzy['category']==='Sedang'?'warning':'success'); ?>"><?php echo hms_fuzzy_e($fuzzy['category']); ?></span></div>
  <p class="mb-3"><?php echo hms_fuzzy_e($recommendation); ?></p>
  <div class="small text-muted">Aturan aktif: <?php echo (int)$fuzzy['active_rules']; ?> dari 729 kombinasi aturan. Metode: AND = MIN, implikasi = MIN, agregasi = MAX, defuzzifikasi = centroid.</div>
 </div></div>
 <div class="col-xl-7"><div class="hms-card p-3 h-100"><h2 class="h5">Grafik indikator operasional</h2><p class="small text-muted">Nilai dinormalisasi terhadap rentang masing-masing variabel agar dapat dibandingkan pada satu skala 0–100.</p><canvas id="hmsInputChart" height="120" aria-label="Grafik indikator operasional"></canvas></div></div>
</div>
<div class="row g-3 mb-3">
 <div class="col-xl-7"><div class="hms-card p-3 h-100"><h2 class="h5">Grafik agregasi dan defuzzifikasi</h2><p class="small text-muted">Kurva menunjukkan derajat keanggotaan output setelah seluruh aturan aktif digabungkan. Garis vertikal menunjukkan nilai crisp.</p><canvas id="hmsOutputChart" height="125" aria-label="Grafik agregasi fuzzy dan centroid"></canvas></div></div>
 <div class="col-xl-5"><div class="hms-card p-3 h-100"><h2 class="h5">Derajat keanggotaan input</h2><div class="table-responsive"><table class="table table-sm table-bordered align-middle mb-0"><thead><tr><th>Variabel</th><th>Rendah</th><th>Sedang</th><th>Tinggi</th></tr></thead><tbody>
 <?php foreach(array('duration'=>'Durasi','queue'=>'Antrean','utilization'=>'Utilisasi','occupancy'=>'Keterisian','availability'=>'Ketersediaan','delay'=>'Keterlambatan') as $k=>$label){ ?><tr><th><?php echo hms_fuzzy_e($label); ?></th><td><?php echo number_format($degreeRows[$k]['rendah'],3); ?></td><td><?php echo number_format($degreeRows[$k]['sedang'],3); ?></td><td><?php echo number_format($degreeRows[$k]['tinggi'],3); ?></td></tr><?php } ?>
 </tbody></table></div></div></div>
</div>
<div class="hms-card p-3 mb-3"><h2 class="h5">Data sumber dan transparansi perhitungan</h2>
 <div class="table-responsive"><table class="table table-sm table-bordered mb-2"><thead><tr><th>Variabel</th><th>Nilai yang digunakan</th><th>Sumber / rumus</th></tr></thead><tbody>
 <tr><td>Predicted service duration</td><td><?php echo number_format($predictedDuration,2,',','.'); ?> menit</td><td><?php echo hms_fuzzy_e($durationSource); ?>; fallback menggunakan slot_duration_minutes jadwal aktif atau 30 menit jika belum tersedia.</td></tr>
 <tr><td>Current queue/load</td><td><?php echo (int)$queueCount; ?> pasien</td><td>hms_patient_visits pada tanggal terpilih dengan status MENUNGGU atau DIPANGGIL.</td></tr>
 <tr><td>Doctor utilization</td><td><?php echo number_format($doctorUtilization,2,',','.'); ?>%</td><td>Durasi pelayanan valid + estimasi durasi pasien berstatus DILAYANI, dibagi total menit jadwal aktif.</td></tr>
 <tr><td>Slot occupancy</td><td><?php echo number_format($slotOccupancy,2,',','.'); ?>%</td><td>Kunjungan non-BATAL dibagi total kuota jadwal aktif. Duplikasi jadwal pada dokter/tanggal/jam yang sama dihitung satu kali.</td></tr>
 <tr><td>Availability</td><td><?php echo number_format($availability,2,',','.'); ?>%</td><td>(Kuota jadwal − kunjungan non-BATAL) / kuota jadwal × 100.</td></tr>
 <tr><td>Estimated delay</td><td><?php echo number_format($estimatedDelay,2,',','.'); ?> menit</td><td>Antrean aktif × durasi pelayanan prediksi / jumlah dokter dengan jadwal aktif (minimum pembagi 1).</td></tr>
 </tbody></table></div>
 <div class="small text-muted">Tanggal <?php echo hms_fuzzy_e($selectedDate); ?> · <?php echo count($schedules); ?> rentang jadwal unik · kuota <?php echo (int)$totalQuota; ?> · <?php echo (int)$bookedCount; ?> kunjungan non-BATAL · <?php echo (int)$historyCount; ?> sampel durasi historis yang lolos filter kualitas.</div>
 <?php if($totalQuota===0){ ?><div class="alert alert-warning mt-3 mb-0">Tidak ditemukan jadwal aktif pada tanggal/filter ini. Availability bernilai 0% dan utilisasi 0%; hasil Fuzzy perlu ditafsirkan dengan memperhatikan ketiadaan jadwal.</div><?php } ?>
</div>
<div class="hms-card p-3"><h2 class="h5">Parameter fungsi keanggotaan dan metode</h2>
 <div class="table-responsive"><table class="table table-sm table-bordered mb-2"><thead><tr><th>Variabel</th><th>Rendah</th><th>Sedang</th><th>Tinggi</th><th>Domain</th></tr></thead><tbody>
 <tr><td>Durasi (menit)</td><td>Trap (0,0,15,35)</td><td>Tri (20,45,75)</td><td>Trap (60,90,120,120)</td><td>0–120</td></tr>
 <tr><td>Antrean (pasien)</td><td>Trap (0,0,4,10)</td><td>Tri (7,15,25)</td><td>Trap (20,30,40,40)</td><td>0–40</td></tr>
 <tr><td>Utilisasi (%)</td><td>Trap (0,0,30,50)</td><td>Tri (35,55,75)</td><td>Trap (65,85,100,100)</td><td>0–100</td></tr>
 <tr><td>Keterisian slot (%)</td><td>Trap (0,0,30,50)</td><td>Tri (35,55,75)</td><td>Trap (65,85,100,100)</td><td>0–100</td></tr>
 <tr><td>Ketersediaan (%)</td><td>Trap (60,80,100,100)</td><td>Tri (30,50,70)</td><td>Trap (0,0,20,40)</td><td>0–100; rendahnya ketersediaan = tekanan tinggi</td></tr>
 <tr><td>Keterlambatan (menit)</td><td>Trap (0,0,20,50)</td><td>Tri (30,75,130)</td><td>Trap (100,160,240,240)</td><td>0–240</td></tr>
 </tbody></table></div>
 <p class="small text-muted mb-0">Basis aturan dibangkitkan lengkap dari kombinasi 3 himpunan × 6 variabel (3⁶ = 729). Konsekuen ditentukan dari rata-rata tingkat tekanan antecedent: ≤0,65 rendah; ≤1,35 sedang; selebihnya tinggi. Batas, domain, dan aturan merupakan parameter awal penelitian dan perlu divalidasi/kalibrasi menggunakan data operasional yang lebih lengkap.</p>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
<script>
(function(){
 const labels=<?php echo json_encode($inputLabels,$chartJsonFlags); ?>;
 const values=<?php echo json_encode($normalized,$chartJsonFlags); ?>;
 const curve=<?php echo json_encode($chartCurve,$chartJsonFlags); ?>;
 const crisp=<?php echo json_encode(round($fuzzy['crisp'],4),$chartJsonFlags); ?>;
 if(typeof Chart==='undefined') return;
 const c1=document.getElementById('hmsInputChart');
 if(c1) new Chart(c1,{type:'bar',data:{labels:labels,datasets:[{label:'Indeks ternormalisasi (%)',data:values,borderWidth:1}]},options:{responsive:true,plugins:{legend:{display:true}},scales:{y:{beginAtZero:true,max:100,title:{display:true,text:'Skala 0–100'}}}}});
 const c2=document.getElementById('hmsOutputChart');
 if(c2) new Chart(c2,{type:'line',data:{labels:Array.from({length:101},(_,i)=>i),datasets:[{label:'Agregasi membership output',data:curve,borderWidth:2,pointRadius:0,tension:0.15},{label:'Nilai crisp',data:Array.from({length:101},(_,i)=>Math.abs(i-crisp)<0.51?Math.max(...curve):null),showLine:false,pointRadius:4,pointHoverRadius:6}]},options:{responsive:true,plugins:{legend:{display:true}},scales:{x:{title:{display:true,text:'Indeks tekanan operasional (0–100)'}},y:{beginAtZero:true,max:1,title:{display:true,text:'Derajat keanggotaan'}}}}});
})();
</script>
<?php hms_layout_footer(); ?>
