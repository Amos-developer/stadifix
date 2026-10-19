import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../booking/presentation/screens/booking_screen.dart';

import '../../domain/models/professional.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({
    super.key,
    required this.professional,
    this.city = 'Nairobi',
    this.favorites,
  });

  final Professional professional;
  final String city;
  final Set<String>? favorites;

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  static const _blue = Color(0xFF0075FF);
  static const _ink = Color(0xFF14233C);
  static const _muted = Color(0xFF778297);
  late final Set<String> _favorites = widget.favorites ?? <String>{};
  String? _selectedService;

  void _preview(bool booking) {
    if (booking) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BookingScreen(
            professional: widget.professional,
            service: _selectedService,
            city: widget.city,
          ),
        ),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                booking
                    ? Icons.calendar_month_rounded
                    : Icons.chat_bubble_outline_rounded,
                color: _blue,
                size: 40,
              ),
              const SizedBox(height: 16),
              Text(
                booking
                    ? 'Book ${widget.professional.name}'
                    : 'Message ${widget.professional.name}',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 12),
              if (booking) ...[
                Text(_selectedService ?? widget.professional.service),
                const SizedBox(height: 8),
                Text(
                  'From KSh ${widget.professional.hourlyRate}/hr',
                  style: const TextStyle(
                    color: _blue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                booking
                    ? 'Booking is coming soon. No appointment has been created.'
                    : 'Messaging is coming soon. No message has been sent.',
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _share() {
    final professional = widget.professional;
    final summary =
        '${professional.name} — ${professional.role} on StadiFix\n${widget.city} · KSh ${professional.hourlyRate}/hr\nSample profile — live booking is not available yet.';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Share professional'),
        content: SelectableText(summary),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text('Copy details'),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: summary));
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile details copied.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String value, String label) => Expanded(
    child: Column(
      children: [
        Icon(icon, color: _blue, size: 23),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: _muted),
        ),
      ],
    ),
  );

  Widget _heading(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: _ink,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final provider = widget.professional;
    final saved = _favorites.contains(provider.name);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FD),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Professional Profile',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: saved ? 'Unsave professional' : 'Save professional',
            onPressed: () => setState(() {
              if (saved) {
                _favorites.remove(provider.name);
              } else {
                _favorites.add(provider.name);
              }
            }),
            icon: Icon(
              saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: saved ? const Color(0xFFEF6170) : _ink,
            ),
          ),
          IconButton(
            tooltip: 'Share professional',
            onPressed: _share,
            icon: const Icon(Icons.ios_share_rounded, size: 21),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 1.65,
                    child: provider.name == 'James Mwangi'
                        ? Image.asset(
                            'assets/images/provider_profile.png',
                            fit: BoxFit.cover,
                            alignment: const Alignment(0, -0.4),
                            semanticLabel:
                                'Sample plumber working in a modern kitchen',
                          )
                        : ColoredBox(
                            color: const Color(0xFFE4EFFF),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.person_outline_rounded,
                                    color: _blue,
                                    size: 64,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    provider.role,
                                    style: const TextStyle(
                                      color: _blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: _ink,
                      ),
                    ),
                    if (provider.isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F8ED),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: Color(0xFF15996B),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF12805A),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  provider.role,
                  style: const TextStyle(fontSize: 15, color: _muted),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFB514),
                      size: 22,
                    ),
                    Text(
                      '${provider.rating}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    Text(
                      '(${provider.reviews} reviews)',
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                    const Text('•', style: TextStyle(color: _muted)),
                    Text(
                      '${provider.distanceKm.toStringAsFixed(0)} km away',
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE8EDF4)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _stat(
                        Icons.workspace_premium_outlined,
                        '${provider.yearsExperience} years',
                        'Experience',
                      ),
                      _stat(
                        Icons.task_alt_rounded,
                        '${provider.completedJobs}+',
                        'Jobs done',
                      ),
                      _stat(
                        Icons.location_on_outlined,
                        widget.city,
                        'Location',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                _heading('About'),
                Text(
                  'Professional ${provider.role.toLowerCase()} with ${provider.yearsExperience}+ years of experience in residential and commercial ${provider.service.toLowerCase()} services. Helping homeowners in ${widget.city} with careful workmanship and practical solutions.',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.65,
                    color: Color(0xFF66748B),
                  ),
                ),
                const SizedBox(height: 24),
                _heading('Services'),
                const Text(
                  'Choose a service to include in your booking preview.',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: provider.services
                      .map(
                        (service) => ChoiceChip(
                          label: Text(service),
                          selected: _selectedService == service,
                          selectedColor: const Color(0xFFD9EBFF),
                          backgroundColor: const Color(0xFFEAF3FF),
                          side: BorderSide.none,
                          labelStyle: const TextStyle(
                            color: Color(0xFF1263B8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (selected) => setState(
                            () => _selectedService = selected ? service : null,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE8EDF4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.payments_outlined, color: _blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Starting rate',
                              style: TextStyle(color: _muted, fontSize: 12),
                            ),
                            Text(
                              'KSh ${provider.hourlyRate}/hr',
                              style: const TextStyle(
                                color: _ink,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF3FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Demo profile: verification, experience, jobs, ratings and pricing are sample data. Live booking and messaging are not connected.',
                    style: TextStyle(fontSize: 11, height: 1.5, color: _muted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE8EDF4))),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _preview(false),
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 18,
                        ),
                        label: const Text('Message'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _blue,
                          minimumSize: const Size(0, 52),
                          side: const BorderSide(color: _blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _preview(true),
                        style: FilledButton.styleFrom(
                          backgroundColor: _blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Book Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
