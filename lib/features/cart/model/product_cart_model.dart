class ProductCartModel {
  final int id;
  final String title;
  final String image;
  final int amount;
  final int priceBeforeDiscount;
  final int discount;
  final int price;
  final double remainingAmount;

  ProductCartModel({
    required this.id,
    required this.title,
    required this.image,
    required this.amount,
    required this.priceBeforeDiscount,
    required this.discount,
    required this.price,
    required this.remainingAmount,
  });

  factory ProductCartModel.fromJson(Map<String, dynamic> json) {
    return ProductCartModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      image: json['image'] as String,
      amount: (json['amount'] as num).toInt(),
      priceBeforeDiscount: (json['price_before_discount'] as num).toInt(),
      discount: (json['discount'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      remainingAmount: (json['remaining_amount'] as num).toDouble(),
    );
  }
}

class GetCartResponse {
  final List<ProductCartModel> data;
  final int totalPriceBeforeDiscount;
  final int totalDiscount;
  final int totalPriceWithVat;
  final int deliveryCost;
  final int freeDeliveryPrice;
  final double vat;
  final int isVip;
  final int vipDiscountPercentage;
  final int minVipPrice;
  final String vipMessage;
  final String status;
  final String message;

  GetCartResponse({
    required this.data,
    required this.totalPriceBeforeDiscount,
    required this.totalDiscount,
    required this.totalPriceWithVat,
    required this.deliveryCost,
    required this.freeDeliveryPrice,
    required this.vat,
    required this.isVip,
    required this.vipDiscountPercentage,
    required this.minVipPrice,
    required this.vipMessage,
    required this.status,
    required this.message,
  });

  factory GetCartResponse.fromJson(Map<String, dynamic> json) {
    return GetCartResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => ProductCartModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPriceBeforeDiscount: (json['total_price_before_discount'] as num).toInt(),
      totalDiscount: (json['total_discount'] as num).toInt(),
      totalPriceWithVat: (json['total_price_with_vat'] as num).toInt(),
      deliveryCost: (json['delivery_cost'] as num).toInt(),
      freeDeliveryPrice: (json['free_delivery_price'] as num).toInt(),
      vat: (json['vat'] as num).toDouble(),
      isVip: (json['is_vip'] as num).toInt(),
      vipDiscountPercentage: (json['vip_discount_percentage'] as num).toInt(),
      minVipPrice: (json['min_vip_price'] as num).toInt(),
      vipMessage: json['vip_message'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }
}