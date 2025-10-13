import '../model/faqs_model.dart';

abstract class FaqsState {}

class FaqsInitial extends FaqsState {}

class FaqsLoading extends FaqsState {}

class FaqsSuccess extends FaqsState {
  final List<Faq> faqs;

  FaqsSuccess(this.faqs);
}

class FaqsError extends FaqsState {
  final String message;

  FaqsError(this.message);
}