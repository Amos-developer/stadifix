import 'package:flutter/material.dart';

import '../../../authentication/presentation/screens/login_screen.dart';
import '../../data/demo_professionals.dart';
import '../../domain/models/professional.dart';
import 'provider_list_screen.dart';
import 'provider_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _blue = Color(0xFF0075FF);
  static const _categories = [
    (name: 'Plumbing', icon: Icons.plumbing_rounded, color: Color(0xFF0877EE)),
    (
      name: 'Electrical',
      icon: Icons.lightbulb_rounded,
      color: Color(0xFFFFB514),
    ),
    (
      name: 'Cleaning',
      icon: Icons.cleaning_services_rounded,
      color: Color(0xFF1389F8),
    ),
    (
      name: 'Painting',
      icon: Icons.format_paint_rounded,
      color: Color(0xFFFF8A36),
    ),
    (name: 'Carpentry', icon: Icons.handyman_rounded, color: Color(0xFFEF7540)),
    (
      name: 'Appliance Repair',
      icon: Icons.local_laundry_service_rounded,
      color: Color(0xFF398AFF),
    ),
    (name: 'Gardening', icon: Icons.yard_rounded, color: Color(0xFF35AE82)),
    (name: 'More', icon: Icons.more_horiz_rounded, color: Color(0xFF233C68)),
  ];

  final _search = TextEditingController();
  final _favorites = <String>{};
  String _city = 'Nairobi';
  String? _category;
  int _tab = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Professional> get _professionals {
    final query = _search.text.trim().toLowerCase();
    return demoProfessionals.where((professional) {
      return (_category == null || professional.service == _category) &&
          '${professional.name} ${professional.service}'.toLowerCase().contains(
            query,
          );
    }).toList();
  }

  void _notice(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showProfessional(Professional professional) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProviderProfileScreen(
          professional: professional,
          city: _city,
          favorites: _favorites,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openProviders([String? category]) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProviderListScreen(
          category: category,
          city: _city,
          favorites: _favorites,
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  void _showCategories() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'All Services',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  for (final category in _categories.where(
                    (item) => item.name != 'More',
                  ))
                    ListTile(
                      leading: Icon(category.icon, color: category.color),
                      title: Text(category.name),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        _openProviders(category.name);
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title, VoidCallback onSeeAll) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF10172B),
          ),
        ),
      ),
      TextButton(
        onPressed: onSeeAll,
        child: const Text(
          'See All',
          style: TextStyle(
            color: Color(0xFF0060C9),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );

  Widget _professionalCard(Professional professional) {
    final favorite = _favorites.contains(professional.name);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFF0F2F6)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 58,
            height: 64,
            child: professional.name == 'James Mwangi'
                ? Image.asset(
                    'assets/images/home_professional.png',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0.8, -0.6),
                  )
                : ColoredBox(
                    color: const Color(0xFFEAF3FF),
                    child: Center(
                      child: Text(
                        professional.name
                            .split(' ')
                            .map((part) => part[0])
                            .join(),
                        style: const TextStyle(
                          color: _blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        title: Text(
          professional.name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              professional.service,
              style: const TextStyle(fontSize: 13, color: Color(0xFF7C8290)),
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '★ ',
                    style: TextStyle(color: Color(0xFFFFB514), fontSize: 17),
                  ),
                  TextSpan(
                    text: '${professional.rating} ',
                    style: const TextStyle(
                      color: Color(0xFF24324A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '(${professional.reviews} reviews)',
                    style: const TextStyle(color: Color(0xFF7C8290)),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          tooltip: favorite
              ? 'Remove ${professional.name} from favorites'
              : 'Save ${professional.name}',
          onPressed: () => setState(() {
            if (favorite) {
              _favorites.remove(professional.name);
            } else {
              _favorites.add(professional.name);
            }
          }),
          icon: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: favorite ? _blue : const Color(0xFFB8C1CF),
            size: 22,
          ),
        ),
        onTap: () => _showProfessional(professional),
      ),
    );
  }

  Widget _home() => ListView(
    padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
    children: [
      Row(
        children: [
          const Icon(Icons.location_on_rounded, color: _blue, size: 22),
          const SizedBox(width: 6),
          DropdownButton<String>(
            value: _city,
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.keyboard_arrow_down, size: 18),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10172B),
            ),
            items: ['Nairobi', 'Mombasa', 'Kisumu']
                .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                .toList(),
            onChanged: (city) => setState(() => _city = city!),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () =>
                _notice('Notifications', 'You have no notifications yet.'),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF27364B),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Profile',
            onPressed: () => setState(() => _tab = 3),
            icon: const CircleAvatar(
              radius: 17,
              backgroundColor: Color(0xFFEAF3FF),
              child: Icon(Icons.person, color: _blue, size: 22),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      TextField(
        controller: _search,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search for services...',
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF939BAB)),
          prefixIcon: const Icon(
            Icons.search,
            size: 21,
            color: Color(0xFF768297),
          ),
          suffixIcon: _search.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: () => setState(_search.clear),
                  icon: const Icon(Icons.close, size: 18),
                ),
          filled: true,
          fillColor: const Color(0xFFF7F9FC),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE9EDF4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE9EDF4)),
          ),
        ),
      ),
      const SizedBox(height: 18),
      ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: SizedBox(
          height: 160,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/home_professional.png',
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0x99214472), Color(0x00214472)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Professional\nHome Services',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'At Your Doorstep',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 32,
                      child: FilledButton(
                        onPressed: _showCategories,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0060C9),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 6),
      _sectionTitle('Categories', _showCategories),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 100,
          crossAxisSpacing: 10,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              if (category.name == 'More') {
                _showCategories();
              } else {
                _openProviders(category.name);
              }
            },
            child: Column(
              children: [
                Container(
                  height: 58,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _category == category.name
                        ? const Color(0xFFE5F1FF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _category == category.name
                          ? _blue
                          : const Color(0xFFF0F3F8),
                    ),
                  ),
                  child: Icon(category.icon, color: category.color, size: 31),
                ),
                const SizedBox(height: 7),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF24324A),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      const SizedBox(height: 18),
      _sectionTitle('Top Rated Professionals', () {
        setState(() {
          _category = null;
          _search.clear();
        });
        _openProviders();
      }),
      if (_category != null)
        Align(
          alignment: Alignment.centerLeft,
          child: InputChip(
            label: Text(_category!),
            onDeleted: () => setState(() => _category = null),
          ),
        ),
      if (_professionals.isEmpty)
        const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No professionals found. Try another service or name.',
            textAlign: TextAlign.center,
          ),
        ),
      ..._professionals.map(_professionalCard),
      const Text(
        'Preview data • Profiles and reviews are samples',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: Color(0xFF7C8290)),
      ),
    ],
  );

  Widget _destination() {
    final title = ['Home', 'Bookings', 'Messages', 'Profile'][_tab];
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              [
                Icons.home,
                Icons.calendar_month_outlined,
                Icons.chat_bubble_outline,
                Icons.person_outline,
              ][_tab],
              color: _blue,
              size: 54,
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              _tab == 3
                  ? 'Welcome to StadiFix. Sign in to manage your account.'
                  : '$title will be available when your account is connected.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_tab == 3)
              FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                ),
                child: const Text('Sign In'),
              )
            else
              TextButton(
                onPressed: () => setState(() => _tab = 0),
                child: const Text('Explore Services'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFBFCFF),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: _tab == 0 ? _home() : _destination(),
        ),
      ),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (tab) => setState(() => _tab = tab),
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFEAF3FF),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: _blue),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Bookings',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          label: 'Messages',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Profile',
        ),
      ],
    ),
  );
}
