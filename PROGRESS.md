# LAPORAN KEMAJUAN PROYEK APLIKASI WEB

> **Ketentuan:** File ini berada di folder utama (*root*) repository dan diperbarui setiap Jumat. Tuliskan laporan minggu terbaru paling atas. **Jangan menghapus laporan minggu-minggu sebelumnya.** Jika fitur belum selesai atau masih error, tetap laporkan secara jujur dan sertakan bukti teknis yang aman untuk dibagikan.

## Identitas Proyek

| Keterangan | Isi |
|---|---|
| Nama Ahmad Yabi / NIM | [2605164002] |
| Nama aplikasi | [Sistem Informasi Manajemen Rumah Sakit] |
| Repository GitHub | [https://github.com/ahmad023878/] |
| Branch yang direview | [nama branch] |
| Status umum proyek | [Dalam proses / Perlu bantuan / Siap direview / Selesai] | Siap direview
| Terakhir diperbarui | [2026-11-13] |

## Ringkasan Kemajuan Saat Ini

- Fitur utama yang sudah berjalan: [Login untuk( dosen,pasien dan admin), menu dokter, menu pasien, admin dan Membuat Janji temu, Layanan Lainya(M2 Queue & Waiting-Waktu Instrumentation)].
- Fitur yang masih dikerjakan: [M3-AdaBoost service-duration predictio].
- Kendala utama saat ini: [isi ringkas, atau "Tidak ada"] Kendala integrasi data ke Adaboost.
- Tautan PR aktif: [tempel URL PR, atau "Belum ada"]-http://localhost:8080/hospital-sim/hms/admin/queue-waiting-time.php?from=2026-11-13&to=2026-11-15&poli=Poli+Bedah.

---

## Riwayat Laporan Mingguan (terbaru di atas)

### Minggu ke-[2] — [2026-11-09 s.d. 2026-11-13]

**Tanggal pembaruan:** 2026-11-13, Jumat
**Branch:** `main` (atau `ahmad023878-patch-1`)
**Commit terakhir:** `775aa4f`
**Pull Request:** https://github.com (atau "Belum ada" jika belum dibuat)


#### 1. Target minggu ini

- [X] [Target 1]
- [X] [Target 2]
- [ ] [Target 3]

#### 2. Pekerjaan yang sudah selesai

- [x] [Fitur/perbaikan yang benar-benar telah dikerjakan dan diverifikasi]||[Layanan, M2-Queue & waiting-time instrumentation] 
- [x] [Fitur/perbaikan lain, jika ada] - [Antrin registrasi Pasein]

#### 3. Pekerjaan yang belum selesai / masih error

| Fitur / pekerjaan | Kondisi saat ini | Kendala atau pesan error ringkas | Upaya yang sudah dicoba | Bantuan yang dibutuhkan |
|M03|AdaBoost service-duration prediction|---|---|---|
| [fitur] | [Belum selesai / Error / Diblokir] | [uraian tanpa data rahasia] | [uraian] | [uraian] |
AdaBoost service-duration prediction ke Apointmen
#### 4. Hasil pengujian

| Pengujian | Hasil | Bukti / catatan |
|---|---|---|
[Uji login Admin, Doctor, dan Patient]|[Sudah Diuji]| [Berhasil Login]
[Uji Patient membuat appointment]|[Sudah Diuji]|[Berhasil dibuat]
[Doctor dapat melihat dan mengubah status appointment]|[sudah diuji]|[Sudah Berhasil]
[Admin dapat melihat appointment] |[Sudah diuji]|[sudah bisa melihat appointment]
[perubahan status terlihat kembali oleh Patient]|[Sudah diuji]|[Sudah bisa lihat] 
[M2 Queue & waiting-time instrumentation]|[Sudah Diuji]|[Bisa dilihat hasil M2]

#### 5. Tindak lanjut review dosen sebelumnya

- [x] [Saran yang sudah ditindaklanjuti, dengan tautan commit/PR bila ada]
- [ ] [Saran yang belum ditindaklanjuti dan alasannya]

#### 6. Rencana lima hari kerja berikutnya

| Prioritas | Tugas | Kriteria selesai |
|---|---|---|
| P0 | [pekerjaan kritis] | [bukti yang dapat diuji] | [Membuat fitur login dan autentikasi pengguna]
| P1 | [pekerjaan penting] | [bukti yang dapat diuji] |[Membuat halaman Admin, Dokter, Pasien]|[
Admin, Dokter, Pasien tampil dari database dan kolom pencarian dapat memfilter sesuai kata kunci yang diketik.
]
| P2 | [penyempurnaan] | [bukti yang dapat diuji] |[
	Mengintregation semua ke appointmen schedule dokter
]

#### 7. Pertanyaan untuk dosen

- [tuliskan pertanyaan spesifik, atau "Tidak ada"]

---

<!-- Tambahkan laporan minggu berikutnya DI ATAS laporan minggu sebelumnya. Pertahankan catatan lama sebagai riwayat. Umpan balik dosen dicatat melalui komentar PR atau GitHub Issue. -->
