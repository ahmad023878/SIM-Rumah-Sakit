<?php
session();
include('../include/config.php');
require_once __DIR__.'/module_bootstrap.php';
require_once __DIR__.'/visit_workflow_helpers.php';
hms_module_require_roles(array('admin','doctor','perawat','rekam_medis'));
hms_module_bootstrap($con);

if($_SERVER['REQUEST_METHOD']==='POST'){
 hms_module_csrf(); $action=$_POST['action']??'';
 try{
  if($action==='create'){
   $visitId=(int)($_POST['visit_id']??0);
   $visit=hms_fetch_one($con,"SELECT * FROM hms_patient_visits WHERE id=? AND visit_type='RAWAT_JALAN'",'i',array($visitId));
   if(!$visit) throw new RuntimeException('Kunjungan rawat jalan tidak ditemukan.');
   if(!in_array($visit['status'],array('DIPANGGIL','DILAYANI'),true)) throw new RuntimeException('Pasien harus dipanggil terlebih dahulu sebelum pelayanan dibuat.');
   $role=hms_module_current_role(); $doctorId=(int)($_POST['doctor_id']??0);
   if($role==='doctor') $doctorId=(int)($_SESSION['id']??0);
   if($doctorId<=0) $doctorId=(int)($visit['doctor_id']??0);
   if($role==='doctor' && (int)$visit['doctor_id']>0 && (int)$visit['doctor_id']!==$doctorId) throw new RuntimeException('Kunjungan ini bukan tanggung jawab dokter yang sedang login.');
   if($visit['status']==='DIPANGGIL'){
     hms_execute($con,"UPDATE hms_patient_visits SET status='DILAYANI',served_at=COALESCE(served_at,NOW()),updated_at=NOW() WHERE id=? AND status='DIPANGGIL'",'i',array($visitId));
   }
   $encounterId=hms_workflow_ensure_outpatient_encounter($con,$visitId,$doctorId);
   hms_set_flash('success','Pelayanan rawat jalan siap. Silakan isi SOAP/RME untuk pasien ini.');
  }

  if($action==='save_clinical'){
   $id=(int)($_POST['encounter_id']??0);
   $e=hms_fetch_one($con,'SELECT o.*,v.status visit_status,v.doctor_id visit_doctor_id,v.appointment_id FROM hms_outpatient_encounters o JOIN hms_patient_visits v ON v.id=o.visit_id WHERE o.id=?','i',array($id));
   if(!$e) throw new RuntimeException('Pelayanan tidak ditemukan.');
   if($e['status']==='SELESAI' || $e['visit_status']==='SELESAI') throw new RuntimeException('Pemeriksaan sudah selesai dan tidak dapat diubah dari formulir ini.');
   if($e['visit_status']!=='DILAYANI') throw new RuntimeException('Status kunjungan harus DILAYANI sebelum SOAP disimpan.');
   $role=hms_module_current_role();
   $doctor=(int)($_POST['doctor_id']??0);
   if($role==='doctor'){
     $doctor=(int)($_SESSION['id']??0);
     if((int)$e['visit_doctor_id']>0 && (int)$e['visit_doctor_id']!==$doctor) throw new RuntimeException('Anda bukan dokter penanggung jawab kunjungan ini.');
   }
   if($doctor<=0) $doctor=(int)($e['doctor_id']?:$e['visit_doctor_id']);
   $anam=trim($_POST['anamnesis']??''); $phys=trim($_POST['physical_exam']??''); $ass=trim($_POST['assessment']??'');
   $plan=trim($_POST['plan']??''); $code=trim($_POST['diagnosis_code']??''); $diag=trim($_POST['diagnosis_name']??''); $act=trim($_POST['action_text']??'');
   if($anam==='' && $phys==='' && $ass==='' && $plan==='' && $code==='' && $diag==='' && $act==='') throw new RuntimeException('Isi minimal satu bagian catatan SOAP sebelum menyimpan.');
   hms_execute($con,"UPDATE hms_outpatient_encounters SET doctor_id=?,anamnesis=?,physical_exam=?,assessment=?,plan=?,diagnosis_code=?,diagnosis_name=?,action_text=?,status='DILAYANI',started_at=COALESCE(started_at,NOW()),updated_at=NOW() WHERE id=?",'isssssssi',array($doctor,$anam,$phys,$ass,$plan,$code,$diag,$act,$id));

   $oldSoap=hms_fetch_one($con,"SELECT * FROM hms_cppt WHERE visit_id=? AND note_type='SOAP' ORDER BY id DESC LIMIT 1",'i',array((int)$e['visit_id']));
   // Preserve previously saved SOAP fields when a user edits only one part of the note.
   if($oldSoap){
     if($anam==='') $anam=(string)($oldSoap['subjective']??'');
     if($phys==='') $phys=(string)($oldSoap['objective']??'');
     if($ass==='') $ass=(string)($oldSoap['assessment']??'');
     if($plan==='') $plan=(string)($oldSoap['plan']??'');
     if($code==='') $code=(string)($oldSoap['diagnosis_code']??'');
     if($diag==='') $diag=(string)($oldSoap['diagnosis_name']??'');
     if($act==='') $act=(string)($oldSoap['action_text']??'');
     hms_execute($con,"UPDATE hms_outpatient_encounters SET anamnesis=?,physical_exam=?,assessment=?,plan=?,diagnosis_code=?,diagnosis_name=?,action_text=?,updated_at=NOW() WHERE id=?",
       'sssssssi',array($anam,$phys,$ass,$plan,$code,$diag,$act,$id));
   }
   $roleName=$role==='doctor'?'DOKTER':($role==='perawat'?'PERAWAT':($role==='rekam_medis'?'REKAM_MEDIS':'ADMIN'));
   $authorId=(int)($_SESSION['id']??0);
   if($oldSoap){
     hms_execute($con,'UPDATE hms_cppt SET author_type=?,author_id=?,subjective=?,objective=?,assessment=?,plan=?,diagnosis_code=?,diagnosis_name=?,action_text=? WHERE id=?',
       'sisssssssi',array($roleName,$authorId,$anam,$phys,$ass,$plan,$code,$diag,$act,(int)$oldSoap['id']));
     $cpptId=(int)$oldSoap['id'];
   }else{
     $st=mysqli_prepare($con,'INSERT INTO hms_cppt(patient_id,visit_id,admission_id,author_type,author_id,note_type,subjective,objective,assessment,plan,diagnosis_code,diagnosis_name,action_text) VALUES(?,?,NULL,?,?,?,?,?,?,?,?,?,?)');
     if(!$st) throw new RuntimeException('Gagal menyiapkan RME rawat jalan.');
     $noteType='SOAP';
     mysqli_stmt_bind_param($st,'iisissssssss',(int)$e['patient_id'],(int)$e['visit_id'],$roleName,$authorId,$noteType,$anam,$phys,$ass,$plan,$code,$diag,$act);
     if(!mysqli_stmt_execute($st)){mysqli_stmt_close($st);throw new RuntimeException('Gagal menyimpan RME rawat jalan.');}
     $cpptId=(int)mysqli_stmt_insert_id($st); mysqli_stmt_close($st);
   }
   hms_module_workflow_event($con,(int)$e['patient_id'],(int)$e['visit_id'],null,null,'RME_ENTRY','DILAYANI','SOAP rawat jalan tersimpan/ diperbarui.');
   hms_module_audit($con,'UPDATE','RAWAT_JALAN','hms_outpatient_encounters',$id,'SOAP rawat jalan tersimpan atau diperbarui.');
   hms_set_flash('success','SOAP/RME berhasil disimpan. Kunjungan tetap DILAYANI sampai dokter menyelesaikan pemeriksaan.');
  }

  if($action==='complete'){
   $id=(int)($_POST['encounter_id']??0);
   $e=hms_fetch_one($con,'SELECT o.*,v.status visit_status,v.appointment_id FROM hms_outpatient_encounters o JOIN hms_patient_visits v ON v.id=o.visit_id WHERE o.id=?','i',array($id));
   if(!$e) throw new RuntimeException('Pelayanan tidak ditemukan.');
   if($e['visit_status']!=='DILAYANI' || $e['status']!=='DILAYANI') throw new RuntimeException('Kunjungan harus berstatus DILAYANI sebelum diselesaikan.');
   if(!hms_workflow_has_soap($con,(int)$e['visit_id'])) throw new RuntimeException('SOAP/RME belum diisi. Simpan catatan pemeriksaan sebelum menyelesaikan pelayanan.');
   $role=hms_module_current_role();
   if($role==='doctor' && (int)$e['doctor_id']>0 && (int)$e['doctor_id']!==(int)($_SESSION['id']??0)) throw new RuntimeException('Hanya dokter penanggung jawab yang dapat menyelesaikan pemeriksaan.');
   hms_execute($con,"UPDATE hms_outpatient_encounters SET status='SELESAI',completed_at=COALESCE(completed_at,NOW()),updated_at=NOW() WHERE id=?",'i',array($id));
   hms_execute($con,"UPDATE hms_patient_visits SET status='SELESAI',completed_at=COALESCE(completed_at,NOW()),updated_at=NOW() WHERE id=? AND status='DILAYANI'",'i',array((int)$e['visit_id']));
   if(!empty($e['appointment_id']) && function_exists('hms_set_appointment_status')){
     hms_set_appointment_status($con,(int)$e['appointment_id'],'Completed',$role==='doctor'?'doctor':'admin',(int)($_SESSION['id']??0));
   }
   hms_module_workflow_event($con,(int)$e['patient_id'],(int)$e['visit_id'],null,null,'RAWAT_JALAN','SELESAI','Pelayanan selesai setelah SOAP/RME tersimpan.');
   hms_module_audit($con,'STATUS_CHANGE','RAWAT_JALAN','hms_outpatient_encounters',$id,'Pelayanan rawat jalan selesai.');
   hms_set_flash('success','Pemeriksaan selesai. Status kunjungan dan pelayanan sudah SELESAI.');
  }
 }catch(Throwable $ex){hms_set_flash('danger',$ex->getMessage());}
}

$visits=hms_fetch_all($con,"SELECT v.*,p.PatientName,p.medical_record_no FROM hms_patient_visits v JOIN tblpatient p ON p.ID=v.patient_id
 LEFT JOIN hms_outpatient_encounters o ON o.visit_id=v.id
 WHERE v.visit_type='RAWAT_JALAN' AND o.id IS NULL AND v.status IN ('DIPANGGIL','DILAYANI')
 ORDER BY v.visit_date DESC,v.id DESC LIMIT 300");
$doctors=hms_fetch_all($con,'SELECT id,doctorName,specilization FROM doctors ORDER BY doctorName');
$icds=hms_fetch_all($con,'SELECT code,description FROM hms_icd10 WHERE is_active=1 ORDER BY code LIMIT 2000');
$rows=hms_fetch_all($con,"SELECT o.*,v.registration_no,v.queue_no,v.status visit_status,v.appointment_id,p.PatientName,p.medical_record_no,d.doctorName,
 (SELECT COUNT(*) FROM hms_cppt c WHERE c.visit_id=v.id AND c.note_type='SOAP') soap_count
 FROM hms_outpatient_encounters o JOIN hms_patient_visits v ON v.id=o.visit_id
 JOIN tblpatient p ON p.ID=o.patient_id LEFT JOIN doctors d ON d.id=o.doctor_id
 ORDER BY o.id DESC LIMIT 150");
$role=hms_module_current_role(); hms_layout_header('Rawat Jalan / Poliklinik',$role,'operations');
?>
<div class="hms-page-title"><div><h1>Rawat Jalan / Poliklinik</h1><div class="text-muted">Satu encounter untuk setiap kunjungan, SOAP/RME, diagnosis, tindakan, dan penyelesaian pemeriksaan.</div></div></div>
<div class="hms-card p-3 mb-4">
 <h2 class="h5">Mulai Pelayanan dari Antrean</h2>
 <form method="post" class="row g-3"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="create">
  <div class="col-md-7"><label class="form-label">Kunjungan yang sudah dipanggil</label><select name="visit_id" class="form-select" required><option value="">Pilih kunjungan</option><?php foreach($visits as $v){ ?><option value="<?php echo (int)$v['id']; ?>"><?php echo hms_e(($v['medical_record_no']?:'RM-'.$v['patient_id']).' | '.$v['registration_no'].' | '.$v['queue_no'].' | '.$v['PatientName'].' | '.$v['poli'].' | '.$v['status']); ?></option><?php } ?></select></div>
  <div class="col-md-3"><label class="form-label">Dokter</label><select name="doctor_id" class="form-select"><option value="0">Gunakan dokter registrasi</option><?php foreach($doctors as $d){ ?><option value="<?php echo (int)$d['id']; ?>"><?php echo hms_e($d['doctorName'].' - '.$d['specilization']); ?></option><?php } ?></select></div>
  <div class="col-md-2 d-flex align-items-end"><button class="btn btn-primary w-100">Buka Pelayanan</button></div>
 </form>
</div>
<div class="hms-card p-3 mb-4">
 <h2 class="h5">Catatan Klinis / SOAP</h2>
 <form method="post" class="row g-3"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="save_clinical">
  <div class="col-md-4"><label class="form-label">Pelayanan</label><select name="encounter_id" class="form-select" required><option value="">Pilih pelayanan aktif</option><?php foreach($rows as $r){ if($r['status']!=='SELESAI'&&$r['status']!=='BATAL'){ ?><option value="<?php echo (int)$r['id']; ?>"><?php echo hms_e($r['registration_no'].' | '.$r['PatientName'].' | '.$r['poli'].' | '.$r['status']); ?></option><?php }} ?></select></div>
  <div class="col-md-4"><label class="form-label">Dokter</label><select name="doctor_id" class="form-select"><option value="0">Gunakan dokter pelayanan</option><?php foreach($doctors as $d){ ?><option value="<?php echo (int)$d['id']; ?>"><?php echo hms_e($d['doctorName']); ?></option><?php } ?></select></div>
  <div class="col-md-4"><label class="form-label">Diagnosis ICD-10</label><select name="diagnosis_code" class="form-select"><option value="">Pilih</option><?php foreach($icds as $ic){ ?><option value="<?php echo hms_e($ic['code']); ?>"><?php echo hms_e($ic['code'].' - '.$ic['description']); ?></option><?php } ?></select></div>
  <div class="col-md-4"><label class="form-label">Nama Diagnosis</label><input name="diagnosis_name" class="form-control"></div>
  <div class="col-md-4"><label class="form-label">Anamnesis / Subjective</label><textarea name="anamnesis" class="form-control" rows="3"></textarea></div>
  <div class="col-md-4"><label class="form-label">Pemeriksaan Fisik / Objective</label><textarea name="physical_exam" class="form-control" rows="3"></textarea></div>
  <div class="col-md-4"><label class="form-label">Assessment</label><textarea name="assessment" class="form-control" rows="3"></textarea></div>
  <div class="col-md-4"><label class="form-label">Plan</label><textarea name="plan" class="form-control" rows="3"></textarea></div>
  <div class="col-md-4"><label class="form-label">Tindakan</label><textarea name="action_text" class="form-control" rows="3"></textarea></div>
  <div class="col-12"><button class="btn btn-success">Simpan / Perbarui SOAP ke RME</button></div>
 </form>
</div>
<div class="hms-card p-3"><h2 class="h5">Daftar Pelayanan</h2><div class="table-responsive"><table class="table table-hover align-middle">
<thead><tr><th>No. RM</th><th>Registrasi/Antrean</th><th>Pasien</th><th>Poli</th><th>Dokter</th><th>Status</th><th>RME</th><th>Aksi</th></tr></thead><tbody>
<?php foreach($rows as $r){ ?><tr>
<td><?php echo hms_e($r['medical_record_no']); ?></td><td><?php echo hms_e($r['registration_no'].' / '.$r['queue_no']); ?></td>
<td><?php echo hms_e($r['PatientName']); ?></td><td><?php echo hms_e($r['poli']); ?></td><td><?php echo hms_e($r['doctorName']??'-'); ?></td>
<td><?php echo hms_status_badge($r['status']); ?></td><td><?php echo (int)$r['soap_count']>0?'<span class="badge bg-success">SOAP tersimpan</span>':'<span class="badge bg-warning text-dark">Belum ada SOAP</span>'; ?></td>
<td><?php if($r['status']==='DILAYANI' && (int)$r['soap_count']>0){ ?><form method="post" class="d-inline" onsubmit="return confirm('Selesaikan pemeriksaan ini?');"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="complete"><input type="hidden" name="encounter_id" value="<?php echo (int)$r['id']; ?>"><button class="btn btn-sm btn-success">Selesaikan</button></form><?php } elseif($r['status']==='DILAYANI'){ ?><span class="small text-muted">Simpan SOAP dahulu</span><?php } else { ?><span class="small text-muted">-</span><?php } ?></td>
</tr><?php } if(!$rows){ ?><tr><td colspan="8" class="text-center text-muted py-4">Belum ada pelayanan rawat jalan.</td></tr><?php } ?>
</tbody></table></div></div>
<?php hms_layout_footer(); ?>
