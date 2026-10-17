import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.onGetStarted, this.onSignIn});

  final VoidCallback? onGetStarted;
  final VoidCallback? onSignIn;

  void _notify(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/splash_home.png', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xF5EFF6FF),
                Color(0xCFF6FAFF),
                Color(0x00FFFFFF),
                Color(0xF0FFFFFF),
                Colors.white,
              ],
              stops: [0, 0.28, 0.48, 0.73, 0.9],
            ),
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 460),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: constraints.maxHeight * 0.12),
                            const Center(
                              child: SizedBox(
                                width: 76,
                                height: 70,
                                child: CustomPaint(painter: _LogoPainter()),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Stadi',
                                    style: TextStyle(color: Color(0xFF080D20)),
                                  ),
                                  TextSpan(
                                    text: 'Fix',
                                    style: TextStyle(color: Color(0xFF0075FF)),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.5,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(height: 100),
                            const Text(
                              'Your Home\nOur Professionals',
                              style: TextStyle(
                                fontSize: 30,
                                height: 1.15,
                                letterSpacing: -0.8,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF080D20),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Find trusted professionals for\nall your home service needs.',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Color(0xFF454B60),
                              ),
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed:
                                    onGetStarted ??
                                    () => Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) =>
                                            const OnboardingScreen(),
                                      ),
                                    ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF0075FF),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                                child: const Text(
                                  'Get Started',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  child: Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF73798A),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      onSignIn ??
                                      () => _notify(
                                        context,
                                        'Sign in is coming soon.',
                                      ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Color(0xFF0075FF),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 82, size.height / 74);
    final paint = Paint()
      ..color = const Color(0xFF0075FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(10, 61)
        ..lineTo(10, 35)
        ..lineTo(41, 9)
        ..lineTo(72, 35)
        ..lineTo(72, 61),
      paint,
    );
    canvas.drawLine(const Offset(61, 14), const Offset(61, 25), paint);
    canvas.drawPath(
      Path()
        ..moveTo(25, 60)
        ..lineTo(25, 48)
        ..lineTo(41, 35)
        ..lineTo(68, 57),
      paint,
    );
    canvas.drawCircle(const Offset(41, 63), 4, Paint()..color = paint.color);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => false;
}
