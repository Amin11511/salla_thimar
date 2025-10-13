abstract class WalletChargeState {}

class WalletChargeInitial extends WalletChargeState {}

class WalletChargeLoading extends WalletChargeState {}

class WalletChargeSuccess extends WalletChargeState {
  final String message;

  WalletChargeSuccess(this.message);
}

class WalletChargeError extends WalletChargeState {
  final String message;

  WalletChargeError(this.message);
}