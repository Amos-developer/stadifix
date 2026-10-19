import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/booking_preview.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key, required this.booking});

  final BookingPreview booking;
  static const _blue = Color(0xFF0075FF);
  static const _ink = Color(0xFF101B35);
  static const _muted = Color(0xFF758096);

  Widget _row(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF39465E)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: _ink, height: 1.4),
          ),
        ),
      ],
    ),
  );

  Widget _summary(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFEDF0F6)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x050F294F),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 58,
                height: 62,
                child: booking.professional.name == 'James Mwangi'
                    ? Image.asset(
                        'assets/images/home_professional.png',
                        fit: BoxFit.cover,
                        alignment: const Alignment(0.8, -0.6),
                      )
                    : const ColoredBox(
                        color: Color(0xFFEAF3FF),
                        child: Icon(
                          Icons.person_outline,
                          color: _blue,
                          size: 30,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.professional.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.professional.role,
                    style: const TextStyle(fontSize: 13, color: _muted),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _row(
          Icons.calendar_today_outlined,
          MaterialLocalizations.of(context).formatFullDate(booking.date),
        ),
        _row(Icons.access_time_rounded, booking.time),
        _row(Icons.location_on_outlined, booking.city),
        _row(Icons.home_repair_service_outlined, booking.service),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1, color: Color(0xFFEDF0F6)),
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Estimated Price',
                style: TextStyle(fontSize: 13, color: _muted),
              ),
            ),
            Text(
              'KSh ${booking.professional.hourlyRate}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  void _viewBooking(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 16),
              _summary(context),
              if (booking.notes.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'Service notes',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(booking.notes),
              ],
              const SizedBox(height: 20),
              const Text(
                'Local preview only. No appointment has been submitted and no payment has been taken.',
                style: TextStyle(fontSize: 12, color: _muted, height: 1.5),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context) async {
    final date = MaterialLocalizations.of(context).formatFullDate(booking.date);
    await Clipboard.setData(
      ClipboardData(
        text:
            'StadiFix booking preview\n${booking.professional.name} · ${booking.service}\n$date · ${booking.time}\n${booking.city}\nEstimated KSh ${booking.professional.hourlyRate}\nLocal preview only — no appointment has been submitted.',
      ),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Booking details copied.')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFAFCFF),
    appBar: AppBar(
      backgroundColor: const Color(0xFFFAFCFF),
      surfaceTintColor: Colors.transparent,
      actions: [
        IconButton(
          tooltip: 'Copy booking details',
          onPressed: () => _copy(context),
          icon: const Icon(Icons.ios_share_rounded, size: 21),
        ),
        const SizedBox(width: 12),
      ],
    ),
    body: SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
            children: [
              const Center(
                child: SizedBox(
                  width: 230,
                  height: 160,
                  child: _SuccessArtwork(),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Booking Confirmed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  letterSpacing: -0.6,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your booking preview is ready.\nHere are your service details.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Color(0xFF57647B),
                ),
              ),
              const SizedBox(height: 24),
              _summary(context),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () => _viewBooking(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'View Booking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Local preview · Not submitted to a professional',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: _muted),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _SuccessArtwork extends StatelessWidget {
  const _SuccessArtwork();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Booking success calendar',
    image: true,
    child: Stack(
      alignment: Alignment.center,
      children: [
        for (final dot in [
          (x: 24.0, y: 35.0, color: Color(0xFF1BA780)),
          (x: 65.0, y: 15.0, color: Color(0xFF21AAB1)),
          (x: 185.0, y: 33.0, color: Color(0xFF5682AA)),
          (x: 208.0, y: 72.0, color: Color(0xFF1BA780)),
          (x: 16.0, y: 88.0, color: Color(0xFFF8BF43)),
          (x: 35.0, y: 128.0, color: Color(0xFF26729F)),
          (x: 193.0, y: 127.0, color: Color(0xFFE7A548)),
        ])
          Positioned(
            left: dot.x,
            top: dot.y,
            child: Transform.rotate(
              angle: 0.6,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dot.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        Container(
          width: 116,
          height: 116,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEDF6FF),
          ),
        ),
        const Icon(
          Icons.calendar_month_rounded,
          size: 112,
          color: Color(0xFF087EFF),
        ),
        Positioned(
          right: 51,
          bottom: 9,
          child: Container(
            width: 61,
            height: 61,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF48D79A), Color(0xFF0AA564)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: const Color(0xFFFAFCFF), width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2525B678),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 37,
            ),
          ),
        ),
      ],
    ),
  );
}
