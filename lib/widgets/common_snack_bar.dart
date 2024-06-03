import 'package:conantcg/utils/color.dart';
import 'package:flutter/material.dart';

class CommonSnackBar {
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(message),
            Icon(
              Icons.close,
              color: getRelativeColor(context, 0),
            ),
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
