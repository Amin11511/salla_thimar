import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/features/home/tabs/home_tab/cubit/slider_state.dart';
import '../repo/home_service.dart';

class SliderCubit extends Cubit<SliderState> {
  final HomeService sliderService;

  SliderCubit(this.sliderService) : super(SliderInitial());

  Future<void> fetchSliders() async {
    print('Fetching sliders...');
    emit(SliderLoading());
    try {
      final sliders = await sliderService.fetchSliders();
      print('Sliders loaded: $sliders');
      emit(SliderLoaded(sliders));
    } catch (e) {
      print('Slider error: $e');
      emit(SliderError(e.toString()));
    }
  }
}