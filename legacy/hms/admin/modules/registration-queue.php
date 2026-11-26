<?php
session(); include('../include/config.php'); require_once __DIR__.'/module_bootstrap.php'; require_once __DIR__.'/simrs_integration_bootstrap.php'; require_once __DIR__.'/visit_workflow_helpers.php'; hms_int_bootstrap($con); hms_module_require_roles(array('admin','rekam_medis'));
if($_SERVER['REQUEST_METHOD']==='POST'){
 hms_module_csrf(); $action=$_POST['action']??'';
 try {
  if($action==='new_patient'){
   $name=trim($_POST['patient_name']??''); $nik=trim($_POST['nik']??''); $phone=trim($_POST['phone']??''); $email=trim($_POST['email']??''); $gender=trim($_POST['gender']??''); $address=trim($_POST['address']??''); $age=(int)($_POST['age']??0);
   if($name==='') throw new RuntimeException('Nama pasien wajib diisi.');
   $idNo=$nik!==''?$nik:null;
   if($nik!=='') { $dup=hms_fetch_one($con,'SELECT ID FROM tblpatient WHERE PatientMedhis LIKE ? LIMIT 1','s',array('%NIK:'.$nik.'%')); if($dup) throw new RuntimeException('NIK sudah terdaftar.'); }
   $med='NIK: '.($nik?:'-');
   $st=mysqli_prepare($con,'INSERT INTO tblpatient(Docid,PatientName,PatientContno,PatientEmail,PatientGender,PatientAdd,PatientAge,PatientMedhis,CreationDate) VALUES(NULL,?,?,?,?,?,?,?,NOW())');
   if(!$st) throw new RuntimeException('Gagal menyiapkan pasien baru.');
   $phoneNum=preg_replace('/\D/','',$phone); $phoneNum=$phoneNum!==''?(int)$phoneNum:0;
   mysqli_stmt_bind_param($st,'sisssis',$name,$phoneNum,$email,$gender,$address,$age,$med); if(!mysqli_stmt_execute($st)){mysqli_stmt_close($st);throw new RuntimeException('Gagal menyimpan pasien baru.');} $pid=mysqli_stmt_insert_id($st); mysqli_stmt_close($st);
   $mrn='RM'.date('Y').str_pad((string)$pid,6,'0',STR_PAD_LEFT); hms_execute($con,'UPDATE tblpatient SET medical_record_no=? WHERE ID=?','si',array($mrn,$pid));
   hms_module_audit($con,'CREATE','REGISTRASI','tblpatient',$pid,'Pasien baru dibuat',null,array('medical_record_no'=>$mrn,'name'=>$name,'nik'=>$nik));
   hms_set_flash('success','Pasien baru berhasil dibuat. No. RM: '.$mrn);
  }
  if($action==='register'){
   $pid=(int)($_POST['patient_id']??0); $type=$_POST['visit_type']??'RAWAT_JALAN'; $poli=trim($_POST['poli']??''); $source=$_POST['source']??'OFFLINE'; $counter=trim($_POST['registration_counter']??''); $doctor=(int)($_POST['doctor_id']??0);
   if($pid<=0) throw new RuntimeException('Pilih pasien.'); if(!in_array($type,array('RAWAT_JALAN','IGD','RAWAT_INAP'),true))$type='RAWAT_JALAN'; if(!in_array($source,array('ONLINE','OFFLINE'),true))$source='OFFLINE';
   if($type==='RAWAT_JALAN' && $poli==='') throw new RuntimeException('Pilih poli untuk kunjungan rawat jalan.');
   if($type==='RAWAT_JALAN' && $doctor<=0) throw new RuntimeException('Pilih dokter untuk mengarahkan antrean ke menu dokter.');
   if($type==='RAWAT_JALAN' && !hms_fetch_one($con,'SELECT id FROM hms_master_poli WHERE poli_name=? AND is_active=1 LIMIT 1','s',array($poli))) throw new RuntimeException('Poli tidak ditemukan atau tidak aktif pada Master Poli.');
   if($doctor>0 && !hms_fetch_one($con,'SELECT id FROM doctors WHERE id=?','i',array($doctor))) throw new RuntimeException('Dokter tidak ditemukan.');
   $patient=hms_fetch_one($con,'SELECT ID,medical_record_no FROM tblpatient WHERE ID=?','i',array($pid)); if(!$patient)throw new RuntimeException('Pasien tidak ditemukan.');
   $mrType='LAMA'; if(empty($patient['medical_record_no'])){ $mr='RM'.date('Y').str_pad((string)$pid,6,'0',STR_PAD_LEFT); hms_execute($con,'UPDATE tblpatient SET medical_record_no=? WHERE ID=?','si',array($mr,$pid)); $mrType='BARU'; } 
   $code=hms_module_next_code($con,'hms_patient_visits','REG','id'); $queue=hms_module_next_queue($con,$poli,date('Y-m-d')); $token=$source==='ONLINE'?bin2hex(random_bytes(12)):null;
   $st=mysqli_prepare($con,'INSERT INTO hms_patient_visits(patient_id,mr_type,registration_no,visit_date,visit_type,poli,doctor_id,queue_no,source,online_booking_token,status,registration_counter,arrived_at) VALUES(?,?,?,CURDATE(),?,?,?,?,?,?,?,?,?)');
   if(!$st)throw new RuntimeException('Gagal menyiapkan registrasi.'); $status='MENUNGGU'; $arrivedAt=$source==='OFFLINE'?date('Y-m-d H:i:s'):null; mysqli_stmt_bind_param($st,'issssissssss',$pid,$mrType,$code,$type,$poli,$doctor,$queue,$source,$token,$status,$counter,$arrivedAt);
   if(!mysqli_stmt_execute($st)){mysqli_stmt_close($st);throw new RuntimeException('Registrasi gagal disimpan.');} $id=mysqli_stmt_insert_id($st); mysqli_stmt_close($st);
   hms_module_audit($con,'CREATE','REGISTRASI','hms_patient_visits',$id,'Kunjungan terdaftar',null,array('medical_record_no'=>$patient['medical_record_no'],'registration_no'=>$code,'mr_type'=>$mrType,'visit_type'=>$type,'poli'=>$poli,'doctor_id'=>$doctor,'queue_no'=>$queue,'source'=>$source,'counter'=>$counter));
   hms_module_workflow_event($con,$pid,$id,null,null,'REGISTRASI','MENUNGGU','Kunjungan '.$code.' terdaftar.');
   hms_set_flash('success','Registrasi '.$code.' berhasil. Antrean '.$queue.($token?' | Token online '.$token:''));
  }
  if($action==='checkin'){
   $id=(int)($_POST['id']??0);
   $visit=hms_fetch_one($con,'SELECT v.id,v.status,v.arrived_at,v.appointment_id,a.status appointment_status FROM hms_patient_visits v LEFT JOIN appointment a ON a.id=v.appointment_id WHERE v.id=?','i',array($id));
   if(!$visit) throw new RuntimeException('Kunjungan tidak ditemukan.');
   if($visit['status']!=='MENUNGGU') throw new RuntimeException('Check-in hanya dapat dilakukan saat status MENUNGGU.');
   if(!empty($visit['appointment_id']) && $visit['appointment_status']!=='Approved') throw new RuntimeException('Appointment harus disetujui admin/dokter sebelum check-in.');
   if(empty($visit['arrived_at'])) {
    hms_execute($con,'UPDATE hms_patient_visits SET arrived_at=NOW(),updated_at=NOW() WHERE id=? AND arrived_at IS NULL','i',array($id));
    hms_module_audit($con,'CHECK_IN','ANTRIAN','hms_patient_visits',$id,'Pasien check-in di lokasi.');
   }
   hms_set_flash('success','Check-in pasien berhasil dicatat.');
  }
  if($action==='status'){
   mysqli_begin_transaction($con);
   $id=(int)($_POST['id']??0); $new=$_POST['status']??''; if(!in_array($new,array('DIPANGGIL','DILAYANI','BATAL'),true))throw new RuntimeException('Status tidak valid. Status SELESAI hanya dapat ditetapkan setelah SOAP/RME disimpan melalui menu Rawat Jalan.');
   $old=hms_fetch_one($con,'SELECT v.*,a.status appointment_status FROM hms_patient_visits v LEFT JOIN appointment a ON a.id=v.appointment_id WHERE v.id=? FOR UPDATE','i',array($id)); if(!$old)throw new RuntimeException('Kunjungan tidak ditemukan.');
   if(!empty($old['appointment_id']) && $old['appointment_status']!=='Approved' && $new!=='BATAL') throw new RuntimeException('Appointment harus disetujui sebelum pasien dipanggil.');
   if($new==='DIPANGGIL' && $old['source']==='ONLINE' && empty($old['arrived_at'])) throw new RuntimeException('Pasien online harus check-in terlebih dahulu sebelum dipanggil.');
   $allowed=array('MENUNGGU'=>array('DIPANGGIL','BATAL'),'DIPANGGIL'=>array('DILAYANI','BATAL'),'DILAYANI'=>array(),'SELESAI'=>array(),'BATAL'=>array()); if(!in_array($new,$allowed[$old['status']]??array(),true))throw new RuntimeException('Perubahan status antrean tidak sesuai alur.');
   $sets='status=?'; $vals=array($new); $types='s';
   if($new==='DIPANGGIL'){$sets.=',called_at=COALESCE(called_at,NOW())';}
   if($new==='DILAYANI'){$sets.=',served_at=COALESCE(served_at,NOW())';}
   $vals[]=$id;$vals[]=$old['status']; $types.='is';
   hms_execute($con,"UPDATE hms_patient_visits SET $sets,updated_at=NOW() WHERE id=? AND status=?",$types,$vals);
   if($new==='DILAYANI' && $old['visit_type']==='RAWAT_JALAN'){
     hms_workflow_ensure_outpatient_encounter($con,$id,(int)$old['doctor_id']);
   }
   hms_module_audit($con,'STATUS_CHANGE','REGISTRASI','hms_patient_visits',$id,'Status antrean diubah',$old,array('status'=>$new));
   hms_module_workflow_event($con,(int)$old['patient_id'],$id,null,null,'ANTRIAN',$new,'Status antrean '.$new.'.');
   hms_set_flash('success',$new==='DILAYANI'?'Pasien mulai dilayani. Encounter rawat jalan tersedia untuk pengisian SOAP/RME.':'Status antrean diperbarui.');
   mysqli_commit($con);
  }
 } catch(Throwable $e){ @mysqli_rollback($con); hms_set_flash('danger',$e->getMessage());}
}
$patients=hms_fetch_all($con,'SELECT ID,PatientName,medical_record_no,PatientEmail FROM tblpatient ORDER BY PatientName LIMIT 1000');
$doctors=hms_fetch_all($con,'SELECT id,doctorName,specilization FROM doctors ORDER BY doctorName'); $polies=hms_fetch_all($con,'SELECT poli_name FROM hms_master_poli WHERE is_active=1 ORDER BY poli_name');
$rows=hms_fetch_all($con,"SELECT v.*,COALESCE(p.PatientName,'-') patient_name,p.medical_record_no,d.doctorName,a.status appointment_status FROM hms_patient_visits v LEFT JOIN tblpatient p ON p.ID=v.patient_id LEFT JOIN doctors d ON d.id=v.doctor_id LEFT JOIN appointment a ON a.id=v.appointment_id ORDER BY v.id DESC LIMIT 150");
$role=hms_module_current_role(); hms_layout_header('Registrasi & Antrean',$role,'operations');
?>
<div class="hms-page-title"><div><h1>Registrasi, Pendaftaran & Antrean</h1><div class="text-muted">Pendaftaran langsung tanpa membuat jadwal dokter. Pilih poli dan dokter agar antrean masuk ke daftar dokter.</div></div></div>
<div class="hms-card p-3 mb-4"><h2 class="h5">Pasien Baru</h2><form method="post" class="row g-3"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="new_patient"><div class="col-md-3"><label class="form-label">Nama *</label><input name="patient_name" class="form-control" required></div><div class="col-md-2"><label class="form-label">NIK</label><input name="nik" class="form-control"></div><div class="col-md-2"><label class="form-label">No. HP</label><input name="phone" class="form-control"></div><div class="col-md-2"><label class="form-label">Jenis Kelamin</label><select name="gender" class="form-select"><option value="">Pilih</option><option value="male">Laki-laki</option><option value="female">Perempuan</option></select></div><div class="col-md-1"><label class="form-label">Umur</label><input name="age" type="number" min="0" class="form-control"></div><div class="col-md-12"><label class="form-label">Alamat</label><input name="address" class="form-control"></div><div class="col-12"><button class="btn btn-outline-primary">Daftarkan Pasien Baru & Buat No. RM</button></div></form></div>
<div class="hms-card p-3 mb-4"><h2 class="h5">Pendaftaran Kunjungan</h2><form method="post" class="row g-3"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="register"><div class="col-md-3"><label class="form-label">Pasien</label><select name="patient_id" class="form-select" required><option value="">Pilih pasien</option><?php foreach($patients as $pp){ ?><option value="<?php echo (int)$pp['ID']; ?>"><?php echo hms_e(($pp['medical_record_no']?:'RM-'.$pp['ID']).' - '.$pp['PatientName']); ?></option><?php } ?></select></div><div class="col-md-2"><label class="form-label">Jenis Kunjungan</label><select name="visit_type" class="form-select"><option>RAWAT_JALAN</option><option>IGD</option><option>RAWAT_INAP</option></select></div><div class="col-md-2"><label class="form-label">Poli/Unit</label><select name="poli" class="form-select"><option value="">Pilih poli</option><?php foreach($polies as $po){ ?><option value="<?php echo hms_e($po['poli_name']); ?>"><?php echo hms_e($po['poli_name']); ?></option><?php } ?></select></div><div class="col-md-2"><label class="form-label">Dokter</label><select name="doctor_id" class="form-select"><option value="0">Pilih dokter</option><?php foreach($doctors as $d){ ?><option value="<?php echo (int)$d['id']; ?>"><?php echo hms_e($d['doctorName'].' - '.$d['specilization']); ?></option><?php } ?></select></div><div class="col-md-1"><label class="form-label">Sumber</label><select name="source" class="form-select"><option>OFFLINE</option><option>ONLINE</option></select></div><div class="col-md-2"><label class="form-label">Loket</label><input name="registration_counter" class="form-control" placeholder="Loket 1"></div><div class="col-12"><button class="btn btn-primary">Daftar Kunjungan & Ambil Antrean</button></div></form></div>
<div class="hms-card p-3"><div class="table-responsive"><table class="table table-hover"><thead><tr><th>No. RM</th><th>Registrasi</th><th>Pasien</th><th>Jenis</th><th>Poli/Dokter</th><th>Antrean</th><th>Sumber/Loket</th><th>Status</th><th>Aksi</th></tr></thead><tbody><?php foreach($rows as $r){ ?><tr><td><?php echo hms_e($r['medical_record_no']); ?></td><td><?php echo hms_e($r['registration_no']); ?><div class="small text-muted"><?php echo hms_e($r['visit_date']); ?></div></td><td><?php echo hms_e($r['patient_name']); ?></td><td><?php echo hms_e($r['visit_type']); ?></td><td><?php echo hms_e($r['poli']); ?><div class="small text-muted"><?php echo hms_e($r['doctorName']??''); ?></div></td><td><strong><?php echo hms_e($r['queue_no']); ?></strong></td><td><?php echo hms_e($r['source'].' / '.($r['registration_counter']?:'-')); ?></td><td><?php echo hms_status_badge($r['status']); ?><?php if(!empty($r['appointment_id']) && $r['appointment_status']!=='Approved' && !in_array($r['status'],array('SELESAI','BATAL'),true)){ ?><div class="small text-warning fw-semibold">Menunggu persetujuan appointment</div><?php } ?></td><td><?php if((empty($r['appointment_id']) || $r['appointment_status']==='Approved') && $r['source']==='ONLINE' && empty($r['arrived_at']) && $r['status']==='MENUNGGU'){ ?><form method="post" class="d-inline"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="checkin"><input type="hidden" name="id" value="<?php echo (int)$r['id']; ?>"><button class="btn btn-sm btn-outline-info">Check-in</button></form><?php } ?><?php $next=array('MENUNGGU'=>'DIPANGGIL','DIPANGGIL'=>'DILAYANI'); if(isset($next[$r['status']]) && (empty($r['appointment_id']) || $r['appointment_status']==='Approved')){ ?><form method="post" class="d-inline"><?php echo hms_csrf_field(); ?><input type="hidden" name="action" value="status"><input type="hidden" name="id" value="<?php echo (int)$r['id']; ?>"><input type="hidden" name="status" value="<?php echo $next[$r['status']]; ?>"><button class="btn btn-sm btn-outline-primary"><?php echo $next[$r['status']]==='DIPANGGIL'?'Panggil':'Mulai Periksa'; ?></button></form><?php } elseif($r['status']==='DILAYANI' && $r['visit_type']==='RAWAT_JALAN'){ ?><a class="btn btn-sm btn-success" href="outpatient.php">Buka Rawat Jalan / RME</a><?php } ?></td></tr><?php } ?></tbody></table></div></div>
<?php hms_layout_footer(); ?>
