<?php
session(); include('../include/config.php'); hms_require_role('admin','logout.php'); require_once __DIR__.'/module_bootstrap.php';
hms_layout_header('Modul Pelayanan Rumah Sakit','admin','operations');
$cards = array(
 ['Registrasi & Antrean','hms_patient_visits','bi-person-plus','registration-queue.php'],
 ['M2 Queue & Waiting-Time','hms_patient_visits','bi-stopwatch','queue-waiting-time.php'],
 ['M3 — AdaBoost Regression','hms_patient_visits','bi-graph-up-arrow','m3-adaboost.php'],
 ['M4 — Fuzzy Mamdani',null,'bi-diagram-3','fuzzy-mamdani.php'],
 ['M5 — Hybrid DSS',null,'bi-calendar2-check','m5-hybrid-dss.php'],
 ['M6 — Adaptive Scheduling',null,'bi-arrow-repeat','m6-adaptive-scheduling.php'],
 ['M7 — Evaluation & Ablation',null,'bi-clipboard-data','m7-evaluation.php'],
 ['Rawat Jalan / Poliklinik','hms_outpatient_encounters','bi-hospital','outpatient.php'],
 ['IGD','hms_igd_visits','bi-heart-pulse','igd.php'],
 ['Rawat Inap','hms_admissions','bi-hospital','inpatient.php'],
 ['RME / CPPT','hms_cppt','bi-journal-medical','rme.php'],
 ['Billing / Kasir','hms_bills','bi-receipt','billing.php'],
 ['Rujukan','hms_referrals','bi-box-arrow-up-right','referrals.php']
);
?>
<div class="hms-page-title"><div><h1>Modul Pelayanan Rumah Sakit</h1><div class="text-muted">Modul tambahan untuk registrasi, IGD, rawat inap, RME dan billing..</div></div></div>
<div class="row g-3 mb-4">
<?php foreach($cards as $c){ $isSpecial = $c[1] === null; $isHybrid = $c[3] === 'm5-hybrid-dss.php'; $isAdaptive = $c[3] === 'm6-adaptive-scheduling.php'; $isEvaluation = $c[3] === 'm7-evaluation.php'; $count = $isSpecial ? 'Uji' : (int)hms_scalar($con,'SELECT COUNT(*) FROM '.$c[1]); ?>
<div class="col-md-6 col-xl-4"><a class="hms-card hms-stat d-block text-reset" href="<?php echo hms_e($c[3]); ?>"><span class="icon"><i class="bi <?php echo hms_e($c[2]); ?>"></i></span><div class="value"><?php echo hms_e($count); ?></div><div class="label"><?php echo hms_e($c[0]); ?></div><?php if($isEvaluation){ ?><div class="small text-muted mt-1">Perbandingan static, Fuzzy-only, AdaBoost, dan Hybrid.</div><?php } elseif($isHybrid){ ?><div class="small text-muted mt-1">Prediksi durasi, penilaian slot, dan rekomendasi appointment.</div><?php } elseif($isAdaptive){ ?><div class="small text-muted mt-1">Hitung ulang rekomendasi saat kondisi operasional berubah.</div><?php } elseif($isSpecial){ ?><div class="small text-muted mt-1">Analisis tingkat tekanan operasional berbasis Fuzzy Mamdani.</div><?php } ?></a></div>
<?php } ?>
</div>
<?php hms_layout_footer(); ?>
