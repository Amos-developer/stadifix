import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadifix_web/features/service_discovery/presentation/screens/home_screen.dart';

void main() {
  testWidgets('Home filters sample professionals and saves favorites', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.text('Nairobi'), findsWidgets);
    expect(find.text('Categories'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'James');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('James Mwangi'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('James Mwangi'), findsOneWidget);
    expect(find.text('David Otieno'), findsNothing);
    await tester.ensureVisible(find.byTooltip('Save James Mwangi'));
    await tester.tap(find.byTooltip('Save James Mwangi'));
    await tester.pump();
    expect(
      find.byTooltip('Remove James Mwangi from favorites'),
      findsOneWidget,
    );
    await tester.tap(find.text('James Mwangi'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Sample professional profile. Availability and bookings are not connected yet.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Home navigation exposes guest profile', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(
      find.text('Welcome to StadiFix. Sign in to manage your account.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
