import '../model/about_model.dart';

abstract class AboutState {}

class AboutInitial extends AboutState {}

class AboutLoading extends AboutState {}

class AboutSuccess extends AboutState {
  final AboutResponse response;

  AboutSuccess(this.response);
}

class AboutError extends AboutState {
  final String message;

  AboutError(this.message);
}