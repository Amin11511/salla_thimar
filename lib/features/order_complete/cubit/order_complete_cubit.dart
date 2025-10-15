import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/order_complete_service.dart';
import 'order_complete_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderService orderService;

  OrderCubit(this.orderService) : super(OrderInitial());

  Future<void> createOrder({
    required int addressId,
    required String date,
    required String time,
    required String payType,
    String? notes,
  }) async {
    emit(OrderLoading());
    try {
      final response = await orderService.createOrder(
        addressId: addressId,
        date: date,
        time: time,
        payType: payType,
        notes: notes,
      );
      if (response['status'] == 'success') {
        emit(OrderSuccess(response['message']));
      } else {
        emit(OrderError('Failed to create order: ${response['message']}'));
      }
    } catch (e) {
      emit(OrderError('Error creating order: $e'));
    }
  }
}