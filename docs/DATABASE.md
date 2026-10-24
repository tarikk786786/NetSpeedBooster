# Data Model & Storage — NetSpeedBooster

## 1. Storage Overview
NetSpeedBooster uses file-backed JSON state storage located at `data/backup_state.json`. It guarantees 100% reversible state changes.

## 2. Schema Specification: `backup_state.json`
```json
{
  "Timestamp": "2026-10-24T12:40:00Z",
  "InterfaceAlias": "Wi-Fi",
  "OriginalDNS": [
    "192.168.29.1"
  ],
  "OriginalAdapterProperties": {
    "Preferred Band": "1. No Preference",
    "Throughput Booster": "Disabled",
    "MIMO Power Save Mode": "Auto SMPS"
  },
  "TCPGlobalParameters": {
    "AutoTuningLevelLocal": "Normal",
    "CongestionProvider": "CUBIC",
    "ECN": "Disabled"
  },
  "DeliveryOptimization": {
    "DownloadMode": 1
  }
}
```

## 3. Migration and Lifecycle
- The file is generated immediately before any system modification.
- Multiple backups can be retained with timestamped filenames (`backup_state_<timestamp>.json`).
- If `backup_state.json` exists, the rollback engine can restore factory default or previous state in < 2 seconds.
