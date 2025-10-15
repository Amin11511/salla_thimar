import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/tabs/home_tab/model/product_model.dart';
import '../repo/product_details_service.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductService _productService;

  ProductDetailsCubit(this._productService) : super(const ProductDetailsInitial());

  Future<void> fetchProductDetails(int productId) async {
    emit(const ProductDetailsLoading());
    try {
      final product = await _productService.getProductDetails(productId);
      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }
}

abstract class ProductDetailsState {
  const ProductDetailsState();
}

class ProductDetailsInitial extends ProductDetailsState {
  const ProductDetailsInitial();
}

class ProductDetailsLoading extends ProductDetailsState {
  const ProductDetailsLoading();
}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductModel product;

  const ProductDetailsLoaded(this.product);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductDetailsLoaded &&
              runtimeType == other.runtimeType &&
              product == other.product;

  @override
  int get hashCode => product.hashCode;
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductDetailsError &&
              runtimeType == other.runtimeType &&
              message == other.message;

  @override
  int get hashCode => message.hashCode;
}