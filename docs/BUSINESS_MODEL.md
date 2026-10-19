# Business model hypothesis

This is a competition planning model, not evidence of customer demand, actual fees, committed partners or financial profitability. Amounts are illustrative Philippine pesos. Validate willingness to pay and actual operating costs before a commercial offer.

## Free + optional convenience

Free: scan workflow, instructions, safety guidance, current research interpretation and encrypted local history.

Proposed Plus: PHP 99/month for optional reminders, useful visit-summary exports and richer result organization. These convenience features and subscriptions are **not implemented** in this prototype. They must not gate warning messages, create more confident medical estimates, or imply improved clinical reliability.

Potential later channel: licensed organizational workflow tools for clinics and screening programs, after validating the workflow and commercial/data-processing agreements. No organization is represented as a customer or partner today. Physical-strip sales would be a distinct supply business with procurement, product and distribution requirements; no strip-store or clinical-service checkout is implemented.

## Illustrative unit economics

| Assumption per paying user/month | PHP |
|---|---:|
| Subscription revenue | 99.00 |
| Assumed platform/payment allowance (15%, not a verified applicable fee) | -14.85 |
| Infrastructure allowance | -8.00 |
| Support allowance | -7.00 |
| Illustrative tax reserve (10%, not tax advice or an applicable rate claim) | -9.90 |
| Acquisition reserve | -5.00 |
| Contribution before fixed costs | **54.25** |

With an assumed PHP 8,000/month fixed operating cost, break-even is `ceil(8000/54.25) = 148` paying subscribers. This excludes development capital, clinical studies, regulatory expenses, refunds, churn and other unmodeled costs.

| Scenario | Paid users | Contribution less PHP 8,000 fixed costs |
|---|---:|---:|
| 1,000 active users, 5% paid | 50 | -PHP 5,287.50 |
| 1,000 active users, 10% paid | 100 | -PHP 2,575.00 |
| 2,000 active users, 10% paid | 200 | PHP 2,850.00 |

None of the conversion assumptions is observed traction. Track activation, successful/retake scans, retention, paid conversion, support load and churn using consented, minimized measures; do not upload images or health findings for revenue analytics by default.

## Billing implementation boundary

Use current [Google Play Payments policy](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en) to determine the permitted billing integration for digital subscriptions in the target market. The planned implementation needs Play Console products, server-side purchase verification, account/entitlement linkage, cancellation/refund/expiry handling and restore purchases. Client-side UI state must never be a purchase receipt. Regulated clinical services and physical goods need their own applicable checkout policy analysis.

Policy sources checked 2026-10-20. No payment SDK, fake purchase button or paid entitlement is enabled here.
