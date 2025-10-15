import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../features/home/tabs/notification_tab/cubit/notification_cubit.dart';
import '../../../features/home/tabs/notification_tab/model/notification_model.dart';
import '../../utils/app_theme.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Tajawal",
                      color: AppThemes.greenColor.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "Tajawal",
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.createdAt,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "Tajawal",
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<NotificationCubit>().deleteNotification(notification.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}