class Venue {
  final String id;
  final String name;
  final String type;
  final double lat;
  final double lng;
  final double rating;
  final int priceLevel;
  final String priceBand;
  final String address;
  final String photoUrl;
  final List<String> tags;
  final bool openNow;
  final String district;
  final int queueMinutes;
  final int noise;
  const Venue({required this.id, required this.name, required this.type, required this.lat, required this.lng, required this.rating, required this.priceLevel, required this.priceBand, required this.address, required this.photoUrl, required this.tags, required this.openNow, required this.district, required this.queueMinutes, required this.noise});
}
