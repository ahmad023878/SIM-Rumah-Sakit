<?php
session();
include 'include/config.php';
hms_require_role('admin', 'logout.php');

$queryId = hms_int(hms_get('id'));
$query = hms_fetch_one($con, 'SELECT * FROM tblcontactus WHERE id = ?', 'i', array($queryId));

if (!$query) {
    hms_flash('danger', 'Query not found.');
    hms_redirect('unread-queries.php');
}

if (isset($_POST['update'])) {
    hms_verify_csrf();
    $remark = hms_post('adminremark');
    if ($remark === '') {
        hms_flash('danger', 'Please enter an admin remark.');
    } else {
        hms_execute($con, 'UPDATE tblcontactus SET AdminRemark = ?, IsRead = 1 WHERE id = ?', 'si', array($remark, $queryId));
        hms_log_audit($con, 'admin', (int) $_SESSION['id'], 'query_replied', 'tblcontactus', $queryId, 'Admin replied to contact query.');
        hms_flash('success', 'Admin remark updated successfully.');
        hms_redirect('read-query.php');
    }
    $query = hms_fetch_one($con, 'SELECT * FROM tblcontactus WHERE id = ?', 'i', array($queryId));
}

hms_layout_header('Detail Pertanyaan', 'admin', 'notifications');
?>
<div class="hms-page-title">
    <div>
        <h1>Detail Pertanyaan</h1>
        <p class="text-muted mb-0">Tinjau dan tanggapi pertanyaan kontak publik.</p>
    </div>
    <a class="btn btn-light" href="<?php echo empty($query['AdminRemark']) ? 'unread-queries.php' : 'read-query.php'; ?>">Kembali ke Pertanyaan</a>
</div>

<div class="row g-4">
    <div class="col-lg-7">
        <div class="hms-card p-4">
            <h2 class="h5 mb-3">Pertanyaan Masuk</h2>
            <dl class="row mb-0">
                <dt class="col-sm-4 text-muted">Nama lengkap</dt>
                <dd class="col-sm-8"><?php echo hms_e($query['fullname']); ?></dd>
                <dt class="col-sm-4 text-muted">Email</dt>
                <dd class="col-sm-8"><?php echo hms_e($query['email']); ?></dd>
                <dt class="col-sm-4 text-muted">Contact</dt>
                <dd class="col-sm-8"><?php echo hms_e($query['contactno']); ?></dd>
                <dt class="col-sm-4 text-muted">Pesan</dt>
                <dd class="col-sm-8"><?php echo nl2br(hms_e($query['message'])); ?></dd>
                <dt class="col-sm-4 text-muted">Tanggal pertanyaan</dt>
                <dd class="col-sm-8"><?php echo hms_e($query['PostingDate']); ?></dd>
            </dl>
        </div>
    </div>
    <div class="col-lg-5">
        <div class="hms-card p-4">
            <h2 class="h5 mb-3">Catatan Admin</h2>
            <?php if (empty($query['AdminRemark'])) { ?>
                <form method="post">
                    <?php echo hms_csrf_field(); ?>
                    <label class="form-label" for="adminremark">Catatan tanggapan</label>
                    <textarea class="form-control" id="adminremark" name="adminremark" rows="6" required></textarea>
                    <button type="submit" name="update" class="btn btn-primary mt-3">
                        <i class="bi bi-send me-1"></i>Simpan Catatan
                    </button>
                </form>
            <?php } else { ?>
                <p><?php echo nl2br(hms_e($query['AdminRemark'])); ?></p>
                <p class="text-muted small mb-0">Terakhir diperbarui: <?php echo hms_e($query['LastupdationDate'] ?: 'Tidak tersedia'); ?></p>
            <?php } ?>
        </div>
    </div>
</div>
<?php hms_layout_footer(); ?>
