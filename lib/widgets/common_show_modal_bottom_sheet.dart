import 'package:flutter/material.dart';

Future<void> commonShowModalBottomSheet(BuildContext context, Widget child, {double heightFactor = 1}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).canvasColor.withOpacity(0.8),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
      ),
    ),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: heightFactor,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Expanded(child: child),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close),
                    Text('閉じる'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
