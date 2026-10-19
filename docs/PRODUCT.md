# Product: Uritect PSC

## Purpose

Help people prepare a supported strip photo, understand screening-support outputs and keep a private record for professional follow-up. The consumer edition should make the process understandable before asking someone to interpret a number.

## First journey

1. Welcome: understand the process, privacy and prototype boundary.
2. Create an encrypted device profile and authenticate with Android credentials, or explore as a guest.
3. Home: personalized greeting, a prominent scan action, the question-mark guide and saved-history access.
4. Scan: use the existing camera/gallery and quality/geometry workflow. Existing timing, specimen and clinical eligibility checks remain.
5. Results and checklist: show supported findings and provisional screening/follow-up, not a diagnosis.
6. History: explicitly unlock saved records; review or delete a scan.

## Capability status

| Capability | This version |
|---|---|
| Personal greeting / local sign-in / guest mode | Implemented |
| Offline guide and project instructions | Implemented |
| Scan/checklist/UTI/renal workflows | Inherited research implementation |
| Profile confidentiality | Existing native authenticated encryption, separate profile context |
| Local profile ownership | One device-owned profile; not a verified patient identity or multi-account service |
| Cloud login / Google sign-in / email recovery | Not implemented; needs a chosen backend and credentials |
| Live subscriptions / restore purchases | Not implemented; preview is explicitly non-purchasable |
| Reminders / visit-summary export / richer organization | Planned Plus value proposition, not advertised as working |
| Clinical release / Play publication | Not completed |

## Design principles

- Clear actions before technical detail. The guide is always easy to find.
- No ads or sale of health information as the prototype revenue strategy.
- Safety messages remain accessible without a paid plan.
- No artificial “health score”, guaranteed detection or improved accuracy claim.
- Familiar existing scan workflows retained, with a separate consumer shell.
- Native device authentication protects a local profile; the UI does not simulate a successful remote login.

The in-memory personalized session lasts until sign-out or process restart. It does not keep the medical vault unlocked: history has its own credential window and background lock. No network account, clinical identity verification or cross-device recovery is implied.
