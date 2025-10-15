import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/features/product_details/cubit/rate_state.dart';

import '../repo/rate_service.dart';

class RateCubit extends Cubit<RateState> {
  final RateService _rateService;

  RateCubit(this._rateService) : super(const RateInitial());

  Future<void> fetchProductRates(int productId) async {
    emit(const RateLoading());
    try {
      final rates = await _rateService.getProductRates(productId);
      emit(RateLoaded(rates));
    } catch (e) {
      emit(RateError(e.toString()));
    }
  }
}