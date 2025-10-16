class OrderDetailsModel {
  final int id;
  final String status;
  final String date;
  final String time;
  final double orderPrice;
  final double deliveryPrice;
  final double totalPrice;
  final String clientName;
  final String phone;
  final Address address;
  final List<Product> products;
  final String payType;
  final String? note;
  final String deliveryPayer;
  final bool isVip;
  final double vipDiscount;
  final double priceBeforeDiscount;
  final double discount;

  OrderDetailsModel({
    required this.id,
    required this.status,
    required this.date,
    required this.time,
    required this.orderPrice,
    required this.deliveryPrice,
    required this.totalPrice,
    required this.clientName,
    required this.phone,
    required this.address,
    required this.products,
    required this.payType,
    this.note,
    required this.deliveryPayer,
    required this.isVip,
    required this.vipDiscount,
    required this.priceBeforeDiscount,
    required this.discount,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      orderPrice: (json['order_price'] ?? 0).toDouble(),
      deliveryPrice: (json['delivery_price'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      clientName: json['client_name'] ?? '',
      phone: json['phone'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ??
          [],
      payType: json['pay_type'] ?? '',
      note: json['note'],
      deliveryPayer: json['delivery_payer'] ?? '',
      isVip: json['is_vip'] == 1,
      vipDiscount: (json['vip_discount'] ?? 0).toDouble(),
      priceBeforeDiscount: (json['price_before_discount'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
    );
  }
}

class Address {
  final int id;
  final String type;
  final double lat;
  final double lng;
  final String location;
  final String description;
  final bool isDefault;
  final String phone;

  Address({
    required this.id,
    required this.type,
    required this.lat,
    required this.lng,
    required this.location,
    required this.description,
    required this.isDefault,
    required this.phone,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      isDefault: json['is_default'] ?? false,
      phone: json['phone'] ?? '',
    );
  }
}

class Product {
  final String name;
  final String url;

  Product({
    required this.name,
    required this.url,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}