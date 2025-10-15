import '../model/rate_model.dart';

abstract class RateState {
  const RateState();
}

class RateInitial extends RateState {
  const RateInitial();
}

class RateLoading extends RateState {
  const RateLoading();
}

class RateLoaded extends RateState {
  final RateModel rates;

  const RateLoaded(this.rates);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RateLoaded &&
              runtimeType == other.runtimeType &&
              rates == other.rates;

  @override
  int get hashCode => rates.hashCode;
}

class RateError extends RateState {
  final String message;

  const RateError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RateError &&
              runtimeType == other.runtimeType &&
              message == other.message;

  @override
  int get hashCode => message.hashCode;
}