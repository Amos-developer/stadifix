import 'package:flutter/foundation.dart';

import '../../service_discovery/domain/models/professional.dart';
import '../domain/models/booking_preview.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }

class BookingEntry {
  const BookingEntry({
    required this.id,
    required this.booking,
    required this.status,
  });
  final int id;
  final BookingPreview booking;
  final BookingStatus status;
}

class BookingHistory extends ChangeNotifier {
  BookingHistory();

  static final instance = BookingHistory().._seed();
  final List<BookingEntry> _entries = [];
  int _nextId = 0;
  List<BookingEntry> get entries => List.unmodifiable(_entries);

  void _seed() {
    final now = DateTime.now();
    for (final item in [
      (
        name: 'James Mwangi',
        service: 'Plumbing',
        days: 1,
        status: BookingStatus.pending,
        rate: 500,
      ),
      (
        name: 'Grace Wanjiku',
        service: 'Cleaning',
        days: 3,
        status: BookingStatus.confirmed,
        rate: 600,
      ),
      (
        name: 'Peter Otieno',
        service: 'Plumbing',
        days: -4,
        status: BookingStatus.completed,
        rate: 450,
      ),
    ]) {
      _entries.add(
        BookingEntry(
          id: _nextId++,
          status: item.status,
          booking: BookingPreview(
            professional: Professional(
              name: item.name,
              service: item.service,
              rating: 4.8,
              reviews: 85,
              hourlyRate: item.rate,
            ),
            date: DateTime(now.year, now.month, now.day + item.days),
            time: item.days == 3 ? '9:00 AM' : '11:00 AM',
            service: item.service,
            notes: '',
            city: 'Nairobi',
          ),
        ),
      );
    }
  }

  void add(BookingPreview booking) {
    _entries.insert(
      0,
      BookingEntry(
        id: _nextId++,
        booking: booking,
        status: BookingStatus.pending,
      ),
    );
    notifyListeners();
  }

  void cancel(int id) {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index < 0) return;
    final entry = _entries[index];
    _entries[index] = BookingEntry(
      id: id,
      booking: entry.booking,
      status: BookingStatus.cancelled,
    );
    notifyListeners();
  }

  void reschedule(int id, DateTime date, String time) {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index < 0) return;
    final old = _entries[index].booking;
    _entries[index] = BookingEntry(
      id: id,
      status: BookingStatus.pending,
      booking: BookingPreview(
        professional: old.professional,
        date: date,
        time: time,
        service: old.service,
        notes: old.notes,
        city: old.city,
      ),
    );
    notifyListeners();
  }
}
