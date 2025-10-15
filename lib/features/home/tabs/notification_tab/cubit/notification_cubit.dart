import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/notification_model.dart';
import '../repo/notofication_service.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService service;

  NotificationCubit(this.service) : super(NotificationInitial());

  Future<void> fetchNotifications({int page = 1}) async {
    emit(NotificationLoading());
    try {
      final response = await service.getNotifications(page: page);
      emit(NotificationSuccess(response));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> showNotification(int id) async {
    emit(NotificationLoading());
    try {
      final response = await service.showNotification(id);
      emit(NotificationSuccess(NotificationsResponse(
        data: NotificationData(unreadNotificationsCount: 0, notifications: []),
        links: Links(),
        meta: Meta(currentPage: 1, lastPage: 1, links: [], path: '', perPage: 10, total: 0),
        status: response.status,
        message: response.message,
      )));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> deleteNotification(int id) async {
    emit(NotificationLoading());
    try {
      final response = await service.deleteNotification(id);
      emit(NotificationDeleted(response.message));
      await fetchNotifications(); // Refresh notifications
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> clearAllNotifications() async {
    if (state is NotificationSuccess && (state as NotificationSuccess).response.data.notifications.isEmpty) {
      emit(NotificationsCleared("لا يوجد إشعارات حاليًا"));
      return;
    }

    emit(NotificationLoading());
    try {
      final response = await service.clearAllNotifications();
      emit(NotificationsCleared(response.message));
      await fetchNotifications(); // Refresh notifications
    } catch (e) {
      emit(NotificationsCleared("لا يوجد إشعارات حاليًا")); // Handle API error as a success case
    }
  }
}