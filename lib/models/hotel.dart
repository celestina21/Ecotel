class Hotel {
  String owner;
  String name;
  int rating;
  String country;
  String? stateProvince;
  String? city;
  String address;
  List<String> certifications;
  List<Map<String, dynamic>> practices;
  String image;

  Hotel({
    required this.owner,
    required this.name,
    required this.rating,
    required this.country,
    required this.stateProvince,
    required this.city,
    required this.address,
    required this.certifications,
    required this.practices,
    required this.image,
  });
}
