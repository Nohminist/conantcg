// widget/card_display_setting.dart
import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  TransparentButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        highlightColor: Theme.of(context).highlightColor,
        splashColor: Theme.of(context).splashColor,
        child: child,
      ),
    );
  }
}
