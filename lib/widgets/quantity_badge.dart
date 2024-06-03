import '../utils/to_roman.dart';
import 'package:flutter/material.dart';
import '../utils/color.dart';

class QuantityBadge extends StatelessWidget {
  final int count;
  final String type;
  final double size;

  QuantityBadge(
      {required this.count,
      required this.type,
      this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return Container();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: type == 'キャラ'
            ? Colors.blue[300]
            : type == 'イベント'
                ? Colors.red[300]
                : getRelativeColor(context, 1),
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.black)],
      ),
      child: Center(
        child: type == '事件' || type == 'パートナー'
            ? Icon(Icons.check, color: getRelativeColor(context, 0), size: 20.0)
            : Text(
                toRoman(count),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: size / 1.5,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
