import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadifix_web/features/service_discovery/domain/models/professional.dart';
import 'package:stadifix_web/features/service_discovery/presentation/screens/provider_profile_screen.dart';

void main() {
  testWidgets('Profile saves favorites and previews the selected service', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final favorites = <String>{};
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderProfileScreen(
          professional: const Professional(
            name: 'James Mwangi',
            service: 'Plumbing',
            rating: 4.8,
            reviews: 120,
          ),
          favorites: favorites,
        ),
      ),
    );
    await tester.tap(find.byTooltip('Save professional'));
    await tester.pump();
    expect(favorites, contains('James Mwangi'));
    await tester.scrollUntilVisible(find.text('Pipe Repair'), 200);
    await tester.tap(find.text('Pipe Repair'));
    await tester.pump();
    await tester.tap(find.text('Book Now'));
    await tester.pumpAndSettle();
    expect(find.text('Book Service'), findsOneWidget);
    expect(find.text('Pipe Repair'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Message'));
    await tester.pumpAndSettle();
    expect(
      find.text('Messaging is coming soon. No message has been sent.'),
      findsOneWidget,
    );
  });
}
