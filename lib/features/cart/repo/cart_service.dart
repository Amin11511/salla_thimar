import '../../../core/services/server_gate.dart';
import '../../../models/user_model.dart';
import '../model/cart_model.dart';
import '../model/copoun_model.dart';
import '../model/product_cart_model.dart';

class CartService {
  final ServerGate _serverGate;

  CartService(this._serverGate);

  Future<CartResponse> addToCart(int productId, int amount) async {
    final token = UserModel.i.token;
    if (token.isEmpty) {
      throw Exception('No authentication token found');
    }
    final response = await _serverGate.sendToServer(
      url: 'client/cart',
      body: {
        'product_id': productId,
        'amount': amount,
      },
    );

    return CartResponse.fromJson(response.data);
  }

  Future<CartResponse> deleteFromCart(int productId) async {
    final token = UserModel.i.token;
    if (token.isEmpty) {
      throw Exception('No authentication token found');
    }

    final response = await _serverGate.deleteFromServer(
      url: 'client/cart/delete_item/$productId',
    );

    return CartResponse.fromJson(response.data);
  }

  Future<GetCartResponse> getCart() async {
    final token = UserModel.i.token;
    if (token.isEmpty) {
      throw Exception('No authentication token found');
    }

    final response = await _serverGate.getFromServer(
      url: 'client/cart',
    );

    return GetCartResponse.fromJson(response.data);
  }

  Future<CartResponse> updateQuantity(int id, int amount) async {
    final token = UserModel.i.token;
    if (token.isEmpty) {
      throw Exception('No authentication token found');
    }

    final response = await _serverGate.putToServer(
      url: 'client/cart/$id',
      body: {
        'amount': amount,
      },
    );

    return CartResponse.fromJson(response.data);
  }

  Future<CouponResponse> applyCoupon(String code) async {
    final token = UserModel.i.token;
    if (token.isEmpty) {
      throw Exception('No authentication token found');
    }

    final response = await _serverGate.sendToServer(
      url: 'client/cart/apply_coupon',
      body: {
        'code': code,
      },
    );

    return CouponResponse.fromJson(response.data);
  }
}