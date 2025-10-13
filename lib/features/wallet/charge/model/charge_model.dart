class WalletChargeResponse {
  final String status;
  final String message;
  final dynamic data;

  WalletChargeResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory WalletChargeResponse.fromJson(Map<String, dynamic> json) {
    return WalletChargeResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}