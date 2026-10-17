class Professional {
  const Professional({
    required this.name,
    required this.service,
    required this.rating,
    required this.reviews,
    this.hourlyRate = 500,
    this.distanceKm = 2,
  });

  final String name;
  final String service;
  final double rating;
  final int reviews;
  final int hourlyRate;
  final double distanceKm;
}
