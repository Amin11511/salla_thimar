import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/routes/app_routes_fun.dart';
import 'package:skydive/core/utils/app_theme.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../core/widgets/custom_message_dialog.dart';
import '../../../../core/widgets/wallet/transaction_card.dart';
import '../../wallet/cubit/wallet_cubit.dart';
import '../../wallet/cubit/wallet_state.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().fetchWallet();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          context.read<WalletCubit>().state is WalletSuccess) {
        final state = context.read<WalletCubit>().state as WalletSuccess;
        if (state.hasMore && !context.read<WalletCubit>().isLoadingMore) {
          context.read<WalletCubit>().loadMoreTransactions();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state is WalletError) {
          showCustomMessageDialog(
            context,
            state.message,
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "سجل المعاملات",
          onBackPressed: () {
            pushBack();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<WalletCubit, WalletState>(
            builder: (context, state) {
              if (state is WalletLoading) {
                return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
              } else if (state is WalletSuccess) {
                final transactions = state.displayedTransactions;
                if (transactions.isEmpty) {
                  return Center(
                    child: Text(
                      "لا توجد معاملات",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 16,
                        color: AppThemes.lightGrey.color,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: transactions.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == transactions.length && state.hasMore) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color)),
                      );
                    } else if (index == transactions.length && !state.hasMore) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "لا توجد معاملات إضافية",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: "Tajawal",
                              fontSize: 16,
                              color: AppThemes.lightGrey.color,
                            ),
                          ),
                        ),
                      );
                    }
                    final transaction = transactions[index];
                    return TransactionCard(
                      date: transaction.date,
                      title: transaction.statusTrans,
                      amount: "${transaction.amount} ر.س",
                      isIncome: transaction.transactionType == "charge",
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "لا توجد معاملات",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontSize: 16,
                      color: AppThemes.lightGrey.color,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}