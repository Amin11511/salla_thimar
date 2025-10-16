import '../../../core/services/server_gate.dart';
import '../../../models/user_model.dart';

class OrderCompleteService {
  final ServerGate _serverGate;

  OrderCompleteService(this._serverGate);

  Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    if (!UserModel.i.isAuth) {
      throw Exception('No token found');
    }

    final response = await _serverGate.getFromServer(
      url: 'client/orders/$orderId',
    );

    if (response.success) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception(response.msg ?? 'Failed to fetch order details');
    }
  }

  Future<Map<String, dynamic>> getDeliveryCost(int addressId) async {
    if (!UserModel.i.isAuth) {
      throw Exception('No token found');
    }

    final response = await _serverGate.getFromServer(
      url: 'client/orders/delivery_cost',
      params: {'address_id': addressId},
    );

    if (response.success) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception(response.msg ?? 'Failed to fetch delivery cost');
    }
  }

  Future<Map<String, dynamic>> cancelOrder(int orderId) async {
    if (!UserModel.i.isAuth) {
      throw Exception('No token found');
    }

    final response = await _serverGate.sendToServer(
      url: 'client/orders/$orderId/cancel',
    );

    if (response.success) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception(response.msg ?? 'Failed to cancel order');
    }
  }
}