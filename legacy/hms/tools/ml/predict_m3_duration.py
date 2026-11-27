#!/usr/bin/env python3
"""M3 inference helper for M5 Hybrid DSS. Reads one JSON object from stdin."""
import json, sys
from pathlib import Path
import joblib

BASE = Path(__file__).resolve().parent
model_path = BASE / "output" / "m3_adaboost_model.joblib"
meta_path = BASE / "output" / "m3_model_artifact.json"
try:
    meta = json.loads(meta_path.read_text(encoding="utf-8"))
    if meta.get("status") != "ready" or not model_path.is_file():
        raise RuntimeError("Model M3 belum tersedia. Jalankan training M3 terlebih dahulu.")
    payload = json.load(sys.stdin)
    import pandas as pd
    cols = ["poli", "doctor_id", "source", "registration_hour", "weekday", "month", "queue_ahead_count", "slot_duration_minutes"]
    row = {k: payload.get(k) for k in cols}
    frame = pd.DataFrame([row], columns=cols)
    value = float(joblib.load(model_path).predict(frame)[0])
    value = max(1.0, min(240.0, value))
    print(json.dumps({"status":"ok", "predicted_minutes":round(value,3), "model_name":meta.get("model_name"), "sample_count":meta.get("sample_count")}))
except Exception as exc:
    print(json.dumps({"status":"error", "message":str(exc)}))
    sys.exit(2)
