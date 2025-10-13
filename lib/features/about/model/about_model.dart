class AboutResponse {
  final String status;
  final String message;
  final AboutData data;

  AboutResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AboutResponse.fromJson(Map<String, dynamic> json) {
    return AboutResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: AboutData.fromJson(json['data'] ?? {}),
    );
  }
}

class AboutData {
  final String about;

  AboutData({
    required this.about,
  });

  factory AboutData.fromJson(Map<String, dynamic> json) {
    return AboutData(
      about: json['about'] ?? '',
    );
  }
}