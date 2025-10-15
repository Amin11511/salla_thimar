import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/category_product_model.dart';
import '../repo/category_product_service.dart';
import 'category_product_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchService searchService;

  SearchCubit(this.searchService) : super(SearchInitial());

  Future<void> searchProducts({
    required String keyword,
    String? filter,
    double? minPrice,
    double? maxPrice,
    int? categoryId,
  }) async {
    emit(SearchLoading());
    try {
      final response = await searchService.searchProducts(
        keyword: keyword,
        filter: filter,
        minPrice: minPrice,
        maxPrice: maxPrice,
        categoryId: categoryId,
      );
      print('Parsed SearchResponseModel: ${response.data}');
      emit(SearchLoaded(SearchResponseModel.fromJson(response.data)));
    } catch (e) {
      print('Search error: $e');
      emit(SearchError('فشل البحث: $e'));
    }
  }
}