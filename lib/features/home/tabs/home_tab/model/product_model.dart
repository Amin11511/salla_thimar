class ProductModel {
  final int categoryId;
  final int id;
  final String title;
  final String description;
  final String code;
  final double priceBeforeDiscount;
  final double price;
  final double discount;
  final int amount;
  final int isActive;
  final bool isFavorite;
  final UnitModel unit;
  final List<String> images;
  final String mainImage;
  final String createdAt;

  const ProductModel({
    required this.categoryId,
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.priceBeforeDiscount,
    required this.price,
    required this.discount,
    required this.amount,
    required this.isActive,
    required this.isFavorite,
    required this.unit,
    required this.images,
    required this.mainImage,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      categoryId: (json['category_id'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      code: json['code'] as String? ?? '',
      priceBeforeDiscount: (json['price_before_discount'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      isActive: (json['is_active'] as num?)?.toInt() ?? 0,
      isFavorite: json['is_favorite'] as bool? ?? false,
      unit: UnitModel.fromJson(json['unit'] as Map<String, dynamic>? ?? {}),
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      mainImage: json['main_image'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'id': id,
      'title': title,
      'description': description,
      'code': code,
      'price_before_discount': priceBeforeDiscount,
      'price': price,
      'discount': discount,
      'amount': amount,
      'is_active': isActive,
      'is_favorite': isFavorite,
      'unit': unit.toJson(),
      'images': images,
      'main_image': mainImage,
      'created_at': createdAt,
    };
  }
}

class UnitModel {
  final int id;
  final String name;
  final String type;
  final String createdAt;
  final String updatedAt;

  const UnitModel({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}