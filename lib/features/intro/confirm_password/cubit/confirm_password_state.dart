abstract class ConfirmPasswordState {}

class ConfirmPasswordInitial extends ConfirmPasswordState {}

class ConfirmPasswordLoading extends ConfirmPasswordState {}

class ConfirmPasswordSuccess extends ConfirmPasswordState {
  final String message;

  ConfirmPasswordSuccess(this.message);
}

class ConfirmPasswordError extends ConfirmPasswordState {
  final String message;

  ConfirmPasswordError(this.message);
}