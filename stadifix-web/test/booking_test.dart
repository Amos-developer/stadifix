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
    expect(find.text('Booking Confirmed!'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('View Booking'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('View Booking'));
    await tester.pumpAndSettle();
    expect(find.text('Booking Details'), findsOneWidget);
    expect(find.textContaining('2:00 PM'), findsWidgets);
    expect(find.text('Fix the leaking kitchen sink.'), findsWidgets);
    expect(
      find.text(
        'Local preview only. No appointment has been submitted and no payment has been taken.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Booking Confirmed!'), findsNothing);
    expect(find.text('Fix the leaking kitchen sink.'), findsOneWidget);
  });
}
