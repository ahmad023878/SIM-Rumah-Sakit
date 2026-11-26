<?php
session(); include('../include/config.php'); require_once __DIR__.'/module_bootstrap.php'; require_once __DIR__.'/simrs_integration_bootstrap.php';
hms_module_require_roles(array('admin','rekam_medis'));
hms_int_bootstrap($con);

// Endpoint server-side untuk memuat jadwal berdasarkan poli, dokter, dan tanggal.
// Ini menghindari ketergantungan pada pencocokan tanggal/ID di JavaScript browser.
if (isset($_GET['ajax']) && $_GET['ajax'] === 'schedule_options') {
    header('Content-Type: application/json; charset=utf-8');
    try {
        $ajaxPoli = (int)($_GET['poli_id'] ?? 0);
        $ajaxDoctor = (int)($_GET['doctor_id'] ?? 0);
        $ajaxDate = trim((string)($_GET['service_date'] ?? ''));
        if ($ajaxPoli <= 0 || $ajaxDoctor <= 0 || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $ajaxDate)) {
            http_response_code(400);
            echo json_encode(array('success'=>false, 'message'=>'Poli, dokter, atau tanggal tidak valid.', 'schedules'=>array()));
            exit;
        }
        $ajaxDay = (int)date('w', strtotime($ajaxDate));
        $ajaxRows = hms_fetch_all($con,
            "SELECT s.id,s.poli_id,s.doctor_id,s.day_of_week,
                    CASE WHEN s.available_date IS NULL OR DATE(s.available_date)='0000-00-00' THEN NULL ELSE DATE_FORMAT(s.available_date,'%Y-%m-%d') END AS available_date,
                    s.start_time,s.end_time,s.quota,p.poli_name,d.doctorName
             FROM hms_doctor_schedules s
             INNER JOIN hms_master_poli p ON p.id=s.poli_id
             LEFT JOIN doctors d ON d.id=s.doctor_id
             WHERE s.poli_id=? AND s.doctor_id=? AND s.is_active=1 AND p.is_active=1
               AND ((s.available_date IS NOT NULL AND DATE(s.available_date)=?)
                    OR ((s.available_date IS NULL OR DATE(s.available_date)='0000-00-00') AND s.day_of_week=?))
             ORDER BY s.start_time,s.end_time,s.id",
            'iisi', array($ajaxPoli,$ajaxDoctor,$ajaxDate,$ajaxDay));
        $ajaxOut = array();
        $seenAjax = array();
        foreach ($ajaxRows as $row) {
            $key = implode('|', array((int)$row['poli_id'],(int)$row['doctor_id'],(string)$row['available_date'],(int)$row['day_of_week'],substr((string)$row['start_time'],0,8),substr((string)$row['end_time'],0,8),(int)$row['quota']));
            if (isset($seenAjax[$key])) continue;
            $seenAjax[$key] = true;
            $row['remaining_quota'] = hms_int_capacity($con, (int)$row['id'], $ajaxDate, (int)$row['quota']);
            $ajaxOut[] = $row;
        }
        echo json_encode(array('success'=>true, 'schedules'=>$ajaxOut), JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
    } catch (Throwable $ajaxError) {
        http_response_code(500);
        echo json_encode(array('success'=>false, 'message'=>'Gagal memuat jadwal: '.$ajaxError->getMessage(), 'schedules'=>array()), JSON_UNESCAPED_UNICODE);
    }
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    hms_module_csrf();
    try {
        if (($_POST['action'] ?? '') !== 'register') throw new RuntimeException('Aksi registrasi tidak valid.');
        $pid=(int)($_POST['patient_id']??0); $scheduleId=(int)($_POST['schedule_id']??0); $date=trim($_POST['service_date']??date('Y-m-d'));
        $source=$_POST['source']??'OFFLINE'; $counter=trim($_POST['registration_counter']??'');
        if ($pid<=0 || $scheduleId<=0) throw new RuntimeException('Pasien dan jadwal pelayanan wajib dipilih.');
        if (!preg_match('/^\d{4}-\d{2}-\d{2}$/',$date)) throw new RuntimeException('Tanggal pelayanan tidak valid.');
        if ($date < date('Y-m-d')) throw new RuntimeException('Tanggal pelayanan tidak boleh sebelum hari ini.');
        if (!in_array($source,array('ONLINE','OFFLINE'),true)) $source='OFFLINE';
        $patient=hms_fetch_one($con,'SELECT ID,PatientName,medical_record_no FROM tblpatient WHERE ID=?','i',array($pid));
        if(!$patient) throw new RuntimeException('Pasien tidak ditemukan.');
        $day=(int)date('w',strtotime($date));
        mysqli_begin_transaction($con);
        // Lock the selected schedule row so two registrations cannot exceed its quota simultaneously.
        $schedule=hms_fetch_one($con,"SELECT s.*,p.poli_name,d.doctorName FROM hms_doctor_schedules s JOIN hms_master_poli p ON p.id=s.poli_id LEFT JOIN doctors d ON d.id=s.doctor_id WHERE s.id=? AND s.is_active=1 AND p.is_active=1 AND ((s.available_date IS NOT NULL AND DATE(s.available_date)=?) OR ((s.available_date IS NULL OR DATE(s.available_date)='0000-00-00') AND s.day_of_week=?)) FOR UPDATE",'isi',array($scheduleId,$date,$day));
        if(!$schedule){ mysqli_rollback($con); throw new RuntimeException('Jadwal tidak aktif atau tidak sesuai tanggal pelayanan.'); }
        $used=(int)hms_scalar($con,"SELECT COUNT(*) FROM hms_visit_schedules vs JOIN hms_patient_visits v ON v.id=vs.visit_id WHERE vs.schedule_id=? AND vs.service_date=? AND v.status<>'BATAL'",'is',array($scheduleId,$date));
        if($used >= (int)$schedule['quota']){ mysqli_rollback($con); throw new RuntimeException('Kuota jadwal sudah penuh. Silakan pilih jadwal lain.'); }
        $existing=hms_fetch_one($con,"SELECT v.id,v.registration_no,v.queue_no FROM hms_patient_visits v JOIN hms_visit_schedules vs ON vs.visit_id=v.id WHERE v.patient_id=? AND vs.schedule_id=? AND vs.service_date=? AND v.status IN ('MENUNGGU','DIPANGGIL','DILAYANI') LIMIT 1",'iis',array($pid,$scheduleId,$date));
        if($existing){ mysqli_rollback($con); throw new RuntimeException('Pasien sudah memiliki antrean aktif pada jadwal ini: '.$existing['queue_no']); }
        $mrType=empty($patient['medical_record_no'])?'BARU':'LAMA';
        if($mrType==='BARU'){ $mr='RM'.date('Y',strtotime($date)).str_pad((string)$pid,6,'0',STR_PAD_LEFT); hms_execute($con,'UPDATE tblpatient SET medical_record_no=? WHERE ID=?','si',array($mr,$pid)); $patient['medical_record_no']=$mr; }
        $reg=hms_module_next_code($con,'hms_patient_visits','REG','id');
        $queue=hms_module_next_queue($con,$schedule['poli_name'],$date);
        $st=mysqli_prepare($con,"INSERT INTO hms_patient_visits(patient_id,mr_type,registration_no,visit_date,visit_type,poli,doctor_id,queue_no,source,status,registration_counter) VALUES(?,?,?,?,'RAWAT_JALAN',?,?,?,?,'MENUNGGU',?)");
        if(!$st) throw new RuntimeException('Gagal menyiapkan registrasi.');
        mysqli_stmt_bind_param($st,'issssisss',$pid,$mrType,$reg,$date,$schedule['poli_name'],$schedule['doctor_id'],$queue,$source,$counter);
        if(!mysqli_stmt_execute($st)){mysqli_stmt_close($st);throw new RuntimeException('Registrasi gagal disimpan.');}
        $visitId=mysqli_stmt_insert_id($st);mysqli_stmt_close($st);
        $st=mysqli_prepare($con,'INSERT INTO hms_visit_schedules(visit_id,schedule_id,service_date,quota_snapshot) VALUES(?,?,?,?)');
        if(!$st) throw new RuntimeException('Gagal mengaitkan jadwal.');
        mysqli_stmt_bind_param($st,'iisi',$visitId,$scheduleId,$date,$schedule['quota']);
        if(!mysqli_stmt_execute($st)){mysqli_stmt_close($st);throw new RuntimeException('Jadwal registrasi gagal disimpan.');}
        mysqli_stmt_close($st);
        mysqli_commit($con);
        hms_module_audit($con,'CREATE','REGISTRASI_TERINTEGRASI','hms_patient_visits',$visitId,'Kunjungan terdaftar melalui master poli-dokter-jadwal-kuota',null,array('registration_no'=>$reg,'queue_no'=>$queue,'poli'=>$schedule['poli_name'],'doctor_id'=>$schedule['doctor_id'],'schedule_id'=>$scheduleId,'service_date'=>$date,'quota_remaining'=>((int)$schedule['quota']-$used-1)));
        hms_module_workflow_event($con,$pid,$visitId,null,null,'REGISTRASI','MENUNGGU','Registrasi terintegrasi '.$reg.' dengan antrean '.$queue.'.');
        hms_set_flash('success','Registrasi berhasil: '.$reg.' | '.$schedule['poli_name'].' | '.$schedule['doctorName'].' | Antrean '.$queue.' | Sisa kuota '.((int)$schedule['quota']-$used-1).'.');
    } catch(Throwable $e){ @mysqli_rollback($con); hms_set_flash('danger',$e->getMessage()); }
}

$patients=hms_fetch_all($con,'SELECT ID,PatientName,medical_record_no FROM tblpatient ORDER BY PatientName LIMIT 1500');
$polies=hms_fetch_all($con,'SELECT id,poli_code,poli_name FROM hms_master_poli WHERE is_active=1 ORDER BY poli_name');
$doctors=hms_fetch_all($con,'SELECT id,doctorName,specilization FROM doctors ORDER BY doctorName');
$schedules=hms_fetch_all($con,"SELECT s.id,s.poli_id,s.doctor_id,s.day_of_week,CASE WHEN s.available_date IS NULL OR DATE(s.available_date)='0000-00-00' THEN NULL ELSE DATE_FORMAT(s.available_date,'%Y-%m-%d') END AS available_date,s.start_time,s.end_time,s.quota,p.poli_name,d.doctorName,d.specilization FROM hms_doctor_schedules s JOIN hms_master_poli p ON p.id=s.poli_id LEFT JOIN doctors d ON d.id=s.doctor_id WHERE s.is_active=1 AND p.is_active=1 ORDER BY p.poli_name,s.day_of_week,s.start_time,d.doctorName");

// Hilangkan baris duplikat pada tabel "Jadwal Aktif".
// Identitas jadwal memakai poli, dokter, tanggal khusus ATAU hari mingguan,
// jam mulai, jam selesai, dan kuota. ID sengaja tidak menjadi bagian kunci
// karena record hasil sinkronisasi dapat memiliki ID berbeda tetapi isi sama.
$uniqueSchedules = array();
foreach ($schedules as $scheduleRow) {
    $scheduleDate = trim((string)($scheduleRow['available_date'] ?? ''));
    $scheduleDayKey = ($scheduleDate !== '')
        ? 'DATE:' . $scheduleDate
        : 'WEEKDAY:' . (string)($scheduleRow['day_of_week'] ?? '');
    $scheduleKeyParts = array(
        (string)($scheduleRow['poli_id'] ?? ''),
        (string)($scheduleRow['doctor_id'] ?? ''),
        $scheduleDayKey,
        substr((string)($scheduleRow['start_time'] ?? ''), 0, 8),
        substr((string)($scheduleRow['end_time'] ?? ''), 0, 8),
        (string)($scheduleRow['quota'] ?? '')
    );
    $scheduleKey = implode('|', $scheduleKeyParts);
    if (!isset($uniqueSchedules[$scheduleKey])) {
        $uniqueSchedules[$scheduleKey] = $scheduleRow;
    }
}
$schedules = array_values($uniqueSchedules);

$today=date('Y-m-d');
$role=hms_module_current_role(); hms_layout_header('Registrasi Terintegrasi',$role,'operations');
?>
<div class="hms-page-title"><div><h1>Registrasi & Antrean Terintegrasi</h1><div class="text-muted">Master Poli → Dokter → Jadwal → Kuota. Modul lama tetap tersedia.</div></div></div>
<div class="hms-card p-3 mb-4"><form method="post" class="row g-3" id="integratedRegistrationForm"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="register">
<div class="col-md-4"><label class="form-label">Pasien *</label><select name="patient_id" class="form-select" required><option value="">Pilih pasien</option><?php foreach($patients as $p){ ?><option value="<?php echo (int)$p['ID']; ?>"><?php echo hms_e(($p['medical_record_no']?:'RM-'.$p['ID']).' - '.$p['PatientName']); ?></option><?php } ?></select></div>
<div class="col-md-2"><label class="form-label">Tanggal *</label><input type="date" name="service_date" id="serviceDate" class="form-control" min="<?php echo hms_e($today); ?>" value="<?php echo hms_e($today); ?>" required></div>
<div class="col-md-3"><label class="form-label">Poli *</label><select id="poliSelect" class="form-select" required><option value="">Pilih poli</option><?php foreach($polies as $p){ ?><option value="<?php echo (int)$p['id']; ?>"><?php echo hms_e($p['poli_name']); ?></option><?php } ?></select></div>
<div class="col-md-3"><label class="form-label">Dokter Spesialis *</label><select id="doctorSelect" class="form-select" required disabled><option value="">Pilih poli terlebih dahulu</option></select></div>
<div class="col-md-3"><label class="form-label">Jadwal / Jam *</label><select name="schedule_id" id="scheduleSelect" class="form-select" required disabled><option value="">Pilih dokter terlebih dahulu</option></select></div>
<div class="col-md-3"><label class="form-label">Dokter Terpilih</label><input id="doctorDisplay" class="form-control" readonly placeholder="Terisi otomatis"></div>
<div class="col-md-4"><label class="form-label">Jam Pelayanan</label><input id="timeDisplay" class="form-control" readonly></div>
<div class="col-md-2"><label class="form-label">Sisa Kuota</label><input id="quotaDisplay" class="form-control" readonly></div>
<div class="col-md-2"><label class="form-label">Sumber</label><select name="source" class="form-select"><option>OFFLINE</option><option>ONLINE</option></select></div>
<div class="col-md-4"><label class="form-label">Loket</label><input name="registration_counter" class="form-control" placeholder="Loket 1"></div>
<div class="col-12"><button class="btn btn-primary btn-lg"><i class="bi bi-ticket-perforated me-1"></i>Daftar & Ambil Antrean</button></div>
</form></div>
<div class="hms-card p-3"><h2 class="h5">Jadwal Aktif</h2><div class="table-responsive"><table class="table table-sm table-hover"><thead><tr><th>Poli</th><th>Dokter</th><th>Hari</th><th>Jam</th><th>Kuota</th></tr></thead><tbody><?php foreach($schedules as $s){ ?><tr><td><?php echo hms_e($s['poli_name']); ?></td><td><?php echo hms_e($s['doctorName']??'-'); ?></td><td><?php echo hms_e(!empty($s['available_date']) ? date('d/m/Y', strtotime($s['available_date'])) : hms_int_day_name($s['day_of_week'])); ?></td><td><?php echo hms_e(substr($s['start_time'],0,5).'–'.substr($s['end_time'],0,5)); ?></td><td><?php echo (int)$s['quota']; ?></td></tr><?php } if(!$schedules){ ?><tr><td colspan="5" class="text-muted">Belum ada jadwal aktif. Buka Master Poli → Dokter → Jadwal → Kuota terlebih dahulu.</td></tr><?php } ?></tbody></table></div></div>
<script>
const schedules=<?php echo json_encode($schedules,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES); ?>;
const doctors=<?php echo json_encode($doctors,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES); ?>;
const poli=<?php echo 'document.getElementById("poliSelect")'; ?>;
const dateEl=document.getElementById('serviceDate'), doctorSelect=document.getElementById('doctorSelect'), sched=document.getElementById('scheduleSelect');
const doctorDisplay=document.getElementById('doctorDisplay'), time=document.getElementById('timeDisplay'), quota=document.getElementById('quotaDisplay');
function norm(v){return String(v||'').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g,'').replace(/[^a-z0-9]+/g,'');}
function specMatches(spec,poliName,poliCode){
 const a=norm(spec), b=norm(poliName), c=norm(poliCode);
 if(!a) return false;
 if(a===b||a===c||b.includes(a)||a.includes(b)||c.includes(a)) return true;
 const aliases={
  anak:['pediatrics','pediatric','paediatrics','paediatric','childhealth'],
  tht:['ent','otorhinolaryngology','earnoseandthroat'],
  gigi:['dentalcare','dentistry','dentist','oralmedicine'],
  penyakitdalem:['internalmedicine','internist','penyakitdalam'],
  penyakitdalam:['internalmedicine','internist','penyakitdalem'],
  kandungan:['obstetricsandgynecology','obgyn','gynecology','obstetrics'],
  kebidanan:['obstetricsandgynecology','obgyn'],
  bedah:['surgery','surgeon','orthopedics','orthopaedics'],
  ortopedi:['orthopedics','orthopaedics'],
  instalasilaboratorium:['laboratorymedicine','pathology','clinicalpathology','labmedicine'],
  mata:['ophthalmology','ophthalmologist','eye']
 };
 const keys=Object.keys(aliases);
 for(const key of keys){
  const group=[key,...aliases[key]].map(norm);
  if(group.includes(a) && (b.includes(norm(key))||c.includes(norm(key))||group.some(x=>b.includes(x)||c.includes(x)))) return true;
 }
 return false;
}
function dayOf(date){ if(!date) return -1; return new Date(date+'T00:00:00').getDay(); }
function updateInfo(){const o=sched.options[sched.selectedIndex];doctorDisplay.value=o?.dataset?.doctor||doctorSelect.options[doctorSelect.selectedIndex]?.textContent||'';time.value=o?.dataset?.time||'';quota.value=o?.dataset?.quota||'';}
function renderDoctors(){
 const pid=Number(poli.value), previousDoctor=String(doctorSelect.value||'');
 doctorSelect.innerHTML='<option value="">Pilih dokter dengan jadwal aktif</option>';
 sched.innerHTML='<option value="">Pilih dokter terlebih dahulu</option>';
 doctorSelect.disabled=!pid; sched.disabled=true;
 doctorDisplay.value='';time.value='';quota.value='';
 if(!pid) return;

 // Admin hanya boleh memilih dokter yang benar-benar memiliki jadwal aktif
 // pada poli yang dipilih. Kecocokan teks spesialisasi saja tidak cukup.
 const scheduledDoctorIds=new Set(schedules
   .filter(s=>Number(s.poli_id)===pid && Number(s.is_active ?? 1)===1)
   .map(s=>String(s.doctor_id)));
 const matching=doctors.filter(d=>scheduledDoctorIds.has(String(d.id)));

 matching.forEach(d=>{
   const o=document.createElement('option');
   o.value=d.id;
   o.textContent=(d.doctorName||'Dokter')+' — '+(d.specilization||'Spesialisasi belum diisi');
   doctorSelect.appendChild(o);
 });

 if(!matching.length){
   const msg=document.createElement('option');
   msg.value='';msg.disabled=true;
   msg.textContent='Belum ada dokter dengan jadwal aktif pada poli ini. Periksa Master Poli & Jadwal.';
   doctorSelect.appendChild(msg);
   sched.innerHTML='<option value="">Belum ada jadwal untuk poli ini</option>';
   return;
 }

 // Jika hanya satu dokter yang mempunyai jadwal pada poli ini, pilih otomatis.
 // Jika lebih dari satu, pertahankan pilihan yang valid atau minta admin memilih.
 if(matching.some(d=>String(d.id)===previousDoctor)) doctorSelect.value=previousDoctor;
 else if(matching.length===1) doctorSelect.value=String(matching[0].id);

 if(doctorSelect.value) renderSchedules();
}
 let scheduleRequestNo=0;
 async function renderSchedules(){
  const pid=String(poli.value||'').trim(), did=String(doctorSelect.value||'').trim(), serviceDate=String(dateEl.value||'').trim();
  sched.innerHTML='<option value="">Memuat jadwal...</option>';
  sched.disabled=!(pid&&did&&serviceDate);
  doctorDisplay.value=doctorSelect.options[doctorSelect.selectedIndex]?.textContent||'';
  time.value='';quota.value='';
  if(!(pid&&did&&serviceDate)){
   sched.innerHTML='<option value="">Pilih poli, dokter, dan tanggal terlebih dahulu</option>';
   return;
  }
  const requestNo=++scheduleRequestNo;
  try{
   const url=new URL(window.location.href);
   url.searchParams.set('ajax','schedule_options');
   url.searchParams.set('poli_id',pid);
   url.searchParams.set('doctor_id',did);
   url.searchParams.set('service_date',serviceDate);
   const response=await fetch(url.toString(),{headers:{'Accept':'application/json'},credentials:'same-origin'});
   const payload=await response.json();
   if(requestNo!==scheduleRequestNo) return;
   sched.innerHTML='<option value="">Pilih jadwal pelayanan</option>';
   if(!response.ok || !payload.success) throw new Error(payload.message||'Server tidak dapat memuat jadwal.');
   (payload.schedules||[]).forEach(row=>{
    const o=document.createElement('option');
    o.value=row.id;
    o.dataset.doctor=row.doctorName||doctorSelect.options[doctorSelect.selectedIndex]?.textContent||'';
    o.dataset.time=String(row.start_time||'').slice(0,5)+'–'+String(row.end_time||'').slice(0,5);
    o.dataset.quota=String(row.remaining_quota ?? row.quota ?? 0);
    o.textContent=o.dataset.time+' | Sisa kuota '+o.dataset.quota;
    sched.appendChild(o);
   });
   if(!(payload.schedules||[]).length){
    const msg=document.createElement('option');msg.value='';msg.disabled=true;
    msg.textContent='Tidak ada jadwal aktif untuk dokter dan tanggal ini.';
    sched.appendChild(msg);
   }
   sched.disabled=false;
   updateInfo();
  }catch(err){
   if(requestNo!==scheduleRequestNo) return;
   sched.innerHTML='';
   const msg=document.createElement('option');msg.value='';msg.disabled=true;
   msg.textContent='Gagal memuat jadwal: '+(err.message||'Periksa koneksi.');
   sched.appendChild(msg);sched.disabled=false;
   doctorDisplay.value='';time.value='';quota.value='';
  }
 }
poli.addEventListener('change',renderDoctors);poli.addEventListener('input',renderDoctors);doctorSelect.addEventListener('change',renderSchedules);doctorSelect.addEventListener('input',renderSchedules);dateEl.addEventListener('change',renderSchedules);dateEl.addEventListener('input',renderSchedules);sched.addEventListener('change',updateInfo);
// Poli code is provided as data to keep matching deterministic.
Array.from(poli.options).forEach(o=>{const row=<?php echo json_encode($polies,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES); ?>.find(x=>String(x.id)===o.value);if(row)o.dataset.code=row.poli_code;});
renderDoctors();
</script>
<?php hms_layout_footer(); ?>
