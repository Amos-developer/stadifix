import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../authentication/presentation/screens/register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _blue = Color(0xFF0075FF);
  static const _slides = [
    (
      title: 'Get Quality\nHome Services',
      description: 'Connect with verified professionals\nin your area.',
    ),
    (
      title: 'Book With\nConfidence',
      description:
          'Choose the right professional and\na time that works for you.',
    ),
    (
      title: 'Your Home,\nIn Good Hands',
      description:
          'Let skilled professionals take care\nof your home service needs.',
    ),
  ];

  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _complete() {
    if (widget.onComplete case final callback?) {
      callback();
      return;
    }
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RegisterScreen()));
  }

  void _next() {
    if (_currentPage == _slides.length - 1) {
      _complete();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textScale = MediaQuery.textScalerOf(context).scale(1);
                final height = math.max(
                  constraints.maxHeight,
                  620.0 + math.max(0.0, textScale - 1) * 180,
                );
                return SingleChildScrollView(
                  child: SizedBox(
                    height: height,
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.095),
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _slides.length,
                            onPageChanged: (page) =>
                                setState(() => _currentPage = page),
                            itemBuilder: (context, page) {
                              final slide = _slides[page];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          slide.title,
                                          style: const TextStyle(
                                            fontSize: 29,
                                            height: 1.18,
                                            letterSpacing: -0.7,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF080D20),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          slide.description,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1.45,
                                            color: Color(0xFF596276),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Semantics(
                                    label:
                                        'Page ${page + 1} of ${_slides.length}',
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(_slides.length, (
                                        index,
                                      ) {
                                        return Container(
                                          width: 10,
                                          height: 10,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: page == index
                                                ? _blue
                                                : const Color(0xFFD7E6F5),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: Image.asset(
                                      'assets/images/onboarding_professional.png',
                                      fit: BoxFit.contain,
                                      alignment: Alignment.bottomCenter,
                                      semanticLabel: 'Friendly home service professional holding a tablet',
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              onPressed: _next,
                              style: FilledButton.styleFrom(
                                backgroundColor: _blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              child: Text(
                                _currentPage == _slides.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _complete,
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF080D20),
                            minimumSize: const Size(80, 48),
                          ),
                          child: const Text('Skip'),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
