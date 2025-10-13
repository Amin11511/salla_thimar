abstract class VerifyPhoneState {}

class VerifyPhoneInitial extends VerifyPhoneState {}

class VerifyPhoneLoading extends VerifyPhoneState {}

class VerifyPhoneVerifySuccess extends VerifyPhoneState {
  final String message;
  final String token;

  VerifyPhoneVerifySuccess(this.message, this.token);
}

class VerifyPhoneResendSuccess extends VerifyPhoneState {
  final String message;
  final int? devMessage;

  VerifyPhoneResendSuccess(this.message, this.devMessage);
}

class VerifyPhoneError extends VerifyPhoneState {
  final String message;

  VerifyPhoneError(this.message);
}