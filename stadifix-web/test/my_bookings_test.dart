import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stadifix_web/features/booking/data/booking_history.dart';
import 'package:stadifix_web/features/booking/domain/models/booking_preview.dart';
import 'package:stadifix_web/features/booking/presentation/screens/my_bookings_screen.dart';
import 'package:stadifix_web/features/service_discovery/domain/models/professional.dart';

void main() {
  testWidgets('Cancelled previews move from Upcoming to Past', (tester) async {
    final history = BookingHistory();
    addTearDown(history.dispose);
    history.add(
      BookingPreview(
        professional: const Professional(
          name: 'James Mwangi',
          service: 'Plumbing',
          rating: 4.8,
          reviews: 120,
        ),
        date: DateTime.now().add(const Duration(days: 2)),
        time: '11:00 AM',
        service: 'Pipe Repair',
        notes: 'Kitchen sink',
        city: 'Nairobi',
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MyBookingsScreen(history: history)),
      ),
    );
    expect(find.text('Pending'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel Booking'));
    await tester.pumpAndSettle();
    expect(find.text('No upcoming bookings'), findsOneWidget);
    await tester.tap(find.text('Past'));
    await tester.pumpAndSettle();
    expect(find.text('Cancelled'), findsOneWidget);
    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();
    expect(find.text('Booking Details'), findsOneWidget);
    expect(find.text('Kitchen sink'), findsOneWidget);
  });

  test('Rescheduling preserves notes and changes status to pending', () {
    final history = BookingHistory();
    addTearDown(history.dispose);
    history.add(
      BookingPreview(
        professional: const Professional(
          name: 'James Mwangi',
          service: 'Plumbing',
          rating: 4.8,
          reviews: 120,
        ),
        date: DateTime(2026, 10, 20),
        time: '11:00 AM',
        service: 'Pipe Repair',
        notes: 'Kitchen sink',
        city: 'Nairobi',
      ),
    );
    history.reschedule(
      history.entries.single.id,
      DateTime(2026, 10, 22),
      '2:00 PM',
    );
    expect(history.entries.single.booking.date, DateTime(2026, 10, 22));
    expect(history.entries.single.booking.notes, 'Kitchen sink');
    expect(history.entries.single.booking.time, '2:00 PM');
  });
}
