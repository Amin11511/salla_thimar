import 'package:flutter/material.dart';
import 'dart:async';
import 'package:skydive/core/utils/app_theme.dart';
import 'package:skydive/core/utils/extensions.dart';

class CustomMessageDialog extends StatefulWidget {
  final String message;
  final Duration? autoDismissDuration;

  const CustomMessageDialog({
    super.key,
    required this.message,
    this.autoDismissDuration,
  });

  @override
  State<CustomMessageDialog> createState() => _CustomMessageDialogState();
}

class _CustomMessageDialogState extends State<CustomMessageDialog> {
  @override
  void initState() {
    super.initState();
    if (widget.autoDismissDuration != null) {
      Timer(widget.autoDismissDuration!, () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppThemes.whiteColor.color,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Tajawal",
                fontWeight: FontWeight.w500,
                color: AppThemes.greenColor.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemes.greenColor.color,
                foregroundColor: AppThemes.whiteColor.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "حسنا",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomConfirmDialog extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomConfirmDialog({
    super.key,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppThemes.whiteColor.color,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Tajawal",
                fontWeight: FontWeight.w500,
                color: AppThemes.greenColor.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.greenColor.color,
                    foregroundColor: AppThemes.whiteColor.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    "نعم",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                    foregroundColor: AppThemes.whiteColor.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    "لا",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomMessageDialog(
    BuildContext context,
    String message, {
      Duration? autoDismissDuration,
    }) {
  showDialog(
    context: context,
    builder: (context) => CustomMessageDialog(
      message: message,
      autoDismissDuration: autoDismissDuration,
    ),
  );
}

void showCustomConfirmDialog({
  required BuildContext context,
  required String message,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) {
  showDialog(
    context: context,
    builder: (context) => CustomConfirmDialog(
      message: message,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ),
  );
}