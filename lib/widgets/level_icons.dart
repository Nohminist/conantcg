// widgets/level_icons.dart
import 'package:flutter/material.dart';
import '../utils/color.dart';

class LevelIcons extends StatelessWidget {
  const LevelIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: List.generate(8, (level) {
          return Expanded(child: LevelIcon(level: level));
        }),
      ),
    );
  }
}

class LevelIcon extends StatelessWidget {
  final int level;

  LevelIcon({required this.level});

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: Container(
          height: 20,
          decoration: BoxDecoration(
            color: getRelativeColor(context, 0.8),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${level + 1}',
              style: TextStyle(
                color: getRelativeColor(context, 0),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      
    );
  }
}
