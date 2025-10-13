class LogoutResponse {
  final String status;
  final String message;
  final dynamic data;

  LogoutResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}