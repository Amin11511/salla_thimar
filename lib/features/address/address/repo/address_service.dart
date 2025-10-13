import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/server_gate.dart';
import '../model/address_model.dart';

class CurrentAddressesService {
  final ServerGate _serverGate;

  CurrentAddressesService(this._serverGate);

  Future<List<CurrentAddressesModel>> getAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await _serverGate.getFromServer(
        url: 'client/addresses',
      );

      if (response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => CurrentAddressesModel.fromJson(json)).toList();
      } else {
        final message = response.data['message'] is String
            ? response.data['message']
            : response.data['message']?.toString() ?? 'Failed to fetch addresses';
        throw Exception('API error: $message, statusCode: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAddress(int id, String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await _serverGate.deleteFromServer(
        url: 'client/addresses/$id',
        body: {'type': type},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        final message = response.data['message'] is String
            ? response.data['message']
            : response.data['message']?.toString() ?? 'Failed to delete address';
        throw Exception('API error: $message, statusCode: ${response.statusCode}');
      }
    } catch (e) {
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
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

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

      if (response.data['status'] == 'success') {
        final data = response.data['data'];
        List<dynamic> addressList;
        if (data is List) {
          addressList = data;
        } else if (data is Map<String, dynamic>) {
          addressList = [data];
        } else {
          throw Exception('Unexpected data format: ${data.runtimeType}');
        }
        return addressList.map((json) => CurrentAddressesModel.fromJson(json)).toList();
      } else {
        final message = response.data['message'] is String
            ? response.data['message']
            : response.data['message']?.toString() ?? 'Failed to update address';
        throw Exception('API error: $message, statusCode: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}