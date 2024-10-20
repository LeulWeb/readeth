import 'package:flutter/material.dart';

void showScaffoldSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(
        message,
        style:
            TextStyle(color: color == Colors.red ? Colors.white : Colors.black),
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
