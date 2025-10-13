import '../model/policy_model.dart';

abstract class PolicyState {}

class PolicyInitial extends PolicyState {}

class PolicyLoading extends PolicyState {}

class PolicySuccess extends PolicyState {
  final PolicyResponse response;

  PolicySuccess(this.response);
}

class PolicyError extends PolicyState {
  final String message;

  PolicyError(this.message);
}