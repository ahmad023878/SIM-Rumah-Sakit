-- M7 Evaluation: prospective experiment assignment and recommendation acceptance log.
-- Apply once to the HMS database. This table does not modify appointments or patient visits.
CREATE TABLE IF NOT EXISTS hms_scheduling_evaluation (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  visit_id INT UNSIGNED NOT NULL,
  appointment_id INT NULL,
  experiment_arm ENUM('STATIC','FUZZY_ONLY','ADABOOST','HYBRID') NOT NULL,
  recommendation_shown TINYINT(1) NOT NULL DEFAULT 0,
  recommendation_accepted TINYINT(1) NULL DEFAULT NULL,
  recommendation_ref VARCHAR(100) NULL,
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  accepted_at DATETIME NULL,
  notes VARCHAR(500) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_m7_visit (visit_id),
  KEY idx_m7_arm_assigned (experiment_arm, assigned_at),
  KEY idx_m7_appointment (appointment_id),
  CONSTRAINT fk_m7_eval_visit FOREIGN KEY (visit_id) REFERENCES hms_patient_visits(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
