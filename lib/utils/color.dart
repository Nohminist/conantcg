// utils/color.dart
import 'package:flutter/material.dart';

Color getRelativeColor(BuildContext context, double amount) {
  assert(amount >= 0 && amount <= 1);

  // 現在のテーマを取得
  var theme = Theme.of(context);
  // テーマの背景色を取得
  var color = theme.colorScheme.surface;

  return theme.brightness == Brightness.dark
      ? lighten(color, amount) // ダークモードの場合、1 + amount倍の明るさ
      : darken(color, amount); // ライトモードの場合、1 - amount倍の暗さ
}




Color lighten(Color color, [double amount = .2]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final lightness = (hsl.lightness + amount).clamp(0.0, 1.0) as double;

  return hsl.withLightness(lightness).toColor();
}

Color darken(Color color, [double amount = .2]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final lightness = (hsl.lightness - amount).clamp(0.0, 1.0) as double;

  return hsl.withLightness(lightness).toColor();
}

