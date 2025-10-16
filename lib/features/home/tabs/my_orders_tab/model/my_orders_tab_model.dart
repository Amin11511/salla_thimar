class OrderModel {
  final int id;
  final String status;
  final String date;
  final String time;
  final double orderPrice;
  final double deliveryPrice;
  final double totalPrice;
  final String clientName;
  final String phone;
  final String location;
  final String deliveryPayer;
  final List<ProductModel> products;
  final String payType;
  final String? note;
  final bool isVip;
  final double vipDiscountPercentage;

  OrderModel({
    required this.id,
    required this.status,
    required this.date,
    required this.time,
    required this.orderPrice,
    required this.deliveryPrice,
    required this.totalPrice,
    required this.clientName,
    required this.phone,
    required this.location,
    required this.deliveryPayer,
    required this.products,
    required this.payType,
    this.note,
    required this.isVip,
    required this.vipDiscountPercentage,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      status: json['status'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      orderPrice: (json['order_price'] as num).toDouble(),
      deliveryPrice: (json['delivery_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      clientName: json['client_name'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
      deliveryPayer: json['delivery_payer'] as String,
      products: (json['products'] as List<dynamic>)
          .map((product) => ProductModel.fromJson(product as Map<String, dynamic>))
          .toList(),
      payType: json['pay_type'] as String,
      note: json['note'] as String?,
      isVip: (json['is_vip'] as int) == 1,
      vipDiscountPercentage: (json['vip_discount_percentage'] as num).toDouble(),
    );
  }
}

class ProductModel {
  final String name;
  final String url;

  ProductModel({
    required this.name,
    required this.url,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}