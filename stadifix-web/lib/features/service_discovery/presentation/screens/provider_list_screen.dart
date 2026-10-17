import 'package:flutter/material.dart';

import '../../data/demo_professionals.dart';
import '../../domain/models/professional.dart';

enum _Sort { recommended, price, nearest }

class ProviderListScreen extends StatefulWidget {
  const ProviderListScreen({
    super.key,
    this.category,
    this.city = 'Nairobi',
    this.favorites,
  });

  final String? category;
  final String city;
  final Set<String>? favorites;

  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  static const _blue = Color(0xFF0075FF);
  final _search = TextEditingController();
  late final Set<String> _favorites = widget.favorites ?? <String>{};
  _Sort _sort = _Sort.recommended;
  bool _topRated = false;
  bool _savedOnly = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Professional> get _results {
    final query = _search.text.trim().toLowerCase();
    final results = demoProfessionals
        .where(
          (item) =>
              (widget.category == null || item.service == widget.category) &&
              '${item.name} ${item.service}'.toLowerCase().contains(query) &&
              (!_topRated || item.rating >= 4.8) &&
              (!_savedOnly || _favorites.contains(item.name)),
        )
        .toList();
    results.sort(
      (first, second) => switch (_sort) {
        _Sort.recommended => second.rating.compareTo(first.rating),
        _Sort.price => first.hourlyRate.compareTo(second.hourlyRate),
        _Sort.nearest => first.distanceKm.compareTo(second.distanceKm),
      },
    );
    return results;
  }

  void _reset() => setState(() {
    _search.clear();
    _topRated = false;
    _savedOnly = false;
    _sort = _Sort.recommended;
  });

  void _filters() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sort professionals',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              for (final option in _Sort.values)
                ListTile(
                  title: Text(switch (option) {
                    _Sort.recommended => 'Recommended',
                    _Sort.price => 'Price: low to high',
                    _Sort.nearest => 'Nearest first',
                  }),
                  leading: Icon(switch (option) {
                    _Sort.recommended => Icons.star_outline_rounded,
                    _Sort.price => Icons.payments_outlined,
                    _Sort.nearest => Icons.near_me_outlined,
                  }),
                  trailing: _sort == option
                      ? const Icon(Icons.check_circle, color: _blue)
                      : null,
                  onTap: () {
                    setState(() => _sort = option);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _details(Professional provider) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                provider.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text('${provider.service} • ${widget.city}'),
              const SizedBox(height: 12),
              Text(
                'KSh ${provider.hourlyRate}/hr',
                style: const TextStyle(
                  fontSize: 20,
                  color: _blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This is a sample profile. Live availability and booking are not connected yet.',
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to professionals'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(Professional provider) {
    final saved = _favorites.contains(provider.name);
    final role = provider.service == 'Plumbing'
        ? 'Plumber'
        : '${provider.service} specialist';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060C2850),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _details(provider),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: 76,
                      height: 90,
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
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: _blue,
                                  ),
                                ),
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
                          provider.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF13213B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          role,
                          style: const TextStyle(
                            color: Color(0xFF758096),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: '★ ',
                                style: TextStyle(
                                  color: Color(0xFFFFB514),
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: '${provider.rating}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF24324A),
                                ),
                              ),
                              TextSpan(
                                text: ' (${provider.reviews} reviews)',
                                style: const TextStyle(
                                  color: Color(0xFF758096),
                                ),
                              ),
                            ],
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 48,
                    child: IconButton(
                      tooltip: saved
                          ? 'Unsave ${provider.name}'
                          : 'Save ${provider.name}',
                      onPressed: () => setState(() {
                        if (saved) {
                          _favorites.remove(provider.name);
                        } else {
                          _favorites.add(provider.name);
                        }
                      }),
                      icon: Icon(
                        saved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: saved
                            ? const Color(0xFFEF6170)
                            : const Color(0xFF758096),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Divider(height: 1, color: Color(0xFFF0F3F8)),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: Color(0xFF758096),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      '${widget.city} · ${provider.distanceKm.toStringAsFixed(0)} km away',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF758096),
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'KSh ${provider.hourlyRate}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF13213B),
                          ),
                        ),
                        const TextSpan(
                          text: '/hr',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF758096),
                          ),
                        ),
                      ],
                    ),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FD),
        surfaceTintColor: Colors.transparent,
        title: Text(
          widget.category ?? 'Service Professionals',
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Sort and filter',
            onPressed: _filters,
            icon: const Icon(Icons.tune_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: TextField(
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search by name or service',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8B95A7),
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF758096),
                      ),
                      suffixIcon: _search.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: () => setState(_search.clear),
                              icon: const Icon(Icons.close, size: 20),
                            ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFFE5EAF2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFFE5EAF2)),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Top rated · 4.8+'),
                        selected: _topRated,
                        onSelected: (value) =>
                            setState(() => _topRated = value),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Saved'),
                        selected: _savedOnly,
                        onSelected: (value) =>
                            setState(() => _savedOnly = value),
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        label: Text(switch (_sort) {
                          _Sort.recommended => 'Recommended',
                          _Sort.price => 'Lowest price',
                          _Sort.nearest => 'Nearest first',
                        }),
                        avatar: const Icon(Icons.swap_vert, size: 18),
                        onPressed: _filters,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${results.length} ${results.length == 1 ? 'professional' : 'professionals'} in ${widget.city}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF758096),
                          ),
                        ),
                      ),
                      const Text(
                        'DEMO',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF758096),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: results.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color: Color(0xFF94A8C5),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'No professionals found',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Try another name or clear your filters.',
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                  onPressed: _reset,
                                  child: const Text('Clear filters'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: results.length + 1,
                          itemBuilder: (context, index) =>
                              index == results.length
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Sample profiles, prices and distances.\nLive services are not connected yet.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF8B95A7),
                                    ),
                                  ),
                                )
                              : _card(results[index]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
