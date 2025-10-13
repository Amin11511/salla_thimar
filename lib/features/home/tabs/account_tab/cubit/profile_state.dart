import '../model/profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileData profileData;

  ProfileSuccess(this.profileData);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}