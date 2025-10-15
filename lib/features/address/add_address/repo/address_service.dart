import 'package:logger/logger.dart';
import '../../../../core/services/server_gate.dart';
import '../../../../models/user_model.dart';

class AddressService {
  final ServerGate _serverGate;
  final Logger _logger = Logger();

  AddressService(this._serverGate);

  Future<Map<String, dynamic>> addAddress({
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required int isDefault,
  }) async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        _logger.e('No authentication token found in UserModel');
        throw Exception('No authentication token found');
      }
      _logger.d('Adding address with token: $token');

      final response = await _serverGate.sendToServer(
        url: 'client/addresses',
        body: {
          'type': type,
          'phone': phone,
          'description': description,
          'location': location,
          'lat': lat,
          'lng': lng,
          'is_default': isDefault,
        },
      );

      _logger.d('Add address response: status=${response.statusCode}, data=${response.data}');

      if (response.data['status'] == 'success') {
        return response.data;
      } else {
        final message = response.data['message'] is String
            ? response.data['message']
            : response.data['message']?.toString() ?? 'Failed to add address';
        _logger.e('API error: $message, statusCode: ${response.statusCode}');
        throw Exception('API error: $message');
      }
    } catch (e) {
      _logger.e('Error adding address: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteAddress(int addressId) async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        _logger.e('No authentication token found in UserModel');
        throw Exception('No authentication token found');
      }
      _logger.d('Deleting address ID: $addressId with token: $token');

      final response = await _serverGate.deleteFromServer(
        url: 'client/addresses/$addressId',
      );

      _logger.d('Delete address response: status=${response.statusCode}, data=${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.data;
      } else {
        final message = response.data['message'] is String
            ? response.data['message']
            : response.data['message']?.toString() ?? 'Failed to delete address';
        _logger.e('API error: $message, statusCode: ${response.statusCode}');
        throw Exception('API error: $message');
      }
    } catch (e) {
      _logger.e('Error deleting address: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateAddress({
    required int addressId,
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required int isDefault,
  }) async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        _logger.e('No authentication token found in UserModel');
        throw Exception('No authentication token found');
      }
      _logger.d('Updating address ID: $addressId with token: $token');

      final response = await _serverGate.putToServer(
        url: 'client/addresses/$addressId',
        body: {
          'type': type,
          'phone': phone,
          'description': description,
          'location': location,
          'lat': lat,
          'lng': lng,
          'is_default': isDefault,
        },
      );

      _logger.d('Update address response: status=${response.statusCode}, data=${response.data}');

      if (response.data['status'] == 'success') {
        return response.data;
      } else {
        final message = response.data['message'] is String
            ? response.data['message']
            : response.data['message']?.toString() ?? 'Failed to update address';
        _logger.e('API error: $message, statusCode: ${response.statusCode}');
        throw Exception('API error: $message');
      }
    } catch (e) {
      _logger.e('Error updating address: $e');
      rethrow;
    }
  }
}