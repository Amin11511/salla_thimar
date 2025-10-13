import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/Wallet_model.dart';
import '../repo/wallet_service.dart';
import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletService service;
  List<Transaction> allTransactions = [];
  int displayedTransactionCount = 0;
  final int transactionsPerPage = 10;
  bool isLoadingMore = false;

  WalletCubit(this.service) : super(WalletInitial());

  Future<void> fetchWallet() async {
    emit(WalletLoading());
    try {
      final response = await service.getWallet();
      final model = WalletResponse.fromJson(response);
      if (model.status == 'true') {
        allTransactions = model.transactions;
        displayedTransactionCount = transactionsPerPage;
        emit(WalletSuccess(
          model,
          allTransactions.take(displayedTransactionCount).toList(),
          hasMore: allTransactions.length > displayedTransactionCount,
        ));
      } else {
        emit(WalletError('فشل في جلب بيانات المحفظة'));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  void loadMoreTransactions() {
    if (isLoadingMore || displayedTransactionCount >= allTransactions.length) {
      return;
    }

    isLoadingMore = true;
    displayedTransactionCount += transactionsPerPage;
    emit(WalletSuccess(
      WalletResponse(
        transactions: allTransactions,
        status: 'true',
        message: '',
        wallet: 0,
      ),
      allTransactions.take(displayedTransactionCount).toList(),
      hasMore: displayedTransactionCount < allTransactions.length,
    ));
    isLoadingMore = false;
  }
}