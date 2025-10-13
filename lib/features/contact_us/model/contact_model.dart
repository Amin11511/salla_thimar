class ContactInfo {
  final String location;
  final String phone;
  final String email;
  final double lat;
  final double lng;

  ContactInfo({
    required this.location,
    required this.phone,
    required this.email,
    required this.lat,
    required this.lng,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      lat: double.parse(json['lat']?.toString() ?? '0.0'),
      lng: double.parse(json['lng']?.toString() ?? '0.0'),
    );
  }
}