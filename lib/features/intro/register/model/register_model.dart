class RegisterModel {
  final String? status;
  final dynamic data;
  final String? message;
  final int? devMessage;

  RegisterModel({
    this.status,
    this.data,
    this.message,
    this.devMessage,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      status: json['status'] as String?,
      data: json['data'],
      message: json['message'] as String?,
      devMessage: json['dev_message'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data,
      'message': message,
      'dev_message': devMessage,
    };
  }
}