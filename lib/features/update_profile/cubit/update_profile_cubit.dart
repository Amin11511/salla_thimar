import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/update_profile_model.dart';
import '../repo/update_profile_service.dart';
import 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileService _updateProfileService;

  UpdateProfileCubit(this._updateProfileService) : super(UpdateProfileInitial());

  Future<void> updateProfile({
    required String fullname,
    required String phone,
    required int cityId,
    String? password,
    String? passwordConfirmation,
    String? imagePath,
  }) async {
    emit(UpdateProfileLoading());
    try {
      final response = await _updateProfileService.updateProfile(
        fullname: fullname,
        phone: phone,
        cityId: cityId,
        password: password,
        passwordConfirmation: passwordConfirmation,
        imagePath: imagePath,
      );
      final updateProfileResponse = UpdateProfileResponse.fromJson(response);
      emit(UpdateProfileSuccess(updateProfileResponse));
    } catch (e) {
      emit(UpdateProfileError(e.toString()));
    }
  }
}