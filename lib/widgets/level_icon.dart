// widgets/level_icon.dart
import '../utils/color.dart';
import 'package:flutter/material.dart';

class LevelIcon extends StatelessWidget {
  final int level;

  LevelIcon({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: getRelativeColor(context, 0.8),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${level + 1}',
            style: TextStyle(
              color: getRelativeColor(context, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
