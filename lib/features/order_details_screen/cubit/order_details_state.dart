import '../model/delivery_cost_model.dart';
import '../model/order_details_model.dart';

abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsSuccess extends OrderDetailsState {
  final OrderDetailsModel orderDetails;
  final DeliveryCostModel deliveryCost;

  OrderDetailsSuccess(this.orderDetails, this.deliveryCost);
}

class OrderDetailsError extends OrderDetailsState {
  final String message;

  OrderDetailsError(this.message);
}

class OrderCancelLoading extends OrderDetailsState {}

class OrderCancelSuccess extends OrderDetailsState {
  final String message;

  OrderCancelSuccess(this.message);
}

class OrderCancelError extends OrderDetailsState {
  final String message;

  OrderCancelError(this.message);
}