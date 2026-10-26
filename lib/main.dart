import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth_gate.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AutoMarketApp());
}

class AppTheme {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  static bool get isDark => mode.value == ThemeMode.dark;

  static void toggle() {
    mode.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}

class AutoMarketApp extends StatelessWidget {
  const AutoMarketApp({super.key});

  static const Color primaryOlive = Color(0xFF557128);
  static const Color accentLime = Color(0xFFB6D477);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'SecondHand',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryOlive,
              primary: primaryOlive,
              secondary: const Color(0xFF789449),
              primaryContainer: const Color(0xFFEAF0DF),
              onPrimaryContainer: const Color(0xFF1F2912),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF6F7F3),
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF6F7F3),
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE2E6DC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE2E6DC)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: primaryOlive, width: 1.8),
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: accentLime,
              primary: accentLime,
              onPrimary: const Color(0xFF1E2418),
              secondary: const Color(0xFF94B45B),
              primaryContainer: const Color(0xFF2B3422),
              onPrimaryContainer: const Color(0xFFDDF0B5),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF141712),
            cardColor: const Color(0xFF1E231B),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF141712),
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF1E231B),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF2E3629)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF2E3629)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: accentLime, width: 1.8),
              ),
            ),
          ),
          home: const AuthGate(),
        );
      },
    );
  }
}
