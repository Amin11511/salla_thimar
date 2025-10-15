class Product {
  final int id;
  final int categoryId;
  final String title;
  final String description;
  final String code;
  final double priceBeforeDiscount;
  final double price;
  final double discount;
  final int amount;
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

  /// ✅ من الـ JSON للـ Product
  factory Product.fromJson(Map<String, dynamic> json) {
    // معالجة اختلاف نوع الحقول (لو كانت Map أو String)
    String title;
    if (json['title'] is Map<String, dynamic>) {
      title = (json['title'] as Map<String, dynamic>)['ar'] as String? ?? '';
    } else {
      title = json['title'] as String? ?? '';
    }

    String description;
    if (json['description'] is Map<String, dynamic>) {
      description =
          (json['description'] as Map<String, dynamic>)['ar'] as String? ?? '';
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
      mainImage =
          (json['main_image'] as Map<String, dynamic>)['url'] as String? ?? '';
    } else {
      mainImage = json['main_image'] as String? ?? '';
    }

    String createdAt;
    if (json['created_at'] is Map<String, dynamic>) {
      createdAt =
          (json['created_at'] as Map<String, dynamic>)['value'] as String? ?? '';
    } else {
      createdAt = json['created_at'] as String? ?? '';
    }

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      categoryId: (json['category_id'] as num?)?.toInt() ?? 0,
      title: title,
      description: description,
      code: code,
      priceBeforeDiscount:
      (json['price_before_discount'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      isActive: (json['is_active'] as num?)?.toInt() ?? 0,
      isFavorite: json['is_favorite'] as bool? ?? false,
      unit: Unit.fromJson(json['unit'] as Map<String, dynamic>? ?? {}),
      images: (json['images'] as List<dynamic>?)
          ?.map((img) => img is String
          ? img
          : (img as Map<String, dynamic>)['url'] as String? ?? '')
          .toList() ??
          [],
      mainImage: mainImage,
      createdAt: createdAt,
    );
  }

  /// ✅ من الـ Product إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
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
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: name,
      type: type,
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

/// ✅ Response Class (للـ HomeTab أو FavoriteTab)
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
          .toList() ??
          [],
      status: json['status'] as String? ?? 'success',
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }
}
