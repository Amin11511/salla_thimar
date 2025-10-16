import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/routes/routes.dart';
import 'package:skydive/core/utils/app_theme.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../../core/widgets/my_orders_tab/order_item.dart';
import '../../../../order_details_screen/cubit/order_details_cubit.dart';
import '../../../../order_details_screen/repo/order_details_screen.dart';
import '../../../../order_details_screen/view/order_details_screen.dart';
import '../cubit/my_orders_tab_cubit.dart';
import '../cubit/my_orders_tab_state.dart';

class MyOrdersTab extends StatefulWidget {
  const MyOrdersTab({super.key});

  @override
  State<MyOrdersTab> createState() => _MyOrdersTabState();
}

class _MyOrdersTabState extends State<MyOrdersTab> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.whiteColor.color,
        title: Text(
          "طلباتي",
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "Tajawal",
            color: AppThemes.greenColor.color,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppThemes.lightGrey.color, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == 0
                                ? AppThemes.greenColor.color
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          child: Text(
                            "الحالية",
                            style: TextStyle(
                              fontFamily: "Tajawal",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selectedIndex == 0
                                  ? Colors.white
                                  : AppThemes.lightGrey.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == 1
                                ? AppThemes.greenColor.color
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          child: Text(
                            "المنتهية",
                            style: TextStyle(
                              fontFamily: "Tajawal",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selectedIndex == 1
                                  ? Colors.white
                                  : AppThemes.lightGrey.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
                  } else if (state is OrdersSuccess) {
                    final orders = selectedIndex == 0
                        ? state.currentOrders
                        : state.finishedOrders;
                    if (orders.isEmpty) {
                      return Center(
                        child: Text(
                          selectedIndex == 0
                              ? "لا توجد طلبات حالية"
                              : "لا توجد طلبات منتهية",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Tajawal",
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              NamedRoutes.orderDetails,
                              arguments: {'orderId': order.id},
                            );
                          },
                          child: OrderItem(
                            status: order.status == 'pending'
                                ? 'بإنتظار الموافقة'
                                : order.status,
                            orderId: order.id.toString(),
                            date: order.date,
                            price: order.totalPrice.toStringAsFixed(2),
                            products: order.products,
                          ),
                        );
                      },
                    );
                  } else if (state is OrdersError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Tajawal",
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}