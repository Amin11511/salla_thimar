import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../../core/utils/app_theme.dart';
import '../../../../../core/widgets/notification_tab/notification_tab.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

class NotificationTab extends StatelessWidget {
  const NotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.whiteColor.color,
        title: Text(
          "الإشعارات",
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "Tajawal",
            color: AppThemes.greenColor.color,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationCubit>().clearAllNotifications();
            },
            child: Text(
              "مسح الكل",
              style: TextStyle(
                fontFamily: "Tajawal",
                color: AppThemes.greenColor.color,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            // showCustomMessageDialog(
            //   context,
            //   state.message,
            //   autoDismissDuration: const Duration(seconds: 2),
            // );
          } else if (state is NotificationDeleted || state is NotificationsCleared) {
            final message = state is NotificationDeleted
                ? (state as NotificationDeleted).message
                : (state as NotificationsCleared).message;
            // showCustomMessageDialog(
            //   context,
            //   message,
            //   autoDismissDuration: const Duration(seconds: 2),
            // );
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
          } else if (state is NotificationSuccess || state is NotificationsCleared) {
            final notifications = state is NotificationSuccess
                ? state.response.data.notifications
                : [];
            if (notifications.isEmpty) {
              return Center(
                child: Text(
                  "لا يوجد إشعارات حاليًا",
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 18,
                    color: AppThemes.greenColor.color,
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationCard(
                    notification: notifications[index],
                  );
                },
              ),
            );
          } else if (state is NotificationError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            );
          }
          return Center(
            child: Text(
              "لا يوجد إشعارات حاليًا",
              style: TextStyle(
                fontFamily: "Tajawal",
                fontSize: 18,
                color: AppThemes.greenColor.color,
              ),
            ),
          );
        },
      ),
    );
  }
}