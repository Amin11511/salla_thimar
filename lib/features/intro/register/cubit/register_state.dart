abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class LocationLoading extends RegisterState {}

class LocationPermissionGranted extends RegisterState {
  final double latitude;
  final double longitude;

  LocationPermissionGranted(this.latitude, this.longitude);
}

class LocationPermissionDenied extends RegisterState {}

class LocationPermissionPermanentlyDenied extends RegisterState {}

class LocationError extends RegisterState {
  final String message;

  LocationError(this.message);
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  final int devMessage;

  RegisterSuccess(this.message, this.devMessage);
}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);
}