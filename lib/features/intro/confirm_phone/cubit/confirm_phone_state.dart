abstract class ConfirmPhoneState {}

class ConfirmPhoneInitial extends ConfirmPhoneState {}

class ConfirmPhoneLoading extends ConfirmPhoneState {}

class ConfirmPhoneVerifySuccess extends ConfirmPhoneState {
  final String message;

  ConfirmPhoneVerifySuccess(this.message);
}

class ConfirmPhoneResendSuccess extends ConfirmPhoneState {
  final String message;
  final int devMessage;

  ConfirmPhoneResendSuccess(this.message, this.devMessage);
}

class ConfirmPhoneError extends ConfirmPhoneState {
  final String message;

  ConfirmPhoneError(this.message);
}