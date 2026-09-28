<?php
if (!defined('HMS_HELPERS_LOADED')) {
    define('HMS_HELPERS_LOADED', true);

    // -------------------------------------------------------------------------
    // Bilingual UI: Indonesian is the default language.
    // The selected language is stored in the session and can be changed with
    // ?lang=id or ?lang=en. A new session always starts in Indonesian.
    // -------------------------------------------------------------------------
    function hms_init_language()
    {
        session();
        // Bahasa Indonesia adalah default untuk session baru.
        // Jika pengguna memilih EN/ID, pilihan tersebut dipertahankan selama session.
        // Versi distribusi ini menggunakan Bahasa Indonesia sebagai bahasa utama.
        // Jangan mewarisi pilihan bahasa EN dari session/cookie lama agar seluruh
        // halaman HMS konsisten berbahasa Indonesia setelah instalasi/update.
        $_SESSION['hms_lang'] = 'id';
        return 'id';
    }

    function hms_lang()
    {
        return hms_init_language();
    }

    function hms_language_url($lang)
    {
        $lang = ($lang === 'en') ? 'en' : 'id';
        $uri = isset($_SERVER['REQUEST_URI']) ? (string) $_SERVER['REQUEST_URI'] : '';
        $path = parse_url($uri, PHP_URL_PATH);
        if (!$path) {
            $path = isset($_SERVER['PHP_SELF']) ? (string) $_SERVER['PHP_SELF'] : '';
        }
        $query = isset($_GET) ? $_GET : array();
        $query['lang'] = $lang;
        return $path . '?' . http_build_query($query);
    }

    function hms_translation_dictionary()
    {
        static $dict = null;
        if ($dict !== null) return $dict;
        $dict = array(
            'Services'=>'Layanan','About'=>'Tentang','Gallery'=>'Galeri','Contact'=>'Kontak','Logins'=>'Login','Login'=>'Masuk','Log In'=>'Masuk','Logout'=>'Keluar',
            'Book Appointment'=>'Buat Janji Temu','Open Portal'=>'Buka Portal','Hospital Management System'=>'Sistem Manajemen Rumah Sakit',
            'Secure hospital workflow portal'=>'Portal alur kerja rumah sakit yang aman',
            'A responsive platform for patient appointments, doctor schedules, prescriptions, reports, and hospital communication.'=>'Platform responsif untuk janji temu pasien, jadwal dokter, resep, laporan, dan komunikasi rumah sakit.',
            'Appointments'=>'Janji Temu','Appointment'=>'Janji Temu','Patient'=>'Pasien','Doctor'=>'Dokter','Admin'=>'Admin','Dashboard'=>'Dasbor',
            'Availability'=>'Ketersediaan','Notifications'=>'Notifikasi','Audit Logs'=>'Log Audit','Doctors'=>'Dokter','Patients'=>'Pasien','Reports'=>'Laporan',
            'Prescriptions'=>'Resep','Medical History'=>'Riwayat Medis','Profile'=>'Profil','Search'=>'Cari','Choose the correct workspace for your role.'=>'Pilih ruang kerja yang sesuai dengan peran Anda.',
            'Portal Logins'=>'Login Portal','Patient Login'=>'Login Pasien','Doctor Login'=>'Login Dokter','Admin Login'=>'Login Admin',
            'Book appointments, track status, and download prescriptions.'=>'Buat janji temu, pantau status, dan unduh resep.',
            'Manage today appointments, prescriptions, and patient history.'=>'Kelola janji temu hari ini, resep, dan riwayat pasien.',
            'Monitor operations, reports, notifications, and audit logs.'=>'Pantau operasional, laporan, notifikasi, dan log audit.',
            'Key Services'=>'Layanan Utama','Designed for everyday hospital workflows and patient care coordination.'=>'Dirancang untuk alur kerja rumah sakit sehari-hari dan koordinasi perawatan pasien.',
            'Cardiology'=>'Kardiologi','Orthopaedic'=>'Ortopedi','Neurology'=>'Neurologi','Pharmacy Pipeline'=>'Layanan Farmasi','Prescription Records'=>'Rekam Resep','Quality Treatment'=>'Perawatan Berkualitas',
            'Hospital Gallery'=>'Galeri Rumah Sakit','A quick look at care spaces and services.'=>'Sekilas tentang ruang perawatan dan layanan rumah sakit.',
            'Secure access for hospital teams'=>'Akses aman untuk tim rumah sakit','Manage care workflows with clarity.'=>'Kelola alur perawatan dengan jelas.',
            'Janji temu, rekam pasien, resep, dan ketersediaan dokter terorganisasi dalam satu sistem responsif.'=>'Janji temu, rekam pasien, resep, dan ketersediaan dokter terorganisasi dalam satu sistem responsif.',
            'Track every status'=>'Pantau setiap status','Downloadable records'=>'Rekam yang dapat diunduh','Doctor schedules'=>'Jadwal dokter',
            'Email address'=>'Alamat email','Password'=>'Kata Sandi','Forgot password?'=>'Lupa kata sandi?','New patient?'=>'Pasien baru?','Create an account'=>'Buat akun',
            'Invalid request token.'=>'Token permintaan tidak valid.','Failed to connect to MySQL.'=>'Gagal terhubung ke MySQL.',
            'Indonesia'=>'Indonesia','English'=>'Inggris','Home'=>'Beranda','Services'=>'Layanan','About Us'=>'Tentang Kami','Contact Us'=>'Kontak Kami','Gallery'=>'Galeri','Login'=>'Masuk','Log In'=>'Masuk','Log Out'=>'Keluar','Profile'=>'Profil','Change Password'=>'Ubah Kata Sandi','Save Changes'=>'Simpan Perubahan','Add'=>'Tambah','Create'=>'Buat','Close'=>'Tutup','Open'=>'Buka','Confirm'=>'Konfirmasi','Yes'=>'Ya','No'=>'Tidak','Submit'=>'Kirim','Send'=>'Kirim','Message'=>'Pesan','Name'=>'Nama','Full Name'=>'Nama Lengkap','Email'=>'Email','Email Address'=>'Alamat Email','Mobile number'=>'Nomor Telepon','Phone Number'=>'Nomor Telepon','Password'=>'Kata Sandi','New Password'=>'Kata Sandi Baru','Current Password'=>'Kata Sandi Saat Ini','Forgot Password'=>'Lupa Kata Sandi','Search'=>'Cari','Filter'=>'Filter','Download'=>'Unduh','Print'=>'Cetak','Export'=>'Ekspor','View Details'=>'Lihat Detail','Details'=>'Detail','Edit'=>'Edit','Delete'=>'Hapus','Update'=>'Perbarui','Cancel'=>'Batal','Back'=>'Kembali','Next'=>'Berikutnya','Previous'=>'Sebelumnya','Status'=>'Status','Date'=>'Tanggal','Time'=>'Waktu','Today'=>'Hari Ini','Tomorrow'=>'Besok','Patient'=>'Pasien','Patients'=>'Pasien','Doctor'=>'Dokter','Doctors'=>'Dokter','Administrator'=>'Administrator','Admin'=>'Administrator','Dashboard'=>'Dasbor','Appointments'=>'Janji Temu','Book Appointment'=>'Buat Janji Temu','Book Appointment Now'=>'Buat Janji Temu Sekarang','Medical History'=>'Riwayat Medis','Prescriptions'=>'Resep','Reports'=>'Laporan','Notifications'=>'Notifikasi','Availability'=>'Ketersediaan','Audit Logs'=>'Log Audit','Manage'=>'Kelola','Settings'=>'Pengaturan','Welcome'=>'Selamat Datang','Welcome Back'=>'Selamat Datang Kembali','Please wait'=>'Silakan tunggu','Loading'=>'Memuat','Success'=>'Berhasil','Error'=>'Kesalahan','Warning'=>'Peringatan','No data found'=>'Data tidak ditemukan','No records found'=>'Data tidak ditemukan','Required'=>'Wajib diisi','Submit'=>'Kirim','Save'=>'Simpan','Cancel'=>'Batal','Edit'=>'Edit','Delete'=>'Hapus','Update'=>'Perbarui','View'=>'Lihat','Back'=>'Kembali','Next'=>'Berikutnya','Previous'=>'Sebelumnya','Actions'=>'Aksi','Status'=>'Status','Date'=>'Tanggal','Time'=>'Waktu','Name'=>'Nama','Email'=>'Email','Phone'=>'Telepon','Address'=>'Alamat','Description'=>'Deskripsi'
        );
        $dict = array_merge($dict, array(
            'Admin Dashboard' => 'Dasbor Admin',
            'Operational overview, appointment flow, and recent activity.' => 'Ringkasan operasional, alur janji temu, dan aktivitas terbaru.',
            'Manage Appointments' => 'Kelola Janji Temu',
            'Doctor Availability' => 'Ketersediaan Dokter',
            'Registered Users' => 'Pengguna Terdaftar',
            'Patient Records' => 'Rekam Pasien',
            'New Queries' => 'Pertanyaan Baru',
            'Appointment Status' => 'Status Janji Temu',
            'Pending, approved, completed, and cancelled appointments.' => 'Janji temu menunggu, disetujui, selesai, dan dibatalkan.',
            'total' => 'total',
            'Signals' => 'Indikator',
            'Unread notifications' => 'Notifikasi belum dibaca',
            'New contact queries' => 'Pertanyaan kontak baru',
            'Audit logging' => 'Pencatatan audit',
            'Enabled' => 'Aktif',
            'Migration needed' => 'Migrasi diperlukan',
            'View Notifications' => 'Lihat Notifikasi',
            'Recent Appointments' => 'Janji Temu Terbaru',
            'View All' => 'Lihat Semua',
            'Fee' => 'Biaya',
            'No appointments yet.' => 'Belum ada janji temu.',
            'Recent Activity' => 'Aktivitas Terbaru',
            'Today’s Appointments' => 'Janji Temu Hari Ini',
            'Search' => 'Cari',
            'Record' => 'Catat',
            'No appointments scheduled for today.' => 'Tidak ada janji temu yang dijadwalkan hari ini.',
            'Follow-ups' => 'Tindak Lanjut',
            'Patient Dashboard' => 'Dasbor Pasien',
            'Track appointments, prescriptions, and medical history.' => 'Pantau janji temu, resep, dan riwayat medis.',
            'Total Appointments' => 'Total Janji Temu',
            'Medical Records' => 'Rekam Medis',
            'Next Appointment' => 'Janji Temu Berikutnya',
            'at' => 'pukul',
            'No upcoming appointment. You can book one when you are ready.' => 'Belum ada janji temu berikutnya. Anda dapat membuat janji saat siap.',
            'Track Status' => 'Pantau Status',
            'Medical History Timeline' => 'Linimasa Riwayat Medis',
            'prescriptions' => 'resep',
            'No appointments found.' => 'Tidak ada janji temu ditemukan.',
            'Manage Patients' => 'Kelola Pasien',
            'Review patient records entered by doctors.' => 'Tinjau rekam pasien yang dimasukkan oleh dokter.',
            'Advanced Search' => 'Pencarian Lanjutan',
            'Patients' => 'Pasien',
            'Patient' => 'Pasien',
            'Doctor' => 'Dokter',
            'Contact' => 'Kontak',
            'Gender' => 'Jenis Kelamin',
            'Created' => 'Dibuat',
            'Updated' => 'Diperbarui',
            'Action' => 'Aksi',
            'Not assigned' => 'Belum ditugaskan',
            'Not updated' => 'Belum diperbarui',
            'No patients found.' => 'Tidak ada pasien ditemukan.',
            'Manage Doctors' => 'Kelola Dokter',
            'Search, update, and manage registered doctors.' => 'Cari, perbarui, dan kelola dokter terdaftar.',
            'Add Doctor' => 'Tambah Dokter',
            'Doctors' => 'Dokter',
            'Specialization' => 'Spesialisasi',
            'Email' => 'Email',
            'No doctors found.' => 'Tidak ada dokter ditemukan.',
            'Edit Doctor' => 'Edit Dokter',
            'Update doctor profile, contact, and fee details.' => 'Perbarui profil, kontak, dan biaya dokter.',
            'Update Doctor' => 'Perbarui Dokter',
            'Doctor name' => 'Nama dokter',
            'Consultancy fees' => 'Biaya konsultasi',
            'Clinic address' => 'Alamat klinik',
            'Doctor Session Logs' => 'Log Sesi Dokter',
            'Track doctor login attempts and logout timestamps.' => 'Pantau percobaan masuk dan waktu keluar dokter.',
            'Doctor Login Logs' => 'Log Masuk Dokter',
            'Doctor ID' => 'ID Dokter',
            'No doctor logs found.' => 'Tidak ada log dokter ditemukan.',
            'Admin schedule control for all doctors.' => 'Pengaturan jadwal admin untuk seluruh dokter.',
            'Schedules' => 'Jadwal',
            'Add Slot' => 'Tambah Slot',
            'Weekly Day' => 'Hari Mingguan',
            'Specific Date' => 'Tanggal Tertentu',
            'Start' => 'Mulai',
            'End' => 'Selesai',
            'Slot Minutes' => 'Durasi Slot (Menit)',
            'Max Bookings' => 'Maksimal Pendaftaran',
            'Save Slot' => 'Simpan Slot',
            'Day / Date' => 'Hari / Tanggal',
            'Capacity' => 'Kapasitas',
            'min / booking(s)' => 'menit / pendaftaran',
            'Remove' => 'Hapus',
            'No availability slots found.' => 'Tidak ada slot ketersediaan ditemukan.',
            'Patient Search' => 'Pencarian Pasien',
            'Find patient records by name or mobile number.' => 'Cari rekam pasien berdasarkan nama atau nomor telepon.',
            'Name or mobile number' => 'Nama atau nomor telepon',
            'Results for' => 'Hasil untuk',
            'No patient matched this search.' => 'Tidak ada pasien yang sesuai dengan pencarian.',
            'Appointment Management' => 'Manajemen Janji Temu',
            'Approve, complete, cancel, filter, and export appointments.' => 'Setujui, selesaikan, batalkan, filter, dan ekspor janji temu.',
            'From' => 'Dari',
            'To' => 'Sampai',
            'result(s)' => 'hasil',
            'No appointments match the selected filters.' => 'Tidak ada janji temu yang sesuai dengan filter yang dipilih.',
            'Audit Logs' => 'Log Audit',
            'Track sensitive workflow changes and security-relevant actions.' => 'Pantau perubahan alur kerja penting dan aktivitas terkait keamanan.',
            'Entity' => 'Entitas',
            'IP' => 'IP',
            'No audit events found.' => 'Tidak ada aktivitas audit ditemukan.',
            'Notifications' => 'Notifikasi',
            'New appointment requests, contact queries, and workflow alerts.' => 'Permintaan janji temu baru, pertanyaan kontak, dan peringatan alur kerja.',
            'Mark All Read' => 'Tandai Semua Dibaca',
            'System Notifications' => 'Notifikasi Sistem',
            'New' => 'Baru',
            'Read' => 'Dibaca',
            'No system notifications yet.' => 'Belum ada notifikasi sistem.',
            'Unread Queries' => 'Pertanyaan Belum Dibaca',
            'Open Queries' => 'Buka Pertanyaan',
            'View query' => 'Lihat pertanyaan',
            'No unread contact queries.' => 'Tidak ada pertanyaan kontak yang belum dibaca.',
            'Read Queries' => 'Pertanyaan Sudah Dibaca',
            'Handled Queries' => 'Pertanyaan Ditangani',
            'No read queries.' => 'Tidak ada pertanyaan yang sudah dibaca.',
            'Query Details' => 'Detail Pertanyaan',
            'Review and respond to a public contact query.' => 'Tinjau dan tanggapi pertanyaan kontak publik.',
            'Back to Queries' => 'Kembali ke Pertanyaan',
            'Submitted Query' => 'Pertanyaan Masuk',
            'Full name' => 'Nama lengkap',
            'Query date' => 'Tanggal pertanyaan',
            'Admin Remark' => 'Catatan Admin',
            'Response note' => 'Catatan tanggapan',
            'Save Remark' => 'Simpan Catatan',
            'Last updated:' => 'Terakhir diperbarui:',
            'Not available' => 'Tidak tersedia',
            'Manage Users' => 'Kelola Pengguna',
            'Review registered patient login accounts.' => 'Tinjau akun masuk pasien yang terdaftar.',
            'Patient Accounts' => 'Akun Pasien',
            'No users found.' => 'Tidak ada pengguna ditemukan.',
            'About Us Content' => 'Konten Tentang Kami',
            'Update the public website About section.' => 'Perbarui bagian Tentang Kami pada situs publik.',
            'Edit Specialization' => 'Edit Spesialisasi',
            'Update the specialization name used in doctor profiles.' => 'Perbarui nama spesialisasi yang digunakan pada profil dokter.',
            'Back to Specializations' => 'Kembali ke Spesialisasi',
            'Maintain the list of services used by doctor profiles.' => 'Kelola daftar layanan yang digunakan pada profil dokter.',
            'Add Specialization' => 'Tambah Spesialisasi',
            'Specializations' => 'Spesialisasi',
            'No specializations found.' => 'Tidak ada spesialisasi ditemukan.',
            'Between Dates Report' => 'Laporan Berdasarkan Rentang Tanggal',
            'Generate a patient registration report for a selected date range.' => 'Buat laporan pendaftaran pasien berdasarkan rentang tanggal yang dipilih.',
            'From date' => 'Dari tanggal',
            'To date' => 'Sampai tanggal',
            'Generate Report' => 'Buat Laporan',
            'Patient Details' => 'Detail Pasien',
            'Administrative view of patient record and medical history.' => 'Tampilan administratif rekam pasien dan riwayat medis.',
            'Add History' => 'Tambah Riwayat',
            'Gender / Age' => 'Jenis Kelamin / Usia',
            'Initial History' => 'Riwayat Awal',
            'Medical History' => 'Riwayat Medis',
            'No medical history added yet.' => 'Belum ada riwayat medis yang ditambahkan.',
            'Add Medical History' => 'Tambah Riwayat Medis',
            'Blood Pressure' => 'Tekanan Darah',
            'Blood Sugar' => 'Gula Darah',
            'Weight' => 'Berat Badan',
            'Temperature' => 'Suhu Tubuh',
            'Prescription / Notes' => 'Resep / Catatan',
            'Close' => 'Tutup',
            'Back to Patients' => 'Kembali ke Pasien',
            'Back to Doctors' => 'Kembali ke Dokter',
            'Back to website' => 'Kembali ke situs',
            'Username' => 'Nama Pengguna',
            'Update Password' => 'Perbarui Kata Sandi',
            'Current password' => 'Kata sandi saat ini',
            'New password' => 'Kata sandi baru',
            'Confirm password' => 'Konfirmasi kata sandi',
            'Change Password' => 'Ubah Kata Sandi',
            'Save' => 'Simpan',
            'Log in' => 'Masuk',
            'Log In' => 'Masuk',
            'Log Out' => 'Keluar',
            'Create Account' => 'Buat Akun',
            'Forgot password?' => 'Lupa kata sandi?',
            'Continue' => 'Lanjutkan',
            'Remembered it?' => 'Sudah ingat?',
            'Registered email' => 'Email terdaftar',
            'New patient?' => 'Pasien baru?',
            'Create an account' => 'Buat akun',
            'Hospital Management System' => 'Sistem Informasi Manajemen Rumah Sakit',
            'Secure access for hospital teams' => 'Akses aman untuk tim rumah sakit',
            'Manage care workflows with clarity.' => 'Kelola alur pelayanan dengan jelas.',
            'Track every status' => 'Pantau setiap status',
            'Downloadable records' => 'Rekam yang dapat diunduh',
            'Doctor schedules' => 'Jadwal dokter',
            'Profile Activity' => 'Aktivitas Profil',
            'Registered' => 'Terdaftar',
            'Last updated' => 'Terakhir diperbarui',
            'My Appointments' => 'Janji Temu Saya',
            'Doctor Specialization' => 'Spesialisasi Dokter',
            'Select specialization' => 'Pilih spesialisasi',
            'Select doctor' => 'Pilih dokter',
            'Consultancy Fee' => 'Biaya Konsultasi',
            'Appointment Date' => 'Tanggal Janji Temu',
            'Appointment Time' => 'Waktu Janji Temu',
            'Submit Request' => 'Kirim Permintaan',
            'Before Booking' => 'Sebelum Membuat Janji',
            'New requests start here.' => 'Permintaan baru dimulai di sini.',
            'Approved' => 'Disetujui',
            'Admin or doctor confirms the visit.' => 'Admin atau dokter mengonfirmasi kunjungan.',
            'Doctor adds diagnosis and prescription.' => 'Dokter menambahkan diagnosis dan resep.',
            'Track status, reschedule visits, cancel when needed, and download prescriptions.' => 'Pantau status, jadwalkan ulang kunjungan, batalkan bila diperlukan, dan unduh resep.',
            'Appointment History' => 'Riwayat Janji Temu',
            'Actions' => 'Aksi',
            'Reschedule' => 'Jadwalkan Ulang',
            'Reschedule Appointment' => 'Jadwalkan Ulang Janji Temu',
            'New Date' => 'Tanggal Baru',
            'New Time' => 'Waktu Baru',
            'Reason' => 'Alasan',
            'Submit' => 'Kirim',
            'Update Profile' => 'Perbarui Profil',
            'Save Profile' => 'Simpan Profil',
            'Keep your patient contact and address details current.' => 'Pastikan data kontak dan alamat pasien selalu terbaru.',
            'Update email address' => 'Perbarui alamat email',
            'Timeline' => 'Linimasa',
            'File' => 'Berkas',
            'Profile Summary' => 'Ringkasan Profil',
            'Linked patient records' => 'Rekam pasien yang terhubung',
            'No medical history records found yet.' => 'Belum ada rekam riwayat medis.',
            'This email is used for patient login and appointment communication.' => 'Email ini digunakan untuk masuk pasien dan komunikasi janji temu.',
            'Current email' => 'Email saat ini',
            'New email' => 'Email baru',
            'Page title' => 'Judul halaman',
            'Page description' => 'Deskripsi halaman',
            'Save Content' => 'Simpan Konten',
            'Specialization name' => 'Nama spesialisasi',
            'Registration successful. The patient can log in now.' => 'Pendaftaran berhasil. Pasien sekarang dapat masuk.',
            'Patient Registration' => 'Pendaftaran Pasien',
            'Create Patient Account' => 'Buat Akun Pasien',
            'Register a patient account with secure password storage.' => 'Daftarkan akun pasien dengan penyimpanan kata sandi yang aman.',
            'Select gender' => 'Pilih jenis kelamin',
            'Female' => 'Perempuan',
            'Male' => 'Laki-laki',
            'Other' => 'Lainnya',
            'Email address' => 'Alamat email',
            'Mobile number' => 'Nomor telepon',
            'Address' => 'Alamat',
            'City' => 'Kota',
            'No data found' => 'Data tidak ditemukan',
            'No records found' => 'Data tidak ditemukan',
            'Required' => 'Wajib diisi',
            'Invalid username or password.' => 'Nama pengguna atau kata sandi tidak valid.',
            'Doctor not found.' => 'Dokter tidak ditemukan.',
            'Doctor details updated successfully.' => 'Data dokter berhasil diperbarui.',
            'Doctor deleted successfully.' => 'Dokter berhasil dihapus.',
            'Patient record not found.' => 'Rekam pasien tidak ditemukan.',
            'Medical history added.' => 'Riwayat medis berhasil ditambahkan.',
            'User deleted successfully.' => 'Pengguna berhasil dihapus.',
            'Notifications updated.' => 'Notifikasi berhasil diperbarui.',
            'Success' => 'Berhasil',
            'Failed' => 'Gagal',
            'Active / not recorded' => 'Aktif / belum tercatat',
            'No user logs found.' => 'Tidak ada log pengguna ditemukan.',
            'Password and confirm password do not match.' => 'Kata sandi dan konfirmasi kata sandi tidak cocok.',
            'This email is already registered.' => 'Email ini sudah terdaftar.',
            'Please enter all required registration details.' => 'Silakan isi semua data pendaftaran yang wajib.',
            'Unable to complete registration.' => 'Pendaftaran tidak dapat diselesaikan.',
            'Log Audit' => 'Log Audit',
            'CSV' => 'CSV',
            'PDF' => 'PDF',
            'All' => 'Semua',
            'Export' => 'Ekspor',
            'Download' => 'Unduh',
            'Print' => 'Cetak',
            'Details' => 'Detail',
            'Edit' => 'Edit',
            'Delete' => 'Hapus',
            'Update' => 'Perbarui',
            'Cancel' => 'Batal',
            'Back' => 'Kembali',
            'Next' => 'Berikutnya',
            'Previous' => 'Sebelumnya',
            'Yes' => 'Ya',
            'No' => 'Tidak',
            'Open' => 'Buka',
            'Confirm' => 'Konfirmasi',
            'Manage' => 'Kelola',
            'Settings' => 'Pengaturan',
            'Welcome' => 'Selamat Datang',
            'Welcome Back' => 'Selamat Datang Kembali',
            'Please wait' => 'Silakan tunggu',
            'Loading' => 'Memuat',
            'Warning' => 'Peringatan',
            'Error' => 'Kesalahan',
            'Save Changes' => 'Simpan Perubahan',
            'Follow-up Date' => 'Tanggal Tindak Lanjut',
            'Not set' => 'Belum diatur',
            'Diagnosis' => 'Diagnosis',
            'Prescription' => 'Resep',
            'Age' => 'Usia',
            'Patient name' => 'Nama pasien',
            'Medical history' => 'Riwayat medis',
            'Update Email' => 'Perbarui Email',
            'Add Patient' => 'Tambah Pasien',
            'Medical History Details' => 'Detail Riwayat Medis',
            'Read-only patient record and visit history.' => 'Rekam pasien dan riwayat kunjungan hanya untuk dibaca.',
            'Back to Timeline' => 'Kembali ke Linimasa',
            'No visit history has been recorded yet.' => 'Belum ada riwayat kunjungan yang tercatat.',
            'Registered full name' => 'Nama lengkap terdaftar',
            'Choose a doctor, review availability, and submit a pending appointment request.' => 'Pilih dokter, tinjau ketersediaan, lalu kirim permintaan janji temu.',
            'Select a doctor to view availability.' => 'Pilih dokter untuk melihat ketersediaan.',
            'Availability is checked again when you submit, so another patient cannot take the same slot silently.' => 'Ketersediaan akan diperiksa kembali saat dikirim agar slot tidak diambil pasien lain tanpa pemberitahuan.',
            'Date / Time' => 'Tanggal / Waktu',
            'Use a unique password to keep your patient account secure.' => 'Gunakan kata sandi yang unik untuk menjaga keamanan akun pasien.',
            'Timeline of patient records, visits, and prescriptions.' => 'Linimasa rekam pasien, kunjungan, dan resep.',
            'Already registered?' => 'Sudah terdaftar?',
            'Contact number' => 'Nomor Telepon',
            'IP Address' => 'Alamat IP',
            'Login Time' => 'Waktu Masuk',
            'Logout Time' => 'Waktu Keluar',
            'Results for "' => 'Hasil untuk "',
            'Create a doctor login and profile.' => 'Buat akun masuk dan profil dokter.',
            'Protect the administrator account with a strong password.' => 'Lindungi akun administrator dengan kata sandi yang kuat.',
            'Contact Content' => 'Konten Kontak',
            'Update the public website contact details.' => 'Perbarui informasi kontak pada situs publik.',
            'Patient Date Report' => 'Laporan Pasien Berdasarkan Tanggal',
            'Report from to .' => 'Laporan dari tanggal sampai tanggal.',
            'Change Dates' => 'Ubah Tanggal',
            'No patients found for this date range.' => 'Tidak ada pasien ditemukan pada rentang tanggal ini.',
            'Back to admin login' => 'Kembali ke masuk admin',
            'Review contact queries that already have an admin response.' => 'Tinjau pertanyaan kontak yang sudah mendapat tanggapan admin.',
            'Review new public contact form submissions.' => 'Tinjau kiriman formulir kontak publik yang baru.',
            'Track patient login attempts and logout timestamps.' => 'Pantau percobaan masuk pasien dan waktu keluar.',
            'Patient Login Logs' => 'Log Masuk Pasien',
            'View, update, and review patients assigned to you.' => 'Lihat, perbarui, dan tinjau pasien yang ditugaskan kepada Anda.',
            'Patient List' => 'Daftar Pasien',
            'Registered contact number' => 'Nomor kontak terdaftar',
            'Diagnosis, treatment notes, and medical history timeline.' => 'Diagnosis, catatan perawatan, dan linimasa riwayat medis.',
            'Create a patient record under your doctor account.' => 'Buat rekam pasien pada akun dokter Anda.',
            'Select' => 'Pilih',
            'Edit Patient' => 'Edit Pasien',
            'Update patient profile and baseline medical history.' => 'Perbarui profil pasien dan riwayat medis awal.',
            'Update Patient' => 'Perbarui Pasien',
            'Review today’s visits, approve pending requests, complete visits, and open prescriptions.' => 'Tinjau kunjungan hari ini, setujui permintaan tertunda, selesaikan kunjungan, dan buka resep.',
            'Doctor Dashboard' => 'Dasbor Dokter',
            'Today’s schedule, prescription work, and follow-up planning.' => 'Jadwal hari ini, pekerjaan resep, dan perencanaan tindak lanjut.',
            'No follow-up appointments recorded yet.' => 'Belum ada janji temu tindak lanjut yang tercatat.',
            'Search Patients' => 'Cari Pasien',
            'Find patients by name or mobile number.' => 'Cari pasien berdasarkan nama atau nomor telepon.',
            'Record diagnosis, treatment, medicines, and follow-up dates.' => 'Catat diagnosis, perawatan, obat, dan tanggal tindak lanjut.',
            'The prescriptions table is not installed yet. Apply' => 'Tabel resep belum terpasang. Terapkan',
            'Prescription Details' => 'Detail Resep',
            'Appointment' => 'Janji Temu',
            'Select appointment' => 'Pilih janji temu',
            'Save Prescription' => 'Simpan Resep',
            'Follow-up' => 'Tindak Lanjut',
            'No prescriptions saved yet.' => 'Belum ada resep yang disimpan.',
            'Update your specialization, clinic address, and contact details.' => 'Perbarui spesialisasi, alamat klinik, dan informasi kontak Anda.',
            'Set weekly or date-specific slots that patients can book.' => 'Atur slot mingguan atau berdasarkan tanggal yang dapat dipesan pasien.',
            'Optional. Use it for one-day overrides.' => 'Opsional. Gunakan untuk pengaturan khusus satu hari.',
            'Current Slots' => 'Slot Saat Ini',
            'Open navigation' => 'Buka navigasi',
            'Results for' => 'Hasil untuk',
            'Protect your doctor account with a strong password.' => 'Lindungi akun dokter Anda dengan kata sandi yang kuat.',
            'Apply the SQL migration to start recording audit activity.' => 'Terapkan migrasi SQL untuk mulai mencatat aktivitas audit.',
            'The notifications table is not installed yet. Apply' => 'Tabel notifikasi belum terpasang. Terapkan',
            'first.' => 'terlebih dahulu.',
            'The audit_logs table is not installed yet. Apply' => 'Tabel audit_logs belum terpasang. Terapkan',
            'The doctor availability table is not installed yet. Apply' => 'Tabel ketersediaan dokter belum terpasang. Terapkan',
            'Delete this doctor?' => 'Hapus dokter ini?',
            'Delete this patient?' => 'Hapus pasien ini?',
            'Delete this user account?' => 'Hapus akun pengguna ini?',
            'Search doctors...' => 'Cari dokter...',
            'Search patients...' => 'Cari pasien...',
            'Search users...' => 'Cari pengguna...',
            'Search queries...' => 'Cari pertanyaan...',
            'Search logs...' => 'Cari log...',
            'No unread queries.' => 'Tidak ada pertanyaan yang belum dibaca.',
            'No unread contact queries.' => 'Tidak ada pertanyaan kontak yang belum dibaca.',
            'No appointments yet.' => 'Belum ada janji temu.',
            'No appointments scheduled for today.' => 'Tidak ada janji temu yang dijadwalkan hari ini.'
        ));
        $dict = array_merge($dict, array(
            'Hospital Management System' => 'Sistem Informasi Manajemen Rumah Sakit',
            'Admin Dashboard' => 'Dasbor Admin',
            'Patient Dashboard' => 'Dasbor Pasien',
            'Doctor Dashboard' => 'Dasbor Dokter',
            'Manage Appointments' => 'Kelola Janji Temu',
            'Doctor Availability' => 'Ketersediaan Dokter',
            'Registered Users' => 'Pengguna Terdaftar',
            'Patient Records' => 'Rekam Pasien',
            'New Queries' => 'Pertanyaan Baru',
            'Appointment Status' => 'Status Janji Temu',
            'Pending, approved, completed, and cancelled appointments.' => 'Janji temu menunggu, disetujui, selesai, dan dibatalkan.',
            'Pending' => 'Menunggu',
            'Approved' => 'Disetujui',
            'Completed' => 'Selesai',
            'Cancelled' => 'Dibatalkan',
            'Signals' => 'Indikator',
            'Unread notifications' => 'Notifikasi belum dibaca',
            'New contact queries' => 'Pertanyaan kontak baru',
            'Audit logging' => 'Pencatatan audit',
            'Enabled' => 'Aktif',
            'Migration needed' => 'Migrasi diperlukan',
            'View Notifications' => 'Lihat Notifikasi',
            'Recent Appointments' => 'Janji Temu Terbaru',
            'View All' => 'Lihat Semua',
            'Recent Activity' => 'Aktivitas Terbaru',
            'No appointments yet.' => 'Belum ada janji temu.',
            'No appointments found.' => 'Tidak ada janji temu ditemukan.',
            'No patients found.' => 'Tidak ada pasien ditemukan.',
            'No doctors found.' => 'Tidak ada dokter ditemukan.',
            'No users found.' => 'Tidak ada pengguna ditemukan.',
            'No doctor logs found.' => 'Tidak ada log dokter ditemukan.',
            'No availability slots found.' => 'Tidak ada slot ketersediaan ditemukan.',
            'No prescriptions saved yet.' => 'Belum ada resep yang disimpan.',
            'No medical history records found yet.' => 'Belum ada rekam riwayat medis.',
            'No medical history added yet.' => 'Belum ada riwayat medis yang ditambahkan.',
            'No visit history has been recorded yet.' => 'Belum ada riwayat kunjungan yang dicatat.',
            'Medical History Details' => 'Detail Riwayat Medis',
            'Patient Details' => 'Detail Pasien',
            'Administrative view of patient record and medical history.' => 'Tampilan administratif rekam pasien dan riwayat medis.',
            'Add History' => 'Tambah Riwayat',
            'Add Medical History' => 'Tambah Riwayat Medis',
            'Prescription / Notes' => 'Resep / Catatan',
            'Back to Timeline' => 'Kembali ke Linimasa',
            'Back to Patients' => 'Kembali ke Pasien',
            'Back to Doctors' => 'Kembali ke Dokter',
            'Back to Queries' => 'Kembali ke Pertanyaan',
            'Back to website' => 'Kembali ke situs',
            'Edit Doctor' => 'Edit Dokter',
            'Edit Profile' => 'Edit Profil',
            'Update doctor profile, contact, and fee details.' => 'Perbarui profil dokter, kontak, dan rincian biaya.',
            'Update your specialization, clinic address, and contact details.' => 'Perbarui spesialisasi, alamat klinik, dan data kontak Anda.',
            'Doctor name' => 'Nama dokter',
            'Specialization' => 'Spesialisasi',
            'Profile Activity' => 'Aktivitas Profil',
            'Doctor Session Logs' => 'Log Sesi Dokter',
            'Doctor Login Logs' => 'Log Masuk Dokter',
            'Doctor ID' => 'ID Dokter',
            'IP Address' => 'Alamat IP',
            'Login Time' => 'Waktu Masuk',
            'Logout Time' => 'Waktu Keluar',
            'Success' => 'Berhasil',
            'Failed' => 'Gagal',
            'Manage Patients' => 'Kelola Pasien',
            'Manage Doctors' => 'Kelola Dokter',
            'Manage Users' => 'Kelola Pengguna',
            'Search patients...' => 'Cari pasien...',
            'Search doctors...' => 'Cari dokter...',
            'Search users...' => 'Cari pengguna...',
            'Search queries...' => 'Cari pertanyaan...',
            'Search logs...' => 'Cari log...',
            'Search report...' => 'Cari laporan...',
            'Search appointments' => 'Cari janji temu',
            'Search timeline' => 'Cari linimasa',
            'Search' => 'Cari',
            'Update Profile' => 'Perbarui Profil',
            'Update Email' => 'Perbarui Email',
            'New email' => 'Email baru',
            'Registered full name' => 'Nama lengkap terdaftar',
            'Registered email' => 'Email terdaftar',
            'New password' => 'Kata sandi baru',
            'Current password' => 'Kata sandi saat ini',
            'Confirm password' => 'Konfirmasi kata sandi',
            'Address' => 'Alamat',
            'Gender' => 'Jenis Kelamin',
            'Email address' => 'Alamat email',
            'Phone Number' => 'Nomor Telepon',
            'Fee' => 'Biaya',
            'Date' => 'Tanggal',
            'Time' => 'Waktu',
            'Created At' => 'Dibuat Pada',
            'Add Slot' => 'Tambah Slot',
            'Specific Date' => 'Tanggal Tertentu',
            'Save Slot' => 'Simpan Slot',
            'Day / Date' => 'Hari / Tanggal',
            'Appointment Management' => 'Manajemen Janji Temu',
            'Approve, complete, cancel, filter, and export appointments.' => 'Setujui, selesaikan, batalkan, filter, dan ekspor janji temu.',
            'From' => 'Dari',
            'To' => 'Sampai',
            'result(s)' => 'hasil',
            'Generate Report' => 'Buat Laporan',
            'Between Dates Report' => 'Laporan Berdasarkan Rentang Tanggal',
            'From date' => 'Dari tanggal',
            'To date' => 'Sampai tanggal',
            'Query Details' => 'Detail Pertanyaan',
            'Submitted Query' => 'Pertanyaan Masuk',
            'Query date' => 'Tanggal pertanyaan',
            'Admin Remark' => 'Catatan Admin',
            'Response note' => 'Catatan tanggapan',
            'Save Remark' => 'Simpan Catatan',
            'System Notifications' => 'Notifikasi Sistem',
            'Mark All Read' => 'Tandai Semua Dibaca',
            'Read' => 'Dibaca',
            'New' => 'Baru',
            'View query' => 'Lihat pertanyaan',
            'Track Status' => 'Pantau Status',
            'Medical History Timeline' => 'Linimasa Riwayat Medis',
            'Next Appointment' => 'Janji Temu Berikutnya',
            'Total Appointments' => 'Total Janji Temu',
            'Medical Records' => 'Rekam Medis',
            'Book Appointment' => 'Buat Janji Temu',
            'My Appointments' => 'Janji Temu Saya',
            'Today’s Appointments' => 'Janji Temu Hari Ini',
            'Doctor Appointments' => 'Janji Temu Dokter',
            'Search Patients' => 'Cari Pasien',
            'No patient matched this search.' => 'Tidak ada pasien yang sesuai dengan pencarian.',
            'Select Doctor' => 'Pilih Dokter',
            'Email already exists.' => 'Email sudah terdaftar.',
            'Email available for registration.' => 'Email tersedia untuk pendaftaran.',
            'Availability' => 'Ketersediaan',
            'Available' => 'Tersedia',
            'Unavailable' => 'Tidak Tersedia',
            'Save Changes' => 'Simpan Perubahan',
            'Log Out' => 'Keluar',
            'Profile' => 'Profil',
            'Change Password' => 'Ubah Kata Sandi',
            'Open navigation' => 'Buka navigasi',
            'Close' => 'Tutup'
        ));
        return $dict;
    }

    /**
     * Translate rendered HMS HTML to Indonesian at render time.
     * This is intentionally applied to the final HTML output so database SQL,
     * field names, routes, PHP variables and JavaScript identifiers are never
     * modified.
     */
    function hms_translate_html($html)
    {
        if (hms_lang() !== 'id' || $html === '') {
            return $html;
        }

        $dict = array(
            'Hospital Management System' => 'Sistem Informasi Manajemen Rumah Sakit',
            'Admin Dashboard' => 'Dasbor Admin',
            'Patient Dashboard' => 'Dasbor Pasien',
            'Doctor Dashboard' => 'Dasbor Dokter',
            'Manage care workflows with clarity.' => 'Kelola alur pelayanan dengan jelas.',
            'Manage appointments, doctors, reports, notifications, and audit logs.' => 'Kelola janji temu, dokter, laporan, notifikasi, dan log audit.',
            'Track appointments, prescriptions, and medical history.' => 'Pantau janji temu, resep, dan riwayat medis.',
            'Track appointments, prescriptions, and medical history' => 'Pantau janji temu, resep, dan riwayat medis',
            'Tinjau janji temu hari ini, resep, dan rekam perawatan pasien.' => 'Tinjau janji temu hari ini, resep, dan rekam perawatan pasien.',
            'Appointments, patient records, prescriptions, and doctor availability stay organized in one responsive system.' => 'Janji temu, rekam pasien, resep, dan ketersediaan dokter terorganisasi dalam satu sistem responsif.',
            'Appointment History' => 'Riwayat Janji Temu',
            'Appointment Details' => 'Detail Janji Temu',
            'Book Appointment' => 'Buat Janji Temu',
            'Manage Appointments' => 'Kelola Janji Temu',
            'Doctor Availability' => 'Ketersediaan Dokter',
            'Doctor Spesialisasi' => 'Spesialisasi Dokter',
            'Doctor Specialization' => 'Spesialisasi Dokter',
            'Doctor name' => 'Nama Dokter',
            'Doctor Name' => 'Nama Dokter',
            'Doctor ID' => 'ID Dokter',
            'Doctor Session Logs' => 'Log Sesi Dokter',
            'Patient Records' => 'Rekam Pasien',
            'Patient Accounts' => 'Akun Pasien',
            'Patient List' => 'Daftar Pasien',
            'Patient Search' => 'Pencarian Pasien',
            'Patient name' => 'Nama Pasien',
            'Medical Records' => 'Rekam Medis',
            'Medical History' => 'Riwayat Medis',
            'Medical history' => 'Riwayat medis',
            'Prescription Detail' => 'Detail Resep',
            'Save Prescription' => 'Simpan Resep',
            'Save Slot' => 'Simpan Jadwal',
            'New appointment requests, contact queries, and workflow alerts.' => 'Permintaan janji temu baru, pertanyaan kontak, dan pemberitahuan alur kerja.',
            'No appointments found.' => 'Tidak ada janji temu.',
            'No appointments scheduled for today.' => 'Tidak ada janji temu untuk hari ini.',
            'No appointments yet.' => 'Belum ada janji temu.',
            'No availability slots found.' => 'Tidak ada jadwal ketersediaan.',
            'No doctor logs found.' => 'Tidak ada log dokter.',
            'No doctors found.' => 'Tidak ada dokter.',
            'No follow-up appointments recorded yet.' => 'Belum ada janji temu tindak lanjut.',
            'No patients found for this date range.' => 'Tidak ada pasien pada rentang tanggal ini.',
            'No patients found.' => 'Tidak ada pasien.',
            'No prescriptions saved yet.' => 'Belum ada resep yang disimpan.',
            'No unread queries.' => 'Tidak ada pertanyaan yang belum dibaca.',
            'No upcoming appointment. You can book one when you are ready.' => 'Tidak ada janji temu mendatang. Anda dapat membuat janji temu jika sudah siap.',
            'No upcoming appointment' => 'Tidak ada janji temu mendatang',
            'Track Status' => 'Pantau Status',
            'Track Every Status' => 'Pantau Setiap Status',
            'Track doctor login attempts and logout timestamps.' => 'Pantau percobaan login dan waktu logout dokter.',
            'Track patient login attempts and logout timestamps.' => 'Pantau percobaan login dan waktu logout pasien.',
            'Find patient records by name or mobile number.' => 'Cari rekam pasien berdasarkan nama atau nomor telepon.',
            'Find patients by name or mobile number.' => 'Cari pasien berdasarkan nama atau nomor telepon.',
            'Review patient records entered by doctors.' => 'Tinjau rekam pasien yang dimasukkan dokter.',
            'Review registered patient login accounts.' => 'Tinjau akun login pasien yang terdaftar.',
            'Review contact queries that already have an admin response.' => 'Tinjau pertanyaan kontak yang sudah mendapat tanggapan admin.',
            'Review new public contact form submissions.' => 'Tinjau kiriman formulir kontak baru dari publik.',
            'Generate a patient registration report for a selected date range.' => 'Buat laporan pendaftaran pasien berdasarkan rentang tanggal yang dipilih.',
            'Select a doctor to view availability.' => 'Pilih dokter untuk melihat ketersediaan.',
            'Choose a doctor, review availability, and submit a pending appointment request.' => 'Pilih dokter, tinjau ketersediaan, lalu kirim permintaan janji temu.',
            'The doctor availability table is not installed yet. Apply' => 'Tabel ketersediaan dokter belum terpasang. Terapkan',
            'This email is used for patient login and appointment communication.' => 'Email ini digunakan untuk login pasien dan komunikasi janji temu.',
            'Use a unique password to keep your patient account secure.' => 'Gunakan kata sandi unik untuk menjaga keamanan akun pasien.',
            'Protect your doctor account with a strong password.' => 'Lindungi akun dokter dengan kata sandi yang kuat.',
            'Keep your patient contact and address details current.' => 'Pastikan data kontak dan alamat pasien selalu terbaru.',
            'Update doctor profile, contact, and fee details.' => 'Perbarui profil dokter, kontak, dan tarif.',
            'Update patient profile and baseline medical history.' => 'Perbarui profil pasien dan riwayat medis dasar.',
            'Update your specialization, clinic address, and contact details.' => 'Perbarui spesialisasi, alamat klinik, dan detail kontak Anda.',
            'Update the public website contact details.' => 'Perbarui detail kontak situs web publik.',
            'Update the specialization name used in doctor profiles.' => 'Perbarui nama spesialisasi yang digunakan pada profil dokter.',
            'Maintain the list of services used by doctor profiles.' => 'Kelola daftar layanan yang digunakan pada profil dokter.',
            'Administrative view of patient record and medical history.' => 'Tampilan administrasi rekam pasien dan riwayat medis.',
            'Read-only patient record and visit history.' => 'Rekam pasien dan riwayat kunjungan hanya-baca.',
            'Diagnosis, treatment notes, and medical history timeline.' => 'Diagnosis, catatan perawatan, dan linimasa riwayat medis.',
            'Record diagnosis, treatment, medicines, and follow-up dates.' => 'Catat diagnosis, perawatan, obat, dan tanggal tindak lanjut.',
            'Linked patient records' => 'Rekam pasien terkait',
            'Contact Content' => 'Isi Kontak',
            'Clinic address' => 'Alamat Klinik',
            'Contact number' => 'Nomor Kontak',
            'Terdaftar contact number' => 'Nomor kontak terdaftar',
            'Terdaftar full name' => 'Nama lengkap terdaftar',
            'Current email' => 'Email saat ini',
            'New email' => 'Email baru',
            'Email address' => 'Alamat Email',
            'Email already registered.' => 'Email sudah terdaftar.',
            'Email tersedia untuk pendaftaran.' => 'Email tersedia untuk pendaftaran.',
            'Email terdaftar' => 'Email Terdaftar',
            'Change Dates' => 'Ubah Tanggal',
            'Mark All Read' => 'Tandai Semua Sudah Dibaca',
            'Read' => 'Baca',
            'New' => 'Baru',
            'Edit Doctor' => 'Edit Dokter',
            'Edit Patient' => 'Edit Pasien',
            'Edit Profil' => 'Edit Profil',
            'Edit Spesialisasi' => 'Edit Spesialisasi',
            'Tambah Doctor' => 'Tambah Dokter',
            'Tambah Patient' => 'Tambah Pasien',
            'Tambah History' => 'Tambah Riwayat',
            'Buat a doctor login and profile.' => 'Buat akun login dan profil dokter.',
            'Buat a patient record under your doctor account.' => 'Buat rekam pasien melalui akun dokter Anda.',
            'Cari, update, and manage registered doctors.' => 'Cari, perbarui, dan kelola dokter terdaftar.',
            'Linimasa of patient records, visits, and prescriptions.' => 'Linimasa rekam pasien, kunjungan, dan resep.',
            'Hari Ini’s schedule, prescription work, and follow-up planning.' => 'Jadwal hari ini, pekerjaan resep, dan perencanaan tindak lanjut.',
            'Kembali to admin login' => 'Kembali ke login admin',
            'Report from' => 'Laporan dari',
            'Status' => 'Status',
            'Action' => 'Aksi',
            'Actions' => 'Aksi',
            'Date' => 'Tanggal',
            'Time' => 'Waktu',
            'Today' => 'Hari Ini',
            'Age' => 'Usia',
            'Gender' => 'Jenis Kelamin',
            'Name' => 'Nama',
            'Email' => 'Email',
            'Phone' => 'Telepon',
            'Address' => 'Alamat',
            'Fee' => 'Biaya',
            'Total' => 'Total',
            'total' => 'total',
            'Specialization' => 'Spesialisasi',
            'Diagnosis' => 'Diagnosis',
            'Treatment' => 'Perawatan',
            'Medicine' => 'Obat',
            'Medicines' => 'Obat',
            'Prescription' => 'Resep',
            'Report' => 'Laporan',
            'Reports' => 'Laporan',
            'Notification' => 'Notifikasi',
            'Notifications' => 'Notifikasi',
            'Audit Logs' => 'Log Audit',
            'Dashboard' => 'Dasbor',
            'Appointments' => 'Janji Temu',
            'Appointment' => 'Janji Temu',
            'Availability' => 'Ketersediaan',
            'Doctors' => 'Dokter',
            'Doctor' => 'Dokter',
            'Patients' => 'Pasien',
            'Patient' => 'Pasien',
            'Prescriptions' => 'Resep',
            'Search' => 'Cari',
            'Profile' => 'Profil',
            'Change Password' => 'Ubah Kata Sandi',
            'Change Email' => 'Ubah Email',
            'Forgot Password' => 'Lupa Kata Sandi',
            'Forgot password?' => 'Lupa kata sandi?',
            'Reset Password' => 'Atur Ulang Kata Sandi',
            'Username' => 'Nama Pengguna',
            'Password' => 'Kata Sandi',
            'Log In' => 'Masuk',
            'Login' => 'Masuk',
            'Log Out' => 'Keluar',
            'Logout' => 'Keluar',
            'Save' => 'Simpan',
            'Submit' => 'Kirim',
            'Cancel' => 'Batal',
            'Delete' => 'Hapus',
            'Update' => 'Perbarui',
            'Add' => 'Tambah',
            'Edit' => 'Edit',
            'View' => 'Lihat',
            'Close' => 'Tutup',
            'Back' => 'Kembali',
            'Download' => 'Unduh',
            'Print' => 'Cetak',
            'Select' => 'Pilih',
            'Choose' => 'Pilih',
            'Create' => 'Buat',
            'New Query' => 'Pertanyaan Baru',
            'New Queries' => 'Pertanyaan Baru',
            'Registered Users' => 'Pengguna Terdaftar',
            'Patient Records' => 'Rekam Pasien',
            'Pending' => 'Menunggu',
            'Approved' => 'Disetujui',
            'Completed' => 'Selesai',
            'Cancelled' => 'Dibatalkan',
            'Enabled' => 'Aktif',
            'Disabled' => 'Nonaktif',
            'Unread notifications' => 'Notifikasi belum dibaca',
            'New contact queries' => 'Pertanyaan kontak baru',
            'Audit logging' => 'Pencatatan audit',
            'View Notifications' => 'Lihat Notifikasi',
            'Recent Appointments' => 'Janji Temu Terbaru',
            'Recent Activity' => 'Aktivitas Terbaru',
            'View All' => 'Lihat Semua',
            'Appointment Status' => 'Status Janji Temu',
            'Pending, approved, completed, and cancelled appointments.' => 'Janji temu menunggu, disetujui, selesai, dan dibatalkan.',
            'Fee' => 'Biaya',
            'Patient Records' => 'Rekam Pasien',
            'Registered Users' => 'Pengguna Terdaftar',
            'Medical Records' => 'Rekam Medis',
            'No data found.' => 'Data tidak ditemukan.',
            'No records found.' => 'Tidak ada data ditemukan.',
            'No appointments found.' => 'Tidak ada janji temu.',
            'No appointments yet.' => 'Belum ada janji temu.',
            'No appointments found' => 'Tidak ada janji temu',
            'at' => 'pukul',
            'on' => 'pada',
            'Apply' => 'Terapkan',
            'required' => 'wajib',
            'Close' => 'Tutup',
            'Welcome' => 'Selamat Datang',
            'Welcome back' => 'Selamat datang kembali',
            'Secure access for hospital teams' => 'Akses aman untuk tim rumah sakit',
            'Back to website' => 'Kembali ke situs',
            'System Access' => 'Akses Sistem',
            'Administrator' => 'Administrator',
            'English' => 'Inggris',
            'Indonesia' => 'Indonesia'
        );

        // Apply longest phrases first.
        uksort($dict, function($a, $b) {
            return strlen($b) - strlen($a);
        });

        // Translate visible text nodes, title/placeholder/aria-label/value attributes.
        $html = preg_replace_callback(
            '/(^|>)([^<>]*)(?=<|$)/u',
            function($m) use ($dict) {
                $text = $m[2];
                foreach ($dict as $en => $id) {
                    $text = preg_replace('/(?<![\pL\pN])' . preg_quote($en, '/') . '(?![\pL\pN])/u', $id, $text);
                }
                return $m[1] . $text;
            },
            $html
        );
        $html = preg_replace_callback(
            '/\b(aria-label|title|placeholder)="([^"]*)"/u',
            function($m) use ($dict) {
                $text = $m[2];
                foreach ($dict as $en => $id) {
                    $text = preg_replace('/(?<![\pL\pN])' . preg_quote($en, '/') . '(?![\pL\pN])/u', $id, $text);
                }
                return $m[1] . '="' . $text . '"';
            },
            $html
        );
        return $html;
    }

    function hms_translate_text($text)
    {
        $dict = hms_translation_dictionary();
        $trim = trim($text);
        if ($trim === '') return $text;

        // English -> Indonesian when ID is active.
        if (hms_lang() === 'id') {
            if (isset($dict[$trim])) {
                $replacement = $dict[$trim];
                $leading = substr($text, 0, strlen($text) - strlen(ltrim($text)));
                $trailing = substr($text, strlen(rtrim($text)));
                return $leading . $replacement . $trailing;
            }
            foreach ($dict as $en => $id) {
                $text = preg_replace('/(?<![\pL\pN])' . preg_quote($en, '/') . '(?![\pL\pN])/u', $id, $text);
            }
            return $text;
        }

        // Indonesian -> English when EN is active. This allows the modern
        // Indonesian homepage and the legacy English pages to coexist.
        static $reverse = null;
        if ($reverse === null) {
            $reverse = array();
            foreach ($dict as $en => $id) {
                if ($id !== '' && !isset($reverse[$id])) {
                    $reverse[$id] = $en;
                }
            }
            $extra = array(
                'Sistem Informasi Manajemen Rumah Sakit' => 'Hospital Management Information System',
                'Pelayanan Kesehatan Terpercaya' => 'Trusted Healthcare Services',
                'Platform terintegrasi untuk janji temu pasien, jadwal dokter, rekam medis, resep, laporan, dan komunikasi rumah sakit secara digital.' => 'An integrated platform for patient appointments, doctor schedules, medical records, prescriptions, reports, and digital hospital communication.',
                'Aman & Terpercaya' => 'Safe & Trusted',
                'Tenaga Profesional' => 'Professional Staff',
                'Cepat & Mudah' => 'Fast & Easy',
                'Pasien Terlayani' => 'Patients Served',
                'Dokter Spesialis' => 'Specialist Doctors',
                'Layanan Klinik' => 'Clinical Services',
                'Kepuasan Pasien' => 'Patient Satisfaction',
                'Layanan Unggulan' => 'Featured Services',
                'Layanan Kesehatan Terbaik untuk Anda' => 'Quality Healthcare Services for You',
                'Berbagai layanan kesehatan yang dapat diakses dengan mudah, cepat, aman, dan terintegrasi.' => 'Healthcare services that are easy, fast, secure, and integrated.',
                'Janji Temu Online' => 'Online Appointment',
                'Pesan jadwal pemeriksaan dokter secara mudah dan cepat.' => 'Book a doctor appointment easily and quickly.',
                'Jadwal Dokter' => 'Doctor Schedule',
                'Lihat jadwal praktik dokter spesialis dan pilih waktu yang sesuai.' => 'View specialist doctor schedules and choose a suitable time.',
                'Rekam Medis' => 'Medical Records',
                'Akses riwayat kesehatan Anda secara digital dan aman.' => 'Access your health history digitally and securely.',
                'Resep Digital' => 'Digital Prescription',
                'Resep obat terintegrasi dengan sistem pelayanan farmasi.' => 'Prescriptions integrated with the pharmacy service system.',
                'Laporan Kesehatan' => 'Health Reports',
                'Laporan lengkap dan akurat untuk mendukung pengambilan keputusan.' => 'Complete and accurate reports to support decision-making.',
                'Komunikasi' => 'Communication',
                'Informasi dan komunikasi antara pasien dengan tenaga medis.' => 'Information and communication between patients and medical staff.',
                'Akses Sistem' => 'System Access',
                'Masuk Sesuai Peran Anda' => 'Sign In According to Your Role',
                'Pilih portal yang sesuai untuk mengakses layanan SIMRS.' => 'Choose the appropriate portal to access SIMRS services.',
                'Pasien' => 'Patient', 'Dokter' => 'Doctor', 'Administrator' => 'Administrator',
                'Kelola janji temu, pantau status pemeriksaan, dan unduh resep.' => 'Manage appointments, track examination status, and download prescriptions.',
                'Kelola jadwal, janji temu, resep, dan riwayat pasien.' => 'Manage schedules, appointments, prescriptions, and patient history.',
                'Kelola operasional, laporan, notifikasi, dan aktivitas sistem.' => 'Manage operations, reports, notifications, and system activity.',
                'Tentang SIMRS' => 'About SIMRS',
                'Kesehatan Anda adalah Prioritas Kami' => 'Your Health Is Our Priority',
                'SIMRS membantu rumah sakit mengelola pelayanan secara terintegrasi, efisien, aman, dan mudah digunakan oleh pasien maupun tenaga kesehatan.' => 'SIMRS helps hospitals manage services in an integrated, efficient, secure, and user-friendly way for patients and healthcare staff.',
                'Terintegrasi' => 'Integrated', 'Aman' => 'Secure', 'Mudah Digunakan' => 'Easy to Use',
                'Informasi antarunit tersusun dalam satu sistem.' => 'Information across units is organized in one system.',
                'Data pelayanan dikelola dengan memperhatikan keamanan informasi.' => 'Service data is managed with information security in mind.',
                'Akses layanan sederhana dari berbagai perangkat.' => 'Simple access from various devices.',
                'Hubungi Kami' => 'Contact Us',
                'Galeri Kegiatan' => 'Activity Gallery',
                'Suasana Pelayanan Rumah Sakit' => 'Hospital Service Environment',
                'Dokumentasi fasilitas, tenaga medis, dan kegiatan pelayanan rumah sakit.' => 'Photos of facilities, medical staff, and hospital services.',
                'Kami Siap Membantu Anda' => 'We Are Ready to Help You',
                'Silakan kirim pertanyaan atau kebutuhan informasi melalui formulir berikut.' => 'Please send your questions or information requests using the form below.',
                'Nama Lengkap' => 'Full Name', 'Nomor Telepon' => 'Phone Number', 'Pesan' => 'Message', 'Kirim Pesan' => 'Send Message',
                'Selamat Datang' => 'Welcome', 'Selamat Datang Kembali' => 'Welcome Back', 'Masuk' => 'Login', 'Keluar' => 'Logout',
                'Buat Janji Temu' => 'Book Appointment', 'Lihat Layanan' => 'View Services', 'Buka Portal' => 'Open Portal',
                'Lihat Detail' => 'View Details', 'Selengkapnya' => 'Learn More', 'Lihat Semua Layanan' => 'View All Services', 'Lihat Semua Foto' => 'View All Photos'
            );
            $extra2 = array(
                'Layanan' => 'Services','Tentang Kami' => 'About Us','Galeri' => 'Gallery','Kontak' => 'Contact','Masuk' => 'Login','Buat Janji Temu' => 'Book Appointment',
                'Pelayanan Kesehatan Terpercaya' => 'Trusted Healthcare Services','Sistem Informasi' => 'Information System','Manajemen Rumah Sakit' => 'Hospital Management',
                'Platform terintegrasi untuk janji temu pasien, jadwal dokter, rekam medis, resep, laporan, dan komunikasi rumah sakit secara digital.' => 'An integrated platform for patient appointments, doctor schedules, medical records, prescriptions, reports, and digital hospital communication.',
                'Aman & Terpercaya' => 'Safe & Trusted','Tenaga Profesional' => 'Professional Staff','Cepat & Mudah' => 'Fast & Easy','Lihat Layanan' => 'View Services',
                'Pasien Terlayani' => 'Patients Served','Dokter Spesialis' => 'Specialist Doctors','Layanan Klinik' => 'Clinical Services','Kepuasan Pasien' => 'Patient Satisfaction',
                'Layanan Unggulan' => 'Featured Services','Layanan Kesehatan Terbaik untuk Anda' => 'Quality Healthcare Services for You',
                'Berbagai layanan kesehatan yang dapat diakses dengan mudah, cepat, aman, dan terintegrasi.' => 'Healthcare services that are easy, fast, secure, and integrated.',
                'Janji Temu Online' => 'Online Appointment','Pesan jadwal pemeriksaan dokter secara mudah dan cepat.' => 'Book a doctor appointment easily and quickly.',
                'Jadwal Dokter' => 'Doctor Schedule','Lihat jadwal praktik dokter spesialis dan pilih waktu yang sesuai.' => 'View specialist doctor schedules and choose a suitable time.',
                'Rekam Medis' => 'Medical Records','Akses riwayat kesehatan Anda secara digital dan aman.' => 'Access your health history digitally and securely.',
                'Resep Digital' => 'Digital Prescription','Resep obat terintegrasi dengan sistem pelayanan farmasi.' => 'Prescriptions integrated with the pharmacy service system.',
                'Laporan Kesehatan' => 'Health Reports','Laporan lengkap dan akurat untuk mendukung pengambilan keputusan.' => 'Complete and accurate reports to support decision-making.',
                'Komunikasi' => 'Communication','Informasi dan komunikasi antara pasien dengan tenaga medis.' => 'Information and communication between patients and medical staff.',
                'Akses Sistem' => 'System Access','Masuk Sesuai Peran Anda' => 'Sign In According to Your Role','Pilih portal yang sesuai untuk mengakses layanan SIMRS.' => 'Choose the appropriate portal to access SIMRS services.',
                'Kelola janji temu, pantau status pemeriksaan, dan unduh resep.' => 'Manage appointments, track examination status, and download prescriptions.',
                'Kelola jadwal, janji temu, resep, dan riwayat pasien.' => 'Manage schedules, appointments, prescriptions, and patient history.',
                'Kelola operasional, laporan, notifikasi, dan aktivitas sistem.' => 'Manage operations, reports, notifications, and system activity.',
                'Tentang SIMRS' => 'About SIMRS','Kesehatan Anda adalah Prioritas Kami' => 'Your Health Is Our Priority',
                'SIMRS membantu rumah sakit mengelola pelayanan secara terintegrasi, efisien, aman, dan mudah digunakan oleh pasien maupun tenaga kesehatan.' => 'SIMRS helps hospitals manage services in an integrated, efficient, secure, and user-friendly way for patients and healthcare staff.',
                'Terintegrasi' => 'Integrated','Aman' => 'Secure','Mudah Digunakan' => 'Easy to Use','Informasi antarunit tersusun dalam satu sistem.' => 'Information across units is organized in one system.',
                'Data pelayanan dikelola dengan memperhatikan keamanan informasi.' => 'Service data is managed with information security in mind.','Akses layanan sederhana dari berbagai perangkat.' => 'Simple access from various devices.',
                'Hubungi Kami' => 'Contact Us','Galeri Kegiatan' => 'Activity Gallery','Suasana Pelayanan Rumah Sakit' => 'Hospital Service Environment',
                'Dokumentasi fasilitas, tenaga medis, dan kegiatan pelayanan rumah sakit.' => 'Photos of facilities, medical staff, and hospital services.',
                'Kami Siap Membantu Anda' => 'We Are Ready to Help You','Silakan kirim pertanyaan atau kebutuhan informasi melalui formulir berikut.' => 'Please send your questions or information requests using the form below.',
                'Nama Lengkap' => 'Full Name','Nomor Telepon' => 'Phone Number','Pesan' => 'Message','Kirim Pesan' => 'Send Message','Pasien' => 'Patient','Dokter' => 'Doctor','Administrator' => 'Administrator',
                'Pelayanan pasien' => 'Patient services','Administrasi rumah sakit' => 'Hospital administration'
            );
            foreach ($extra as $id => $en) { $reverse[$id] = $en; }
            foreach ($extra2 as $id => $en) { $reverse[$id] = $en; }
        }
        if (isset($reverse[$trim])) {
            $replacement = $reverse[$trim];
            $leading = substr($text, 0, strlen($text) - strlen(ltrim($text)));
            $trailing = substr($text, strlen(rtrim($text)));
            return $leading . $replacement . $trailing;
        }
        foreach ($reverse as $id => $en) {
            $text = preg_replace('/(?<![\pL\pN])' . preg_quote($id, '/') . '(?![\pL\pN])/u', $en, $text);
        }
        return $text;
    }

    function hms_translate_output($html)
    {
        if (trim($html) === '') return $html;
        // Translate visible HTML text nodes only; attributes, CSS and scripts are untouched.
        $parts = preg_split('/(<(?:script|style)\\b[^>]*>.*?<\\/(?:script|style)>)/is', $html, -1, PREG_SPLIT_DELIM_CAPTURE);
        foreach ($parts as $i => $part) {
            if (preg_match('/^<(?:script|style)\\b/i', $part)) continue;
            $parts[$i] = preg_replace_callback('/>([^<>]+)</u', function ($m) {
                return '>' . hms_translate_text($m[1]) . '<';
            }, $part);
        }
        return implode('', $parts);
    }

    hms_init_language();
    ob_start('hms_translate_output');

    function hms_e($value)
    {
        return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
    }

    function hms_post($key, $default = '')
    {
        return isset($_POST[$key]) ? trim((string) $_POST[$key]) : $default;
    }

    function hms_get($key, $default = '')
    {
        return isset($_GET[$key]) ? trim((string) $_GET[$key]) : $default;
    }

    function hms_int($value)
    {
        return filter_var($value, FILTER_VALIDATE_INT) !== false ? (int) $value : 0;
    }

    
    // -------------------------------------------------------------------------
    // CI4 <-> Legacy authentication bridge
    // -------------------------------------------------------------------------
    // Legacy pages are executed inside CodeIgniter 4. A dedicated signed cookie
    // provides a second, application-scoped authentication marker so an old
    // localhost session/cookie cannot accidentally reset the admin login.
    function hms_auth_secret()
    {
        return 'HMS-CI4-LOCAL-AUTH-2026-09-SESSION-BRIDGE-7F3A9C2D';
    }

    function hms_auth_cookie_name()
    {
        return 'hms_admin_auth';
    }

    function hms_auth_cookie_path()
    {
        $path = parse_url(base_url(), PHP_URL_PATH);
        if (!$path) {
            return '/';
        }
        return rtrim($path, '/') . '/';
    }

    function hms_set_admin_auth_cookie($id, $username)
    {
        $issued = time();
        $payload = (int) $id . '|' . (string) $username . '|' . $issued;
        $signature = hash_hmac('sha256', $payload, hms_auth_secret());
        $value = rtrim(strtr(base64_encode($payload . '|' . $signature), '+/', '-_'), '=');

        setcookie(hms_auth_cookie_name(), $value, array(
            'expires'  => $issued + 7200,
            'path'     => hms_auth_cookie_path(),
            'secure'   => false,
            'httponly' => true,
            'samesite' => 'Lax',
        ));
    }

    function hms_get_admin_auth_cookie()
    {
        if (empty($_COOKIE[hms_auth_cookie_name()])) {
            return null;
        }

        $encoded = strtr((string) $_COOKIE[hms_auth_cookie_name()], '-_', '+/');
        $padding = strlen($encoded) % 4;
        if ($padding) {
            $encoded .= str_repeat('=', 4 - $padding);
        }

        $decoded = base64_decode($encoded, true);
        if ($decoded === false) {
            return null;
        }

        $parts = explode('|', $decoded);
        if (count($parts) !== 4) {
            return null;
        }

        list($id, $username, $issued, $signature) = $parts;

        if (!ctype_digit((string) $id) || !ctype_digit((string) $issued)) {
            return null;
        }

        $issued = (int) $issued;
        if ($issued <= 0 || (time() - $issued) > 7200 || $issued > (time() + 60)) {
            return null;
        }

        $payload = $id . '|' . $username . '|' . $issued;
        $expected = hash_hmac('sha256', $payload, hms_auth_secret());

        if (!hash_equals($expected, $signature)) {
            return null;
        }

        return array(
            'id'       => (int) $id,
            'username' => $username,
        );
    }

    function hms_make_admin_ticket($id, $username)
    {
        $issued = time();
        $payload = (int) $id . '|' . (string) $username . '|' . $issued;
        $signature = hash_hmac('sha256', $payload, hms_auth_secret());
        return rtrim(strtr(base64_encode($payload . '|' . $signature), '+/', '-_'), '=');
    }

    function hms_get_admin_ticket()
    {
        if (empty($_GET['auth'])) {
            return null;
        }

        $encoded = strtr((string) $_GET['auth'], '-_', '+/');
        $padding = strlen($encoded) % 4;
        if ($padding) {
            $encoded .= str_repeat('=', 4 - $padding);
        }

        $decoded = base64_decode($encoded, true);
        if ($decoded === false) {
            return null;
        }

        $parts = explode('|', $decoded);
        if (count($parts) !== 4) {
            return null;
        }

        list($id, $username, $issued, $signature) = $parts;
        if (!ctype_digit((string) $id) || !ctype_digit((string) $issued)) {
            return null;
        }

        $issued = (int) $issued;
        // Handoff ticket is intentionally short lived.
        if ($issued <= 0 || (time() - $issued) > 7200 || $issued > (time() + 60)) {
            return null;
        }

        $payload = $id . '|' . $username . '|' . $issued;
        $expected = hash_hmac('sha256', $payload, hms_auth_secret());
        if (!hash_equals($expected, $signature)) {
            return null;
        }

        return array('id' => (int) $id, 'username' => $username);
    }

    function hms_clear_admin_auth_cookie()
    {
        setcookie(hms_auth_cookie_name(), '', array(
            'expires'  => time() - 3600,
            'path'     => hms_auth_cookie_path(),
            'secure'   => false,
            'httponly' => true,
            'samesite' => 'Lax',
        ));
        unset($_COOKIE[hms_auth_cookie_name()]);
    }

function hms_redirect($location)
    {
        // Preserve the admin authentication handoff for internal relative
        // redirects. Absolute URLs and logout are intentionally untouched.
        if (strpos($location, '://') === false
            && strpos($location, '..') === false
            && stripos($location, 'logout.php') === false
            && strpos($location, 'auth=') === false
            && function_exists('hms_admin_auth_query')) {
            $session = session();
            if ($session->get('role') === 'admin') {
                $query = hms_admin_auth_query();
                if ($query !== '') {
                    $location .= (strpos($location, '?') === false ? $query : '&' . ltrim($query, '?'));
                }
            }
        }

        header('Location: ' . $location);
        exit;
    }

function hms_require_role($role, $redirect = 'logout.php')
{
    $session = session();

    $sessionId    = $session->get('id');
    $sessionRole  = $session->get('role');
    $sessionLogin = $session->get('login');

    if (!empty($sessionId) && $sessionRole === $role) {
        return true;
    }

    if ($role === 'admin' && function_exists('hms_get_admin_ticket')) {
        $ticket = hms_get_admin_ticket();
        if ($ticket !== null) {
            $session->set([
                'login' => $ticket['username'],
                'id'    => $ticket['id'],
                'role'  => 'admin',
            ]);
            $_SESSION['login'] = $ticket['username'];
            $_SESSION['id'] = $ticket['id'];
            $_SESSION['role'] = 'admin';
            hms_set_admin_auth_cookie($ticket['id'], $ticket['username']);
            $_SESSION['hms_admin_auth_ticket'] = hms_make_admin_ticket($ticket['id'], $ticket['username']);
            return true;
        }
    }

    if ($role === 'admin' && function_exists('hms_get_admin_auth_cookie')) {
        $auth = hms_get_admin_auth_cookie();
        if ($auth !== null) {
            $session->set([
                'login' => $auth['username'],
                'id'    => $auth['id'],
                'role'  => 'admin',
            ]);
            $_SESSION['login'] = $auth['username'];
            $_SESSION['id'] = $auth['id'];
            $_SESSION['role'] = 'admin';
            $_SESSION['hms_admin_auth_ticket'] = hms_make_admin_ticket($auth['id'], $auth['username']);
            return true;
        }
    }

    if (!empty($sessionId) && $role === 'admin' && !empty($sessionLogin)) {
        $session->set('role', 'admin');
        $_SESSION['role'] = 'admin';
        return true;
    }

    hms_redirect($redirect);
    return false;
}

function hms_admin_auth_query()
{
    $ticket = '';

    if (!empty($_GET['auth']) && function_exists('hms_get_admin_ticket')) {
        $valid = hms_get_admin_ticket();
        if ($valid !== null) {
            $ticket = (string) $_GET['auth'];
        }
    }

    // Prefer a fresh ticket generated from the persistent signed cookie.
    if ($ticket === '' && function_exists('hms_get_admin_auth_cookie')) {
        $auth = hms_get_admin_auth_cookie();
        if ($auth !== null) {
            $ticket = hms_make_admin_ticket($auth['id'], $auth['username']);
            $_SESSION['hms_admin_auth_ticket'] = $ticket;
        }
    }

    if ($ticket === '' && !empty($_SESSION['hms_admin_auth_ticket'])) {
        $candidate = (string) $_SESSION['hms_admin_auth_ticket'];
        $old = $_GET['auth'] ?? null;
        $_GET['auth'] = $candidate;
        $valid = function_exists('hms_get_admin_ticket') ? hms_get_admin_ticket() : null;
        if ($old === null) { unset($_GET['auth']); } else { $_GET['auth'] = $old; }
        if ($valid !== null) {
            $ticket = $candidate;
        }
    }

    if ($ticket === '') {
        $session = session();
        $id = (int) $session->get('id');
        $username = (string) $session->get('login');
        if ($id > 0 && $username !== '' && $session->get('role') === 'admin') {
            $ticket = hms_make_admin_ticket($id, $username);
            $_SESSION['hms_admin_auth_ticket'] = $ticket;
        }
    }

    return $ticket !== '' ? '?auth=' . rawurlencode($ticket) : '';
}

function hms_admin_url($path)
{
    if ($path === '' || $path === '#' || stripos($path, 'javascript:') === 0) {
        return $path;
    }
    if (strpos($path, '?') !== false || strpos($path, '#') !== false) {
        return $path;
    }
    return $path . hms_admin_auth_query();
}

function hms_flash($type, $message)
{
    session();

    $_SESSION['hms_flash'] = array(
        'type'    => $type,
        'message' => $message
    );
}

    function hms_get_flash()
    {
        session();
        $flash = isset($_SESSION['hms_flash']) ? $_SESSION['hms_flash'] : null;
        unset($_SESSION['hms_flash']);
        return $flash;
    }

    function hms_csrf_token()
    {
        session();
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
        return $_SESSION['csrf_token'];
    }

    function hms_csrf_field()
    {
        return '<input type="hidden" name="csrf_token" value="' . hms_e(hms_csrf_token()) . '">';
    }

    function hms_verify_csrf()
    {
        session();
        $token = isset($_POST['csrf_token']) ? (string) $_POST['csrf_token'] : '';
        if (empty($_SESSION['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $token)) {
            http_response_code(419);
            die('Invalid request token.');
        }
    }

    function hms_stmt($con, $sql, $types = '', $params = array())
    {
        $stmt = mysqli_prepare($con, $sql);
        if (!$stmt) {
            throw new RuntimeException('Database statement failed.');
        }

        if ($types !== '' && !empty($params)) {
            $bind = array_merge(array($types), $params);
            $refs = array();
            foreach ($bind as $key => $value) {
                $refs[$key] = &$bind[$key];
            }
            call_user_func_array(array($stmt, 'bind_param'), $refs);
        }

        if (!mysqli_stmt_execute($stmt)) {
            throw new RuntimeException('Database query failed.');
        }

        return $stmt;
    }

    function hms_fetch_all($con, $sql, $types = '', $params = array())
    {
        $stmt = hms_stmt($con, $sql, $types, $params);
        $result = mysqli_stmt_get_result($stmt);
        $rows = array();
        if ($result) {
            while ($row = mysqli_fetch_assoc($result)) {
                $rows[] = $row;
            }
        }
        mysqli_stmt_close($stmt);
        return $rows;
    }

    function hms_result($con, $sql, $types = '', $params = array())
    {
        $stmt = hms_stmt($con, $sql, $types, $params);
        return mysqli_stmt_get_result($stmt);
    }

    function hms_fetch_one($con, $sql, $types = '', $params = array())
    {
        $rows = hms_fetch_all($con, $sql, $types, $params);
        return isset($rows[0]) ? $rows[0] : null;
    }

    function hms_scalar($con, $sql, $types = '', $params = array())
    {
        $row = hms_fetch_one($con, $sql, $types, $params);
        if (!$row) {
            return 0;
        }
        $values = array_values($row);
        return isset($values[0]) ? $values[0] : 0;
    }

    function hms_execute($con, $sql, $types = '', $params = array())
    {
        $stmt = hms_stmt($con, $sql, $types, $params);
        $affected = mysqli_stmt_affected_rows($stmt);
        mysqli_stmt_close($stmt);
        return $affected;
    }

    function hms_table_exists($con, $table)
    {
        if (!preg_match('/^[A-Za-z0-9_]+$/', $table)) {
            return false;
        }
        return (int) hms_scalar(
            $con,
            'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ?',
            's',
            array($table)
        ) > 0;
    }

    function hms_column_exists($con, $table, $column)
    {
        if (!preg_match('/^[A-Za-z0-9_]+$/', $table) || !preg_match('/^[A-Za-z0-9_]+$/', $column)) {
            return false;
        }
        return (int) hms_scalar(
            $con,
            'SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = ? AND column_name = ?',
            'ss',
            array($table, $column)
        ) > 0;
    }

    function hms_appointment_status_expr($con, $alias = 'appointment')
    {
        $prefix = $alias ? '`' . $alias . '`.' : '';
        if (hms_column_exists($con, 'appointment', 'status')) {
            return 'COALESCE(NULLIF(' . $prefix . '`status`, ""), CASE WHEN ' . $prefix . '`userStatus` = 0 OR ' . $prefix . '`doctorStatus` = 0 THEN "Cancelled" ELSE "Pending" END)';
        }
        return 'CASE WHEN ' . $prefix . '`userStatus` = 0 OR ' . $prefix . '`doctorStatus` = 0 THEN "Cancelled" ELSE "Pending" END';
    }

    function hms_status_from_row($row)
    {
        if (isset($row['status']) && $row['status'] !== '') {
            return $row['status'];
        }
        if ((isset($row['userStatus']) && (int) $row['userStatus'] === 0) || (isset($row['doctorStatus']) && (int) $row['doctorStatus'] === 0)) {
            return 'Cancelled';
        }
        return 'Pending';
    }

    function hms_status_badge($status)
    {
        $status = ucfirst(strtolower((string) $status));
        $classes = array(
            'Pending' => 'text-bg-warning',
            'Approved' => 'text-bg-primary',
            'Completed' => 'text-bg-success',
            'Cancelled' => 'text-bg-secondary'
        );
        $class = isset($classes[$status]) ? $classes[$status] : 'text-bg-light';
        return '<span class="badge rounded-pill ' . $class . '">' . hms_e($status) . '</span>';
    }

    function hms_valid_status($status)
    {
        return in_array($status, array('Pending', 'Approved', 'Completed', 'Cancelled'), true);
    }

    function hms_set_appointment_status($con, $appointmentId, $status, $actorType, $actorId)
    {
        if (!hms_valid_status($status)) {
            return false;
        }

        $userStatus = 1;
        $doctorStatus = 1;
        if ($status === 'Cancelled') {
            if ($actorType === 'patient') {
                $userStatus = 0;
            } else {
                $doctorStatus = 0;
            }
        }

        $fields = array();
        $types = '';
        $params = array();

        if (hms_column_exists($con, 'appointment', 'status')) {
            $fields[] = 'status = ?';
            $types .= 's';
            $params[] = $status;
        }
        $fields[] = 'userStatus = ?';
        $fields[] = 'doctorStatus = ?';
        $types .= 'ii';
        $params[] = $userStatus;
        $params[] = $doctorStatus;

        if (hms_column_exists($con, 'appointment', 'status_updated_at')) {
            $fields[] = 'status_updated_at = NOW()';
        }
        if (hms_column_exists($con, 'appointment', 'status_updated_by')) {
            $fields[] = 'status_updated_by = ?';
            $types .= 's';
            $params[] = $actorType . ':' . (int) $actorId;
        }

        $types .= 'i';
        $params[] = (int) $appointmentId;
        hms_execute($con, 'UPDATE appointment SET ' . implode(', ', $fields) . ' WHERE id = ?', $types, $params);
        hms_log_audit($con, $actorType, $actorId, 'appointment_status_changed', 'appointment', $appointmentId, 'Status changed to ' . $status);
        return true;
    }

    function hms_log_audit($con, $actorType, $actorId, $action, $entityType, $entityId = null, $details = '')
    {
        if (!hms_table_exists($con, 'audit_logs')) {
            return false;
        }
        hms_execute(
            $con,
            'INSERT INTO audit_logs(actor_type, actor_id, action, entity_type, entity_id, details, ip_address, created_at) VALUES(?, ?, ?, ?, ?, ?, ?, NOW())',
            'sississ',
            array((string) $actorType, (int) $actorId, (string) $action, (string) $entityType, $entityId ? (int) $entityId : null, (string) $details, isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '')
        );
        return true;
    }

    function hms_notify($con, $userType, $userId, $title, $message)
    {
        if (!hms_table_exists($con, 'notifications')) {
            return false;
        }
        hms_execute(
            $con,
            'INSERT INTO notifications(user_type, user_id, title, message, is_read, created_at) VALUES(?, ?, ?, ?, 0, NOW())',
            'siss',
            array((string) $userType, $userId === null ? null : (int) $userId, (string) $title, (string) $message)
        );
        return true;
    }

    function hms_password_matches($plain, $stored)
    {
        if ($stored === null || $stored === '') {
            return false;
        }
        if (password_get_info($stored)['algo']) {
            return password_verify($plain, $stored);
        }
        if (hash_equals((string) $stored, md5($plain))) {
            return true;
        }
        return hash_equals((string) $stored, (string) $plain);
    }

    function hms_password_needs_upgrade($stored)
    {
        return !password_get_info((string) $stored)['algo'] || password_needs_rehash((string) $stored, PASSWORD_DEFAULT);
    }

    function hms_upgrade_password($con, $table, $idColumn, $id, $plain)
    {
        if (!preg_match('/^[A-Za-z0-9_]+$/', $table) || !preg_match('/^[A-Za-z0-9_]+$/', $idColumn)) {
            return false;
        }
        $hash = password_hash($plain, PASSWORD_DEFAULT);
        hms_execute($con, 'UPDATE `' . $table . '` SET password = ? WHERE `' . $idColumn . '` = ?', 'si', array($hash, (int) $id));
        return true;
    }

    function hms_normalize_time($time)
    {
        $timestamp = strtotime((string) $time);
        if ($timestamp === false) {
            return null;
        }
        return date('H:i:s', $timestamp);
    }

    function hms_is_valid_future_date($date)
    {
        $parsed = DateTime::createFromFormat('Y-m-d', $date);
        if (!$parsed || $parsed->format('Y-m-d') !== $date) {
            return false;
        }
        $today = new DateTime('today');
        return $parsed >= $today;
    }

    function hms_doctor_available($con, $doctorId, $date, $time, &$reason = '', $excludeAppointmentId = 0)
    {
        $doctorId = (int) $doctorId;
        $time = hms_normalize_time($time);
        if (!$doctorId || !hms_is_valid_future_date($date) || !$time) {
            $reason = 'Please choose a valid future date and time.';
            return false;
        }

        $statusExpr = hms_appointment_status_expr($con, 'appointment');
        $conflictSql = 'SELECT COUNT(*) FROM appointment WHERE doctorId = ? AND appointmentDate = ? AND appointmentTime = ? AND ' . $statusExpr . ' <> "Cancelled"';
        $conflictTypes = 'iss';
        $conflictParams = array($doctorId, $date, $time);
        if ((int) $excludeAppointmentId > 0) {
            $conflictSql .= ' AND id <> ?';
            $conflictTypes .= 'i';
            $conflictParams[] = (int) $excludeAppointmentId;
        }
        $conflict = (int) hms_scalar($con, $conflictSql, $conflictTypes, $conflictParams);

        if ($conflict > 0) {
            $reason = 'This doctor already has an appointment at that time.';
            return false;
        }

        if (!hms_table_exists($con, 'doctor_availability')) {
            return true;
        }

        $day = (int) (new DateTime($date))->format('w');
        $slot = hms_fetch_one(
            $con,
            'SELECT * FROM doctor_availability WHERE doctor_id = ? AND is_active = 1 AND (available_date = ? OR (available_date IS NULL AND day_of_week = ?)) AND start_time <= ? AND end_time > ? ORDER BY available_date DESC, start_time ASC LIMIT 1',
            'isiss',
            array($doctorId, $date, $day, $time, $time)
        );

        if (!$slot) {
            $reason = 'The doctor is not available at the selected date and time.';
            return false;
        }

        $max = isset($slot['max_appointments']) ? (int) $slot['max_appointments'] : 1;
        if ($max < 1) {
            $reason = 'The selected slot is closed.';
            return false;
        }

        return true;
    }

    function hms_availability_summary($con, $doctorId)
    {
        if (!hms_table_exists($con, 'doctor_availability')) {
            return 'Availability schedule has not been configured yet.';
        }
        $rows = hms_fetch_all(
            $con,
            'SELECT * FROM doctor_availability WHERE doctor_id = ? AND is_active = 1 ORDER BY available_date DESC, day_of_week ASC, start_time ASC LIMIT 8',
            'i',
            array((int) $doctorId)
        );
        if (!$rows) {
            return 'No active availability slots.';
        }
        $days = array('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
        $parts = array();
        foreach ($rows as $row) {
            $label = $row['available_date'] ? $row['available_date'] : $days[(int) $row['day_of_week']];
            $parts[] = $label . ' ' . substr($row['start_time'], 0, 5) . '-' . substr($row['end_time'], 0, 5);
        }
        return implode(', ', $parts);
    }

    function hms_send_csv($filename, $headers, $rows)
    {
        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        $out = fopen('php://output', 'w');
        fputcsv($out, $headers);
        foreach ($rows as $row) {
            fputcsv($out, $row);
        }
        fclose($out);
        exit;
    }

    function hms_pdf_escape($text)
    {
        return str_replace(array('\\', '(', ')'), array('\\\\', '\\(', '\\)'), (string) $text);
    }

    function hms_send_basic_pdf($filename, $title, $lines)
    {
        $content = "BT\n/F1 16 Tf\n50 790 Td\n(" . hms_pdf_escape($title) . ") Tj\n/F1 10 Tf\n0 -24 Td\n";
        foreach ($lines as $line) {
            $content .= '(' . hms_pdf_escape(substr((string) $line, 0, 115)) . ") Tj\n0 -14 Td\n";
        }
        $content .= "ET";

        $objects = array();
        $objects[] = "<< /Type /Catalog /Pages 2 0 R >>";
        $objects[] = "<< /Type /Pages /Kids [3 0 R] /Count 1 >>";
        $objects[] = "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 842] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>";
        $objects[] = "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>";
        $objects[] = "<< /Length " . strlen($content) . " >>\nstream\n" . $content . "\nendstream";

        $pdf = "%PDF-1.4\n";
        $offsets = array(0);
        foreach ($objects as $index => $object) {
            $offsets[] = strlen($pdf);
            $pdf .= ($index + 1) . " 0 obj\n" . $object . "\nendobj\n";
        }
        $xref = strlen($pdf);
        $pdf .= "xref\n0 " . (count($objects) + 1) . "\n0000000000 65535 f \n";
        for ($i = 1; $i <= count($objects); $i++) {
            $pdf .= str_pad((string) $offsets[$i], 10, '0', STR_PAD_LEFT) . " 00000 n \n";
        }
        $pdf .= "trailer\n<< /Size " . (count($objects) + 1) . " /Root 1 0 R >>\nstartxref\n" . $xref . "\n%%EOF";

        header('Content-Type: application/pdf');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        echo $pdf;
        exit;
    }

    function hms_current_user_name($con, $role)
    {
        $id = isset($_SESSION['id']) ? (int) $_SESSION['id'] : 0;
        if ($role === 'patient') {
            $row = hms_fetch_one($con, 'SELECT fullName FROM users WHERE id = ?', 'i', array($id));
            return $row ? $row['fullName'] : 'Patient';
        }
        if ($role === 'doctor') {
            $row = hms_fetch_one($con, 'SELECT doctorName FROM doctors WHERE id = ?', 'i', array($id));
            return $row ? $row['doctorName'] : 'Doctor';
        }
        return 'Admin';
    }

    function hms_nav_items($role)
    {
        if ($role === 'admin') {
            return array(
                array('dashboard', 'Dasbor', hms_admin_url('dashboard.php'), 'bi-speedometer2'),
                array('appointments', 'Janji Temu', hms_admin_url('appointment-history.php'), 'bi-calendar-check'),
                array('availability', 'Ketersediaan', hms_admin_url('doctor-availability.php'), 'bi-clock-history'),
                array('notifications', 'Notifikasi', hms_admin_url('notifications.php'), 'bi-bell'),
                array('audit', 'Log Audit', hms_admin_url('audit-logs.php'), 'bi-shield-check'),
                array('doctors', 'Dokter', hms_admin_url('manage-doctors.php'), 'bi-person-badge'),
                array('patients', 'Pasien', hms_admin_url('manage-patient.php'), 'bi-people'),
                array('reports', 'Laporan', hms_admin_url('between-dates-reports.php'), 'bi-file-earmark-text')
            );
        }
        if ($role === 'doctor') {
            return array(
                array('dashboard', 'Dasbor', 'dashboard.php', 'bi-speedometer2'),
                array('appointments', 'Janji Temu', 'appointment-history.php', 'bi-calendar-check'),
                array('availability', 'Ketersediaan', 'availability.php', 'bi-clock-history'),
                array('prescriptions', 'Resep', 'prescriptions.php', 'bi-file-medical'),
                array('patients', 'Pasien', 'manage-patient.php', 'bi-people'),
                array('search', 'Cari', 'search.php', 'bi-search')
            );
        }
        return array(
            array('dashboard', 'Dasbor', 'dashboard.php', 'bi-speedometer2'),
            array('book', 'Buat Janji Temu', 'book-appointment.php', 'bi-calendar-plus'),
            array('appointments', 'Janji Temu', 'appointment-history.php', 'bi-calendar-check'),
            array('history', 'Riwayat Medis', 'manage-medhistory.php', 'bi-journal-medical'),
            array('profile', 'Profil', 'edit-profile.php', 'bi-person')
        );
    }

    function hms_auth_header($title, $heading, $subtitle = '', $homeHref = '../index.php')
    {
        ob_start();
        ?>
<!doctype html>
<html lang="<?php echo hms_e(hms_lang()); ?>">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php echo hms_e($title); ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --auth-bg: #f5f8fb;
            --auth-ink: #1f2937;
            --auth-muted: #667085;
            --auth-line: #d9e2ec;
            --auth-teal: #127c8a;
            --auth-navy: #17324d;
            --auth-amber: #b7791f;
        }
        body {
            min-height: 100vh;
            margin: 0;
            background:
                linear-gradient(135deg, rgba(18, 124, 138, .11), rgba(183, 121, 31, .08)),
                var(--auth-bg);
            color: var(--auth-ink);
            letter-spacing: 0;
        }
        .auth-shell {
            min-height: 100vh;
            display: grid;
            grid-template-columns: minmax(280px, 480px) minmax(0, 1fr);
        }
        .auth-panel {
            background: #fff;
            border-right: 1px solid var(--auth-line);
            padding: 32px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .auth-card {
            border: 1px solid var(--auth-line);
            border-radius: 8px;
            box-shadow: 0 18px 42px rgba(16, 24, 40, .08);
            padding: 28px;
        }
        .auth-brand {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            color: var(--auth-navy);
            font-weight: 750;
            margin-bottom: 24px;
        }
        .auth-brand-icon {
            width: 38px;
            height: 38px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            background: var(--auth-teal);
        }
        .auth-card h1 {
            font-size: 26px;
            line-height: 1.2;
            margin-bottom: 8px;
            font-weight: 750;
        }
        .auth-muted { color: var(--auth-muted); }
        .auth-side {
            padding: 44px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .auth-side-inner {
            max-width: 560px;
        }
        .auth-metric {
            background: rgba(255, 255, 255, .76);
            border: 1px solid rgba(217, 226, 236, .85);
            border-radius: 8px;
            padding: 18px;
            min-height: 120px;
        }
        .form-control, .form-select, .btn { border-radius: 7px; }
        .btn-primary {
            background: var(--auth-teal);
            border-color: var(--auth-teal);
        }
        .btn-primary:hover, .btn-primary:focus {
            background: #0f6671;
            border-color: #0f6671;
        }
        a { color: var(--auth-teal); text-decoration: none; }
        a:hover { color: #0f6671; text-decoration: underline; }
        @media (max-width: 991.98px) {
            .auth-shell { display: block; }
            .auth-side { display: none; }
            .auth-panel {
                min-height: 100vh;
                border-right: 0;
                padding: 20px;
            }
            .auth-card { padding: 22px; }
        }
    </style>
</head>
<body>
<div class="auth-shell">
    <section class="auth-panel">
        <div class="auth-card">
            <div class="d-flex justify-content-end gap-1 mb-3">
                <a class="btn btn-sm <?php echo hms_lang() === 'id' ? 'btn-primary' : 'btn-outline-primary'; ?>" href="<?php echo hms_e(hms_language_url('id')); ?>">ID</a>
                <a class="btn btn-sm <?php echo hms_lang() === 'en' ? 'btn-primary' : 'btn-outline-primary'; ?>" href="<?php echo hms_e(hms_language_url('en')); ?>">EN</a>
            </div>
            <a class="auth-brand" href="<?php echo hms_e($homeHref); ?>">
                <span class="auth-brand-icon"><i class="bi bi-hospital"></i></span>
                <span>Sistem Informasi Manajemen Rumah Sakit</span>
            </a>
            <h1><?php echo hms_e($heading); ?></h1>
            <?php if ($subtitle !== '') { ?><p class="auth-muted mb-4"><?php echo hms_e($subtitle); ?></p><?php } ?>
            <?php
            $flash = hms_get_flash();
            if ($flash) {
                $type = $flash['type'] === 'error' ? 'danger' : $flash['type'];
                echo '<div class="alert alert-' . hms_e($type) . ' alert-dismissible fade show" role="alert">' . hms_e($flash['message']) . '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div>';
            }
    }

    function hms_auth_footer($extraScripts = '')
    {
        ?>
        </div>
    </section>
    <aside class="auth-side">
        <div class="auth-side-inner">
            <div class="d-inline-flex align-items-center gap-2 px-3 py-2 rounded-3 bg-white border mb-4">
                <i class="bi bi-shield-check text-success"></i>
                <span class="small fw-semibold">Akses aman untuk tim rumah sakit</span>
            </div>
            <h2 class="display-6 fw-bold mb-3">Kelola alur pelayanan dengan jelas.</h2>
            <p class="auth-muted fs-5 mb-4">Janji temu, rekam pasien, resep, dan ketersediaan dokter terorganisasi dalam satu sistem responsif.</p>
            <div class="row g-3">
                <div class="col-sm-4"><div class="auth-metric"><i class="bi bi-calendar-check fs-3 text-success"></i><div class="fw-bold mt-3">Janji Temu</div><div class="small auth-muted">Pantau setiap status</div></div></div>
                <div class="col-sm-4"><div class="auth-metric"><i class="bi bi-file-medical fs-3 text-primary"></i><div class="fw-bold mt-3">Resep</div><div class="small auth-muted">Rekam yang dapat diunduh</div></div></div>
                <div class="col-sm-4"><div class="auth-metric"><i class="bi bi-clock-history fs-3" style="color: var(--auth-amber);"></i><div class="fw-bold mt-3">Ketersediaan</div><div class="small auth-muted">Jadwal dokter</div></div></div>
            </div>
        </div>
    </aside>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<?php echo $extraScripts; ?>
</body>
</html>
<?php
        $hmsRendered = ob_get_clean();
        echo hms_translate_html($hmsRendered);
    }

    function hms_layout_header($title, $role, $active = 'dashboard')
    {
        ob_start();
        global $con;
        $name = hms_current_user_name($con, $role);
        $items = hms_nav_items($role);
        $logout = $role === 'admin' ? 'logout.php' : 'logout.php';
        ?>
<!doctype html>
<html lang="<?php echo hms_e(hms_lang()); ?>">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php echo hms_e($title); ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --hms-ink: #1f2937;
            --hms-muted: #667085;
            --hms-line: #d9e2ec;
            --hms-bg: #f6f8fb;
            --hms-sidebar: #17324d;
            --hms-sidebar-active: #256f7a;
            --hms-teal: #127c8a;
            --hms-amber: #b7791f;
        }
        body { background: var(--hms-bg); color: var(--hms-ink); font-size: 14px; letter-spacing: 0; }
        a { text-decoration: none; }
        .hms-shell { min-height: 100vh; display: grid; grid-template-columns: 260px minmax(0, 1fr); }
        .hms-sidebar { background: var(--hms-sidebar); color: #fff; padding: 18px 14px; position: sticky; top: 0; height: 100vh; }
        .hms-brand { display: flex; align-items: center; gap: 10px; padding: 8px 10px 20px; font-weight: 700; }
        .hms-brand-icon { width: 34px; height: 34px; border-radius: 8px; background: #e6fffb; color: var(--hms-teal); display: inline-flex; align-items: center; justify-content: center; }
        .hms-nav a { color: #dbeafe; display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 8px; margin-bottom: 4px; }
        .hms-nav a.active, .hms-nav a:hover { background: var(--hms-sidebar-active); color: #fff; }
        .hms-main { min-width: 0; }
        .hms-topbar { background: #fff; border-bottom: 1px solid var(--hms-line); min-height: 64px; display: flex; align-items: center; justify-content: space-between; padding: 0 24px; position: sticky; top: 0; z-index: 10; }
        .hms-content { padding: 24px; }
        .hms-page-title { display: flex; justify-content: space-between; gap: 16px; align-items: center; margin-bottom: 20px; }
        .hms-page-title h1 { font-size: 26px; margin: 0; font-weight: 700; }
        .hms-card { background: #fff; border: 1px solid var(--hms-line); border-radius: 8px; box-shadow: 0 8px 24px rgba(16, 24, 40, .04); }
        .hms-stat { padding: 18px; min-height: 118px; }
        .hms-stat .icon { width: 42px; height: 42px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; background: #e6fffb; color: var(--hms-teal); font-size: 20px; }
        .hms-stat .value { font-size: 28px; font-weight: 750; margin-top: 12px; }
        .hms-stat .label { color: var(--hms-muted); }
        .table thead th { color: #475467; background: #f8fafc; font-size: 12px; text-transform: uppercase; white-space: nowrap; }
        .table td, .table th { vertical-align: middle; }
        .btn { border-radius: 7px; }
        .form-control, .form-select { border-radius: 7px; }
        .timeline { position: relative; padding-left: 28px; }
        .timeline:before { content: ""; position: absolute; left: 9px; top: 4px; bottom: 4px; width: 2px; background: var(--hms-line); }
        .timeline-item { position: relative; padding-bottom: 18px; }
        .timeline-item:before { content: ""; position: absolute; left: -23px; top: 4px; width: 12px; height: 12px; border-radius: 50%; background: var(--hms-teal); border: 2px solid #fff; box-shadow: 0 0 0 2px var(--hms-line); }
        .mobile-menu-btn { display: none; }
        @media (max-width: 991.98px) {
            .hms-shell { display: block; }
            .hms-sidebar { display: none; }
            .mobile-menu-btn { display: inline-flex; }
            .hms-content { padding: 16px; }
            .hms-page-title { align-items: flex-start; flex-direction: column; }
        }
        @media (max-width: 575.98px) {
            .hms-topbar { padding: 0 14px; }
            .hms-page-title h1 { font-size: 22px; }
            .hms-stat .value { font-size: 24px; }
        }
    </style>
</head>
<body>
<div class="hms-shell">
    <aside class="hms-sidebar">
        <div class="hms-brand"><span class="hms-brand-icon"><i class="bi bi-hospital"></i></span><span>HMS</span></div>
        <nav class="hms-nav">
            <?php foreach ($items as $item) { ?>
                <a class="<?php echo $active === $item[0] ? 'active' : ''; ?>" href="<?php echo hms_e($item[2]); ?>">
                    <i class="bi <?php echo hms_e($item[3]); ?>"></i><span><?php echo hms_e($item[1]); ?></span>
                </a>
            <?php } ?>
        </nav>
    </aside>
    <div class="hms-main">
        <header class="hms-topbar">
            <button class="btn btn-outline-secondary mobile-menu-btn" type="button" data-bs-toggle="offcanvas" data-bs-target="#mobileNav" aria-label="Open navigation">
                <i class="bi bi-list"></i>
            </button>
            <div class="fw-semibold">Sistem Informasi Manajemen Rumah Sakit</div>
            <div class="dropdown">
                <button class="btn btn-light dropdown-toggle" type="button" data-bs-toggle="dropdown">
                    <i class="bi bi-person-circle me-1"></i><?php echo hms_e($name); ?>
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <?php if ($role !== 'admin') { ?><li><a class="dropdown-item" href="edit-profile.php">Profile</a></li><?php } ?>
                    <li><a class="dropdown-item" href="change-password.php">Ubah Kata Sandi</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="<?php echo hms_e($logout); ?>">Log Out</a></li>
                </ul>
            </div>
        </header>
        <div class="offcanvas offcanvas-start" tabindex="-1" id="mobileNav">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title">HMS</h5>
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <div class="offcanvas-body">
                <nav class="list-group">
                    <?php foreach ($items as $item) { ?>
                        <a class="list-group-item list-group-item-action <?php echo $active === $item[0] ? 'active' : ''; ?>" href="<?php echo hms_e($item[2]); ?>">
                            <i class="bi <?php echo hms_e($item[3]); ?> me-2"></i><?php echo hms_e($item[1]); ?>
                        </a>
                    <?php } ?>
                </nav>
            </div>
        </div>
        <main class="hms-content">
<?php
        $flash = hms_get_flash();
        if ($flash) {
            $type = $flash['type'] === 'error' ? 'danger' : $flash['type'];
            echo '<div class="alert alert-' . hms_e($type) . ' alert-dismissible fade show" role="alert">' . hms_e($flash['message']) . '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div>';
        }
    }

    function hms_layout_footer($extraScripts = '')
    {
        ?>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.querySelectorAll('[data-table-search]').forEach(function (input) {
    input.addEventListener('input', function () {
        var selector = input.getAttribute('data-table-search');
        var table = document.querySelector(selector);
        if (!table) return;
        var query = input.value.toLowerCase();
        table.querySelectorAll('tbody tr').forEach(function (row) {
            row.hidden = row.textContent.toLowerCase().indexOf(query) === -1;
        });
    });
});
document.querySelectorAll('table[data-sortable] th[data-sort]').forEach(function (th, index) {
    th.style.cursor = 'pointer';
    th.addEventListener('click', function () {
        var table = th.closest('table');
        var tbody = table.querySelector('tbody');
        var rows = Array.from(tbody.querySelectorAll('tr'));
        var direction = th.dataset.direction === 'asc' ? 'desc' : 'asc';
        th.dataset.direction = direction;
        rows.sort(function (a, b) {
            var av = a.children[index].textContent.trim().toLowerCase();
            var bv = b.children[index].textContent.trim().toLowerCase();
            return direction === 'asc' ? av.localeCompare(bv) : bv.localeCompare(av);
        });
        rows.forEach(function (row) { tbody.appendChild(row); });
    });
});
</script>
<?php echo $extraScripts; ?>
</body>
</html>
<?php
        $hmsRendered = ob_get_clean();
        echo hms_translate_html($hmsRendered);
    }
}
?>
