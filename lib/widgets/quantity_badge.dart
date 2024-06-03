import '../utils/to_roman.dart';
import 'package:flutter/material.dart';

class QuantityBadge extends StatelessWidget {
  final int count;
  final String type;
  final double size;

  const QuantityBadge(
      {super.key, required this.count, required this.type, required this.size});

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return SizedBox(
        width: size,
        height: size,
      );
    }
    var iconSize = size * 0.7;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: type == 'キャラ'
            ? Colors.blue[300]
            : type == 'イベント'
                ? Colors.red[300]
                : Colors.grey,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.black)],
      ),
      child: Center(
        child: type == '事件' || type == 'パートナー'
            ? Icon(Icons.check, color: Colors.white, size: iconSize)
            : Text(
                toRoman(count),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: iconSize,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
