# Initial preview verification — 2026-10-20

- App: Uritect PSC 0.1.0+1, Android package `app.uritect.psc`, min SDK 24, target/compile SDK 36.
- 193 automated tests passed in the isolated fork, including inherited scan/orientation/reliability/clinical/history regressions and new profile/UI tests.
- Five PSC visual/workflow tests were rerun after loading the actual icon font and using the real application theme for the dashboard screenshot; all passed. The screenshot was visually inspected.
- Flutter static analysis: no issues found.
- Debug APK built successfully and Android signature verification passed. It is a development preview, not a production-signed Play release.
- APK model bytes exactly match the fork source and original retained classifier; a new commercial interface has not changed model performance.
- All 70 protected original thesis source/assets hashes match the pre-copy baseline. Original signing keys and private dataset files were not copied.
- Staged-source checks exclude APK/AAB, local SDK configuration and signing files. Large APKs are generated locally and must be distributed separately from source commits.
- A Windows Gradle generated-cache rename failed on the first complete build. After the completed entry's metadata and exact paths were verified, its rename was completed and the build succeeded. No application logic or thesis source was changed to bypass the failure.

## Boundaries

Profile tests verify the service's authentication sequencing, preservation of files after canceled authentication, encrypted-storage contract and no-overwrite behavior using a behavioral fake. They do not independently certify Android hardware cryptography. Native credential dialogs, camera/gallery and device lifecycle should be exercised with this exact APK on a phone before a public pilot. No new installation or manual phone acceptance is claimed.

Device profile sign-in is implemented. Cloud identity, email/password accounts, live billing, paid entitlements, Play publication and independent consumer clinical validation are not implemented or claimed. The Plus screen explicitly describes a non-purchasable concept.

Detailed build/model/source checks: `BUILD_VERIFICATION.json`, `THESIS_SOURCE_BASELINE.json` and `SOURCE_MANIFEST.json`. Local verbose logs are ignored by Git; no build logs containing machine-specific paths are included in the source distribution.
