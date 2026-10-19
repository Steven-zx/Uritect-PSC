import 'package:flutter/material.dart';
import '../pages/capture_dipstick_page.dart';
import '../services/history_cipher.dart';
import 'session.dart';
import 'guide.dart';
import 'plans.dart';
import 'history.dart';

const pscInk = Color(0xFF153D38);
const pscGreen = Color(0xFF087D73);
const pscMint = Color(0xFFE0F5ED);

class PscEntryPage extends StatelessWidget {
  const PscEntryPage({super.key});
  @override
  Widget build(BuildContext context) {
    final session = PscScope.of(context);
    if (!session.ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (session.startupError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(session.startupError!),
                FilledButton(
                  onPressed: session.initialize,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return session.profile != null || session.guest
        ? const PscHomePage()
        : const PscWelcomePage();
  }
}

class PscWelcomePage extends StatefulWidget {
  const PscWelcomePage({super.key});
  @override
  State<PscWelcomePage> createState() => _PscWelcomePageState();
}

class _PscWelcomePageState extends State<PscWelcomePage> {
  int page = 0;
  bool acknowledged = false;
  final controller = PageController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = PscScope.of(context);
    const slides = [
      (
        'A clearer picture.\nA better next step.',
        'Your strip photo, useful guidance and a private record — together on your phone.',
        Icons.center_focus_strong,
      ),
      (
        'Understand the process.\nOne step at a time.',
        'Get preparation tips, photograph the full strip, then review your readings and checklist.',
        Icons.auto_stories_outlined,
      ),
      (
        'Made for your privacy.\nBuilt with care.',
        'Photo analysis works offline. Your device lock protects saved records. You control what you keep.',
        Icons.lock_outline,
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F6),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'URITECT',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: pscInk,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const PscGuidePage(),
                          ),
                        ),
                        child: const Text('How it works'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: (v) => setState(() => page = v),
                    children: [
                      for (final slide in slides)
                        SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 190,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: pscMint,
                                  borderRadius: BorderRadius.circular(34),
                                ),
                                child: Icon(
                                  slide.$3,
                                  size: 94,
                                  color: pscGreen,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                slide.$1,
                                style: const TextStyle(
                                  fontSize: 29,
                                  height: 1.22,
                                  fontWeight: FontWeight.w700,
                                  color: pscInk,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                slide.$2,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.all(4),
                            width: page == i ? 24 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: page == i
                                  ? pscGreen
                                  : const Color(0xFFCAD9D3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      if (page < 2) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => controller.nextPage(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                            ),
                            child: const Text('Continue'),
                          ),
                        ),
                      ] else ...[
                        CheckboxListTile(
                          value: acknowledged,
                          onChanged: (v) =>
                              setState(() => acknowledged = v ?? false),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                            'I understand this is an early prototype, not a diagnosis.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: acknowledged
                                ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) => PscAccessPage(
                                        create: !session.hasProfile,
                                      ),
                                    ),
                                  )
                                : null,
                            icon: const Icon(Icons.lock_outline),
                            label: Text(
                              session.hasProfile
                                  ? 'Sign in with device lock'
                                  : 'Create my device profile',
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: acknowledged
                              ? session.continueAsGuest
                              : null,
                          child: const Text('Explore as a guest'),
                        ),
                      ],
                      const SizedBox(height: 12),
                      const Text(
                        'PSC PREVIEW · SCREENING SUPPORT',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.4,
                          color: Color(0xFF637B73),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PscAccessPage extends StatefulWidget {
  final bool create;
  const PscAccessPage({super.key, required this.create});
  @override
  State<PscAccessPage> createState() => _PscAccessPageState();
}

class _PscAccessPageState extends State<PscAccessPage> {
  final name = TextEditingController();
  final form = GlobalKey<FormState>();
  bool busy = false;
  String? error;
  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (busy || !(form.currentState?.validate() ?? false)) return;
    final session = PscScope.of(context);
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (widget.create) {
        await session.create(name.text);
      } else {
        await session.signIn();
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(
          () => error =
              'Sign-in could not be completed. Use your phone’s PIN, pattern or password and try again. Your saved files were preserved.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.create ? 'Make it yours' : 'Welcome back'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.fingerprint, size: 64, color: pscGreen),
            const SizedBox(height: 24),
            Text(
              widget.create
                  ? 'Hello starts with\nyour name.'
                  : 'Your phone.\nYour private space.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 18),
            const Text(
              'This preview uses one encrypted profile on this phone. Sign in with your device screen lock. No email, password or cloud account is created.',
            ),
            const SizedBox(height: 24),
            if (widget.create)
              TextFormField(
                controller: name,
                maxLength: 60,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.givenName],
                decoration: const InputDecoration(
                  labelText: 'What should we call you?',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  try {
                    PscProfile.validate(v ?? '');
                    return null;
                  } catch (_) {
                    return 'Enter a name between 1 and 60 characters.';
                  }
                },
              ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: busy ? null : submit,
                icon: busy
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.lock_open),
                label: Text(
                  busy
                      ? 'Securing your profile…'
                      : widget.create
                      ? 'Create profile securely'
                      : 'Sign in securely',
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Set a screen lock in Android settings first. A canceled authentication leaves the profile locked. History is separately protected when you open it.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}

class PscHomePage extends StatefulWidget {
  const PscHomePage({super.key});
  @override
  State<PscHomePage> createState() => _PscHomePageState();
}

class _PscHomePageState extends State<PscHomePage> {
  int tab = 0;
  void openGuide() => Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (_) => const PscGuidePage()),
  );
  @override
  Widget build(BuildContext context) {
    final session = PscScope.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F6),
      body: SafeArea(
        child: IndexedStack(
          index: tab,
          children: [
            _dashboard(context, session),
            const PscGuidePage(),
            const PscPlansPage(),
            _profile(context, session),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.workspace_premium_outlined),
            label: 'Plus',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _dashboard(BuildContext context, PscSession session) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Row(
            children: [
              const Text(
                'URITECT',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                  letterSpacing: 2,
                  color: pscInk,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'How URITECT works',
                onPressed: openGuide,
                icon: const Icon(Icons.help_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            'Hello, ${session.greeting}.',
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w700,
              color: pscInk,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Take your next step with a little more clarity.',
            style: TextStyle(color: Color(0xFF637B73)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFF124E43), Color(0xFF087D73)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.offline_bolt_outlined,
                      color: Color(0xFFBEF7D6),
                      size: 17,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'ON-DEVICE PHOTO ANALYSIS',
                      style: TextStyle(
                        color: Color(0xFFBEF7D6),
                        letterSpacing: 1,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Your dipstick.\nMade clearer.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          height: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 18),
                    SizedBox(
                      width: 62,
                      height: 132,
                      child: CustomPaint(painter: _StripPainter()),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'One full strip. Good lighting.\nFollow the reading times on your bottle.',
                  style: TextStyle(color: Color(0xFFD9EFE7), fontSize: 13),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD8F9CE),
                      foregroundColor: pscInk,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const CaptureDipstickPage(),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Scan a dipstick'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6E5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Color(0xFF875B16), size: 19),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Early prototype. Readings and estimates need professional confirmation. Do not delay care for symptoms.',
                    style: TextStyle(color: Color(0xFF715327), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'A good place to start',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          _tile(
            Icons.auto_stories_outlined,
            'Get your first scan right',
            'Preparation, photos and reading times',
            openGuide,
          ),
          _tile(
            Icons.history_rounded,
            'Your saved scans',
            'Open your encrypted local history',
            () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const PscHistoryPage()),
            ),
          ),
          _tile(
            Icons.workspace_premium_outlined,
            'Meet the Plus concept',
            'A look at our planned convenience features',
            () => setState(() => tab = 2),
          ),
          const SizedBox(height: 10),
          const Text(
            'Private by design · No cloud upload in this preview',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Color(0xFF637B73)),
          ),
        ],
      ),
    ),
  );
  Widget _tile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      leading: Icon(icon, color: pscGreen),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
  Widget _profile(BuildContext context, PscSession session) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      const SizedBox(height: 18),
      Text('Your space', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 24),
      const CircleAvatar(
        radius: 40,
        backgroundColor: pscMint,
        child: Icon(Icons.person_outline, size: 40, color: pscGreen),
      ),
      const SizedBox(height: 16),
      Text(
        session.profile?.name ?? 'Guest explorer',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 8),
      Text(
        session.profile != null
            ? 'Device-secured profile · Free'
            : 'No profile or cloud account',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 28),
      if (session.profile == null)
        _tile(
          Icons.lock_outline,
          session.hasProfile ? 'Sign in' : 'Create a device profile',
          'Use this phone’s screen lock',
          () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => PscAccessPage(create: !session.hasProfile),
            ),
          ),
        ),
      _tile(
        Icons.lock_outline,
        'Privacy & saved records',
        'Local encryption and device authentication',
        () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const PscGuidePage()),
        ),
      ),
      _tile(
        Icons.info_outline,
        'About URITECT PSC',
        'Version 0.1.0 · Competition preview',
        openGuide,
      ),
      const SizedBox(height: 20),
      const Text(
        'One device profile per installation. Signing out keeps your encrypted records. This is not a verified cloud identity or a clinical account.',
        style: TextStyle(fontSize: 12),
      ),
      const SizedBox(height: 20),
      OutlinedButton(
        onPressed: () async {
          try {
            await session.signOut();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(historyAccessMessage(e))));
            }
          }
        },
        child: Text(session.profile == null ? 'Leave guest mode' : 'Sign out'),
      ),
    ],
  );
}

class _StripPainter extends CustomPainter {
  const _StripPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFF5F4DF);
    final left = size.width * .34;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 2, size.width * .34, size.height - 4),
        const Radius.circular(4),
      ),
      paint,
    );
    const colors = [
      Color(0xFFDCD8BD),
      Color(0xFFF3E4C1),
      Color(0xFFE8B07C),
      Color(0xFFE1CC68),
      Color(0xFFD7BA61),
      Color(0xFFD4B45E),
      Color(0xFFA8B771),
      Color(0xFFDCBEAE),
      Color(0xFFE9D9AD),
      Color(0xFF73BBA1),
    ];
    for (var i = 0; i < 10; i++) {
      paint.color = colors[i];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left + 3, 6 + i * 9.0, size.width * .34 - 6, 7),
          const Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
