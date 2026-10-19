import '../../../service_discovery/domain/models/professional.dart';

class BookingPreview {
  const BookingPreview({
    required this.professional,
    required this.date,
    required this.time,
    required this.service,
    required this.notes,
    required this.city,
  });

  final Professional professional;
  final DateTime date;
  final String time;
  final String service;
  final String notes;
  final String city;
}
