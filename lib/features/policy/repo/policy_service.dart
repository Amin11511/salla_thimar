import '../../../core/services/server_gate.dart';

class PolicyService {
  final ServerGate _serverGate;

  PolicyService(this._serverGate);

  Future<Map<String, dynamic>> getPolicy() async {
    try {
      final response = await _serverGate.getFromServer(
        url: 'policy',
      );
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to fetch policy data');
      }
    } catch (e) {
      throw Exception('Error fetching policy data: $e');
    }
  }
}