import '../../../core/services/server_gate.dart';
import '../../../models/user_model.dart';

class SearchService {
  Future<CustomResponse> searchProducts({
    required String keyword,
    String? filter,
    double? minPrice,
    double? maxPrice,
    int? categoryId,
  }) async {
    UserModel.i.get();
    final params = <String, dynamic>{
      'keyword': keyword.isEmpty ? ' ' : keyword,
      if (filter != null && filter.isNotEmpty) 'filter': filter,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (categoryId != null) 'category_id': categoryId,
    };

    return ServerGate.i.getFromServer(
      url: 'search',
      params: params,
    );
  }
}