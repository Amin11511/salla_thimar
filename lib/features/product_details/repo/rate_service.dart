import 'package:dio/dio.dart';
import 'package:skydive/core/services/server_gate.dart';
import '../model/rate_model.dart';

class RateService {
  final ServerGate _serverGate;

  RateService(this._serverGate);

  static const String baseUrl = 'https://thimar.amr.aait-d.com/public/api';

  Future<RateModel> getProductRates(int productId) async {
    try {
      final response = await _serverGate.getFromServer(url: 'products/$productId/rates');
      if (response.statusCode == 200) {
        return RateModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load rates: $response');
      }
    } catch (e) {
      throw Exception('Failed to load rates: $e');
    }
  }
}