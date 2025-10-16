import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skydive/core/routes/app_routes_fun.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../core/widgets/custom_message_dialog.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../gen/assets.gen.dart';
import '../cubit/order_details_cubit.dart';
import '../cubit/order_details_state.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderDetailsCubit>().fetchOrderDetails(widget.orderId, 1822);
  }

  void _onMapCreated(GoogleMapController controller) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "تفاصيل الطلب",
        onBackPressed: () {
          pushBack();
        },
      ),
      body: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        listener: (context, state) {
          if (state is OrderCancelSuccess) {
            showCustomMessageDialog(
              context,
              state.message,
              autoDismissDuration: const Duration(seconds: 2),
            );
            pushBack();
          } else if (state is OrderCancelError) {
            showCustomMessageDialog(
              context,
              state.message,
              autoDismissDuration: const Duration(seconds: 2),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderDetailsLoading) {
            return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
          } else if (state is OrderDetailsSuccess) {
            final order = state.orderDetails;
            final deliveryCost = state.deliveryCost;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // تفاصيل الطلب
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppThemes.lightLightGrey.color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              order.status == 'pending' ? 'بإنتظار الموافقة' : order.status,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: "Tajawal",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppThemes.greenColor.color,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                "#${order.id}",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "طلب",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            order.date,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppThemes.lightGrey.color,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: order.products
                            .map(
                              (product) => Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.network(
                                product.url,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                      Assets.images.tomato.path,
                                      fit: BoxFit.cover,
                                    ),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ],
                  ),
                  // عنوان الطلب
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "عنوان التوصيل",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: "Tajawal",
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 72,
                              height: 62,
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(order.address.lat, order.address.lng),
                                  zoom: 14,
                                ),
                                zoomControlsEnabled: false,
                                myLocationButtonEnabled: false,
                                liteModeEnabled: true,
                                gestureRecognizers: {},
                              ),
                            ),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                order.address.type,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                              Text(
                                order.address.description,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: AppThemes.lightGrey.color,
                                ),
                              ),
                              Text(
                                order.address.location,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ملخص الطلب
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "ملخص الطلب",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: "Tajawal",
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppThemes.lightGreen.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${order.orderPrice.toStringAsFixed(2)} ر.س",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: AppThemes.greenColor.color,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "إجمالي المنتجات",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: AppThemes.greenColor.color,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "${deliveryCost.deliveryPrice.toStringAsFixed(2)} ر.س",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: AppThemes.greenColor.color,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "سعر التوصيل",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: AppThemes.greenColor.color,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Divider(color: AppThemes.lightGrey.color),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "${order.totalPrice.toStringAsFixed(2)} ر.س",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: AppThemes.greenColor.color,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "المجموع",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: AppThemes.greenColor.color,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Divider(color: AppThemes.lightGrey.color),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    order.payType == 'visa' ? Assets.images.visa.path : Assets.images.master.path,
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    "تم الدفع بواسطة",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: AppThemes.greenColor.color,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // إلغاء الطلب
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is OrderCancelLoading
                          ? null
                          : () {
                        context.read<OrderDetailsCubit>().cancelOrder(widget.orderId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.lightRed.color,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: AppThemes.lightRed.color, width: 2),
                        ),
                        elevation: 0,
                      ),
                      child: state is OrderCancelLoading
                          ? CircularProgressIndicator(color: Colors.red)
                          : Text(
                        "إلغاء الطلب",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Tajawal",
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          } else if (state is OrderDetailsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}