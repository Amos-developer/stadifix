class Professional {
  const Professional({
    required this.name,
    required this.service,
    required this.rating,
    required this.reviews,
    this.hourlyRate = 500,
    this.distanceKm = 2,
    this.yearsExperience = 5,
    this.completedJobs = 500,
    this.isVerified = true,
  });

  final String name;
  final String service;
  final double rating;
  final int reviews;
  final int hourlyRate;
  final double distanceKm;
  final int yearsExperience;
  final int completedJobs;
  final bool isVerified;

  String get role => service == 'Plumbing' ? 'Plumber' : '$service specialist';

  List<String> get services => switch (service) {
    'Plumbing' => ['Pipe Repair', 'Installation', 'Leak Detection'],
    'Electrical' => ['Wiring', 'Lighting', 'Electrical Repairs'],
    'Cleaning' => ['Deep Cleaning', 'Home Cleaning', 'Move-out Cleaning'],
    'Painting' => ['Interior Painting', 'Exterior Painting', 'Wall Finishing'],
    'Carpentry' => [
      'Furniture Repair',
      'Cabinet Installation',
      'Custom Woodwork',
    ],
    'Appliance Repair' => ['Diagnostics', 'Appliance Repair', 'Maintenance'],
    'Gardening' => ['Lawn Care', 'Landscaping', 'Garden Maintenance'],
    _ => [service],
  };
}
