import 'package:flutter/material.dart';

import 'home_page.dart';
import '../psc/session.dart';
import '../psc/home.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PscScope.maybeOf(context) == null
        ? const HomePage()
        : const PscEntryPage();
  }
}
