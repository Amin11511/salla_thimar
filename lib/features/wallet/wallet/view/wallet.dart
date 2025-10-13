import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../core/widgets/wallet/transaction_card.dart';
import '../cubit/wallet_cubit.dart';
import '../cubit/wallet_state.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().fetchWallet();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state is WalletError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "المحفظة",
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60.0),
                  child: Center(
                    child: BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, state) {
                        if (state is WalletSuccess) {
                          return Column(
                            children: [
                              Text(
                                "رصيدك",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "${state.response.wallet} ر.س",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                            ],
                          );
                        } else if (state is WalletLoading) {
                          return CircularProgressIndicator(color: AppThemes.greenColor.color);
                        } else {
                          return Column(
                            children: [
                              Text(
                                "رصيدك",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "0 ر.س",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(16),
                    color: AppThemes.greenColor.color,
                    strokeWidth: 2,
                    dashPattern: const [6, 3],
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, NamedRoutes.charge);
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
                          "اشحن الآن",
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
                ),
                SizedBox(height: 60),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, NamedRoutes.transaction);
                      },
                      child: Text(
                        "عرض الكل",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: AppThemes.greenColor.color,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "عرض المعاملات",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.greenColor.color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, state) {
                    if (state is WalletSuccess) {
                      final transactions = state.response.transactions
                          .take(5)
                          .toList(); // نأخذ أول 5 معاملات فقط
                      if (transactions.isEmpty) {
                        return Text(
                          "لا توجد معاملات",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: "Tajawal",
                            fontSize: 16,
                            color: AppThemes.lightGrey.color,
                          ),
                        );
                      }
                      return Column(
                        children: transactions
                            .map(
                              (transaction) => TransactionCard(
                            date: transaction.date,
                            title: transaction.statusTrans,
                            amount: "${transaction.amount} ر.س",
                            isIncome: transaction.transactionType == "charge",
                          ),
                        )
                            .toList(),
                      );
                    } else if (state is WalletLoading) {
                      return CircularProgressIndicator(color: AppThemes.greenColor.color);
                    } else {
                      return Text(
                        "لا توجد معاملات",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 16,
                          color: AppThemes.lightGrey.color,
                        ),
                      );
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