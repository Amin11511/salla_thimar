import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/charge_model.dart';
import '../repo/charge_service.dart';
import 'charge_state.dart';

class WalletChargeCubit extends Cubit<WalletChargeState> {
  final WalletChargeService service;

  WalletChargeCubit(this.service) : super(WalletChargeInitial());

  Future<void> chargeWallet(int amount, int transactionId) async {
    emit(WalletChargeLoading());
    try {
      final response = await service.chargeWallet(amount, transactionId);
      final model = WalletChargeResponse.fromJson(response);
      if (model.status == 'success') {
        emit(WalletChargeSuccess(model.message));
      } else {
        emit(WalletChargeError('فشل في الشحن'));
      }
    } catch (e) {
      emit(WalletChargeError(e.toString()));
    }
  }
}