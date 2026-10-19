import 'package:flutter/material.dart';

class PscPlansPage extends StatelessWidget {
  const PscPlansPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('URITECT Plus')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Chip(label: Text('PRODUCT CONCEPT · NO PAYMENTS')),
        const SizedBox(height: 12),
        Text(
          'Everyday clarity.\nRoom to grow.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        const Text(
          'Core guidance and safety messages stay free. Paid convenience features are planned for a future release.',
        ),
        const SizedBox(height: 24),
        _plan(context, 'Free', 'Included in this prototype', [
          'Camera and gallery scan workflow',
          'Offline instructions and safety checklist',
          'Encrypted local history with device authentication',
        ]),
        const SizedBox(height: 16),
        _plan(context, 'Plus', 'Proposed: PHP 99 / month', [
          'Planned: personal reminder schedules',
          'Planned: readable visit-summary exports',
          'Planned: longer-term result organization',
        ]),
        const SizedBox(height: 16),
        const Text(
          'The price is a competition hypothesis, not an offer or a charge. These Plus features are not enabled in this build. No plan changes the classifier, medical reliability or safety advice.',
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (c) => AlertDialog(
              title: const Text('Plus is not on sale yet'),
              content: const Text(
                'No payment was taken and no subscription was created. We are validating this product concept before connecting a billing service.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c),
                  child: const Text('Got it'),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.info_outline),
          label: const Text('About the Plus preview'),
        ),
      ],
    ),
  );
  Widget _plan(
    BuildContext context,
    String name,
    String price,
    List<String> items,
  ) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.headlineSmall),
          Text(price, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
