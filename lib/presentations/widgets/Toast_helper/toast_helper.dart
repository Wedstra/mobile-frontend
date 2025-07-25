import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error }

class ToastHelper {
  static final ToastHelper _instance = ToastHelper._internal();
  factory ToastHelper() => _instance;
  ToastHelper._internal();

  late FToast _fToast;

  void init(BuildContext context) {
    _fToast = FToast();
    _fToast.init(context);
  }

  void showToast(String message, ToastType type) {
    Color backgroundColor = type == ToastType.success ? Colors.green : Colors.red;
    IconData icon = type == ToastType.success ? Icons.check_circle : Icons.error;

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    _fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
