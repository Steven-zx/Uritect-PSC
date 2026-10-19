# Uritect PSC

An independently versioned consumer-app prototype for the Philippine Startup Competition, derived from URITECT's offline Android research app. This repository is separate from the thesis project and installs alongside it.

**Version:** 0.1.0+1. **Android application ID:** `app.uritect.psc` (provisional; availability/ownership has not been registered). **Status:** competition prototype, not publicly released or clinically validated.

Local preview APK: `releases/Uritect_PSC_0.1.0_preview.apk` (generated artifact, excluded from Git). Its checksum is in `releases/SHA256SUMS.txt` and `docs/BUILD_VERIFICATION.json`. The initial build passed 193 automated tests and clean static analysis; the consumer dashboard was visually inspected. See `docs/VERIFICATION.md` for the exact scope.

## Start here

```powershell
cd app
flutter pub get
flutter analyze
flutter test
flutter run
```

Use Flutter 3.41.9 / Dart 3.11.5 or a tested compatible toolchain, Android SDK 36 and Android Studio's JDK. The Gradle wrapper is included. Set your own SDK location; no developer machine paths or signing keys are distributed. Android is the supported target for this first version.

Build an installable preview with `flutter build apk --debug`. The preview uses a development signature, not the thesis signing key. A Play release requires your own signing configuration, separate release review and Android App Bundle. `flutter build appbundle --release` intentionally fails without configured release signing.

## Working features

- Three-page first-run introduction and explicit prototype acknowledgment.
- Personalized “Hello, [name]” dashboard, guest exploration and sign-out.
- Real device-credential sign-in to a single encrypted local profile. There is no email/password server or cloud identity in this version.
- Home question-mark button and searchable offline guide, including strip preparation, photo capture, interpretation, renal-related follow-up, privacy and project background.
- Home/Learn/Plus/Profile navigation and a fresh consumer visual design.
- Existing camera/gallery, alignment grid, progressive pad overlays, classifier/checklist, provisional Bayesian UTI pathways and protein/blood follow-up.
- Separately authenticated local scan history, record review and deletion. Records and photos retain the inherited encryption/recovery protections.
- A clearly labeled Free/Plus concept screen. No payment is collected, no entitlement is granted and no subscription exists.

Core scan guidance, safety advice and the local vault are not paywalled. Paid plans cannot change medical confidence or safety thresholds.

## Where things live

| Path | Purpose |
|---|---|
| `app/lib/psc/home.dart` | Welcome, sign-in/profile and dashboard |
| `app/lib/psc/session.dart` | Encrypted device profile and in-memory session |
| `app/lib/psc/guide.dart` | Searchable offline instructions and project guide |
| `app/lib/psc/history.dart` | Consumer history interface using the inherited vault |
| `app/lib/psc/plans.dart` | Non-purchasable Plus preview |
| `app/lib/services/` | Retained offline analysis, provenance and storage |
| `app/lib/models/` | Retained classifier and clinical interpretation contracts |
| `app/android/` | Isolated Android identity and native security bridge |
| `app/test/` | Inherited regressions plus PSC coverage |
| `docs/PRODUCT.md` | Product scope and capability status |
| `docs/BUSINESS_MODEL.md` | Monetization assumptions and unit economics |
| `docs/RELEASE_READINESS.md` | Backend, store and health-release work still required |

## Important scope

The copied model remains `direction_verified_experimental_v1_20261011`, SHA-256 `1380d9e04d044413b42bd045e3c7370bf3d06a720695d2654598657234742279`. A new interface does not improve its accuracy, calibrate disease probabilities or establish consumer medical suitability. Existing manufacturer/IFU, timing, abnormal-class and clinical-validation limits remain. The guide and dashboard communicate this explicitly.

The thesis app, data, original labels, frozen releases and signing materials are preserved. No raw dataset, health record, phone capture, personal account credential or original signing key was copied. The new repository has no GitHub remote until its owner chooses one; repository visibility and public publication are separate decisions.
