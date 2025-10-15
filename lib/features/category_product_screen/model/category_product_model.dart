import '../../home/tabs/home_tab/model/product_response.dart';

class SearchResponseModel {
  final bool status;
  final String message;
  final SearchResultData data;

  SearchResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: SearchResultData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class SearchResultData {
  final List<Product> searchResult;

  SearchResultData({required this.searchResult});

  factory SearchResultData.fromJson(Map<String, dynamic> json) {
    return SearchResultData(
      searchResult: (json['search_result'] as List<dynamic>?)
          ?.map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}