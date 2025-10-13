import '../../../../core/services/server_gate.dart';

class WalletService {
  final ServerGate _serverGate;

  WalletService(this._serverGate);

  Future<Map<String, dynamic>> getWallet() async {
    try {
      final response = await _serverGate.getFromServer(
        url: 'wallet',
      );
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to fetch wallet data');
      }
    } catch (e) {
      throw Exception('Error fetching wallet data: $e');
    }
  }
}