import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../../models/user_model.dart';
import '../model/address_model.dart';
import '../repo/address_service.dart';
import 'add_address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressService _addressService;
  final Logger _logger = Logger();

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
    _logger.d('Attempting to add address: type=$type, phone=$phone, location=$location');
    emit(AddressLoading());
    try {
      final response = await _addressService.addAddress(
        type: type,
        phone: phone,
        description: description,
        location: location,
        lat: lat,
        lng: lng,
        isDefault: isDefault,
      );
      final address = AddressModel.fromJson(response['data'] ?? response);
      _logger.d('Address added successfully: $address');
      emit(AddressSuccess(address, 'تمت إضافة العنوان بنجاح'));
    } catch (e) {
      _logger.e('Error adding address: $e');
      if (e.toString().contains('401')) {
        _logger.d('401 error detected, retrying after reloading UserModel...');
        UserModel.i.get();
        if (UserModel.i.isAuth) {
          try {
            final response = await _addressService.addAddress(
              type: type,
              phone: phone,
              description: description,
              location: location,
              lat: lat,
              lng: lng,
              isDefault: isDefault,
            );
            final address = AddressModel.fromJson(response['data'] ?? response);
            _logger.d('Retry successful, address added: $address');
            emit(AddressSuccess(address, 'تمت إضافة العنوان بنجاح'));
          } catch (retryError) {
            _logger.e('Retry failed: $retryError');
            emit(AddressError('مطلوب تسجيل الدخول: $retryError'));
          }
        } else {
          _logger.w('No valid token found after retry');
          emit(AddressError('مطلوب تسجيل الدخول'));
        }
      } else {
        emit(AddressError('خطأ في إضافة العنوان: $e'));
      }
    }
  }
}