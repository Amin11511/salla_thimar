import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/about_model.dart';
import '../repo/about_service.dart';
import 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  final AboutService _aboutService;

  AboutCubit(this._aboutService) : super(AboutInitial());

  Future<void> fetchAbout() async {
    emit(AboutLoading());
    try {
      final response = await _aboutService.getAbout();
      final aboutResponse = AboutResponse.fromJson(response);
      emit(AboutSuccess(aboutResponse));
    } catch (e) {
      emit(AboutError(e.toString()));
    }
  }
}