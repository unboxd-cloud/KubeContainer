#!/usr/bin/env python3
import json
import pathlib
import re
import sys

root = pathlib.Path(__file__).resolve().parents[2]
sla_path = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else root / "contracts" / "metakube-sla.json"
report_path = pathlib.Path(sys.argv[2]) if len(sys.argv) > 2 else root / "dist" / "metakube-report.txt"
out_path = pathlib.Path(sys.argv[3]) if len(sys.argv) > 3 else root / "dist" / "metakube-score.json"

if not sla_path.exists():
    raise SystemExit(f"missing SLA contract: {sla_path}")
if not report_path.exists():
    raise SystemExit(f"missing observance report: {report_path}")

sla = json.loads(sla_path.read_text())
report = report_path.read_text()

fields = {}
for line in report.splitlines():
    if ":" in line:
        key, value = line.split(":", 1)
        fields[key.strip().lower().replace(" ", "_")] = value.strip()

metric_map = {
    "cluster_ready": fields.get("cluster", "Unknown"),
    "operator_ready": fields.get("operator", "Unknown"),
    "kubecontainer_ready": fields.get("kubecontainer", "Unknown"),
    "metrics_service_present": fields.get("metrics", "Unknown"),
    "release_verdict": fields.get("verdict", "PROMISE_UNKNOWN"),
    "evidence_artifact_written": "Written" if report_path.exists() and report_path.stat().st_size > 0 else "Missing",
}

slos = []
weighted = 0.0
weight_total = 0.0
for slo in sla["slos"]:
    actual = metric_map.get(slo["metric"], "Unknown")
    expected = slo.get("expected")
    expected_any = slo.get("expectedAny")
    if expected_any is not None:
        passed = actual in expected_any
    else:
        passed = actual == expected
    raw = 1.0 if passed else 0.0
    adjusted = raw * (1.0 - float(sla.get("uncertainty", 0.0)))
    trusted = adjusted * float(sla.get("providerConfidence", 1.0))
    weight = float(slo["weight"])
    weighted += trusted * weight
    weight_total += weight
    slos.append({
        "name": slo["name"],
        "metric": slo["metric"],
        "actual": actual,
        "expected": expected_any if expected_any is not None else expected,
        "weight": weight,
        "score": trusted,
        "passed": passed,
    })

weighted_score = weighted / weight_total if weight_total else 0.0
critical_cap = 1.0
caps_applied = []
for cap in sla.get("criticalCaps", []):
    actual = metric_map.get(cap["metric"], "Unknown")
    applies = False
    if "notExpected" in cap:
        applies = actual != cap["notExpected"]
    if "expected" in cap:
        applies = actual == cap["expected"]
    if applies:
        critical_cap = min(critical_cap, float(cap["cap"]))
        caps_applied.append({"name": cap["name"], "metric": cap["metric"], "actual": actual, "cap": cap["cap"]})

final_score = min(weighted_score, critical_cap)
threshold = float(sla.get("threshold", 0.9))
verdict = "SLA_KEPT" if final_score >= threshold else "SLA_BROKEN"

result = {
    "sla": sla["sla"],
    "version": sla["version"],
    "scope": sla["scope"],
    "threshold": threshold,
    "metrics": metric_map,
    "slos": slos,
    "weightedScore": round(weighted_score, 4),
    "criticalCap": round(critical_cap, 4),
    "capsApplied": caps_applied,
    "finalScore": round(final_score, 4),
    "verdict": verdict,
}

out_path.parent.mkdir(parents=True, exist_ok=True)
out_path.write_text(json.dumps(result, indent=2) + "\n")
print(json.dumps(result, indent=2))

if verdict != "SLA_KEPT":
    raise SystemExit(1)
