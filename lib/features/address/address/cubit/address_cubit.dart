import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../repo/address_service.dart';
import 'address_state.dart';

class CurrentAddressesCubit extends Cubit<CurrentAddressesState> {
  final CurrentAddressesService _addressesService;
  final Logger _logger = Logger();

  CurrentAddressesCubit(this._addressesService) : super(CurrentAddressesInitial()) {
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    emit(CurrentAddressesLoading());
    try {
      final addresses = await _addressesService.getAddresses();
      _logger.d('CurrentAddressesCubit: Fetched addresses: $addresses');
      emit(CurrentAddressesSuccess(addresses));
    } catch (e) {
      _logger.e('CurrentAddressesCubit: Failed to fetch addresses: $e');
      emit(CurrentAddressesError(e.toString()));
    }
  }

  Future<void> deleteAddress(int id, String type) async {
    emit(DeleteAddressLoading());
    try {
      await _addressesService.deleteAddress(id, type);
      final addresses = await _addressesService.getAddresses();
      _logger.d('CurrentAddressesCubit: Addresses after deletion: $addresses');
      emit(DeleteAddressSuccess(addresses));
    } catch (e) {
      _logger.e('CurrentAddressesCubit: Failed to delete address: $e');
      emit(DeleteAddressError(e.toString()));
    }
  }

  Future<void> updateAddress({
    required int id,
    required String type,
    required double lat,
    required double lng,
    required String location,
    required String description,
    required bool isDefault,
    required String phone,
  }) async {
    emit(UpdateAddressLoading());
    try {
      final addresses = await _addressesService.updateAddress(
        id: id,
        type: type,
        lat: lat,
        lng: lng,
        location: location,
        description: description,
        isDefault: isDefault,
        phone: phone,
      );
      _logger.d('CurrentAddressesCubit: Addresses after update: $addresses');
      emit(UpdateAddressSuccess(addresses));
    } catch (e) {
      _logger.e('CurrentAddressesCubit: Failed to update address: $e');
      emit(UpdateAddressError(e.toString()));
    }
  }
}