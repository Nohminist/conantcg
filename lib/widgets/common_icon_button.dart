// widgets/common_icon__button.dart

import 'package:flutter/material.dart';

class CommonIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Icon icon;

  const CommonIconButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
        Positioned(
          bottom: 0,
          child: Text(
            text,
            style: const TextStyle(fontSize: 8.0),
          ),
        ),
      ],
    );
  }
}
