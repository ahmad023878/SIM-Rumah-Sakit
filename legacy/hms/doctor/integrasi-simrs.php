<?php
session(); include('../include/config.php'); require_once __DIR__.'/modules/module_bootstrap.php'; require_once __DIR__.'/modules/simrs_integration_bootstrap.php';
hms_module_require_roles(array('admin','rekam_medis','doctor','perawat'));
hms_int_bootstrap($con);
$role=hms_module_current_role(); hms_layout_header('Integrasi SIMRS',$role,'operations');
$masterCount=(int)hms_scalar($con,'SELECT COUNT(*) FROM hms_master_poli WHERE is_active=1');
$scheduleCount=(int)hms_scalar($con,'SELECT COUNT(*) FROM hms_doctor_schedules WHERE is_active=1');
$serviceCount=(int)hms_scalar($con,'SELECT COUNT(*) FROM hms_service_catalog WHERE is_active=1');
?>
<div class="hms-page-title"><div><h1>Integrasi SIMRS</h1><div class="text-muted">Pusat akses tambahan untuk master poli, jadwal, kuota, registrasi terintegrasi dan pelayanan.</div></div></div>
<div class="row g-4">
<div class="col-md-4"><div class="hms-card p-3 h-100"><div class="small text-muted">Master Poli Aktif</div><div class="display-6 fw-bold"><?php echo $masterCount; ?></div><a class="btn btn-outline-primary mt-2" href="master-poli-jadwal.php">Kelola Poli & Jadwal</a></div></div>
<div class="col-md-4"><div class="hms-card p-3 h-100"><div class="small text-muted">Jadwal Aktif</div><div class="display-6 fw-bold"><?php echo $scheduleCount; ?></div><a class="btn btn-outline-primary mt-2" href="registrasi-terintegrasi.php">Registrasi & Antrean</a></div></div>
<div class="col-md-4"><div class="hms-card p-3 h-100"><div class="small text-muted">Jenis Pelayanan / Tarif</div><div class="display-6 fw-bold"><?php echo $serviceCount; ?></div><a class="btn btn-outline-success mt-2" href="outpatient.php">Buka Pelayanan Rawat Jalan</a></div></div>
</div>
<div class="hms-card p-4 mt-4"><h2 class="h5">Alur Integrasi</h2><div class="d-flex flex-wrap gap-2 align-items-center"><span class="badge text-bg-primary p-2">Master Poli</span><span>→</span><span class="badge text-bg-primary p-2">Dokter</span><span>→</span><span class="badge text-bg-primary p-2">Jadwal</span><span>→</span><span class="badge text-bg-primary p-2">Kuota</span><span>→</span><span class="badge text-bg-success p-2">Registrasi</span><span>→</span><span class="badge text-bg-success p-2">Antrean</span><span>→</span><span class="badge text-bg-info p-2">RME</span><span>→</span><span class="badge text-bg-warning p-2">Billing</span></div><p class="text-muted mt-3 mb-0">Semua tambahan ini bersifat additive. Modul legacy tetap tersedia dan data kunjungan lama tidak dipindahkan atau dihapus.</p></div>
<?php hms_layout_footer(); ?>
