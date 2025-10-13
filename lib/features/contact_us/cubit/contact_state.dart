import '../model/contact_model.dart';

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactSuccess extends ContactState {
  final ContactInfo contactInfo;

  ContactSuccess(this.contactInfo);
}

class ContactError extends ContactState {
  final String message;

  ContactError(this.message);
}

class SendMessageLoading extends ContactState {}

class SendMessageSuccess extends ContactState {
  final String message;

  SendMessageSuccess(this.message);
}

class SendMessageError extends ContactState {
  final String message;

  SendMessageError(this.message);
}