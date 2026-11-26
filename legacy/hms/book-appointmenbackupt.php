<?php
session();
include('include/config.php');
include('include/checklogin.php');
require_once __DIR__ . '/include/appointment_queue_bridge.php';
require_once __DIR__ . '/admin/modules/simrs_integration_bootstrap.php';
hms_int_bootstrap($con);
hms_bridge_ensure_schema($con);
check_login();
hms_require_role('patient', 'logout.php');

$userId = (int) $_SESSION['id'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    hms_verify_csrf();
    $doctorId = hms_int(hms_post('doctor'));
    $poliId = hms_int(hms_post('poli_id'));
    $appDate = hms_post('appdate');
    $appTime = hms_normalize_time(hms_post('apptime'));

    $doctor = hms_fetch_one(
        $con,
        'SELECT id, doctorName, specilization, docFees FROM doctors WHERE id = ?',
        'i',
        array($doctorId)
    );

    $poli = hms_fetch_one($con, 'SELECT id,poli_name FROM hms_master_poli WHERE id=? AND is_active=1 LIMIT 1', 'i', array($poliId));
    $reason = '';
    if (!$doctor || !$poli) {
        hms_flash('error', 'Silakan pilih poli dan dokter yang valid.');
        hms_redirect('book-appointment.php');
    }
    mysqli_begin_transaction($con);
    try {
        $matchedSchedule = hms_bridge_validate_schedule($con, $poliId, $doctorId, $appDate, $appTime, 0, $reason);
        if (!$matchedSchedule) {
            throw new RuntimeException($reason);
        }

        $fields = array('doctorSpecialization', 'doctorId', 'userId', 'consultancyFees', 'appointmentDate', 'appointmentTime', 'userStatus', 'doctorStatus');
        $placeholders = array('?', '?', '?', '?', '?', '?', '1', '1');
        $types = 'siisss';
        $params = array($poli['poli_name'], $doctorId, $userId, (string) $doctor['docFees'], $appDate, $appTime);
        if (hms_column_exists($con, 'appointment', 'status')) {
            $fields[] = 'status';
            $placeholders[] = '?';
            $types .= 's';
            $params[] = 'Pending';
        }

        hms_execute(
            $con,
            'INSERT INTO appointment(' . implode(',', $fields) . ') VALUES(' . implode(',', $placeholders) . ')',
            $types,
            $params
        );
        $appointmentId = mysqli_insert_id($con);
        $linkedVisitId = hms_bridge_create_visit_for_appointment($con, $appointmentId);
        if ($linkedVisitId <= 0) {
            throw new RuntimeException('Janji temu tersimpan tetapi kunjungan antrean gagal dibuat.');
        }
        mysqli_commit($con);
    } catch (Throwable $bookingError) {
        mysqli_rollback($con);
        hms_flash('error', $bookingError->getMessage());
        hms_redirect('book-appointment.php');
    }
    hms_log_audit($con, 'patient', $userId, 'appointment_created', 'appointment', $appointmentId, 'Booked with Dr. ' . $doctor['doctorName']);
    hms_notify($con, 'admin', null, 'New appointment request', 'A patient booked appointment #' . $appointmentId . '.');
    hms_notify($con, 'doctor', $doctorId, 'New appointment request', 'A patient booked appointment #' . $appointmentId . '.');
    // Pastikan sesi pasien tetap konsisten setelah proses INSERT.
    // Ini mencegah halaman riwayat dianggap sebagai sesi anonim lalu
    // diarahkan ke halaman utama.
    $_SESSION['id'] = $userId;
    $_SESSION['role'] = 'patient';
    if (empty($_SESSION['login'])) {
        $currentUser = hms_fetch_one($con, 'SELECT email FROM users WHERE id = ? LIMIT 1', 'i', array($userId));
        if ($currentUser && isset($currentUser['email'])) {
            $_SESSION['login'] = $currentUser['email'];
        }
    }

    if ($linkedVisitId > 0) {
        hms_flash('success', 'Janji temu berhasil dikirim dan terhubung dengan kunjungan/antrean SIMRS (No. kunjungan: ' . $linkedVisitId . '). Status dapat dipantau pada menu Janji Temu.');
    } else {
        hms_flash('warning', 'Janji temu tersimpan, tetapi tautan antrean SIMRS belum terbentuk. Hubungi admin untuk menjalankan pemeriksaan integrasi.');
    }
    hms_redirect('appointment-history.php');
}

$specialties = hms_fetch_all($con, "SELECT p.id,p.poli_code,p.poli_name\nFROM hms_master_poli p\nWHERE p.is_active=1\n  AND p.id=(\n      SELECT p2.id\n      FROM hms_master_poli p2\n      WHERE p2.is_active=1\n        AND LOWER(TRIM(p2.poli_name))=LOWER(TRIM(p.poli_name))\n      ORDER BY\n        (SELECT COUNT(*) FROM hms_doctor_schedules ds\n         WHERE ds.poli_id=p2.id AND ds.is_active=1) DESC,\n        p2.id ASC\n      LIMIT 1\n  )\nORDER BY p.poli_name ASC");
$doctors = hms_fetch_all($con, 'SELECT id, doctorName, specilization, docFees, address, contactno, docEmail FROM doctors ORDER BY doctorName ASC');
$bookingSchedules = hms_fetch_all($con, "SELECT poli_id,doctor_id,day_of_week,available_date,start_time,end_time,quota,is_active
    FROM hms_doctor_schedules WHERE is_active=1 ORDER BY poli_id,doctor_id,start_time");

hms_layout_header('Book Janji Temu', 'patient', 'book');
?>
<div class="hms-page-title">
    <div>
        <h1>Book Janji Temu</h1>
        <div class="text-muted">Pilih poli dari Master Poli, dokter dengan jadwal aktif, tanggal, dan jam praktik.</div>
    </div>
    <a class="btn btn-outline-secondary" href="appointment-history.php"><i class="bi bi-calendar-check me-1"></i>Janji Temu Saya</a>
</div>

<div class="row g-3">
    <div class="col-lg-7">
        <div class="hms-card p-3">
            <form method="post" id="bookingForm">
                <?php echo hms_csrf_field(); ?>
                <div class="mb-3">
                    <label class="form-label">Poli</label>
                    <select class="form-select" name="poli_id" id="specialization" required>
                        <option value="">Pilih poli</option>
                        <?php foreach ($specialties as $specialty) { ?>
                            <option value="<?php echo (int)$specialty['id']; ?>"><?php echo hms_e($specialty['poli_name']); ?></option>
                        <?php } ?>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Dokter</label>
                    <select class="form-select" name="doctor" id="doctor" required disabled>
                        <option value="">Pilih poli terlebih dahulu</option>
                        <?php foreach ($doctors as $doctor) { ?>
                            <option value="<?php echo hms_e($doctor['id']); ?>"
                                data-fee="<?php echo hms_e($doctor['docFees']); ?>"
                                data-specialization="<?php echo hms_e($doctor['specilization']); ?>"
                                data-address="<?php echo hms_e($doctor['address']); ?>"
                                data-phone="<?php echo hms_e($doctor['contactno']); ?>"
                                data-email="<?php echo hms_e($doctor['docEmail']); ?>">
                                <?php echo hms_e($doctor['doctorName']); ?>
                            </option>
                        <?php } ?>
                    </select>
                    <div class="form-text" id="availabilityText">Pilih poli untuk menampilkan dokter yang memiliki jadwal aktif.</div>
                    <div class="border rounded p-3 mt-2 bg-light" id="doctorMasterInfo" hidden>
                        <div class="fw-semibold mb-2">Informasi Dokter (Master Dokter)</div>
                        <div class="small" id="doctorSpecializationInfo"></div>
                        <div class="small" id="doctorAddressInfo"></div>
                        <div class="small" id="doctorPhoneInfo"></div>
                        <div class="small" id="doctorEmailInfo"></div>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Biaya Konsultasi</label>
                    <input class="form-control" id="fees" value="" readonly>
                </div>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <label class="form-label">Tanggal Janji Temu</label>
                        <input class="form-control" type="date" id="appdate" name="appdate" min="<?php echo date('Y-m-d'); ?>" required>
                    </div>
                    <div class="col-sm-6">
                        <label class="form-label">Waktu Janji Temu</label>
                        <input class="form-control" type="time" id="apptime" name="apptime" required>
                    </div>
                </div>
                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a class="btn btn-light" href="dashboard.php">Batal</a>
                    <button class="btn btn-primary" type="submit"><i class="bi bi-send me-1"></i>Kirim Permintaan</button>
                </div>
            </form>
        </div>
    </div>
    <div class="col-lg-5">
        <div class="hms-card p-3 h-100">
            <h2 class="h5">Sebelum Membuat Janji</h2>
            <div class="text-muted mb-3">Ketersediaan akan diperiksa kembali saat Anda mengirim permintaan agar slot tidak diambil pasien lain secara diam-diam.</div>
            <div class="timeline">
                <div class="timeline-item">
                    <div class="fw-semibold">Pending</div>
                    <div class="small text-muted">Permintaan baru dimulai di sini.</div>
                </div>
                <div class="timeline-item">
                    <div class="fw-semibold">Approved</div>
                    <div class="small text-muted">Admin atau dokter mengonfirmasi kunjungan.</div>
                </div>
                <div class="timeline-item">
                    <div class="fw-semibold">Completed</div>
                    <div class="small text-muted">Dokter menambahkan diagnosis dan resep.</div>
                </div>
            </div>
        </div>
    </div>
</div>
<?php
$script = '<script>
const poliSelect = document.getElementById("specialization");
const doctorSelect = document.getElementById("doctor");
const feeInput = document.getElementById("fees");
const availabilityText = document.getElementById("availabilityText");
const dateInput = document.getElementById("appdate");
const timeInput = document.getElementById("apptime");
const doctorInfo = document.getElementById("doctorMasterInfo");
const doctorSpecInfo = document.getElementById("doctorSpecializationInfo");
const doctorAddressInfo = document.getElementById("doctorAddressInfo");
const doctorPhoneInfo = document.getElementById("doctorPhoneInfo");
const doctorEmailInfo = document.getElementById("doctorEmailInfo");
const schedules = ' . json_encode($bookingSchedules, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES) . ';
const doctorOptions = Array.from(doctorSelect.querySelectorAll("option")).slice(1);

function getPoliDoctorSchedules(doctorId) {
  const selectedPoli = String(poliSelect.value || "");
  return schedules.filter(function(item) {
    return String(item.poli_id) === selectedPoli &&
           String(item.doctor_id) === String(doctorId) &&
           String(item.is_active === undefined ? 1 : item.is_active) === "1";
  });
}
function isWeeklySchedule(value) {
  const v = String(value || "").slice(0, 10);
  return !v || v === "0000-00-00";
}
function getSchedulesForSelectedDate(doctorId) {
  const date = dateInput.value || "";
  if (!date) return [];
  const day = new Date(date + "T00:00:00").getDay();
  return getPoliDoctorSchedules(doctorId).filter(function(item) {
    const specificDate = String(item.available_date || "").slice(0, 10);
    if (isWeeklySchedule(specificDate)) {
      return Number(item.day_of_week) === day;
    }
    return specificDate === date;
  });
}
function updateDoctorInformation() {
  const option = doctorSelect.options[doctorSelect.selectedIndex];
  if (!option || !option.value) {
    feeInput.value = "";
    doctorInfo.hidden = true;
    return;
  }
  feeInput.value = option.dataset.fee || "";
  doctorInfo.hidden = false;
  doctorSpecInfo.textContent = "Spesialisasi: " + (option.dataset.specialization || "-");
  doctorAddressInfo.textContent = "Alamat praktik: " + (option.dataset.address || "-");
  doctorPhoneInfo.textContent = "Nomor kontak: " + (option.dataset.phone || "-");
  doctorEmailInfo.textContent = "Email: " + (option.dataset.email || "-");

  const poliSchedules = getPoliDoctorSchedules(option.value);
  if (!dateInput.value) {
    availabilityText.textContent = poliSchedules.length
      ? "Dokter memiliki " + poliSchedules.length + " jadwal aktif pada poli ini. Pilih tanggal untuk melihat jam praktik."
      : "Tidak ditemukan baris jadwal aktif untuk kombinasi poli_id dan doctor_id ini. Admin perlu menyimpan jadwal pada poli yang dipilih.";
    return;
  }

  let matches = getSchedulesForSelectedDate(option.value);
  if (timeInput.value) {
    const requestedTime = timeInput.value.length === 5 ? timeInput.value + ":00" : timeInput.value;
    matches = matches.filter(function(item) {
      return String(item.start_time) <= requestedTime && String(item.end_time) > requestedTime;
    });
  }
  if (matches.length) {
    availabilityText.textContent = "Jadwal aktif: " + matches.map(function(item) {
      return String(item.start_time).slice(0,5) + "–" + String(item.end_time).slice(0,5) +
             " (kuota " + item.quota + ")";
    }).join(" | ");
  } else {
    availabilityText.textContent = "Dokter terdaftar pada poli ini, tetapi tidak ada jadwal aktif yang sesuai dengan tanggal/jam pilihan.";
  }
}
function filterDoctorsByPoli() {
  const selectedPoli = String(poliSelect.value || "");
  doctorSelect.value = "";
  feeInput.value = "";
  doctorInfo.hidden = true;
  doctorSelect.disabled = !selectedPoli;
  let visibleCount = 0;

  doctorOptions.forEach(function(option) {
    const hasSchedule = selectedPoli && getPoliDoctorSchedules(option.value).length > 0;
    option.hidden = !hasSchedule;
    option.disabled = !hasSchedule;
    if (hasSchedule) visibleCount++;
  });

  if (!selectedPoli) {
    doctorSelect.options[0].textContent = "Pilih poli terlebih dahulu";
    availabilityText.textContent = "Pilih poli untuk menampilkan dokter.";
  } else {
    doctorSelect.options[0].textContent = "Pilih dokter";
    availabilityText.textContent = visibleCount
      ? "Daftar dokter otomatis diambil dari jadwal aktif untuk poli yang dipilih."
      : "Belum ada jadwal aktif yang terhubung ke ID poli ini pada hms_doctor_schedules. Admin perlu menambahkan jadwal untuk poli dan dokter tersebut.";
  }
}
poliSelect.addEventListener("change", filterDoctorsByPoli);
doctorSelect.addEventListener("change", updateDoctorInformation);
dateInput.addEventListener("change", updateDoctorInformation);
timeInput.addEventListener("change", updateDoctorInformation);
timeInput.addEventListener("input", updateDoctorInformation);
filterDoctorsByPoli();
</script>';
hms_layout_footer($script);
?>
