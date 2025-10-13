import '../../../../../core/services/server_gate.dart';
import '../model/categories_model.dart';
import '../model/product_model.dart';
import '../model/product_response.dart';
import '../model/slider_model.dart';

class HomeService {
  final ServerGate _serverGate;

  HomeService(this._serverGate);

  Future<CategoryResponse> getCategories() async {
    try {
      final response = await _serverGate.getFromServer(
        url: '/categories',
      );
      if (response.success) {
        return CategoryResponse.fromJson(response.data);
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<ProductResponse> fetchProductsByCategory(int categoryId) async {
    try {
      final response = await _serverGate.getFromServer(
        url: '/categories/$categoryId',
      );
      if (response.success) {
        return ProductResponse.fromJson(response.data);
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<SliderData>> fetchSliders() async {
    try {
      final response = await _serverGate.getFromServer(
        url: '/sliders',
      );
      if (response.success) {
        final data = response.data['data'] as List;
        return data.map((item) => SliderData.fromJson(item)).toList();
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to load sliders');
      }
    } catch (e) {
      throw Exception('Error fetching sliders: $e');
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _serverGate.getFromServer(
        url: '/products',
      );
      if (response.success) {
        final data = response.data['data'] as List;
        return data.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}