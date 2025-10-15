import 'package:logger/logger.dart';
import '../../../../core/services/server_gate.dart';
import '../../../../models/user_model.dart';
import '../model/address_model.dart';

class CurrentAddressesService {
  final ServerGate _serverGate;
  final Logger _logger = Logger();

  CurrentAddressesService(this._serverGate);

  Future<List<CurrentAddressesModel>> getAddresses() async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        _logger.e('No authentication token found in UserModel');
        throw Exception('No authentication token found');
      }
      _logger.d('Fetching addresses with token: $token');

      final response = await _serverGate.getFromServer(
        url: 'client/addresses',
      );

      _logger.d('Get addresses response: status=${response.statusCode}, data=${response.data}');

      if (response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => CurrentAddressesModel.fromJson(json)).toList();
      } else {
        final message = response.data['message'] is String
            ? response.data['message']
            : response.data['message']?.toString() ?? 'Failed to fetch addresses';
        _logger.e('API error: $message, statusCode: ${response.statusCode}');
        throw Exception('API error: $message');
      }
    } catch (e) {
      _logger.e('Error fetching addresses: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(int id, String type) async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        _logger.e('No authentication token found in UserModel');
        throw Exception('No authentication token found');
      }
      _logger.d('Deleting address ID: $id with token: $token');

      final response = await _serverGate.deleteFromServer(
        url: 'client/addresses/$id',
        body: {'type': type},
      );

      _logger.d('Delete address response: status=${response.statusCode}, data=${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
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

  Future<List<CurrentAddressesModel>> updateAddress({
    required int id,
    required String type,
    required double lat,
    required double lng,
    required String location,
    required String description,
    required bool isDefault,
    required String phone,
  }) async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        _logger.e('No authentication token found in UserModel');
        throw Exception('No authentication token found');
      }
      _logger.d('Updating address ID: $id with token: $token');

      final response = await _serverGate.putToServer(
        url: 'client/addresses/$id',
        body: {
          'type': type,
          'lat': lat,
          'lng': lng,
          'location': location,
          'description': description,
          'is_default': isDefault ? 1 : 0,
          'phone': phone,
        },
      );

      _logger.d('Update address response: status=${response.statusCode}, data=${response.data}');

      if (response.data['status'] == 'success') {
        final data = response.data['data'];
        List<dynamic> addressList;
        if (data is List) {
          addressList = data;
        } else if (data is Map<String, dynamic>) {
          addressList = [data];
        } else {
          _logger.e('Unexpected data format: ${data.runtimeType}');
          throw Exception('Unexpected data format: ${data.runtimeType}');
        }
        return addressList.map((json) => CurrentAddressesModel.fromJson(json)).toList();
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