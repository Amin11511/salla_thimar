class DeliveryCostModel {
  final double deliveryPrice;

  DeliveryCostModel({required this.deliveryPrice});

  factory DeliveryCostModel.fromJson(Map<String, dynamic> json) {
    return DeliveryCostModel(
      deliveryPrice: (json['dellivery_price'] ?? 0).toDouble(),
    );
  }
}