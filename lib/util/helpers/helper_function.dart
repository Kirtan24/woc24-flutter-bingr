import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class BHelperFunction {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static void showToast({
    required BuildContext context,
    required String message,
    ToastificationType? type,
  }) {
    toastification.show(
      context: context,
      title: Text(message),
      padding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(10),
      autoCloseDuration: const Duration(seconds: 2),
      style: ToastificationStyle.simple,
      type: type,
      backgroundColor: type != null
          ? (type == ToastificationType.success ? Colors.green : Colors.red)
          : null,
      foregroundColor: Colors.white,
      closeOnClick: true,
      alignment: Alignment.bottomCenter,
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }
}
