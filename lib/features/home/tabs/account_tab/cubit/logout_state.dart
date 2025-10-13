import '../model/logout_model.dart';

abstract class LogoutState {}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {
  final LogoutResponse response;

  LogoutSuccess(this.response);
}

class LogoutError extends LogoutState {
  final String message;

  LogoutError(this.message);
}