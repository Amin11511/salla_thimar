class PolicyResponse {
  final String status;
  final String message;
  final PolicyData data;

  PolicyResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PolicyResponse.fromJson(Map<String, dynamic> json) {
    return PolicyResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: PolicyData.fromJson(json['data'] ?? {}),
    );
  }
}

class PolicyData {
  final String policy;

  PolicyData({
    required this.policy,
  });

  factory PolicyData.fromJson(Map<String, dynamic> json) {
    return PolicyData(
      policy: json['policy'] ?? '',
    );
  }
}