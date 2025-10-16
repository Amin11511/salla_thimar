import '../model/my_orders_tab_model.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersSuccess extends OrdersState {
  final List<OrderModel> currentOrders;
  final List<OrderModel> finishedOrders;

  OrdersSuccess({required this.currentOrders, required this.finishedOrders});
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);
}