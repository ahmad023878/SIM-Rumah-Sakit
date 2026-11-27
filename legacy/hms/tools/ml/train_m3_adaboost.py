#!/usr/bin/env python3
"""M3 service-duration regression benchmark for SIMRS HMS.

Input: tools/ml/data/m3_service_duration_dataset.csv (exported by M3 page)
Target: actual service duration in minutes = completed_at - served_at.
Models: Linear Regression, Random Forest, AdaBoost Regression.
Evaluation: chronological holdout and TimeSeriesSplit MAE/RMSE/R2 where sample size permits.
"""
from __future__ import annotations
import json
import joblib
import sys
from datetime import datetime
from pathlib import Path

import numpy as np
import pandas as pd

BASE = Path(__file__).resolve().parent
DATA = BASE / "data" / "m3_service_duration_dataset.csv"
OUT = BASE / "output"
OUT.mkdir(parents=True, exist_ok=True)

PROFILE_PATH = OUT / "m3_data_profile.json"
METRICS_PATH = OUT / "m3_model_metrics.json"


def write_json(path: Path, payload: dict) -> None:
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=False, allow_nan=False), encoding="utf-8")


def clean_dataset(df: pd.DataFrame) -> tuple[pd.DataFrame, dict]:
    original_rows = len(df)
    required = ["service_duration_minutes"]
    missing_columns = [c for c in required if c not in df.columns]
    if missing_columns:
        raise ValueError("Kolom target tidak ditemukan: " + ", ".join(missing_columns))

    # Explicit predictors: only information available by registration / scheduling time.
    numeric_features = ["registration_hour", "weekday", "month", "queue_ahead_count", "slot_duration_minutes"]
    categorical_features = ["poli", "doctor_id", "source"]
    for col in numeric_features:
        if col not in df.columns:
            df[col] = np.nan
    for col in categorical_features:
        if col not in df.columns:
            df[col] = "Tidak diketahui"

    df["service_duration_minutes"] = pd.to_numeric(df["service_duration_minutes"], errors="coerce")
    for col in numeric_features:
        df[col] = pd.to_numeric(df[col], errors="coerce")
    for col in categorical_features:
        df[col] = df[col].fillna("Tidak diketahui").astype(str).replace({"": "Tidak diketahui", "nan": "Tidak diketahui", "None": "Tidak diketahui"})

    # Remove invalid target rows; retain only plausible positive duration <= 24 hours.
    df = df.replace([np.inf, -np.inf], np.nan)
    df = df.dropna(subset=["service_duration_minutes"])
    df = df[(df["service_duration_minutes"] > 0) & (df["service_duration_minutes"] <= 1440)].copy()

    # Preserve temporal order for a realistic future-period test.
    sort_cols = [c for c in ["visit_date", "served_at", "visit_id"] if c in df.columns]
    if sort_cols:
        df = df.sort_values(sort_cols, kind="mergesort")
    df = df.reset_index(drop=True)

    profile = {
        "rows_before_cleaning": int(original_rows),
        "rows_after_cleaning": int(len(df)),
        "rows_removed": int(original_rows - len(df)),
        "target": "service_duration_minutes",
        "target_unit": "minutes",
        "target_summary": {},
        "missing_predictor_values": {},
        "generated_at": datetime.now().astimezone().isoformat(timespec="seconds"),
    }
    if len(df):
        y = df["service_duration_minutes"]
        profile["target_summary"] = {
            "mean": round(float(y.mean()), 4),
            "median": round(float(y.median()), 4),
            "std": round(float(y.std(ddof=1)), 4) if len(y) > 1 else None,
            "min": round(float(y.min()), 4),
            "max": round(float(y.max()), 4),
        }
    for col in numeric_features + categorical_features:
        profile["missing_predictor_values"][col] = int(df[col].isna().sum())
    return df, profile


def build_models():
    from sklearn.compose import ColumnTransformer
    from sklearn.impute import SimpleImputer
    from sklearn.pipeline import Pipeline
    from sklearn.preprocessing import OneHotEncoder, StandardScaler
    from sklearn.linear_model import LinearRegression
    from sklearn.ensemble import RandomForestRegressor, AdaBoostRegressor
    from sklearn.tree import DecisionTreeRegressor

    numeric = ["registration_hour", "weekday", "month", "queue_ahead_count", "slot_duration_minutes"]
    categorical = ["poli", "doctor_id", "source"]
    numeric_lr = Pipeline([("imputer", SimpleImputer(strategy="median")), ("scale", StandardScaler())])
    numeric_tree = Pipeline([("imputer", SimpleImputer(strategy="median"))])
    categorical_pipe = Pipeline([
        ("imputer", SimpleImputer(strategy="most_frequent")),
        ("onehot", OneHotEncoder(handle_unknown="ignore")),
    ])
    pre_lr = ColumnTransformer([("num", numeric_lr, numeric), ("cat", categorical_pipe, categorical)])
    pre_tree = ColumnTransformer([("num", numeric_tree, numeric), ("cat", categorical_pipe, categorical)])

    stump = DecisionTreeRegressor(max_depth=3, min_samples_leaf=2, random_state=42)
    try:
        ada = AdaBoostRegressor(estimator=stump, n_estimators=100, learning_rate=0.05, loss="linear", random_state=42)
    except TypeError:  # scikit-learn < 1.2 compatibility
        ada = AdaBoostRegressor(base_estimator=stump, n_estimators=100, learning_rate=0.05, loss="linear", random_state=42)

    return {
        "Linear Regression": Pipeline([("preprocess", pre_lr), ("model", LinearRegression())]),
        "Random Forest": Pipeline([("preprocess", pre_tree), ("model", RandomForestRegressor(n_estimators=300, min_samples_leaf=2, random_state=42, n_jobs=-1))]),
        "AdaBoost Regression": Pipeline([("preprocess", pre_tree), ("model", ada)]),
    }


def main():
    if not DATA.is_file():
        msg = f"Dataset belum ditemukan: {DATA}. Ekspor dataset aktual dari halaman M3 lalu simpan pada lokasi tersebut."
        write_json(PROFILE_PATH, {"status": "dataset_missing", "message": msg, "generated_at": datetime.now().astimezone().isoformat(timespec="seconds")})
        write_json(METRICS_PATH, {"status": "dataset_missing", "message": msg, "models": {}, "generated_at": datetime.now().astimezone().isoformat(timespec="seconds")})
        print(msg)
        return 2

    raw = pd.read_csv(DATA)
    df, profile = clean_dataset(raw)
    profile["status"] = "profiled"
    profile["predictors"] = ["poli", "doctor_id", "source", "registration_hour", "weekday", "month", "queue_ahead_count", "slot_duration_minutes"]
    write_json(PROFILE_PATH, profile)

    # Do not manufacture a model result from a tiny sample. Holdout + time CV require enough observations.
    minimum_rows = 20
    if len(df) < minimum_rows:
        msg = (f"Training belum dijalankan: hanya {len(df)} baris valid; diperlukan minimal {minimum_rows} "
               "baris untuk uji awal chronological holdout dan TimeSeriesSplit. Tambahkan data pelayanan selesai yang valid.")
        write_json(METRICS_PATH, {
            "status": "insufficient_data", "message": msg, "sample_count": int(len(df)),
            "minimum_rows": minimum_rows, "models": {}, "cross_validation": {},
            "generated_at": datetime.now().astimezone().isoformat(timespec="seconds"),
        })
        for stale in (OUT / "m3_adaboost_model.joblib", OUT / "m3_model_artifact.json"):
            if stale.exists(): stale.unlink()
        print(msg)
        return 0

    from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
    from sklearn.model_selection import TimeSeriesSplit, cross_val_score
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    feature_cols = ["poli", "doctor_id", "source", "registration_hour", "weekday", "month", "queue_ahead_count", "slot_duration_minutes"]
    X = df[feature_cols]
    y = df["service_duration_minutes"].astype(float)
    split_at = int(np.floor(len(df) * 0.8))
    split_at = min(max(split_at, 2), len(df) - 2)
    X_train, X_test = X.iloc[:split_at], X.iloc[split_at:]
    y_train, y_test = y.iloc[:split_at], y.iloc[split_at:]

    models = build_models()
    results = {}
    fitted = {}
    predictions = {}
    for name, model in models.items():
        model.fit(X_train, y_train)
        pred = np.asarray(model.predict(X_test), dtype=float)
        fitted[name] = model
        predictions[name] = pred
        results[name] = {
            "MAE": round(float(mean_absolute_error(y_test, pred)), 6),
            "RMSE": round(float(np.sqrt(mean_squared_error(y_test, pred))), 6),
            "R2": round(float(r2_score(y_test, pred)), 6) if len(y_test) >= 2 else None,
        }

    # TimeSeriesSplit keeps each validation fold later than its training fold.
    n_splits = min(5, max(2, len(df) // 5))
    tscv = TimeSeriesSplit(n_splits=n_splits)
    cv_results = {}
    for name, model in models.items():
        scores = -cross_val_score(model, X, y, cv=tscv, scoring="neg_mean_absolute_error", n_jobs=None)
        cv_results[name] = {
            "TimeSeriesSplit_MAE_mean": round(float(np.mean(scores)), 6),
            "TimeSeriesSplit_MAE_std": round(float(np.std(scores, ddof=1)) if len(scores) > 1 else 0.0, 6),
            "fold_scores": [round(float(v), 6) for v in scores],
        }

    # Best is determined by measured holdout MAE, not assumed to be AdaBoost.
    best_name = min(results, key=lambda k: results[k]["MAE"])
    metrics = {
        "status": "trained", "sample_count": int(len(df)),
        "train_samples": int(len(X_train)), "test_samples": int(len(X_test)),
        "split": "chronological_80_20", "cross_validation_method": f"TimeSeriesSplit_{n_splits}_fold",
        "models": results, "cross_validation": cv_results,
        "best_model_by_holdout_MAE": best_name,
        "best_model_note": "Model terbaik ditentukan berdasarkan MAE data uji; bukan ditetapkan sebelumnya.",
        "generated_at": datetime.now().astimezone().isoformat(timespec="seconds"),
        "features": feature_cols,
        "target": "service_duration_minutes",
    }
    write_json(METRICS_PATH, metrics)

    # M5 follows the declared research architecture and therefore deploys AdaBoost.
    # Benchmark winner is still reported separately; it is never assumed to be AdaBoost.
    deployed_model = models["AdaBoost Regression"]
    deployed_model.fit(X, y)
    MODEL_PATH = OUT / "m3_adaboost_model.joblib"
    joblib.dump(deployed_model, MODEL_PATH)
    write_json(OUT / "m3_model_artifact.json", {
        "status": "ready", "model_name": "AdaBoost Regression",
        "benchmark_winner_by_holdout_MAE": best_name,
        "features": feature_cols, "sample_count": int(len(df)),
        "trained_at": datetime.now().astimezone().isoformat(timespec="seconds")
    })

    # Save out-of-sample predictions for transparent review.
    pred_frame = df.iloc[split_at:][[c for c in ["visit_id", "visit_date", "poli", "doctor_id"] if c in df.columns]].copy()
    pred_frame["actual_minutes"] = y_test.to_numpy()
    for name, pred in predictions.items():
        pred_frame[name.lower().replace(" ", "_")] = pred
    pred_frame.to_csv(OUT / "m3_test_predictions.csv", index=False)

    # Metric comparison chart.
    names = list(results.keys())
    x = np.arange(len(names))
    width = 0.25
    fig, ax = plt.subplots(figsize=(9, 5))
    for i, metric in enumerate(["MAE", "RMSE"]):
        ax.bar(x + (i - 0.5) * width, [results[n][metric] for n in names], width, label=metric)
    ax.set_xticks(x, names, rotation=10)
    ax.set_ylabel("Error (minutes; lower is better)")
    ax.set_title("M3 — Benchmark Model Service Duration")
    ax.legend()
    ax.grid(axis="y", alpha=0.25)
    fig.tight_layout()
    fig.savefig(OUT / "m3_model_comparison.png", dpi=150)
    plt.close(fig)

    # Actual vs predicted plot for each model on the same chronological holdout.
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.plot(np.arange(len(y_test)), y_test.to_numpy(), marker="o", label="Actual")
    for name, pred in predictions.items():
        ax.plot(np.arange(len(pred)), pred, marker="x", linestyle="--", label=name)
    ax.set_xlabel("Urutan sampel pada data uji")
    ax.set_ylabel("Service duration (menit)")
    ax.set_title("Aktual vs Prediksi — Data Uji Kronologis")
    ax.legend()
    ax.grid(alpha=0.25)
    fig.tight_layout()
    fig.savefig(OUT / "m3_actual_vs_predicted.png", dpi=150)
    plt.close(fig)

    print(json.dumps({"status": "trained", "best_model": best_name, "metrics": results}, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        error = {"status": "error", "message": str(exc), "generated_at": datetime.now().astimezone().isoformat(timespec="seconds")}
        write_json(METRICS_PATH, error)
        print("M3 training error:", exc, file=sys.stderr)
        raise
