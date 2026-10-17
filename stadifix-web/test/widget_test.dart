import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadifix_web/main.dart';

void main() {
  testWidgets('Splash shows entry actions', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Your Home\nOur Professionals'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Get Started'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Sign In'), findsOneWidget);
    await tester.tap(find.text('Get Started'));
    await tester.pump();
    expect(find.text('Registration is coming soon.'), findsOneWidget);
  });
}
