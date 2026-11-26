<?php
session();
include('include/config.php');
require_once __DIR__ . '/../admin/modules/module_bootstrap.php';
require_once __DIR__ . '/../admin/modules/simrs_integration_bootstrap.php';
hms_module_bootstrap($con);
hms_int_bootstrap($con);
hms_require_role('doctor', 'logout.php');

$doctorId = (int)($_SESSION['id'] ?? 0);
$hasTable = hms_table_exists($con, 'hms_doctor_schedules');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    hms_verify_csrf();
    $action = hms_post('action');
    try {
        if (!$hasTable) throw new RuntimeException('Tabel jadwal dokter belum tersedia. Jalankan bootstrap integrasi SIMRS.');
        if ($action === 'delete') {
            $id = hms_int(hms_post('id'));
            hms_execute($con, 'UPDATE hms_doctor_schedules SET is_active=0,updated_at=NOW() WHERE id=? AND doctor_id=?', 'ii', array($id,$doctorId));
            hms_module_audit($con, 'DEACTIVATE', 'JADWAL_DOKTER', 'hms_doctor_schedules', $id, 'Dokter menonaktifkan jadwal praktik.');
            hms_flash('success', 'Jadwal dinonaktifkan. Riwayat jadwal dan relasi antrean tetap disimpan.');
            hms_redirect('availability.php');
        }

        if ($action === 'assign_poli') {
            // Hubungkan jadwal lama yang belum memiliki poli ke master yang sama
            // dengan jadwal Admin. Tidak membuat baris/tabel jadwal baru.
            $id = hms_int(hms_post('id'));
            $poliId = hms_int(hms_post('poli_id'));
            $poli = hms_fetch_one($con, 'SELECT id FROM hms_master_poli WHERE id=? AND is_active=1 LIMIT 1', 'i', array($poliId));
            if ($id <= 0 || !$poli) throw new RuntimeException('Pilih poli aktif yang valid.');
            $owned = hms_fetch_one($con, 'SELECT id FROM hms_doctor_schedules WHERE id=? AND doctor_id=? LIMIT 1', 'ii', array($id, $doctorId));
            if (!$owned) throw new RuntimeException('Jadwal tidak ditemukan atau bukan milik akun dokter ini.');
            hms_execute($con, 'UPDATE hms_doctor_schedules SET poli_id=?,updated_at=NOW() WHERE id=? AND doctor_id=?', 'iii', array($poliId, $id, $doctorId));
            hms_module_audit($con, 'UPDATE', 'JADWAL_DOKTER', 'hms_doctor_schedules', $id, 'Jadwal lama dihubungkan ke Master Poli.', null, array('poli_id'=>$poliId));
            hms_flash('success', 'Jadwal lama berhasil dihubungkan ke Master Poli. Data tetap berada pada tabel jadwal yang sama.');
            hms_redirect('availability.php');
        }

        if ($action === 'create') {
            $poliId = hms_int(hms_post('poli_id'));
            $day = hms_int(hms_post('day_of_week'));
            $date = hms_post('available_date') !== '' ? hms_post('available_date') : null;
            $start = hms_normalize_time(hms_post('start_time'));
            $end = hms_normalize_time(hms_post('end_time'));
            $duration = max(5, hms_int(hms_post('slot_duration_minutes')));
            $quota = max(1, hms_int(hms_post('max_appointments')));

            $poli = hms_fetch_one($con, 'SELECT id,poli_name FROM hms_master_poli WHERE id=? AND is_active=1 LIMIT 1', 'i', array($poliId));
            if (!$poli) throw new RuntimeException('Pilih poli aktif dari Master Poli.');
            if ($day < 0 || $day > 6 || !$start || !$end || $start >= $end) {
                throw new RuntimeException('Hari dan rentang jam praktik tidak valid.');
            }
            if ($date !== null && (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $date) || $date < date('Y-m-d'))) {
                throw new RuntimeException('Tanggal khusus tidak valid atau sudah lewat.');
            }

            $duplicate = hms_fetch_one($con,
                'SELECT id FROM hms_doctor_schedules
                 WHERE poli_id=? AND doctor_id=? AND day_of_week=? AND available_date <=> ?
                   AND start_time=? AND end_time=? AND is_active=1 LIMIT 1',
                'iiisss', array($poliId,$doctorId,$day,$date,$start,$end)
            );
            if ($duplicate) throw new RuntimeException('Jadwal aktif dengan poli, hari/tanggal, dan jam yang sama sudah ada. Gunakan jadwal yang sudah tersedia atau ubah jadwal lama.');

            $st = mysqli_prepare($con,
                'INSERT INTO hms_doctor_schedules(poli_id,doctor_id,day_of_week,available_date,start_time,end_time,quota,slot_duration_minutes,is_active,created_at)
                 VALUES(?,?,?,?,?,?,?, ?,1,NOW())'
            );
            if (!$st) throw new RuntimeException('Gagal menyiapkan jadwal dokter.');
            mysqli_stmt_bind_param($st, 'iiisssii', $poliId,$doctorId,$day,$date,$start,$end,$quota,$duration);
            if (!mysqli_stmt_execute($st)) {
                mysqli_stmt_close($st);
                throw new RuntimeException('Jadwal dokter gagal disimpan.');
            }
            $id = (int)mysqli_stmt_insert_id($st);
            mysqli_stmt_close($st);
            hms_module_audit($con, 'CREATE', 'JADWAL_DOKTER', 'hms_doctor_schedules', $id, 'Dokter menambahkan jadwal pada Master Poli.', null,
                array('poli_id'=>$poliId,'doctor_id'=>$doctorId,'day_of_week'=>$day,'available_date'=>$date,'start_time'=>$start,'end_time'=>$end,'quota'=>$quota,'slot_duration_minutes'=>$duration));
            hms_flash('success', 'Jadwal praktik berhasil disimpan ke Master Jadwal SIMRS dan langsung tersedia untuk booking/registrasi.');
            hms_redirect('availability.php');
        }
        throw new RuntimeException('Aksi jadwal tidak dikenal.');
    } catch (Throwable $e) {
        hms_flash('error', $e->getMessage());
        hms_redirect('availability.php');
    }
}

$polies = hms_fetch_all($con, 'SELECT id,poli_name FROM hms_master_poli WHERE is_active=1 ORDER BY poli_name');
$slots = $hasTable ? hms_fetch_all($con,
    "SELECT s.*,p.poli_name FROM hms_doctor_schedules s
     LEFT JOIN hms_master_poli p ON p.id=s.poli_id
     WHERE s.doctor_id=?
     ORDER BY s.is_active DESC,s.available_date DESC,s.day_of_week ASC,s.start_time ASC,s.id ASC",
    'i', array($doctorId)
) : array();
// Hide exact legacy duplicates in the display; no schedule or visit rows are deleted.
$uniqueSlots = array();
$seenSlotKeys = array();
foreach ($slots as $slotRow) {
    $slotKey = implode('|', array(
        (string)($slotRow['poli_id'] ?? ''),
        (string)($slotRow['doctor_id'] ?? ''),
        (string)($slotRow['day_of_week'] ?? ''),
        (string)($slotRow['available_date'] ?? ''),
        substr((string)($slotRow['start_time'] ?? ''),0,8),
        substr((string)($slotRow['end_time'] ?? ''),0,8),
        (string)($slotRow['quota'] ?? ''),
        (string)($slotRow['is_active'] ?? '')
    ));
    if (isset($seenSlotKeys[$slotKey])) continue;
    $seenSlotKeys[$slotKey] = true;
    $uniqueSlots[] = $slotRow;
}
$slots = $uniqueSlots;
$days = array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');

hms_layout_header('Ketersediaan Dokter','doctor','availability');
?>
<div class="hms-page-title">
  <div><h1>Ketersediaan Dokter</h1><div class="text-muted">Jadwal pada halaman ini tersimpan pada Master Poli & Jadwal yang sama dengan booking pasien dan registrasi antrean.</div></div>
</div>

<div class="row g-3">
 <div class="col-lg-4">
  <div class="hms-card p-3">
   <h2 class="h5 mb-3">Tambah Slot Praktik</h2>
   <form method="post">
    <?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="create">
    <div class="mb-3"><label class="form-label">Poli</label><select class="form-select" name="poli_id" required><option value="">Pilih poli</option><?php foreach($polies as $p){ ?><option value="<?php echo (int)$p['id']; ?>"><?php echo hms_e($p['poli_name']); ?></option><?php } ?></select></div>
    <div class="mb-3"><label class="form-label">Hari Mingguan</label><select class="form-select" name="day_of_week" required><?php foreach($days as $i=>$day){ ?><option value="<?php echo (int)$i; ?>"><?php echo hms_e($day); ?></option><?php } ?></select></div>
    <div class="mb-3"><label class="form-label">Tanggal Khusus</label><input class="form-control" type="date" name="available_date" min="<?php echo date('Y-m-d'); ?>"><div class="form-text">Kosongkan untuk jadwal mingguan.</div></div>
    <div class="row g-3">
     <div class="col-6"><label class="form-label">Mulai</label><input class="form-control" type="time" name="start_time" required></div>
     <div class="col-6"><label class="form-label">Selesai</label><input class="form-control" type="time" name="end_time" required></div>
     <div class="col-6"><label class="form-label">Durasi Slot (menit)</label><input class="form-control" type="number" name="slot_duration_minutes" min="5" value="30" required></div>
     <div class="col-6"><label class="form-label">Kuota</label><input class="form-control" type="number" name="max_appointments" min="1" value="20" required></div>
    </div>
    <button class="btn btn-primary w-100 mt-4" type="submit">Simpan Jadwal</button>
   </form>
  </div>
 </div>
 <div class="col-lg-8">
  <div class="hms-card p-3">
   <h2 class="h5 mb-3">Jadwal Praktik Saya</h2>
   <div class="table-responsive"><table class="table table-hover align-middle mb-0" data-sortable>
    <thead><tr><th>Poli</th><th>Hari / Tanggal</th><th>Waktu</th><th>Kapasitas</th><th>Status</th><th class="text-end">Aksi</th></tr></thead><tbody>
    <?php foreach($slots as $slot){ ?>
     <tr>
      <td>
       <?php if (!empty($slot['poli_name'])) { echo hms_e($slot['poli_name']); }
       else { ?>
        <span class="text-warning">Belum terhubung ke poli</span>
        <form method="post" class="d-flex gap-1 mt-2">
         <?php echo hms_csrf_field(); ?>
         <input type="hidden" name="action" value="assign_poli">
         <input type="hidden" name="id" value="<?php echo (int)$slot['id']; ?>">
         <select class="form-select form-select-sm" name="poli_id" required>
          <option value="">Pilih poli</option>
          <?php foreach ($polies as $poliOption) { ?>
           <option value="<?php echo (int)$poliOption['id']; ?>"><?php echo hms_e($poliOption['poli_name']); ?></option>
          <?php } ?>
         </select>
         <button class="btn btn-sm btn-outline-primary" type="submit">Hubungkan</button>
        </form>
       <?php } ?>
      </td>
      <td><?php echo hms_e(!empty($slot['available_date'])?$slot['available_date']:$days[(int)$slot['day_of_week']]); ?></td>
      <td><?php echo hms_e(substr($slot['start_time'],0,5).' - '.substr($slot['end_time'],0,5)); ?></td>
      <td><?php echo (int)($slot['slot_duration_minutes']??30); ?> min / <?php echo (int)$slot['quota']; ?> booking(s)</td>
      <td><?php echo (int)$slot['is_active']===1?'<span class="badge text-bg-success">Aktif</span>':'<span class="badge text-bg-secondary">Nonaktif</span>'; ?></td>
      <td class="text-end"><?php if((int)$slot['is_active']===1){ ?><form method="post" onsubmit="return confirm('Nonaktifkan jadwal ini?');"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<?php echo (int)$slot['id']; ?>"><button class="btn btn-sm btn-outline-secondary">Nonaktifkan</button></form><?php } ?></td>
     </tr>
    <?php } if(!$slots){ ?><tr><td colspan="6" class="text-center text-muted py-4">Belum ada jadwal pada Master Poli & Jadwal.</td></tr><?php } ?>
    </tbody>
   </table></div>
  </div>
 </div>
</div>
<?php hms_layout_footer(); ?>
