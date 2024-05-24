// widgets/quantity_badge.dart
import '../utils/to_roman.dart';
import 'package:flutter/material.dart';
import '../utils/color.dart';

class QuantityBadge extends StatelessWidget {
  final int count;
  final String type;

  QuantityBadge({required this.count, required this.type});

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return Container(); // countが0の場合、空のContainerを返す
    }

    return Positioned(
      right: 0,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: type == 'キャラ'
              ? Colors.blue
              : type == 'イベント'
                  ? Colors.red
                  : getRelativeColor(context, 1),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black)],
        ),
        child: Center(
          child: type == '事件' || type == 'パートナー'
                ? Icon(Icons.check, color: getRelativeColor(context, 0), size: 18.0) // チェックマークアイコンを表示
                : Text(
                    toRoman(count), // ローマ数字を表示
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
        ),
      ),
    );
  }
}
