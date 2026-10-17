import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadifix_web/main.dart';

void main() {
  testWidgets('Splash shows entry actions', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    expect(find.text('Your Home\nOur Professionals'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Get Started'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Sign In'), findsOneWidget);
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Get Quality\nHome Services'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Book With\nConfidence'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Create Account'), findsOneWidget);
  });
}
