import 'package:skydive/core/services/server_gate.dart';

import '../../../../../models/user_model.dart';

class MyOrdersService {
  final ServerGate _serverGate;

  MyOrdersService(this._serverGate);

  Future<List<Map<String, dynamic>>> getCurrentOrders() async {
    if (!UserModel.i.isAuth) {
      throw Exception('No token found');
    }

    final response = await _serverGate.getFromServer(
      url: 'client/orders/current',
    );

    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    } else {
      throw Exception(response.msg ?? 'Failed to fetch current orders');
    }
  }

  Future<List<Map<String, dynamic>>> getFinishedOrders() async {
    if (!UserModel.i.isAuth) {
      throw Exception('No token found');
    }

    final response = await _serverGate.getFromServer(
      url: 'client/orders/finished',
    );

    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    } else {
      throw Exception(response.msg ?? 'Failed to fetch finished orders');
    }
  }
}