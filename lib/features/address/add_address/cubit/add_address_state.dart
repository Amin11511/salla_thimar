import '../model/address_model.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressSuccess extends AddressState {
  final AddressModel address;
  final String message;

  AddressSuccess(this.address, this.message);
}

class AddressError extends AddressState {
  final String message;

  AddressError(this.message);
}