<?php
session();
include 'include/config.php';
hms_require_role('admin', 'logout.php');
require_once __DIR__ . '/modules/simrs_integration_bootstrap.php';
hms_int_bootstrap($con);

$specializations = hms_fetch_all($con,
    'SELECT id, poli_code, poli_name, is_active FROM hms_master_poli ORDER BY is_active DESC, poli_name ASC');

hms_layout_header('Spesialisasi Dokter', 'admin', 'doctors');
?>
<div class="hms-page-title">
    <div>
        <h1>Spesialisasi Dokter</h1>
        <p class="text-muted mb-0">Pilihan spesialisasi dokter menggunakan Master Poli sebagai sumber data utama.</p>
    </div>
    <a class="btn btn-primary" href="master-poli-jadwal.php">Kelola Master Poli</a>
</div>
<div class="alert alert-info">Penambahan dan perubahan poli dilakukan melalui Master Poli. Daftar ini tidak membuat data spesialisasi terpisah.</div>
<div class="hms-card p-4">
    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead><tr><th>Kode Poli</th><th>Nama Poli / Spesialisasi</th><th>Status</th></tr></thead>
            <tbody>
            <?php foreach ($specializations as $row) { ?>
                <tr>
                    <td><?php echo hms_e($row['poli_code']); ?></td>
                    <td class="fw-semibold"><?php echo hms_e($row['poli_name']); ?></td>
                    <td><?php echo ((int)$row['is_active'] === 1) ? 'Aktif' : 'Nonaktif'; ?></td>
                </tr>
            <?php } ?>
            <?php if (!$specializations) { ?><tr><td colspan="3" class="text-center text-muted py-4">Belum ada Master Poli.</td></tr><?php } ?>
            </tbody>
        </table>
    </div>
</div>
<?php hms_layout_footer(); ?>
