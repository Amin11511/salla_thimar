import '../../../core/services/server_gate.dart';
import '../../home/tabs/home_tab/model/product_model.dart';

class ProductService {
  final ServerGate _serverGate;

  ProductService(this._serverGate);

  // Fetch all products
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _serverGate.getFromServer(url: 'products');
      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['status'] == 'success') {
          final products = (jsonData['data'] as List<dynamic>)
              .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return products;
        } else {
          throw Exception('Failed to load products: ${jsonData['message']}');
        }
      } else {
        throw Exception('Failed to load products: $response');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Existing method for fetching a single product
  Future<ProductModel> getProductDetails(int productId) async {
    try {
      final response = await _serverGate.getFromServer(url: 'products/$productId');
      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['status'] == 'success') {
          return ProductModel.fromJson(jsonData['data']);
        } else {
          throw Exception('Failed to load product: ${jsonData['message']}');
        }
      } else {
        throw Exception('Failed to load product: $response');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }
}