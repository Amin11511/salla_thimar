import 'package:dio/dio.dart';
import '../../../core/services/server_gate.dart';
import '../../../models/user_model.dart';

class OrderService {
  final ServerGate _serverGate;

  OrderService(this._serverGate);

  Future<Map<String, dynamic>> createOrder({
    required int addressId,
    required String date,
    required String time,
    required String payType,
    String? notes,
  }) async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await _serverGate.sendToServer(
        url: 'client/orders',
        body: {
          'address_id': addressId,
          'date': date,
          'time': time,
          'pay_type': payType,
          'notes': notes ?? '',
        },
      );
      print('Create order response: ${response.statusCode}, ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('Error creating order: ${e.message}');
      print('Response body: ${e.response?.data}');
      throw Exception('Failed to create order: ${e.message}, Response: ${e.response?.data}');
    } catch (e) {
      print('Unexpected error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }
}