import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/faqs_service.dart';
import 'faqs_state.dart';

class FaqsCubit extends Cubit<FaqsState> {
  final FaqsService faqsService;

  FaqsCubit(this.faqsService) : super(FaqsInitial());

  Future<void> fetchFaqs() async {
    emit(FaqsLoading());
    try {
      final faqs = await faqsService.fetchFaqs();
      emit(FaqsSuccess(faqs));
    } catch (e) {
      emit(FaqsError(e.toString()));
    }
  }
}