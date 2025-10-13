import '../model/address_model.dart';

abstract class CurrentAddressesState {}

class CurrentAddressesInitial extends CurrentAddressesState {}

class CurrentAddressesLoading extends CurrentAddressesState {}

class CurrentAddressesSuccess extends CurrentAddressesState {
  final List<CurrentAddressesModel> addresses;

  CurrentAddressesSuccess(this.addresses);
}

class CurrentAddressesError extends CurrentAddressesState {
  final String message;

  CurrentAddressesError(this.message);
}

class DeleteAddressLoading extends CurrentAddressesState {}

class DeleteAddressSuccess extends CurrentAddressesState {
  final List<CurrentAddressesModel> addresses;

  DeleteAddressSuccess(this.addresses);
}

class DeleteAddressError extends CurrentAddressesState {
  final String message;

  DeleteAddressError(this.message);
}

class UpdateAddressLoading extends CurrentAddressesState {}

class UpdateAddressSuccess extends CurrentAddressesState {
  final List<CurrentAddressesModel> addresses;

  UpdateAddressSuccess(this.addresses);
}

class UpdateAddressError extends CurrentAddressesState {
  final String message;

  UpdateAddressError(this.message);
}