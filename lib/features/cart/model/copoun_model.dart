class CouponResponse {
  final String status;
  final String message;
  final dynamic data;

  CouponResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'],
    );
  }
}