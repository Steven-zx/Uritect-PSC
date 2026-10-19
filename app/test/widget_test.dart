import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uritect_psc/main.dart';
import 'package:uritect_psc/pages/root_page.dart';
import 'package:uritect_psc/pages/app_splash_page.dart';
import 'package:uritect_psc/psc/home.dart';
import 'package:uritect_psc/psc/session.dart';

class EmptyPscStore extends PscProfileStore {
  @override
  Future<bool> exists() async => false;
}

void main() {
  testWidgets('PSC opens onboarding directly without a second splash', (
    tester,
  ) async {
    final session = PscSession(store: EmptyPscStore());
    await tester.pumpWidget(MyApp(sessionOverride: session));
    await tester.pumpAndSettle();
    expect(find.byType(AppSplashPage), findsNothing);
    expect(find.byType(PscWelcomePage), findsOneWidget);
    expect(find.byType(RootPage), findsOneWidget);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'disposing app during initialization does not notify dead listeners',
    (tester) async {
      await tester.pumpWidget(
        MyApp(sessionOverride: PscSession(store: EmptyPscStore())),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 3));
      expect(tester.takeException(), isNull);
    },
  );
}
