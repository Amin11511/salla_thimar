import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../../core/widgets/account_tab_widgets/address_card.dart';
import '../../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../cubit/address_cubit.dart';
import '../cubit/address_state.dart';

class Address extends StatelessWidget {
  const Address({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrentAddressesCubit>().fetchAddresses();
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: "العناوين",
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocConsumer<CurrentAddressesCubit, CurrentAddressesState>(
          listener: (context, state) {
            if (state is CurrentAddressesError) {
              // handle error message
            } else if (state is DeleteAddressSuccess) {
              // handle delete success
            } else if (state is DeleteAddressError) {
              // handle delete error
            } else if (state is UpdateAddressSuccess) {
              // handle update success
            } else if (state is UpdateAddressError) {
              // handle update error
            }
          },
          builder: (context, state) {
            if (state is CurrentAddressesLoading ||
                state is DeleteAddressLoading ||
                state is UpdateAddressLoading) {
              return Center(
                  child: CircularProgressIndicator(
                      color: AppThemes.greenColor.color));
            }

            else if (state is CurrentAddressesSuccess ||
                state is DeleteAddressSuccess ||
                state is UpdateAddressSuccess) {
              final addresses = state is CurrentAddressesSuccess
                  ? state.addresses
                  : state is DeleteAddressSuccess
                  ? state.addresses
                  : (state as UpdateAddressSuccess).addresses;

              // هنا التعديل الرئيسي
              if (addresses.isEmpty) {
                return Center(
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(16),
                    color: AppThemes.greenColor.color,
                    strokeWidth: 2,
                    dashPattern: const [6, 3],
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, NamedRoutes.addAddress);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.whiteColor.color,
                        foregroundColor: AppThemes.greenColor.color,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "إضافة عنوان",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Tajawal",
                          color: AppThemes.greenColor.color,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: addresses.length + 1,
                      itemBuilder: (context, index) {
                        if (index < addresses.length) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: AddressCard(address: addresses[index]),
                          );
                        } else {
                          return SizedBox(
                            width: double.infinity,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(16),
                              color: AppThemes.greenColor.color,
                              strokeWidth: 2,
                              dashPattern: const [6, 3],
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, NamedRoutes.addAddress);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppThemes.whiteColor.color,
                                  foregroundColor: AppThemes.greenColor.color,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide.none,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "إضافة عنوان",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal",
                                      color: AppThemes.greenColor.color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            }

            else if (state is CurrentAddressesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(
                        fontFamily: "Tajawal",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CurrentAddressesCubit>().fetchAddresses();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.greenColor.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "إعادة المحاولة",
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppThemes.whiteColor.color,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text("حدث خطأ غير متوقع"));
          },
        ),
      ),
    );
  }
}
