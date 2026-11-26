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

// Repair jadwal lama yang masih aktif tetapi poli_id-nya NULL.
// Pemetaan hanya dilakukan jika spesialisasi dokter cocok tepat dengan satu Master Poli aktif
// (awalan "Poli " diabaikan). Tidak membuat jadwal baru dan tidak mengubah jadwal yang sudah terhubung.
if (hms_table_exists($con, 'hms_doctor_schedules') && hms_table_exists($con, 'hms_master_poli')) {
    $orphanSchedules = hms_fetch_all($con,
        "SELECT s.id, d.specilization
         FROM hms_doctor_schedules s
         JOIN doctors d ON d.id=s.doctor_id
         WHERE s.is_active=1 AND s.poli_id IS NULL"
    );
    foreach ($orphanSchedules as $orphan) {
        $specialization = trim((string)($orphan['specilization'] ?? ''));
        if ($specialization === '') continue;
        $matchingPolies = hms_fetch_all($con,
            "SELECT p.id
             FROM hms_master_poli p
             WHERE p.is_active=1
               AND LOWER(TRIM(REPLACE(p.poli_name,'poli ',''))) =
                   LOWER(TRIM(REPLACE(?,'poli ','')))
             LIMIT 2",
            's', array($specialization)
        );
        // Hindari pemetaan otomatis yang ambigu bila ada lebih dari satu poli dengan nama setara.
        if (count($matchingPolies) === 1) {
            hms_execute($con,
                'UPDATE hms_doctor_schedules SET poli_id=?, updated_at=NOW() WHERE id=? AND poli_id IS NULL',
                'ii', array((int)$matchingPolies[0]['id'], (int)$orphan['id'])
            );
        }
    }
}

$specialties = hms_fetch_all($con, "SELECT p.id,p.poli_code,p.poli_name\nFROM hms_master_poli p\nWHERE p.is_active=1\n  AND p.id=(\n      SELECT p2.id\n      FROM hms_master_poli p2\n      WHERE p2.is_active=1\n        AND LOWER(TRIM(p2.poli_name))=LOWER(TRIM(p.poli_name))\n      ORDER BY\n        (SELECT COUNT(*) FROM hms_doctor_schedules ds\n         WHERE ds.poli_id=p2.id AND ds.is_active=1) DESC,\n        p2.id ASC\n      LIMIT 1\n  )\nORDER BY p.poli_name ASC");
$doctors = hms_fetch_all($con, 'SELECT id, doctorName, specilization, docFees, address, contactno, docEmail FROM doctors ORDER BY doctorName ASC');
// Satukan ID Master Poli yang namanya sama untuk kebutuhan pencarian jadwal.
 // Jadwal lama dengan poli_id NULL dipetakan sementara melalui spesialisasi dokter.
 // Pemetaan ini hanya untuk pencarian/booking; tidak mengubah atau menghapus data lama.
$bookingSchedules = hms_fetch_all($con, "SELECT
        ds.poli_id,
        COALESCE(
            (SELECT p2.id
             FROM hms_master_poli p2
             WHERE p2.is_active=1
               AND LOWER(TRIM(p2.poli_name))=LOWER(TRIM(COALESCE(p.poli_name,d.specilization)))
             ORDER BY
               (SELECT COUNT(*) FROM hms_doctor_schedules sx
                WHERE sx.poli_id=p2.id AND sx.is_active=1) DESC,
               p2.id ASC
             LIMIT 1),
            ds.poli_id
        ) AS booking_poli_id,
        COALESCE(p.poli_name,d.specilization,'') AS schedule_poli_name,
        ds.doctor_id,ds.day_of_week,ds.available_date,ds.start_time,ds.end_time,ds.quota,
        COALESCE(ds.slot_duration_minutes,30) AS slot_duration_minutes,ds.is_active
    FROM hms_doctor_schedules ds
    LEFT JOIN hms_master_poli p ON p.id=ds.poli_id
    LEFT JOIN doctors d ON d.id=ds.doctor_id
    WHERE ds.is_active=1
    ORDER BY booking_poli_id,ds.doctor_id,ds.available_date,ds.start_time");

hms_layout_header('Book Janji Temu', 'patient', 'book');
?>
<div class="hms-page-title">
    <div>
        <h1>Book Janji Temu</h1>
        <div class="text-muted">Pilih poli dan dokter, lihat jadwal praktik, lalu masukkan tanggal serta jam kunjungan sesuai jadwal.</div>
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
                        <input class="form-control" type="time" id="apptime" name="apptime" required disabled>
                        <div class="form-text">Masukkan jam mulai kunjungan sesuai rentang jadwal praktik yang ditampilkan.</div>
                    </div>
                </div>
               
                <div class="mt-3" id="practiceSchedulePanel" hidden>
                    <div class="border rounded p-3 bg-light">
                        <div class="fw-semibold mb-2"><i class="bi bi-calendar-week me-1"></i>Jadwal Praktik Dokter</div>
                        <div id="practiceScheduleContent" class="small"></div>
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
const schedulePanel = document.getElementById("practiceSchedulePanel");
const scheduleContent = document.getElementById("practiceScheduleContent");
const schedules = ' . json_encode($bookingSchedules, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES) . ';
const doctorOptions = Array.from(doctorSelect.querySelectorAll("option")).slice(1);

function normalizePoliName(value) {
  return String(value || "").toLowerCase().trim().replace(/^poli\\s+/, "").replace(/\\s+/g, " ");
}
function getPoliDoctorSchedules(doctorId) {
  const selectedPoli = String(poliSelect.value || "");
  const selectedOption = poliSelect.options[poliSelect.selectedIndex];
  const selectedPoliName = normalizePoliName(selectedOption ? selectedOption.textContent : "");
  return schedules.filter(function(item) {
    const mappedPoliId = item.booking_poli_id === undefined || item.booking_poli_id === null ? item.poli_id : item.booking_poli_id;
    const sameId = String(mappedPoliId || "") === selectedPoli;
    const sameName = selectedPoliName !== "" && normalizePoliName(item.schedule_poli_name) === selectedPoliName;
    return (sameId || sameName) && String(item.doctor_id) === String(doctorId) && String(item.is_active === undefined ? 1 : item.is_active) === "1";
  });
}
function normalizeScheduleDate(value) {
  const raw = String(value || "").trim();
  if (!raw || raw === "0000-00-00" || raw.startsWith("0000-00-00 ")) return "";
  let match = raw.match(/^(\\d{4})-(\\d{1,2})-(\\d{1,2})/);
  if (match) {
    const y = Number(match[1]), m = Number(match[2]), d = Number(match[3]);
    if (y < 1900 || m < 1 || m > 12 || d < 1 || d > 31) return "";
    return String(y).padStart(4,"0") + "-" + String(m).padStart(2,"0") + "-" + String(d).padStart(2,"0");
  }
  match = raw.match(/^(\\d{1,2})[-/](\\d{1,2})[-/](\\d{4})$/);
  if (match) return match[3] + "-" + String(match[2]).padStart(2,"0") + "-" + String(match[1]).padStart(2,"0");
  return "";
}
function dateLabel(value) {
  const normalized = normalizeScheduleDate(value);
  return normalized ? normalized.split("-").reverse().join("-") : "Jadwal mingguan";
}
function getSchedulesForSelectedDate(list, date) {
  if (!date) return [];
  const parts = date.split("-").map(Number);
  const day = new Date(parts[0], parts[1]-1, parts[2]).getDay();
  return list.filter(function(item) {
    const specificDate = normalizeScheduleDate(item.available_date);
    return specificDate ? specificDate === date : Number(item.day_of_week) === day;
  });
}
function setTimeInputEnabled(enabled) {
  timeInput.disabled = !enabled;
  if (!enabled) timeInput.value = "";
}
function renderPracticeSchedule() {
  const doctorId = doctorSelect.value;
  const date = dateInput.value;
  scheduleContent.replaceChildren();
  schedulePanel.hidden = true;
  if (!doctorId) {
    setTimeInputEnabled(false);
    availabilityText.textContent = "Pilih dokter untuk melihat jadwal praktik.";
    return;
  }
  setTimeInputEnabled(true);
  const doctorSchedules = getPoliDoctorSchedules(doctorId);
  if (!doctorSchedules.length) {
    availabilityText.textContent = "Tidak ditemukan jadwal aktif untuk dokter dan poli ini.";
    return;
  }

  const matching = date ? getSchedulesForSelectedDate(doctorSchedules, date) : [];
  schedulePanel.hidden = false;
  const intro = document.createElement("div");
  intro.className = "text-muted mb-2";
  intro.textContent = date
    ? "Jadwal praktik dokter. Baris bertanda SESUAI TANGGAL cocok dengan tanggal yang dipilih."
    : "Daftar jadwal praktik aktif dokter. Pilih tanggal, kemudian masukkan jam berdasarkan rentang jadwal berikut.";
  scheduleContent.appendChild(intro);

  const dayNames = ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];
  doctorSchedules.forEach(function(item) {
    const specificDate = normalizeScheduleDate(item.available_date);
    const rowMatches = date ? getSchedulesForSelectedDate([item], date).length > 0 : false;
    const row = document.createElement("div");
    row.className = "border-bottom py-2" + (rowMatches ? " bg-light" : "");
    const heading = document.createElement("div");
    heading.className = "fw-semibold";
    const when = specificDate ? "Tanggal " + dateLabel(specificDate) : (dayNames[Number(item.day_of_week)] || "Jadwal mingguan");
    heading.textContent = when + " · " + String(item.start_time || "").slice(0,5) + "–" + String(item.end_time || "").slice(0,5);
    const meta = document.createElement("div");
    meta.className = "text-muted";
    meta.textContent = "Durasi " + Number(item.slot_duration_minutes || 30) + " menit · Kuota " + Number(item.quota || 0) + " pasien";
    row.appendChild(heading);
    row.appendChild(meta);
    if (date && rowMatches) {
      const match = document.createElement("span");
      match.className = "badge text-bg-success mt-1";
      match.textContent = "SESUAI TANGGAL";
      row.appendChild(match);
    }
    scheduleContent.appendChild(row);
  });

  if (date && matching.length) {
    availabilityText.textContent = "Jadwal ditemukan untuk tanggal " + dateLabel(date) + ". Silakan masukkan jam mulai di dalam rentang praktik yang sesuai.";
  } else if (date) {
    availabilityText.textContent = "Tanggal dipilih belum cocok dengan jadwal khusus atau hari praktik mingguan di atas. Periksa kembali tanggal jadwal.";
  } else {
    availabilityText.textContent = "Jadwal praktik ditampilkan. Pilih tanggal dan masukkan sendiri jam kunjungan berdasarkan rentang jadwal.";
  }
}
function updateDoctorInformation() {
  const option = doctorSelect.options[doctorSelect.selectedIndex];
  if (!option || !option.value) {
    feeInput.value = "";
    doctorInfo.hidden = true;
    schedulePanel.hidden = true;
    setTimeInputEnabled(false);
    return;
  }
  feeInput.value = option.dataset.fee || "";
  doctorInfo.hidden = false;
  doctorSpecInfo.textContent = "Spesialisasi: " + (option.dataset.specialization || "-");
  doctorAddressInfo.textContent = "Alamat praktik: " + (option.dataset.address || "-");
  doctorPhoneInfo.textContent = "Nomor kontak: " + (option.dataset.phone || "-");
  doctorEmailInfo.textContent = "Email: " + (option.dataset.email || "-");
  timeInput.value = "";
  renderPracticeSchedule();
}
function filterDoctorsByPoli() {
  const selectedPoli = String(poliSelect.value || "");
  doctorSelect.value = "";
  feeInput.value = "";
  doctorInfo.hidden = true;
  schedulePanel.hidden = true;
  timeInput.value = "";
  setTimeInputEnabled(false);
  doctorSelect.disabled = !selectedPoli;
  let visibleCount = 0;
  doctorOptions.forEach(function(option) {
    const hasSchedule = selectedPoli && getPoliDoctorSchedules(option.value).length > 0;
    option.hidden = !hasSchedule;
    option.disabled = !hasSchedule;
    if (hasSchedule) visibleCount++;
  });
  doctorSelect.options[0].textContent = selectedPoli ? "Pilih dokter" : "Pilih poli terlebih dahulu";
  availabilityText.textContent = !selectedPoli
    ? "Pilih poli untuk menampilkan dokter."
    : (visibleCount ? "Dokter ditampilkan berdasarkan jadwal aktif pada poli yang dipilih." : "Belum ada jadwal aktif untuk poli ini. Silakan hubungi admin.");
}
document.getElementById("bookingForm").addEventListener("submit", function(event) {
  if (!doctorSelect.value || !dateInput.value || !timeInput.value) {
    event.preventDefault();
    alert("Silakan pilih poli, dokter, tanggal, dan masukkan jam kunjungan.");
    return;
  }
  const list = getPoliDoctorSchedules(doctorSelect.value);
  const matches = getSchedulesForSelectedDate(list, dateInput.value);
  const minutes = Number(timeInput.value.slice(0,2))*60 + Number(timeInput.value.slice(3,5));
  const withinSchedule = matches.some(function(item) {
    const start = Number(String(item.start_time).slice(0,2))*60 + Number(String(item.start_time).slice(3,5));
    const end = Number(String(item.end_time).slice(0,2))*60 + Number(String(item.end_time).slice(3,5));
    const duration = Math.max(5, Number(item.slot_duration_minutes || 30));
    return minutes >= start && minutes < end && ((minutes-start) % duration === 0);
  });
  if (!withinSchedule) {
    event.preventDefault();
    alert("Jam yang dimasukkan tidak sesuai jadwal praktik pada tanggal tersebut. Silakan lihat rentang jadwal dokter.");
    timeInput.focus();
  }
});
poliSelect.addEventListener("change", filterDoctorsByPoli);
doctorSelect.addEventListener("change", updateDoctorInformation);
dateInput.addEventListener("input", renderPracticeSchedule);
dateInput.addEventListener("change", renderPracticeSchedule);
dateInput.addEventListener("blur", renderPracticeSchedule);
document.getElementById("refreshPracticeSchedule").addEventListener("click", function() {
  renderPracticeSchedule();
  if (!dateInput.value) {
    availabilityText.textContent = "Pilih tanggal janji temu untuk memeriksa jadwal pada tanggal tersebut.";
    dateInput.focus();
  }
});
filterDoctorsByPoli();
</script>';

hms_layout_footer($script);
?>
