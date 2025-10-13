import '../../../../core/services/server_gate.dart';
import '../model/address_model.dart';

class AddressService {
  final ServerGate _serverGate;

  AddressService(this._serverGate);

  Future<AddressModel> addAddress({
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required int isDefault,
  }) async {
    try {
      final response = await _serverGate.sendToServer(
        url: 'client/addresses',
        body: {
          'type': type,
          'phone': phone,
          'description': description,
          'location': location,
          'lat': lat.toString(),
          'lng': lng.toString(),
          'is_default': isDefault,
        },
      );
      if (response.success) {
        return AddressModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to add address');
      }
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }
}