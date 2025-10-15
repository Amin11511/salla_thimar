import 'package:flutter/cupertino.dart';
import '../model/product_cart_model.dart';

@immutable
sealed class CartState {
  final List<int>? loadingProductIds;
  final List<int>? updatingQuantityIds;

  CartState({this.loadingProductIds, this.updatingQuantityIds});
}

final class CartInitial extends CartState {
  CartInitial() : super(loadingProductIds: null, updatingQuantityIds: null);
}

final class CartLoading extends CartState {
  CartLoading({List<int>? loadingProductIds, List<int>? updatingQuantityIds})
      : super(loadingProductIds: loadingProductIds, updatingQuantityIds: updatingQuantityIds);
}

final class CartSuccess extends CartState {
  final String message;
  final int? productId;

  CartSuccess(this.message, {this.productId, List<int>? loadingProductIds, List<int>? updatingQuantityIds})
      : super(loadingProductIds: loadingProductIds, updatingQuantityIds: updatingQuantityIds);
}

final class CartError extends CartState {
  final String message;
  final int? productId;

  CartError(this.message, {this.productId, List<int>? loadingProductIds, List<int>? updatingQuantityIds})
      : super(loadingProductIds: loadingProductIds, updatingQuantityIds: updatingQuantityIds);
}

final class CartCouponError extends CartState {
  final String message;

  CartCouponError(this.message, {List<int>? loadingProductIds, List<int>? updatingQuantityIds})
      : super(loadingProductIds: loadingProductIds, updatingQuantityIds: updatingQuantityIds);
}

final class CartLoaded extends CartState {
  final GetCartResponse cartResponse;

  CartLoaded(this.cartResponse, {List<int>? loadingProductIds, List<int>? updatingQuantityIds})
      : super(loadingProductIds: loadingProductIds, updatingQuantityIds: updatingQuantityIds);
}