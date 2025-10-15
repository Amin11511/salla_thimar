class FavoriteResponse {
  final String status;
  final String message;
  final dynamic data;

  FavoriteResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}