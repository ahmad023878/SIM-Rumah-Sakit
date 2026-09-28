<?php
session();
include_once 'hms/include/config.php';

if (isset($_POST['submit'])) {
    hms_verify_csrf();
    $name = hms_post('fullname');
    $email = hms_post('emailid');
    $mobile = hms_post('mobileno');
    $message = hms_post('description');

    if ($name === '' || !filter_var($email, FILTER_VALIDATE_EMAIL) || !preg_match('/^[0-9+\-\s]{7,15}$/', $mobile) || $message === '') {
        hms_flash('danger', 'Silakan masukkan data kontak yang valid.');
    } else {
        hms_execute(
            $con,
            'INSERT INTO tblcontactus(fullname, email, contactno, message) VALUES(?, ?, ?, ?)',
            'ssss',
            array($name, $email, $mobile, $message)
        );
        $queryId = mysqli_insert_id($con);
        hms_notify($con, 'admin', null, 'Pertanyaan kontak baru', $name . ' mengirimkan pertanyaan kontak.');
        hms_log_audit($con, 'public', 0, 'contact_query_created', 'tblcontactus', $queryId, 'Pertanyaan kontak publik baru.');
        hms_flash('success', 'Data Anda berhasil dikirim.');
        hms_redirect('index.php#contact_us');
    }
}

$about = hms_fetch_one($con, "SELECT * FROM tblpage WHERE PageType = 'aboutus'");
$contact = hms_fetch_one($con, "SELECT * FROM tblpage WHERE PageType = 'contactus'");
$flash = hms_get_flash();
?>
<!doctype html>
<html lang="<?php echo hms_e(hms_lang()); ?>">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>SIMRS - Sistem Informasi Manajemen Rumah Sakit</title>
    <link rel="shortcut icon" href="assets/images/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary:#087ea4; --primary-dark:#075985; --teal:#08a88a; --navy:#102a56;
            --ink:#18324d; --muted:#60758b; --line:#dce8f2; --soft:#f4f9fc; --white:#fff;
        }
        * { box-sizing:border-box; }
        html { scroll-behavior:smooth; }
        body { margin:0; color:var(--ink); background:#f7fbfe; font-family:Arial, Helvetica, sans-serif; }
        a { text-decoration:none; }
        .navbar { background:rgba(255,255,255,.92); backdrop-filter:blur(16px); border-bottom:1px solid rgba(220,232,242,.9); }
        .brand { display:flex; align-items:center; gap:10px; color:var(--navy); font-weight:800; line-height:1.05; }
        .brand img { width:46px; height:46px; object-fit:contain; border-radius:12px; }
        .brand small { display:block; color:var(--muted); font-weight:600; font-size:11px; }
        .nav-link { color:#29415c!important; font-weight:600; padding:12px 14px!important; }
        .nav-link:hover { color:var(--primary)!important; }
        .btn-primary { background:linear-gradient(135deg,var(--primary),#006ee6); border:0; box-shadow:0 10px 24px rgba(8,126,164,.22); }
        .btn-primary:hover { background:linear-gradient(135deg,#056f91,#005fc7); }
        .btn { border-radius:13px; padding:.72rem 1.15rem; font-weight:700; }
        .hero { position:relative; min-height:620px; padding:120px 0 90px; overflow:hidden; background:#eaf7fb; }
        .hero:before { content:""; position:absolute; inset:0; background:linear-gradient(90deg,rgba(239,250,255,.98) 0%,rgba(239,250,255,.9) 34%,rgba(239,250,255,.24) 63%,rgba(239,250,255,.03) 100%),url('assets/images/slider/banner_hero_modern.jpg') center right/cover no-repeat; }
        .hero .container { position:relative; z-index:2; }
        .hero-copy { max-width:650px; padding-top:10px; }
        .eyebrow { display:inline-flex; align-items:center; gap:8px; padding:8px 14px; border-radius:999px; background:#fff; color:#075985; box-shadow:0 8px 24px rgba(16,72,100,.08); font-weight:800; }
        .hero h1 { color:var(--navy); font-size:clamp(2.6rem,5.4vw,4.7rem); line-height:.98; font-weight:900; letter-spacing:-2px; margin:22px 0 20px; }
        .hero h1 span { color:var(--teal); }
        .hero p { color:#46617b; font-size:1.12rem; line-height:1.65; max-width:620px; }
        .trust-row { display:flex; flex-wrap:wrap; gap:14px; margin-top:28px; }
        .trust-pill { display:flex; align-items:center; gap:9px; color:#294b68; font-weight:700; }
        .trust-pill i { width:34px; height:34px; display:grid; place-items:center; border-radius:50%; background:#e5f5ff; color:var(--primary); }
        .stats { position:relative; z-index:5; margin-top:-45px; }
        .stats-card { background:rgba(255,255,255,.97); border:1px solid var(--line); border-radius:24px; padding:20px; box-shadow:0 20px 50px rgba(16,55,80,.10); }
        .stat { display:flex; align-items:center; gap:14px; padding:8px 24px; border-right:1px solid var(--line); }
        .stat:last-child { border-right:0; }
        .stat-icon { width:52px;height:52px;border-radius:18px;display:grid;place-items:center;font-size:23px;background:#eaf6ff;color:#087ea4; }
        .stat strong { display:block; color:var(--navy); font-size:1.45rem; }
        .stat span { color:var(--muted); font-size:.88rem; }
        .section-pad { padding:88px 0; }
        .section-kicker { color:var(--primary); font-weight:800; margin-bottom:8px; }
        .section-title h2 { color:var(--navy); font-size:clamp(2rem,4vw,3rem); font-weight:900; letter-spacing:-1px; }
        .section-title p { color:var(--muted); max-width:720px; }
        .service-card { height:100%; background:#fff; border:1px solid var(--line); border-radius:22px; padding:25px; box-shadow:0 12px 34px rgba(16,55,80,.06); transition:.25s ease; }
        .service-card:hover { transform:translateY(-7px); box-shadow:0 20px 42px rgba(16,55,80,.12); }
        .service-icon { width:56px;height:56px;border-radius:18px;display:grid;place-items:center;font-size:24px;margin-bottom:20px; background:#eef9ff;color:var(--primary); }
        .service-card h3 { color:var(--navy); font-size:1.1rem; font-weight:800; }
        .service-card p { color:var(--muted); margin:0; line-height:1.6; }
        .login-card { overflow:hidden; background:#fff; border:1px solid var(--line); border-radius:24px; box-shadow:0 15px 35px rgba(16,55,80,.07); transition:.25s; height:100%; }
        .login-card:hover { transform:translateY(-7px); box-shadow:0 22px 45px rgba(16,55,80,.13); }
        .login-card img { width:100%; aspect-ratio:16/9; object-fit:cover; }
        .login-card-body { padding:24px; }
        .login-card h3 { color:var(--navy); font-weight:800; }
        .login-card p { color:var(--muted); min-height:50px; }
        .about-band { background:linear-gradient(135deg,#e9f8ff,#f4fffc); }
        .about-image { min-height:430px; background:url('assets/images/why.jpg') center/cover no-repeat; border-radius:28px; }
        .about-panel { padding:40px; }
        .check-item { display:flex; gap:12px; margin-top:18px; color:#46617b; }
        .check-item i { color:var(--teal); font-size:20px; }
        .gallery-img { width:100%; aspect-ratio:4/3; object-fit:cover; border-radius:20px; border:1px solid var(--line); transition:.25s; }
        .gallery-img:hover { transform:scale(1.025); box-shadow:0 15px 30px rgba(16,55,80,.12); }
        .contact-panel { background:#fff; border:1px solid var(--line); border-radius:24px; padding:28px; box-shadow:0 15px 35px rgba(16,55,80,.06); }
        .form-control { border-radius:13px; padding:12px 14px; border-color:#d7e5ef; }
        footer { background:#0d2748; color:#cbd9e8; padding:46px 0; }
        footer a { color:#e7f5ff; }
        @media(max-width:991px){ .hero{min-height:700px;padding-top:115px}.hero:before{background:linear-gradient(90deg,rgba(239,250,255,.98),rgba(239,250,255,.75)),url('assets/images/slider/banner_hero_modern.jpg') center/cover}.stat{border-right:0;border-bottom:1px solid var(--line);padding:15px}.stat:last-child{border-bottom:0}.about-image{min-height:320px}.navbar-collapse{background:#fff;padding:15px;border-radius:16px;margin-top:8px} }
        @media(max-width:575px){ .hero{min-height:720px;padding:105px 0 80px}.hero h1{font-size:3rem}.section-pad{padding:60px 0}.stats{margin-top:-30px}.hero p{font-size:1rem} }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">
        <a class="brand" href="#">
            <img src="assets/images/logo.png" alt="Logo SIMRS">
            <span>SIMRS<small>Sistem Informasi Manajemen Rumah Sakit</small></span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav"><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav ms-auto align-items-lg-center">
                <li class="nav-item"><a class="nav-link" href="#services">Layanan</a></li>
                <li class="nav-item"><a class="nav-link" href="#about_us">Tentang Kami</a></li>
                <li class="nav-item"><a class="nav-link" href="#gallery">Galeri</a></li>
                <li class="nav-item"><a class="nav-link" href="#contact_us">Kontak</a></li>
                <li class="nav-item"><a class="nav-link" href="#logins">Masuk</a></li>
                <li class="nav-item ms-lg-2"><a class="btn btn-primary" href="hms/user-login.php"><i class="bi bi-calendar-check me-1"></i>Buat Janji Temu</a></li>
                <li class="nav-item ms-lg-2 d-flex align-items-center gap-1">
                    <a class="btn btn-sm <?php echo hms_lang() === 'id' ? 'btn-primary' : 'btn-outline-primary'; ?>" href="<?php echo hms_e(hms_language_url('id')); ?>">ID</a>
                    <a class="btn btn-sm <?php echo hms_lang() === 'en' ? 'btn-primary' : 'btn-outline-primary'; ?>" href="<?php echo hms_e(hms_language_url('en')); ?>">EN</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<header class="hero">
    <div class="container">
        <div class="hero-copy">
            <div class="eyebrow"><i class="bi bi-shield-check"></i>Pelayanan Kesehatan Terpercaya</div>
            <h1>Sistem Informasi<br><span>Manajemen Rumah Sakit</span></h1>
            <p>Platform terintegrasi untuk janji temu pasien, jadwal dokter, rekam medis, resep, laporan, dan komunikasi rumah sakit secara digital.</p>
            <div class="d-flex flex-wrap gap-3 mt-4">
                <a class="btn btn-primary btn-lg" href="hms/user-login.php"><i class="bi bi-calendar-plus me-2"></i>Buat Janji Temu</a>
                <a class="btn btn-outline-primary btn-lg" href="#services"><i class="bi bi-grid me-2"></i>Lihat Layanan</a>
            </div>
            <div class="trust-row">
                <div class="trust-pill"><i class="bi bi-shield-check"></i>Aman & Terpercaya</div>
                <div class="trust-pill"><i class="bi bi-people"></i>Tenaga Profesional</div>
                <div class="trust-pill"><i class="bi bi-lightning-charge"></i>Cepat & Mudah</div>
            </div>
        </div>
    </div>
</header>

<section class="stats">
    <div class="container">
        <div class="stats-card row g-0">
            <div class="col-md-3 stat"><div class="stat-icon"><i class="bi bi-people-fill"></i></div><div><strong>10.000+</strong><span>Pasien Terlayani</span></div></div>
            <div class="col-md-3 stat"><div class="stat-icon"><i class="bi bi-person-badge"></i></div><div><strong>50+</strong><span>Dokter Spesialis</span></div></div>
            <div class="col-md-3 stat"><div class="stat-icon"><i class="bi bi-hospital"></i></div><div><strong>25+</strong><span>Layanan Klinik</span></div></div>
            <div class="col-md-3 stat"><div class="stat-icon"><i class="bi bi-heart-pulse"></i></div><div><strong>99%</strong><span>Kepuasan Pasien</span></div></div>
        </div>
    </div>
</section>

<main>
<section id="services" class="section-pad">
    <div class="container">
        <div class="section-title mb-5">
            <div class="section-kicker">LAYANAN UNGGULAN</div>
            <h2>Layanan Kesehatan Terbaik untuk Anda</h2>
            <p>Berbagai layanan kesehatan yang dapat diakses dengan mudah, cepat, aman, dan terintegrasi.</p>
        </div>
        <div class="row g-4">
            <?php
            $services = array(
                array('bi-calendar-check','Janji Temu Online','Pesan jadwal pemeriksaan dokter secara mudah dan cepat.'),
                array('bi-person-badge','Jadwal Dokter','Lihat jadwal praktik dokter spesialis dan pilih waktu yang sesuai.'),
                array('bi-file-medical','Rekam Medis','Akses riwayat kesehatan Anda secara digital dan aman.'),
                array('bi-capsule','Resep Digital','Resep obat terintegrasi dengan sistem pelayanan farmasi.'),
                array('bi-bar-chart-line','Laporan Kesehatan','Laporan lengkap dan akurat untuk mendukung pengambilan keputusan.'),
                array('bi-chat-dots','Komunikasi','Informasi dan komunikasi antara pasien dengan tenaga medis.')
            );
            foreach($services as $service){ ?>
                <div class="col-sm-6 col-lg-4"><div class="service-card"><div class="service-icon"><i class="bi <?php echo hms_e($service[0]); ?>"></i></div><h3><?php echo hms_e($service[1]); ?></h3><p><?php echo hms_e($service[2]); ?></p></div></div>
            <?php } ?>
        </div>
    </div>
</section>

<section id="logins" class="section-pad bg-white">
    <div class="container">
        <div class="section-title mb-5">
            <div class="section-kicker">AKSES SISTEM</div>
            <h2>Masuk Sesuai Peran Anda</h2>
            <p>Pilih portal yang sesuai untuk mengakses layanan SIMRS.</p>
        </div>
        <?php if ($flash) { $type = $flash['type'] === 'error' ? 'danger' : $flash['type']; ?>
            <div class="alert alert-<?php echo hms_e($type); ?> alert-dismissible fade show" role="alert"><?php echo hms_e($flash['message']); ?><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        <?php } ?>
        <div class="row g-4">
            <div class="col-md-4"><div class="login-card"><img src="assets/images/patient.jpg" alt="Pelayanan pasien"><div class="login-card-body"><h3>Pasien</h3><p>Kelola janji temu, pantau status pemeriksaan, dan unduh resep.</p><a class="btn btn-primary w-100" href="hms/user-login.php">Masuk sebagai Pasien</a></div></div></div>
            <div class="col-md-4"><div class="login-card"><img src="assets/images/doctor.jpg" alt="Dokter"><div class="login-card-body"><h3>Dokter</h3><p>Kelola jadwal, janji temu, resep, dan riwayat pasien.</p><a class="btn btn-primary w-100" href="hms/doctor/">Masuk sebagai Dokter</a></div></div></div>
            <div class="col-md-4"><div class="login-card"><img src="assets/images/admin.jpg" alt="Administrasi rumah sakit"><div class="login-card-body"><h3>Administrator</h3><p>Kelola operasional, laporan, notifikasi, dan aktivitas sistem.</p><a class="btn btn-primary w-100" href="hms/admin/">Masuk sebagai Administrator</a></div></div></div>
        </div>
    </div>
</section>

<section id="about_us" class="section-pad about-band">
    <div class="container">
        <div class="row g-5 align-items-center">
            <div class="col-lg-6"><div class="about-image"></div></div>
            <div class="col-lg-6 about-panel">
                <div class="section-kicker">TENTANG SIMRS</div>
                <h2 class="fw-bold display-6">Kesehatan Anda adalah Prioritas Kami</h2>
                <p class="text-muted fs-5">SIMRS membantu rumah sakit mengelola pelayanan secara terintegrasi, efisien, aman, dan mudah digunakan oleh pasien maupun tenaga kesehatan.</p>
                <div class="check-item"><i class="bi bi-check-circle-fill"></i><span><strong>Terintegrasi</strong><br>Informasi antarunit tersusun dalam satu sistem.</span></div>
                <div class="check-item"><i class="bi bi-check-circle-fill"></i><span><strong>Aman</strong><br>Data pelayanan dikelola dengan memperhatikan keamanan informasi.</span></div>
                <div class="check-item"><i class="bi bi-check-circle-fill"></i><span><strong>Mudah Digunakan</strong><br>Akses layanan sederhana dari berbagai perangkat.</span></div>
                <a href="#contact_us" class="btn btn-primary mt-3">Hubungi Kami <i class="bi bi-arrow-right ms-1"></i></a>
            </div>
        </div>
    </div>
</section>

<section id="gallery" class="section-pad">
    <div class="container">
        <div class="section-title mb-5"><div class="section-kicker">GALERI KEGIATAN</div><h2>Suasana Pelayanan Rumah Sakit</h2><p>Dokumentasi fasilitas, tenaga medis, dan kegiatan pelayanan rumah sakit.</p></div>
        <div class="row g-3">
            <?php foreach(array('01','02','03','04','05','06') as $image){ ?><div class="col-sm-6 col-lg-4"><img class="gallery-img" src="assets/images/gallery/gallery_<?php echo hms_e($image); ?>.jpg" alt="Galeri kegiatan rumah sakit"></div><?php } ?>
        </div>
    </div>
</section>

<section id="contact_us" class="section-pad bg-white">
    <div class="container"><div class="row g-5 align-items-center">
        <div class="col-lg-5"><div class="section-kicker">HUBUNGI KAMI</div><h2 class="display-6 fw-bold">Kami Siap Membantu Anda</h2><p class="text-muted fs-5">Silakan kirim pertanyaan atau kebutuhan informasi melalui formulir berikut.</p>
            <div class="mt-4"><p><i class="bi bi-telephone text-primary me-2"></i><?php echo hms_e($contact['MobileNumber'] ?? ''); ?></p><p><i class="bi bi-envelope text-primary me-2"></i><?php echo hms_e($contact['Email'] ?? ''); ?></p></div>
        </div>
        <div class="col-lg-7"><div class="contact-panel"><form method="post"><?php echo hms_csrf_field(); ?><div class="row g-3">
            <div class="col-md-6"><label class="form-label fw-semibold" for="fullname">Nama Lengkap</label><input type="text" class="form-control" id="fullname" name="fullname" required></div>
            <div class="col-md-6"><label class="form-label fw-semibold" for="emailid">Alamat Email</label><input type="email" class="form-control" id="emailid" name="emailid" required></div>
            <div class="col-12"><label class="form-label fw-semibold" for="mobileno">Nomor Telepon</label><input type="text" class="form-control" id="mobileno" name="mobileno" required></div>
            <div class="col-12"><label class="form-label fw-semibold" for="description">Pesan</label><textarea class="form-control" id="description" name="description" rows="5" required></textarea></div>
        </div><button class="btn btn-primary mt-4" type="submit" name="submit"><i class="bi bi-send me-1"></i>Kirim Pesan</button></form></div></div>
    </div></div>
</section>
</main>
<footer><div class="container d-flex flex-column flex-md-row justify-content-between gap-3"><div><div class="fw-bold text-white">SIMRS - Sistem Informasi Manajemen Rumah Sakit</div><div class="small">Janji temu, rekam medis, resep, laporan, dan layanan rumah sakit dalam satu sistem.</div></div><div class="d-flex flex-wrap gap-3"><a href="#services">Layanan</a><a href="#about_us">Tentang Kami</a><a href="#gallery">Galeri</a><a href="#contact_us">Kontak</a><a href="#logins">Masuk</a></div></div></footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
