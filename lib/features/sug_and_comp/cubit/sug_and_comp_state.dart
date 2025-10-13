abstract class SugAndCompState {}

class SugAndCompInitial extends SugAndCompState {}

class SugAndCompLoading extends SugAndCompState {}

class SugAndCompSuccess extends SugAndCompState {
  final String message;

  SugAndCompSuccess(this.message);
}

class SugAndCompError extends SugAndCompState {
  final String message;

  SugAndCompError(this.message);
}