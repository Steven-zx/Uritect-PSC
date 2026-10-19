import 'package:flutter/material.dart';

class GuideTopic {
  final String title, summary, body;
  final IconData icon;
  const GuideTopic(this.title, this.summary, this.body, this.icon);
}

const guideTopics = [
  GuideTopic(
    'Start here',
    'What URITECT can help you do',
    'URITECT PSC is an early consumer prototype built from the URITECT research project. It reads supported ten-pad strip photos on your phone, then uses a checklist to provide screening-support information. It does not diagnose UTI or kidney disease. The existing classifier and clinical estimates are research components; public-release clinical performance has not been established.',
    Icons.auto_awesome_outlined,
  ),
  GuideTopic(
    'Prepare your strip',
    'The strip, lighting and timing matter',
    'Use the supported URS-10T profile and follow your exact bottle instructions for collection, dipping and each pad’s reading time. Check expiry and storage. Keep the entire strip, including the plain handle, visible against a plain neutral background. Avoid glare and strong shadows. Different pads can require different reading times; one late photo does not establish correct timing for every result. If you cannot verify the product or timing, do not rely on the readings.',
    Icons.science_outlined,
  ),
  GuideTopic(
    'Take a clear photo',
    'Camera, gallery and the alignment grid',
    'Open Scan and place one full strip in view. Tap the pads to focus. Grid toggles a visual alignment aid; it does not validate pad detection. Light changes the camera light and Gallery selects an existing photo. Check the preview before submitting. An imported or repeated photo does not establish a fresh specimen. Enter an optional name and answer the timing and specimen questions honestly.',
    Icons.camera_alt_outlined,
  ),
  GuideTopic(
    'Understand your results',
    'Readings, retakes and the checklist',
    'The boxes show sampled regions, not proof that a reading is accurate. A result is a semiquantitative strip category, not a diagnosis. Unusable images require a new scan. Available readings can still fail confidence or evidence checks. Complete the checklist to see whether a provisional UTI estimate can be calculated. Eligibility, symptoms, reliable required pads and specimen context determine whether an estimate is available. A low estimate does not rule out illness.',
    Icons.fact_check_outlined,
  ),
  GuideTopic(
    'Protein & blood follow-up',
    'A separate next-action pathway',
    'Protein and blood findings and reported symptoms can trigger repeat-testing or consultation guidance alongside the UTI estimate. This is a separate rule-based pathway, not a kidney-disease probability or kidney-function test. A healthcare professional decides what confirmation is appropriate. The strip alone does not confirm urinary blood cells or chronic kidney disease.',
    Icons.medical_services_outlined,
  ),
  GuideTopic(
    'History & your privacy',
    'Your records stay on this phone',
    'Saved results, checklist answers and saved photos use the inherited encrypted local vault. Device authentication protects access to saved history. Your PSC profile is also encrypted and protected by your phone’s screen lock. This prototype has no cloud account or synchronization, no advertising SDK and no payment processing. Signing out keeps saved files. Deleting a scan in History removes its app record; gallery originals remain outside URITECT. Do not clear app data or change the device lock as a recovery method.',
    Icons.lock_outline,
  ),
  GuideTopic(
    'When to seek care',
    'Use symptoms, not just a photo result',
    'Do not delay professional care while trying to get an app result. Follow the app’s safety prompts and seek professional assessment for concerning or worsening symptoms, even when a scan fails or no estimate is available. If you feel severely unwell, seek urgent medical assistance. URITECT does not prescribe antibiotics or replace laboratory testing.',
    Icons.health_and_safety_outlined,
  ),
  GuideTopic(
    'About this project',
    'Research foundation and PSC direction',
    'The PSC edition is a separate Android project derived from the URITECT thesis app. It retains offline photo analysis, the corrected tip-to-handle order (LEU, NIT, URO, PRO, pH, BLD, SG, KET, BIL, GLU), reliability checks, provisional UTI estimates and protected history. Consumer onboarding, a personal device profile and a Free/Plus product concept are new. Plus features are proposals, not active subscriptions. Store publication, clinical validation, cloud identity and live billing are not completed by this preview.',
    Icons.info_outline,
  ),
];

class PscGuidePage extends StatefulWidget {
  const PscGuidePage({super.key});
  @override
  State<PscGuidePage> createState() => _PscGuidePageState();
}

class _PscGuidePageState extends State<PscGuidePage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final topics = guideTopics.where(
      (t) => '${t.title} ${t.summary} ${t.body}'.toLowerCase().contains(
        query.toLowerCase(),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Your URITECT guide')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'A little guidance.\nA lot more clarity.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          const Text(
            'Preparation, scanning, results and privacy — all available offline.',
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search the guide',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (topics.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No matching topic. Try “timing”, “history” or “results”.',
              ),
            ),
          for (final topic in topics)
            Card(
              child: ExpansionTile(
                key: ValueKey(topic.title),
                leading: Icon(topic.icon),
                title: Text(topic.title),
                subtitle: Text(topic.summary),
                childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [Text(topic.body)],
              ),
            ),
        ],
      ),
    );
  }
}
