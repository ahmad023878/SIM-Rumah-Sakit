@echo off
setlocal
cd /d %~dp0
echo ==============================================
echo Hospital - CodeIgniter 4.7.4 XAMPP Setup
echo ==============================================
where composer >nul 2>&1
if errorlevel 1 (
  echo Composer belum ditemukan di PATH.
  echo Install Composer terlebih dahulu, lalu jalankan file ini lagi.
  pause
  exit /b 1
)
composer install
if errorlevel 1 (
  echo Composer install gagal.
  pause
  exit /b 1
)
if not exist writable mkdir writable
if not exist writable\cache mkdir writable\cache
if not exist writable\logs mkdir writable\logs
if not exist writable\session mkdir writable\session
if not exist writable\uploads mkdir writable\uploads
echo.
echo Selesai. Pastikan Apache + MySQL XAMPP aktif.
echo URL: http://localhost:8080/hospital/
pause
