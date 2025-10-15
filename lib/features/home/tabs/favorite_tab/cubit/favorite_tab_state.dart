import '../../home_tab/model/product_response.dart';

abstract class FavoriteTabState {}

class FavoriteTabInitial extends FavoriteTabState {}

class FavoriteTabLoading extends FavoriteTabState {}

class FavoriteTabSuccess extends FavoriteTabState {
  final List<Product> products;

  FavoriteTabSuccess(this.products);
}

class FavoriteTabError extends FavoriteTabState {
  final String message;

  FavoriteTabError(this.message);
}