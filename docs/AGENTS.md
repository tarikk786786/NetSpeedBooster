# Operational Agent Directives — NetSpeedBooster

## 1. Context & Scope
NetSpeedBooster manages critical operating system network configuration. Any agent operating in this repository must exercise high rigor.

## 2. Guardrails
- **No Destructive Operations**: Never issue commands that delete network adapters, wipe system registry hives, or disrupt active remote shells without warning.
- **Elevation Requirement**: Recognize that `Set-DnsClientServerAddress` and `Set-NetAdapterAdvancedProperty` require Administrator privileges. Always provide a fallback or wrapper with `-Verb RunAs`.
- **Credential Storage**: Comply with root `appinfo11.txt` rules if any remote APIs or credentials are added.

## 3. Definition of Verification
- Every PR or modification must execute `tests/Test-NetSpeedBooster.ps1` and confirm 100% pass rate before concluding.
