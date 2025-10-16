import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/my_orders_tab_model.dart';
import '../repo/my_orders_tab_service.dart';
import 'my_orders_tab_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final MyOrdersService _myOrdersService;

  OrdersCubit(this._myOrdersService) : super(OrdersInitial());

  Future<void> fetchOrders() async {
    emit(OrdersLoading());
    try {
      final currentOrdersData = await _myOrdersService.getCurrentOrders();
      final finishedOrdersData = await _myOrdersService.getFinishedOrders();

      final currentOrders = currentOrdersData
          .map((data) => OrderModel.fromJson(data))
          .toList();
      final finishedOrders = finishedOrdersData
          .map((data) => OrderModel.fromJson(data))
          .toList();

      emit(OrdersSuccess(
        currentOrders: currentOrders,
        finishedOrders: finishedOrders,
      ));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}