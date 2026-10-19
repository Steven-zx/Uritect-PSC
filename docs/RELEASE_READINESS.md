# Public release boundary

This repository is a working competition preview. It is **not** a declaration that the thesis classifier is ready for unsupervised public medical use.

## Before Play publication

- Validate the intended consumer use, strip/IFU, per-pad timing and clinical/analytical performance. Carry current research limits forward rather than treating new branding as validation. Determine the applicable medical-device/regulatory pathway with appropriate advisers before making public medical claims.
- Decide the publisher/legal entity, provisional package identity and final branding. Set up its own signing and Play App Signing. Never reuse the thesis signing materials by accident.
- Prepare an accurate Health apps declaration, Data safety disclosures and a publicly accessible privacy policy matching actual processing. Include in-app policy access, an operational contact and appropriate deletion/recovery flows for the final account model.
- If cloud identity is added, implement real account verification, secure sessions, account deletion, recovery, consent, authorization and separation of records per account. Do not replace the working device-login screen with an unverified “success” stub.
- If subscriptions are added, connect real products and verified purchase lifecycles. Confirm current billing policy and avoid charging for unavailable features.
- Verify the exact AAB, permissions, target API, camera/gallery behavior, screen locks, accessibility, offline behavior, current supported Android devices, crash handling, history recovery and source/model parity.

The release should describe validated capabilities only. No store listing has been submitted or remote account created by this work.

## Sources checked 2026-10-20

- [Google Play Health Content and Services](https://support.google.com/googleplay/android-developer/answer/16679511?hl=en): health-app declaration, privacy and health-functionality requirements.
- [Google Play Payments](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en): digital-feature billing and applicable exceptions.

## First-build manual acceptance

- Install beside thesis `ph.edu.wvsu.uritect`; confirm `app.uritect.psc` uses an independent data vault.
- Complete onboarding and confirm prototype acknowledgment is required.
- Create profile, cancel credentials, then authenticate successfully and confirm personalized greeting.
- Restart: sign in again; no plaintext profile should exist in storage.
- Guest mode: guide works; no cloud identity or purchase is implied.
- Scan invalid and valid supported research images; verify retake and clinical gates remain.
- Return Home from the scan flow and confirm PSC dashboard returns.
- Open saved history: authenticate; background and wait for expiry; confirm records are hidden.
- Delete a scan with confirmation; preserve gallery original.
- Open Plus and verify no payment, entitlement or subscription can be created.

## Handling source provenance

`THESIS_SOURCE_BASELINE.json` stores the copied source/assets hashes so the original thesis app can be checked after construction. The package/channel identity and consumer UI changes are confined to this repository. Original dataset archives and clinical evidence are not part of the copy.
