import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/user_model.dart';
import '../model/copoun_model.dart';
import '../model/product_cart_model.dart';
import '../repo/cart_service.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartService _cartService;

  CartCubit(this._cartService) : super(CartInitial());

  Future<void> addToCart(int productId, int amount) async {
    List<int> currentLoadingIds = state.loadingProductIds ?? [];
    emit(CartLoading(loadingProductIds: [...currentLoadingIds, productId]));
    try {
      final response = await _cartService.addToCart(productId, amount);
      if (response.status == 'success') {
        final updatedLoadingIds = List<int>.from(currentLoadingIds)..remove(productId);
        emit(CartSuccess('تمت الإضافة إلى السلة بنجاح',
            productId: productId, loadingProductIds: updatedLoadingIds));
        await fetchCart();
      } else {
        emit(CartError(response.message,
            productId: productId,
            loadingProductIds: currentLoadingIds..remove(productId)));
      }
    } catch (e) {
      print('Add to cart error: $e');
      emit(CartError(e.toString(),
          productId: productId,
          loadingProductIds: currentLoadingIds..remove(productId)));
    }
  }

  Future<void> deleteFromCart(int productId) async {
    List<int> currentLoadingIds = state.loadingProductIds ?? [];
    List<int> currentUpdatingIds = state.updatingQuantityIds ?? [];
    try {
      final response = await _cartService.deleteFromCart(productId);
      if (response.status == 'success') {
        final updatedLoadingIds = List<int>.from(currentLoadingIds)..remove(productId);
        if (state is CartLoaded) {
          final currentState = state as CartLoaded;

          final updatedCartData =
          currentState.cartResponse.data.where((item) => item.id != productId).toList();

          if (updatedCartData.isNotEmpty) {
            final removedItem = currentState.cartResponse.data.firstWhereOrNull(
                    (item) => item.id == productId);

            if (removedItem != null) {
              final updatedTotalPriceBeforeDiscount =
                  currentState.cartResponse.totalPriceBeforeDiscount -
                      (removedItem.priceBeforeDiscount * removedItem.amount);
              final updatedTotalDiscount = currentState.cartResponse.totalDiscount -
                  (removedItem.discount * removedItem.amount);
              final updatedTotalPriceWithVat =
                  currentState.cartResponse.totalPriceWithVat -
                      (removedItem.price * removedItem.amount);

              final updatedCartResponse = GetCartResponse(
                status: currentState.cartResponse.status,
                message: currentState.cartResponse.message,
                data: updatedCartData,
                totalPriceBeforeDiscount: updatedTotalPriceBeforeDiscount,
                totalDiscount: updatedTotalDiscount,
                totalPriceWithVat: updatedTotalPriceWithVat,
                deliveryCost: currentState.cartResponse.deliveryCost,
                freeDeliveryPrice: currentState.cartResponse.freeDeliveryPrice,
                vat: currentState.cartResponse.vat,
                isVip: currentState.cartResponse.isVip,
                vipDiscountPercentage: currentState.cartResponse.vipDiscountPercentage,
                minVipPrice: currentState.cartResponse.minVipPrice,
                vipMessage: currentState.cartResponse.vipMessage,
              );

              emit(CartLoaded(updatedCartResponse,
                  loadingProductIds: updatedLoadingIds,
                  updatingQuantityIds: currentUpdatingIds));
              return;
            }
          }
          emit(CartSuccess('تم الحذف من السلة بنجاح',
              productId: productId,
              loadingProductIds: updatedLoadingIds,
              updatingQuantityIds: currentUpdatingIds));
          await fetchCart();
        } else {
          emit(CartSuccess('تم الحذف من السلة بنجاح',
              productId: productId,
              loadingProductIds: updatedLoadingIds,
              updatingQuantityIds: currentUpdatingIds));
          await fetchCart();
        }
      } else {
        emit(CartError(response.message,
            productId: productId,
            loadingProductIds: currentLoadingIds..remove(productId),
            updatingQuantityIds: currentUpdatingIds));
      }
    } catch (e) {
      print('Delete from cart error: $e');
      emit(CartError(e.toString(),
          productId: productId,
          loadingProductIds: currentLoadingIds..remove(productId),
          updatingQuantityIds: currentUpdatingIds));
      await fetchCart();
    }
  }

  Future<void> fetchCart() async {
    List<int>? currentLoadingIds = state.loadingProductIds;
    List<int>? currentUpdatingIds = state.updatingQuantityIds;
    emit(CartLoading(
        loadingProductIds: currentLoadingIds,
        updatingQuantityIds: currentUpdatingIds));
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        emit(CartError('No token found',
            loadingProductIds: currentLoadingIds,
            updatingQuantityIds: currentUpdatingIds));
        return;
      }

      final response = await _cartService.getCart();
      if (response.status == 'success') {
        emit(CartLoaded(response,
            loadingProductIds: currentLoadingIds,
            updatingQuantityIds: currentUpdatingIds));
      } else {
        emit(CartError(response.message,
            loadingProductIds: currentLoadingIds,
            updatingQuantityIds: currentUpdatingIds));
      }
    } catch (e) {
      print('Fetch cart error: $e');
      emit(CartError(e.toString(),
          loadingProductIds: currentLoadingIds,
          updatingQuantityIds: currentUpdatingIds));
    }
  }

  Future<void> updateQuantity(int id, int amount) async {
    List<int> currentUpdatingIds = state.updatingQuantityIds ?? [];
    List<int> currentLoadingIds = state.loadingProductIds ?? [];
    try {
      final response = await _cartService.updateQuantity(id, amount);
      if (response.status == 'success') {
        if (state is CartLoaded) {
          final currentState = state as CartLoaded;

          final updatedCartData = currentState.cartResponse.data.map((item) {
            if (item.id == id) {
              return ProductCartModel(
                id: item.id,
                title: item.title,
                image: item.image,
                amount: amount,
                priceBeforeDiscount: item.priceBeforeDiscount,
                discount: item.discount,
                price: item.price,
                remainingAmount: item.remainingAmount,
              );
            }
            return item;
          }).toList();

          final oldItem =
          currentState.cartResponse.data.firstWhereOrNull((item) => item.id == id);
          if (oldItem != null) {
            final amountDiff = amount - oldItem.amount;
            final updatedTotalPriceBeforeDiscount =
                currentState.cartResponse.totalPriceBeforeDiscount +
                    (amountDiff * oldItem.priceBeforeDiscount);
            final updatedTotalDiscount =
                currentState.cartResponse.totalDiscount +
                    (amountDiff * oldItem.discount);
            final updatedTotalPriceWithVat =
                currentState.cartResponse.totalPriceWithVat +
                    (amountDiff * oldItem.price);

            final updatedCartResponse = GetCartResponse(
              status: currentState.cartResponse.status,
              message: currentState.cartResponse.message,
              data: updatedCartData,
              totalPriceBeforeDiscount: updatedTotalPriceBeforeDiscount,
              totalDiscount: updatedTotalDiscount,
              totalPriceWithVat: updatedTotalPriceWithVat,
              deliveryCost: currentState.cartResponse.deliveryCost,
              freeDeliveryPrice: currentState.cartResponse.freeDeliveryPrice,
              vat: currentState.cartResponse.vat,
              isVip: currentState.cartResponse.isVip,
              vipDiscountPercentage: currentState.cartResponse.vipDiscountPercentage,
              minVipPrice: currentState.cartResponse.minVipPrice,
              vipMessage: currentState.cartResponse.vipMessage,
            );

            emit(CartLoaded(updatedCartResponse,
                loadingProductIds: currentLoadingIds,
                updatingQuantityIds: currentUpdatingIds));
            return;
          }
        }
        await fetchCart();
      } else {
        emit(CartError(response.message,
            productId: id,
            loadingProductIds: currentLoadingIds,
            updatingQuantityIds: currentUpdatingIds));
      }
    } catch (e) {
      print('Update quantity error: $e');
      emit(CartError(e.toString(),
          productId: id,
          loadingProductIds: currentLoadingIds,
          updatingQuantityIds: currentUpdatingIds));
      await fetchCart();
    }
  }

  Future<void> applyCoupon(String code) async {
    try {
      final response = await _cartService.applyCoupon(code);
      if (response.status == 'success') {
        await fetchCart();
        emit(CartSuccess('تم تطبيق الكوبون بنجاح'));
      } else {
        emit(CartCouponError(response.message));
      }
    } catch (e) {
      print('Apply coupon error: $e');
      String errorMessage = 'حدث خطأ أثناء تطبيق الكوبون';
      if (e is DioException && e.response?.data != null) {
        try {
          final response = CouponResponse.fromJson(e.response!.data);
          errorMessage = response.message;
        } catch (_) {
          errorMessage = e.message ?? 'حدث خطأ غير معروف';
        }
      }
      emit(CartCouponError(errorMessage));
    }
  }
}
