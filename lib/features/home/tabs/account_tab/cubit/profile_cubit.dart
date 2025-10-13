import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/features/home/tabs/account_tab/cubit/profile_state.dart';
import '../model/profile_model.dart';
import '../repo/account_tab_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService _profileService;

  ProfileCubit(this._profileService) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final response = await _profileService.getProfile();
      final profileData = ProfileData.fromJson(response['data']);
      emit(ProfileSuccess(profileData));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}