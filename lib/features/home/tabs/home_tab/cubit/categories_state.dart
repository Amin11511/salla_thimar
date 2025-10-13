import '../model/categories_model.dart';
import '../model/product_response.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeCategoriesLoaded extends HomeState {
  final CategoryResponse categories;

  HomeCategoriesLoaded(this.categories);
}

class HomeProductsLoaded extends HomeState {
  final ProductResponse products;

  HomeProductsLoaded(this.products);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}