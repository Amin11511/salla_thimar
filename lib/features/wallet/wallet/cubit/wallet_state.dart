import '../model/Wallet_model.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletSuccess extends WalletState {
  final WalletResponse response;
  final List<Transaction> displayedTransactions;
  final bool hasMore;

  WalletSuccess(this.response, this.displayedTransactions, {this.hasMore = true});
}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);
}