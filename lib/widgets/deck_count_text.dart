import 'package:conantcg/utils/color.dart';
import 'package:flutter/material.dart';

class DeckCountText extends StatelessWidget {
  const DeckCountText({
    Key? key,
    required this.deck,
    this.fontSize = 14.0, // デフォルトのフォントサイズを設定
  }) : super(key: key);

  final List<String> deck;
  final double fontSize; // フォントサイズを追加

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: deck.length.toString(),
            style: TextStyle(
              color: deck.length == 40 ? getRelativeColor(context, 1) : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: fontSize, // フォントサイズを適用
            ),
          ),
          TextSpan(
            text: ' /40',
            style: TextStyle(
              color: getRelativeColor(context, 1),
              fontWeight: FontWeight.bold,
              fontSize: fontSize, // フォントサイズを適用
            ),
          ),
        ],
      ),
    );
  }
}
