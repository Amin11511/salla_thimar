import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../../core/widgets/app_btn.dart';
import '../../../../core/widgets/app_field.dart';
import '../../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../cubit/charge_cubit.dart';
import '../cubit/charge_state.dart';

class Charge extends StatefulWidget {
  const Charge({super.key});

  @override
  State<Charge> createState() => _ChargeState();
}

class _ChargeState extends State<Charge> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController transactionIdController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    nameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletChargeCubit, WalletChargeState>(
      listener: (context, state) {
        if (state is WalletChargeSuccess) {
          // showCustomMessageDialog(
          //   context,
          //   state.message,
          //   autoDismissDuration: const Duration(seconds: 2),
          // );
          // النقل إلى AppRoutes.wallet بعد النجاح
          Navigator.pushReplacementNamed(context, NamedRoutes.wallet);
        } else if (state is WalletChargeError) {
          // showCustomMessageDialog(
          //   context,
          //   state.message,
          //   autoDismissDuration: const Duration(seconds: 2),
          // );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "شحن الآن", onBackPressed: () { Navigator.pop(context); }),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 60),
                Text(
                      "معلومات المبلغ",
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.greenColor.color,
                      ),
                    ),
                SizedBox(height: 10),
                AppField(hintText: "المبلغ الخاص بك", controller: amountController),
                SizedBox(height: 10),
                Text(
                      "معلومات البطاقة",
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.greenColor.color,
                      ),
                    ),
                SizedBox(height: 10),
                AppField(hintText: "الاسم", controller: nameController),
                SizedBox(height: 10),
                AppField(hintText: "رقم البطاقة اللإتمانية", controller: cardNumberController),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: AppField(hintText: "رقم المتسلسل", controller: cvvController)),
                    SizedBox(width: 20),
                    Expanded(child: AppField(hintText: "تاريخ الإنتهاء", controller: expiryDateController)),
                  ],
                ),
                SizedBox(height: 10),
                AppField(hintText: "رقم العملية (Transaction ID)", controller: transactionIdController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                AppBtn(
                  title: "دفع",
                  backgroundColor: AppThemes.greenColor.color,
                  onPressed: () {
                    if (amountController.text.isEmpty || transactionIdController.text.isEmpty) {
                      // showCustomMessageDialog(
                      //   context,
                      //   "يرجى إدخال المبلغ ورقم العملية",
                      //   autoDismissDuration: const Duration(seconds: 2),
                      // );
                      return;
                    }
                    try {
                      final amount = int.parse(amountController.text);
                      final transactionId = int.parse(transactionIdController.text);
                      context.read<WalletChargeCubit>().chargeWallet(amount, transactionId);
                    } catch (e) {
                      // showCustomMessageDialog(
                      //   context,
                      //   "يرجى إدخال أرقام صحيحة",
                      //   autoDismissDuration: const Duration(seconds: 2),
                      // );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}