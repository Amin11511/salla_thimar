import 'package:skydive/features/home/tabs/home_tab/model/product_model.dart';

class ProductResponse {
  final List<Product> data;
  final String status;
  final String message;

  ProductResponse({
    this.data = const [],
    this.status = 'success',
    this.message = '',
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Product.fromJson(item as Map<String, dynamic>))
          ?.toList() ?? [],
      status: json['status'] as String? ?? 'success',
      message: json['message'] as String? ?? '',
    );
  }
}

class Product {
  final int id;
  final int categoryId;
  final String title;
  final String description;
  final String code;
  final double priceBeforeDiscount;
  final double price;
  final double discount;
  final double amount;
  final int isActive;
  final bool isFavorite;
  final Unit unit;
  final List<String> images;
  final String mainImage;
  final String createdAt;

  Product({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    this.code = '',
    required this.priceBeforeDiscount,
    required this.price,
    required this.discount,
    required this.amount,
    required this.isActive,
    this.isFavorite = false,
    required this.unit,
    this.images = const [],
    required this.mainImage,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String title;
    if (json['title'] is Map<String, dynamic>) {
      title = (json['title'] as Map<String, dynamic>)['ar'] as String? ?? '';
    } else {
      title = json['title'] as String? ?? '';
    }

    String description;
    if (json['description'] is Map<String, dynamic>) {
      description = (json['description'] as Map<String, dynamic>)['ar'] as String? ?? '';
    } else {
      description = json['description'] as String? ?? '';
    }

    String code;
    if (json['code'] is Map<String, dynamic>) {
      code = (json['code'] as Map<String, dynamic>)['value'] as String? ?? '';
    } else {
      code = json['code'] as String? ?? '';
    }

    String mainImage;
    if (json['main_image'] is Map<String, dynamic>) {
      mainImage = (json['main_image'] as Map<String, dynamic>)['url'] as String? ?? '';
    } else {
      mainImage = json['main_image'] as String? ?? '';
    }

    String createdAt;
    if (json['created_at'] is Map<String, dynamic>) {
      createdAt = (json['created_at'] as Map<String, dynamic>)['value'] as String? ?? '';
    } else {
      createdAt = json['created_at'] as String? ?? '';
    }

    return Product(
      id: json['id'] as int? ?? 0,
      categoryId: json['category_id'] as int? ?? 0,
      title: title,
      description: description,
      code: code,
      priceBeforeDiscount: (json['price_before_discount'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as int? ?? 0,
      isFavorite: json['is_favorite'] as bool? ?? false,
      unit: Unit.fromJson(json['unit'] as Map<String, dynamic>? ?? {}),
      images: (json['images'] as List<dynamic>?)
          ?.map((img) => img is String ? img : (img as Map<String, dynamic>)['url'] as String? ?? '')
          .toList() ?? [],
      mainImage: mainImage,
      createdAt: createdAt,
    );
  }

  ProductModel toProductModel() {
    return ProductModel(
      categoryId: categoryId,
      id: id,
      title: title,
      description: description,
      code: code,
      priceBeforeDiscount: priceBeforeDiscount,
      price: price,
      discount: discount,
      amount: amount.toInt(),
      isActive: isActive,
      isFavorite: isFavorite,
      unit: UnitModel(
        id: unit.id,
        name: unit.name,
        type: unit.type,
        createdAt: unit.createdAt,
        updatedAt: unit.updatedAt,
      ),
      images: images,
      mainImage: mainImage,
      createdAt: createdAt,
    );
  }
}

class Unit {
  final int id;
  final String name;
  final String type;
  final String createdAt;
  final String updatedAt;

  Unit({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    String name;
    if (json['name'] is Map<String, dynamic>) {
      name = (json['name'] as Map<String, dynamic>)['ar'] as String? ?? '';
    } else {
      name = json['name'] as String? ?? '';
    }

    String type;
    if (json['type'] is Map<String, dynamic>) {
      type = (json['type'] as Map<String, dynamic>)['ar'] as String? ?? '';
    } else {
      type = json['type'] as String? ?? '';
    }

    return Unit(
      id: json['id'] as int? ?? 0,
      name: name,
      type: type,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}