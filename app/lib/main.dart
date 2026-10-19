import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/theme.dart';
import 'pages/root_page.dart';
import 'psc/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Fonts ship with the APK; startup must never fetch them over the network.
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final PscSession? sessionOverride;
  const MyApp({super.key, this.sessionOverride});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final session = widget.sessionOverride ?? PscSession();
  @override
  void initState() {
    super.initState();
    session.initialize();
  }

  @override
  void dispose() {
    session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PscScope(
      session: session,
      child: MaterialApp(
        title: 'Uritect PSC',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme.copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF087D73),
            secondary: Color(0xFFBEE8C8),
            surface: Color(0xFFF5F8F6),
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F8F6),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F8F6),
            foregroundColor: Color(0xFF153D38),
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFE3ECE7)),
            ),
          ),
        ),
        home: const RootPage(),
      ),
    );
  }
}
