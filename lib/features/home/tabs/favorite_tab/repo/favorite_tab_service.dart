import '../../../../../core/services/server_gate.dart';
import '../../../../../models/user_model.dart';
import '../../home_tab/model/product_response.dart';
import '../model/favorite_tab_model.dart';

class FavoriteTabService {
  final ServerGate _serverGate;

  FavoriteTabService(this._serverGate);

  Future<ProductResponse> getFavoriteProducts() async {
    try {
      UserModel.i.token;
      final response = await _serverGate.getFromServer(
        url: 'client/products/favorites',
      );

      return ProductResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch favorite products: $e');
    }
  }
}