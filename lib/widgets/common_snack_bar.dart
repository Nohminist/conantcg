import 'package:flutter/material.dart';

class CommonSnackBar {
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: GestureDetector(
        child: Text(message),
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
