# Testing Strategy — NetSpeedBooster

## 1. Test Goals
Ensure that:
1. Benchmark engine accurately resolves test domains across multiple DNS servers without throwing unhandled exceptions.
2. Adapter property detection identifies Intel and generic Wi-Fi cards correctly.
3. Backup serialization accurately captures existing settings.
4. Rollback successfully restores baseline state.

## 2. Test Suites
- **Unit / Contract Tests**: `tests/Test-NetSpeedBooster.ps1`
  - Validates DNS latency measurement accuracy.
  - Tests `data/backup_state.json` schema validity.
  - Verifies network connectivity remains functional (`google.com`, `1.1.1.1`).
- **Commands**:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\tests\Test-NetSpeedBooster.ps1
  ```

## 3. Coverage Target
- 100% of public functions tested.
- 0 fatal errors on disconnected or alternate adapter topologies.
