
import 'package:flutter/material.dart';
import 'auth_gate.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _controller.forward().then((_) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) =>
              const AuthGate(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildLogo(double progress, double screenWidth) {
    final shift = Curves.easeOutCubic.transform(
      ((progress - 0.10) / 0.45).clamp(0.0, 1.0),
    );

    final textOpacity = Curves.easeIn.transform(
      ((progress - 0.35) / 0.30).clamp(0.0, 1.0),
    );

    final logoWidth =
        (screenWidth * 0.82).clamp(300.0, 650.0);

    final sWidth = logoWidth * 0.19;
    final textWidth = logoWidth * 0.76;

    return SizedBox(
      width: logoWidth,
      height: 115,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.translate(
            offset: Offset(180 * (1 - shift), 0),
            child: SizedBox(
              width: sWidth,
              height: 90,
              child: Image.asset(
                'assets/images/logo_s.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Opacity(
            opacity: textOpacity,
            child: Transform.translate(
              offset: Offset(35 * (1 - textOpacity), 0),
              child: SizedBox(
                width: textWidth,
                height: 90,
                child: Image.asset(
                  'assets/images/logo_text.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF080B10),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = _controller.value;

            final taglineOpacity = Curves.easeIn.transform(
              ((progress - 0.70) / 0.25).clamp(0.0, 1.0),
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLogo(progress, screenWidth),

                const SizedBox(height: 12),

                Opacity(
                  opacity: taglineOpacity,
                  child: const Text(
                    'DRIVE BETTER, BUY SMARTER.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFD6B76A),
                      fontSize: 14,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
