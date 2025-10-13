class UpdateProfileResponse {
  final String status;
  final String message;
  final ProfileData data;

  UpdateProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProfileData {
  final int id;
  final String fullname;
  final String phone;
  final String? image;
  final City? city;
  final bool isVip;

  ProfileData({
    required this.id,
    required this.fullname,
    required this.phone,
    this.image,
    this.city,
    required this.isVip,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      isVip: json['is_vip'] == 1,
    );
  }
}

class City {
  final int id;
  final String name;

  City({
    required this.id,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}