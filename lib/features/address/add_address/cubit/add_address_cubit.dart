import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/address_service.dart';
import 'add_address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressService _addressService;

  AddressCubit(this._addressService) : super(AddressInitial());

  Future<void> addAddress({
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required int isDefault,
  }) async {
    emit(AddressLoading());
    try {
      final address = await _addressService.addAddress(
        type: type,
        phone: phone,
        description: description,
        location: location,
        lat: lat,
        lng: lng,
        isDefault: isDefault,
      );
      emit(AddressSuccess(address, 'تمت إضافة العنوان بنجاح'));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}