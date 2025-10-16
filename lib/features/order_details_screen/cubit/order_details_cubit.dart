import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/delivery_cost_model.dart';
import '../model/order_details_model.dart';
import '../repo/order_details_screen.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrderCompleteService _orderCompleteService;

  OrderDetailsCubit(this._orderCompleteService) : super(OrderDetailsInitial());

  Future<void> fetchOrderDetails(int orderId, int addressId) async {
    emit(OrderDetailsLoading());
    try {
      final orderResponse = await _orderCompleteService.getOrderDetails(orderId);
      final deliveryResponse = await _orderCompleteService.getDeliveryCost(addressId);
      final orderDetails = OrderDetailsModel.fromJson(orderResponse['data']);
      final deliveryCost = DeliveryCostModel.fromJson(deliveryResponse['data']);
      emit(OrderDetailsSuccess(orderDetails, deliveryCost));
    } catch (e) {
      emit(OrderDetailsError(e.toString()));
    }
  }

  Future<void> cancelOrder(int orderId) async {
    emit(OrderCancelLoading());
    try {
      final response = await _orderCompleteService.cancelOrder(orderId);
      emit(OrderCancelSuccess(response['message']));
    } catch (e) {
      emit(OrderCancelError(e.toString()));
    }
  }
}