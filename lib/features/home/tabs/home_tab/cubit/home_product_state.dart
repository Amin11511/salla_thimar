import '../model/product_model.dart';

abstract class HomeProductState {}

class HomeProductInitial extends HomeProductState {}

class HomeProductLoading extends HomeProductState {}

class HomeProductLoaded extends HomeProductState {
  final List<ProductModel> products;

  HomeProductLoaded(this.products);
}

class HomeProductError extends HomeProductState {
  final String message;

  HomeProductError(this.message);
}