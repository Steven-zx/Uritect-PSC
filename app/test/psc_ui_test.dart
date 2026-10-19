import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uritect_psc/config/theme.dart';
import 'package:uritect_psc/pages/root_page.dart';
import 'package:uritect_psc/psc/home.dart';
import 'package:uritect_psc/psc/session.dart';
import 'package:uritect_psc/psc/guide.dart';
import 'package:uritect_psc/psc/plans.dart';
import 'support/load_app_fonts.dart';
import 'package:flutter/services.dart';
import 'package:uritect_psc/main.dart';

class CanceledPscStore extends PscProfileStore {
  @override
  Future<bool> exists() async => false;
  @override
  Future<PscProfile> unlock() async =>
      throw PlatformException(code: 'CANCELED');
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  testWidgets('personal dashboard and help work at phone width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final session = PscSession(store: CanceledPscStore())
      ..ready = true
      ..profile = const PscProfile('Aser Test');
    await tester.pumpWidget(MyApp(sessionOverride: session));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Aser.'), findsOneWidget);
    expect(find.text('Scan a dipstick'), findsOneWidget);
    await expectLater(
      find.byType(PscHomePage),
      matchesGoldenFile('goldens/psc_dashboard.png'),
    );
    await tester.tap(find.byTooltip('How URITECT works'));
    await tester.pumpAndSettle();
    expect(find.text('Your URITECT guide'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'not_a_topic');
    await tester.pump();
    expect(find.textContaining('No matching topic'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Plus cannot create an entitlement or misleading purchase', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.lightTheme, home: const PscPlansPage()),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('About the Plus preview'), 300);
    await tester.tap(find.text('About the Plus preview'));
    await tester.pumpAndSettle();
    expect(find.text('Plus is not on sale yet'), findsOneWidget);
    expect(find.textContaining('No payment was taken'), findsOneWidget);
  });
  testWidgets('onboarding requires acknowledgment before guest exploration', (
    tester,
  ) async {
    final session = PscSession()..ready = true;
    await tester.pumpWidget(
      PscScope(
        session: session,
        child: MaterialApp(theme: AppTheme.lightTheme, home: const RootPage()),
      ),
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    final disabled = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Explore as a guest'),
    );
    expect(disabled.onPressed, null);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.tap(find.text('Explore as a guest'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, there.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('canceled sign-in stays on access screen', (tester) async {
    final session = PscSession(store: CanceledPscStore())..hasProfile = true;
    await tester.pumpWidget(
      PscScope(
        session: session,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const PscAccessPage(create: false),
        ),
      ),
    );
    await tester.tap(find.text('Sign in securely'));
    await tester.pumpAndSettle();
    expect(session.profile, null);
    expect(
      find.textContaining('Sign-in could not be completed'),
      findsOneWidget,
    );
  });
  testWidgets('guide remains readable with large text', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: PscGuidePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
