import 'package:flutter/material.dart';

import '../../../service_discovery/domain/models/professional.dart';
import '../../domain/models/booking_preview.dart';
import 'booking_confirmation_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({
    super.key,
    required this.professional,
    this.service,
    this.city = 'Nairobi',
  });

  final Professional professional;
  final String? service;
  final String city;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const _blue = Color(0xFF0075FF);
  static const _ink = Color(0xFF14233C);
  static const _muted = Color(0xFF778297);
  static const _times = ['9:00 AM', '11:00 AM', '2:00 PM', '4:00 PM'];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final _details = TextEditingController();
  late final List<DateTime> _dates = List.generate(7, (index) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + index + 1);
  });
  int _selectedDate = 0;
  int _selectedTime = 1;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  void _priceInfo() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Estimated price'),
      content: Text(
        'KSh ${widget.professional.hourlyRate} is a sample estimate for one hour. Final pricing may depend on the work, duration and materials. This preview does not check live availability or create a booking.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    ),
  );

  void _confirm() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookingConfirmationScreen(
          booking: BookingPreview(
            professional: widget.professional,
            date: _dates[_selectedDate],
            time: _times[_selectedTime],
            service: widget.service ?? widget.professional.service,
            notes: _details.text.trim(),
            city: widget.city,
          ),
        ),
      ),
    );
  }

  Widget _heading(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: _ink,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final provider = widget.professional;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFCFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFCFF),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Book Service',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Booking information',
            onPressed: _priceInfo,
            icon: const Icon(Icons.info_outline_rounded, size: 22),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFEDF0F5)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: SizedBox(
                          width: 66,
                          height: 72,
                          child: provider.name == 'James Mwangi'
                              ? Image.asset(
                                  'assets/images/home_professional.png',
                                  fit: BoxFit.cover,
                                  alignment: const Alignment(0.8, -0.6),
                                )
                              : const ColoredBox(
                                  color: Color(0xFFEAF3FF),
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    color: _blue,
                                    size: 36,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: _ink,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              provider.role,
                              style: const TextStyle(
                                fontSize: 13,
                                color: _muted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: '★ ',
                                    style: TextStyle(
                                      color: Color(0xFFFFB514),
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${provider.rating} ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: _ink,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '(${provider.reviews} reviews)',
                                    style: const TextStyle(color: _muted),
                                  ),
                                ],
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                _heading('Select Date & Time'),
                SizedBox(
                  height: 84,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dates.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final date = _dates[index];
                      final selected = index == _selectedDate;
                      return Semantics(
                        selected: selected,
                        button: true,
                        label: MaterialLocalizations.of(context)
                            .formatFullDate(date),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => setState(() => _selectedDate = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            width: 72,
                            decoration: BoxDecoration(
                              color: selected ? _blue : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? _blue
                                    : const Color(0xFFE8EDF4),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _weekdays[date.weekday - 1],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: selected ? Colors.white : _muted,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  '${_months[date.month - 1]} ${date.day}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: selected ? Colors.white : _ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    _times.length,
                    (index) => ChoiceChip(
                      label: Text(_times[index]),
                      selected: _selectedTime == index,
                      showCheckmark: false,
                      selectedColor: _blue,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: _selectedTime == index
                            ? _blue
                            : const Color(0xFFE8EDF4),
                      ),
                      labelStyle: TextStyle(
                        color: _selectedTime == index ? Colors.white : _ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => setState(() => _selectedTime = index),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _heading('Service Details'),
                if (widget.service != null) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      label: Text(widget.service!),
                      backgroundColor: const Color(0xFFEAF3FF),
                      side: BorderSide.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                TextField(
                  controller: _details,
                  minLines: 4,
                  maxLines: 6,
                  maxLength: 1000,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Describe your service needs (optional)',
                    alignLabelWithHint: true,
                    hintText: 'e.g. Fix leaking sink, install new tap, etc.',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9AA2B1),
                    ),
                    labelStyle: const TextStyle(fontSize: 13, color: _muted),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE8EDF4)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Estimated Price',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _ink,
                        ),
                      ),
                    ),
                    Text(
                      'KSh ${provider.hourlyRate}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    IconButton(
                      tooltip: 'About estimated price',
                      onPressed: _priceInfo,
                      icon: const Icon(
                        Icons.info_outline,
                        size: 19,
                        color: _blue,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Based on one hour of service. Final price may vary.',
                  style: TextStyle(fontSize: 12, color: _muted),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: _confirm,
                    style: FilledButton.styleFrom(
                      backgroundColor: _blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Demo availability · No booking or payment will be made',
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
}
