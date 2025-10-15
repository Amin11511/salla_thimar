import '../model/category_product_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final SearchResponseModel response;

  SearchLoaded(this.response);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}