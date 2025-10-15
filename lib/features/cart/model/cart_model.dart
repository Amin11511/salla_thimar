class CartResponse {
  final String status;
  final String message;
  final CartData? data;

  CartResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] != null ? CartData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }
}

class CartData {
  final String title;
  final String image;
  final int amount;
  final int deliveryCost;
  final int price;

  CartData({
    required this.title,
    required this.image,
    required this.amount,
    required this.deliveryCost,
    required this.price,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      title: json['title'] as String,
      image: json['image'] as String,
      amount: json['amount'] as int,
      deliveryCost: json['delivery_cost'] as int,
      price: json['price'] as int,
    );
  }
}