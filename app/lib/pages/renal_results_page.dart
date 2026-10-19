import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/clinical_symptoms.dart';
import '../models/renal_followup.dart';
import '../models/scan_model.dart';

class RenalResultsPage extends StatelessWidget {
  final ScanResult scanResult;
  final ClinicalChecklistResult checklistResult;

  const RenalResultsPage({
    super.key,
    required this.scanResult,
    required this.checklistResult,
  });

  @override
  Widget build(BuildContext context) {
    final result = const RenalFollowupEngine().evaluate(
      scanResult: scanResult,
      checklist: checklistResult,
    );

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        backgroundColor: AppColors.bgMain,
        elevation: 0,
        foregroundColor: AppColors.primaryMain,
        title: const Text(
          'Protein & Blood Follow-up',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Follow-up for protein, blood and warning symptoms, alongside UTI screening.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              _actionPanel(context, result),
              if (result.triggeredRules.any(
                (rule) => rule.action != RenalAction.observe,
              )) ...[
                const SizedBox(height: 14),
                _sectionTitle(context, 'Why this follow-up?'),
                const SizedBox(height: 8),
                _reasonPanel(context, result),
              ],
              const SizedBox(height: 14),
              _sectionTitle(context, 'Results Considered'),
              const SizedBox(height: 8),
              _evidencePanel(context, result),
              const SizedBox(height: 14),
              _limitationsPanel(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reasonPanel(BuildContext context, RenalFollowupResult result) {
    final reasons =
        result.triggeredRules
            .where((rule) => rule.action != RenalAction.observe)
            .toList()
          ..sort((a, b) => b.action.priority.compareTo(a.action.priority));
    final explanations = reasons.map((rule) => rule.explanation).toSet();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final explanation in explanations)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(explanation),
            ),
          if (result.finalAction == RenalAction.consult ||
              result.finalAction == RenalAction.repeatConfirm) ...[
            if (result.proteinReliable &&
                reasons.any(
                  (rule) =>
                      rule.id.startsWith('PRO-') ||
                      rule.id == 'COMB-01' ||
                      rule.id == 'COMB-02',
                ))
              const Text(
                'A healthcare professional may arrange quantitative urine protein testing, such as an albumin-to-creatinine ratio (ACR) or protein-to-creatinine ratio (PCR).',
              ),
            if (result.bloodReliable &&
                reasons.any(
                  (rule) => rule.id.startsWith('BLD-') || rule.id == 'COMB-01',
                ))
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'A laboratory urine test with microscopy can assess a dipstick blood finding. The strip alone does not confirm blood cells in urine.',
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _actionPanel(BuildContext context, RenalFollowupResult result) {
    final color = _actionColor(result.finalAction);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_actionIcon(result.finalAction), color: color, size: 25),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  result.finalAction.heading,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          if (result.finalAction == RenalAction.retake &&
              result.triggeredRules.any(
                (r) =>
                    r.action == RenalAction.consult ||
                    r.action == RenalAction.promptConsult,
              ))
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'A reported symptom or finding also needs professional review. Retaking a photo does not replace medical advice.',
              ),
            ),
          const SizedBox(height: 9),
          Text(
            result.finalAction == RenalAction.retake
                ? 'Unable to interpret the kidney-related readings reliably. Please repeat the scan. Seek medical advice for concerning symptoms.'
                : result.finalAction.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _evidencePanel(BuildContext context, RenalFollowupResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _evidenceRow(
            context,
            'Inputs',
            result.proteinReliable && result.bloodReliable
                ? 'Available for follow-up'
                : 'Repeat needed for strip readings',
          ),
          _evidenceRow(
            context,
            'Protein',
            result.proteinReliable
                ? result.proteinCategory
                : 'Unable to confirm',
          ),
          _evidenceRow(
            context,
            'Blood',
            result.bloodReliable ? result.bloodCategory : 'Unable to confirm',
          ),
        ],
      ),
    );
  }

  Widget _evidenceRow(
    BuildContext context,
    String label,
    String value, {
    bool last = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _limitationsPanel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF2C36B)),
      ),
      child: Text(
        'Follow-up guidance, not a kidney diagnosis. A negative strip does not rule out kidney disease. These rules are not clinically validated as a prediction model.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF704600),
          fontSize: 11.5,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.primaryMain,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }

  Color _actionColor(RenalAction action) => switch (action) {
    RenalAction.promptConsult => AppColors.statusHigh,
    RenalAction.retake => const Color(0xFFB36B00),
    RenalAction.consult => const Color(0xFFB36B00),
    RenalAction.repeatConfirm => AppColors.primaryMain,
    RenalAction.observe => AppColors.statusLow,
  };

  IconData _actionIcon(RenalAction action) => switch (action) {
    RenalAction.promptConsult => Icons.emergency_rounded,
    RenalAction.retake => Icons.replay_rounded,
    RenalAction.consult => Icons.medical_services_outlined,
    RenalAction.repeatConfirm => Icons.biotech_outlined,
    RenalAction.observe => Icons.visibility_outlined,
  };
}
