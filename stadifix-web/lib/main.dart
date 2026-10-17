import 'package:flutter/material.dart';

import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'features/service_discovery/presentation/screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'StadiFix',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0075FF)),
      scaffoldBackgroundColor: Colors.white,
    ),
    home: const SplashScreen(),
    routes: {'/home': (_) => const HomeScreen()},
  );
}
