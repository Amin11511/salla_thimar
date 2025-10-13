import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/features/policy/cubit/policy_state.dart';
import '../model/policy_model.dart';
import '../repo/policy_service.dart';

class PolicyCubit extends Cubit<PolicyState> {
  final PolicyService _policyService;

  PolicyCubit(this._policyService) : super(PolicyInitial());

  Future<void> fetchPolicy() async {
    emit(PolicyLoading());
    try {
      final response = await _policyService.getPolicy();
      final policyResponse = PolicyResponse.fromJson(response);
      emit(PolicySuccess(policyResponse));
    } catch (e) {
      emit(PolicyError(e.toString()));
    }
  }
}