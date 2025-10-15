import '../model/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final NotificationsResponse response;
  NotificationSuccess(this.response);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationDeleted extends NotificationState {
  final String message;
  NotificationDeleted(this.message);
}

class NotificationsCleared extends NotificationState {
  final String message;
  NotificationsCleared(this.message);
}