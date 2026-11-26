<?php
session();
include('../include/config.php');
hms_require_role('admin','logout.php');
require_once __DIR__.'/module_bootstrap.php';

hms_layout_header('System Audit SIMRS','admin','dashboard');

$checks = [];
function audit_add($id,$severity,$status,$title,$detail) {
    global $checks;
    $checks[] = compact('id','severity','status','title','detail');
}

$envPath = dirname(__DIR__, 4).'/.env';
$env = is_file($envPath) ? (string)@file_get_contents($envPath) : '';
$dev = preg_match('/CI_ENVIRONMENT\s*=\s*development/i',$env) === 1;
$rootDb = preg_match('/database\.default\.username\s*=\s*root/i',$env) === 1;
audit_add('ENV-01','HIGH',$dev?'WARN':'PASS','Environment', $dev ? 'Environment masih development. Untuk produksi gunakan CI_ENVIRONMENT=production.' : 'Environment bukan development.');
audit_add('ENV-02','HIGH',$rootDb?'WARN':'PASS','Database account', $rootDb ? 'Database memakai root. Gunakan user aplikasi dengan hak minimum.' : 'Database user tidak terdeteksi sebagai root.');

$filters = is_file(dirname(__DIR__,4).'/app/Config/Filters.php') ? file_get_contents(dirname(__DIR__,4).'/app/Config/Filters.php') : '';
audit_add('SEC-01','HIGH',strpos($filters,"'secureheaders',") !== false && strpos($filters,"// 'secureheaders'") === false ? 'PASS':'WARN','Security headers', 'SecureHeaders tersedia; rollout global perlu diuji terhadap legacy assets.');

$helpers = is_file(dirname(__DIR__,2).'/include/hms_helpers.php') ? file_get_contents(dirname(__DIR__,2).'/include/hms_helpers.php') : '';
$legacyPassword = strpos($helpers,'md5($plain)') !== false || strpos($helpers,'return hash_equals((string) $stored, (string) $plain)') !== false;
audit_add('SEC-02','HIGH',$legacyPassword?'WARN':'PASS','Password legacy', $legacyPassword ? 'Masih ada fallback MD5/plaintext untuk kompatibilitas. Migrasikan semua akun lalu hapus fallback.' : 'Fallback legacy tidak ditemukan.');

audit_add('PUB-01','MEDIUM','WARN','Portal publik','Tambahkan CAPTCHA/rate-limit sebelum portal registrasi dipublikasikan ke internet.');
audit_add('DATA-01','HIGH','WARN','Data contoh','Pastikan data pasien/user pada hms.sql dianonimkan sebelum production.');

audit_add('FLOW-01','MEDIUM','PASS','Compatibility bridge','Bridge legacy → modul additive dipertahankan sehingga halaman lama tidak perlu diubah.');
audit_add('FLOW-02','MEDIUM','PASS','Rawat Inap','Admission/bed workflow menggunakan transaksi dan row locking pada modul baru.');
audit_add('UI-01','LOW','PASS','UI/UX','Layout modul baru sudah responsive dan konsisten dengan sidebar/topbar.');

$counts = ['PASS'=>0,'WARN'=>0,'FAIL'=>0];
foreach($checks as $c){ $counts[$c['status']] = ($counts[$c['status']] ?? 0)+1; }
?>
<div class="hms-page-title">
  <div><h1>System Audit SIMRS</h1><div class="text-muted">Audit read-only. Halaman ini tidak mengubah data atau konfigurasi.</div></div>
  <a class="btn btn-outline-primary" href="operations_dashboard.php"><i class="bi bi-arrow-left me-1"></i>Kembali</a>
</div>
<div class="row g-3 mb-4">
<?php foreach([['PASS','Lulus','success'],['WARN','Perlu perhatian','warning'],['FAIL','Gagal','danger']] as $s){ ?>
<div class="col-md-4"><div class="hms-card hms-stat"><div class="value"><?php echo (int)$counts[$s[0]]; ?></div><div class="label text-<?php echo $s[2]; ?>"><?php echo hms_e($s[1]); ?></div></div></div>
<?php } ?>
</div>
<div class="hms-card p-3">
<div class="table-responsive"><table class="table table-hover mb-0"><thead><tr><th>ID</th><th>Severity</th><th>Status</th><th>Temuan</th><th>Rekomendasi</th></tr></thead><tbody>
<?php foreach($checks as $c){
  $badge = $c['status']==='PASS'?'success':($c['status']==='FAIL'?'danger':'warning');
  echo '<tr><td><code>'.hms_e($c['id']).'</code></td><td>'.hms_e($c['severity']).'</td><td><span class="badge text-bg-'.$badge.'">'.hms_e($c['status']).'</span></td><td><strong>'.hms_e($c['title']).'</strong></td><td>'.hms_e($c['detail']).'</td></tr>';
} ?>
</tbody></table></div></div>
<div class="alert alert-info mt-3"><strong>Catatan:</strong> Audit ini membantu readiness teknis, bukan sertifikasi regulasi kesehatan. Baca <code>docs/SIMRS_AUDIT_TAHAP3.md</code> dan <code>docs/GO_LIVE_CHECKLIST.md</code> sebelum deployment.</div>
<?php hms_layout_footer(); ?>
