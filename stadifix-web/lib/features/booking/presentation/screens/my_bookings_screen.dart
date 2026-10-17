import 'package:flutter/material.dart';

import '../../data/booking_history.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key, this.history, this.onBack});
  final BookingHistory? history;
  final VoidCallback? onBack;

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  static const _blue = Color(0xFF0075FF);
  static const _ink = Color(0xFF14233C);
  static const _muted = Color(0xFF778297);
  BookingHistory get _history => widget.history ?? BookingHistory.instance;
  bool _past = false;

  bool _isPast(BookingEntry entry) {
    final now = DateTime.now();
    return entry.status == BookingStatus.completed ||
        entry.status == BookingStatus.cancelled ||
        entry.booking.date.isBefore(DateTime(now.year, now.month, now.day));
  }

  Future<void> _cancel(BookingEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this booking?'),
        content: Text(
          'Cancel your local booking preview with ${entry.booking.professional.name}? No professional will be notified.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Booking'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cancel Booking',
              style: TextStyle(color: Color(0xFFCF4656)),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) _history.cancel(entry.id);
  }

  Future<void> _reschedule(BookingEntry entry) async {
    final now = DateTime.now();
    final first = DateTime(now.year, now.month, now.day + 1);
    final date = await showDatePicker(
      context: context,
      initialDate: entry.booking.date.isBefore(first)
          ? first
          : entry.booking.date,
      firstDate: first,
      lastDate: DateTime(now.year + 2, now.month, now.day),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 11, minute: 0),
    );
    if (time == null || !mounted) return;
    _history.reschedule(
      entry.id,
      date,
      MaterialLocalizations.of(context).formatTimeOfDay(time),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking preview rescheduled.')),
    );
  }

  void _details(BookingEntry entry) {
    final booking = entry.booking;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Booking Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),
              Text(
                booking.professional.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text('${booking.service} · ${booking.city}'),
              const SizedBox(height: 10),
              Text(
                '${MaterialLocalizations.of(context).formatFullDate(booking.date)} · ${booking.time}',
              ),
              const SizedBox(height: 10),
              Text('Status: ${_statusLabel(entry.status)}'),
              const SizedBox(height: 10),
              Text('Estimated price: KSh ${booking.professional.hourlyRate}'),
              if (booking.notes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(booking.notes),
              ],
              const SizedBox(height: 20),
              const Text(
                'Local preview only. No appointment or payment has been submitted.',
                style: TextStyle(fontSize: 12, color: _muted),
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

  String _statusLabel(BookingStatus status) => switch (status) {
    BookingStatus.pending => 'Pending',
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.completed => 'Completed',
    BookingStatus.cancelled => 'Cancelled',
  };

  Widget _card(BookingEntry entry) {
    final booking = entry.booking;
    final provider = booking.professional;
    final statusColor = switch (entry.status) {
      BookingStatus.pending => const Color(0xFFAE7400),
      BookingStatus.confirmed => const Color(0xFF12805A),
      BookingStatus.completed => const Color(0xFF1263B8),
      BookingStatus.cancelled => const Color(0xFFCF4656),
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBEFF5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 52,
              height: 60,
              child: provider.name == 'James Mwangi'
                  ? Image.asset(
                      'assets/images/home_professional.png',
                      fit: BoxFit.cover,
                      alignment: const Alignment(0.8, -0.6),
                    )
                  : ColoredBox(
                      color: const Color(0xFFEAF3FF),
                      child: Center(
                        child: Text(
                          provider.name
                              .split(' ')
                              .map((part) => part[0])
                              .join(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: _blue,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.role,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 15,
                      color: _muted,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        '${MaterialLocalizations.of(context).formatMediumDate(booking.date)} · ${booking.time}',
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Color(0xFF59677E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: _muted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          booking.city,
                          style: const TextStyle(fontSize: 12, color: _muted),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel(entry.status),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (!_isPast(entry) &&
                        entry.status == BookingStatus.pending) ...[
                      OutlinedButton(
                        onPressed: () => _reschedule(entry),
                        child: const Text('Reschedule'),
                      ),
                      OutlinedButton(
                        onPressed: () => _cancel(entry),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFCF4656),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ] else ...[
                      OutlinedButton(
                        onPressed: () => _details(entry),
                        child: const Text('View Details'),
                      ),
                      if (!_isPast(entry))
                        OutlinedButton(
                          onPressed: () => ScaffoldMessenger.of(context)
                              .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Messaging is not connected yet.',
                                  ),
                                ),
                              ),
                          child: const Text('Message'),
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _history,
    builder: (context, _) {
      final entries =
          _history.entries.where((entry) => _isPast(entry) == _past).toList()
            ..sort(
              (first, second) => _past
                  ? second.booking.date.compareTo(first.booking.date)
                  : first.booking.date.compareTo(second.booking.date),
            );
      return Column(
        children: [
          SizedBox(
            height: 58,
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Back to Home',
                  onPressed:
                      widget.onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                ),
                const Expanded(
                  child: Text(
                    'My Bookings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Row(
            children: [
              for (final past in [false, true])
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _past = past),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _past == past
                                ? _blue
                                : const Color(0xFFEDF0F6),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        past ? 'Past' : 'Upcoming',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _past == past ? _blue : _muted,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.event_note_rounded,
                          size: 48,
                          color: Color(0xFF9AACBF),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _past
                              ? 'No past bookings yet'
                              : 'No upcoming bookings',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your local booking previews will appear here.',
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: entries.length + 1,
                    itemBuilder: (context, index) => index == entries.length
                        ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Local previews · Changes are not sent to professionals',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: _muted),
                            ),
                          )
                        : _card(entries[index]),
                  ),
          ),
        ],
      );
    },
  );
}
