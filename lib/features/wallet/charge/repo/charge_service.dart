import '../../../../core/services/server_gate.dart';

class WalletChargeService {
  final ServerGate _serverGate;

  WalletChargeService(this._serverGate);

  Future<Map<String, dynamic>> chargeWallet(int amount, int transactionId) async {
    try {
      final response = await _serverGate.sendToServer(
        url: 'wallet/charge',
        body: {
          'amount': amount,
          'transaction_id': transactionId,
        },
      );
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to charge wallet');
      }
    } catch (e) {
      throw Exception('Error charging wallet: $e');
    }
  }
}