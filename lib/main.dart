import 'package:flutter/material.dart';

import 'login_page.dart';

void main() {
  runApp(const AutoMarketApp());
}

class AutoMarketApp extends StatelessWidget {
  const AutoMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AutoMarket',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF171717)),
      ),
      home: const LoginPage(),
    );
  }
}
