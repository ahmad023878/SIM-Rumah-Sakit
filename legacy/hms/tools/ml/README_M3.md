# M3 — AdaBoost Regression: service duration SIMRS

## Target and data source

Target: `service_duration_minutes = TIMESTAMPDIFF(SECOND, hms_patient_visits.served_at, hms_patient_visits.completed_at) / 60`.
Only outpatient visits with a positive duration up to 24 hours are included in the initial analytical dataset. The source database is read-only during export/training.

## Predictors

- `poli`: clinic/polyclinic assigned before service.
- `doctor_id`: assigned doctor identifier (categorical; no patient identity).
- `source`: ONLINE/OFFLINE.
- `registration_hour`: hour from `created_at`.
- `weekday`, `month`: visit calendar features.
- `queue_ahead_count`: earlier registrations in the same clinic/date that had not yet started service at the current registration time.
- `slot_duration_minutes`: active schedule slot duration for the same doctor and visit date, when available.

`visit_id` is retained only as a row reference and is never a predictor. `served_at`, `completed_at`, `status`, patient identifiers, diagnosis, and service duration are not predictors. Timestamp-derived fields after service start are excluded to avoid target leakage.

## Preprocessing and evaluation

- Numeric missing values: median imputation; categorical missing values: most-frequent imputation and one-hot encoding.
- Linear Regression additionally uses numeric standardization.
- Chronological 80:20 train/test split; no random shuffle.
- TimeSeriesSplit cross-validation on the ordered dataset.
- Benchmarks: Linear Regression, Random Forest Regressor, AdaBoost Regressor (DecisionTreeRegressor base estimator).
- Metrics: MAE, RMSE, R². Lower MAE/RMSE is better; higher R² is better.
- The best model is selected from measured holdout MAE. AdaBoost is not assumed to be best.
- The script refuses to train when fewer than 20 valid rows are available. It still writes a profiling report and a clear insufficient-data status.

## Run

1. In the M3 page, select the required date range and click **Unduh dataset aktual**.
2. Save the downloaded CSV as `tools/ml/data/m3_service_duration_dataset.csv`.
3. From the application root, install dependencies: `python -m pip install -r tools/ml/requirements.txt`.
4. Run: `python tools/ml/train_m3_adaboost.py`.
5. Refresh the M3 page. Reports are written to `tools/ml/output/`.

The script does not update the operational database. Results are experimental and should not be used for clinical decisions without adequate data validation.
