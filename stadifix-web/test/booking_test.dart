import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadifix_web/features/booking/presentation/screens/booking_screen.dart';
import 'package:stadifix_web/features/service_discovery/domain/models/professional.dart';

void main() {
  testWidgets('Booking carries selected time, service, and notes into review', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: BookingScreen(
          professional: Professional(
            name: 'James Mwangi',
            service: 'Plumbing',
            rating: 4.8,
            reviews: 120,
          ),
          service: 'Pipe Repair',
        ),
      ),
    );
    expect(find.text('Book Service'), findsOneWidget);
    await tester.tap(find.text('2:00 PM'));
    await tester.enterText(
      find.byType(TextField),
      'Fix the leaking kitchen sink.',
    );
    await tester.scrollUntilVisible(
      find.text('Confirm Booking'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Confirm Booking'));
    await tester.pumpAndSettle();
    expect(find.text('Review your booking'), findsOneWidget);
    expect(find.textContaining('2:00 PM'), findsWidgets);
    expect(find.text('Fix the leaking kitchen sink.'), findsWidgets);
    expect(
      find.text(
        'Preview only. No booking has been created and no payment has been taken.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Continue editing'));
    await tester.pumpAndSettle();
    expect(find.text('Review your booking'), findsNothing);
    expect(find.text('Fix the leaking kitchen sink.'), findsOneWidget);
  });
}
