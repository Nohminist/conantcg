import 'package:conantcg/providers/card_provider.dart';
import 'package:conantcg/widgets/cardset_outline.dart';
import 'package:conantcg/widgets/updated_date.dart';
import 'package:flutter/material.dart';

class CardSetOutline2 extends StatelessWidget {
  const CardSetOutline2({
    super.key,
    required this.cardSet,
    required this.screenWidth,
    required this.screenHeight,
  });

  final CardSetNo cardSet;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cardSet.name.isEmpty ? 'デッキ名' : cardSet.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        UpdatedDate(date: cardSet.date),
        CardSetOutline(
          cardSetManage: cardSet,
          widgetWidth:
              screenWidth > screenHeight ? screenWidth / 2 : screenWidth,
          isReadOnly: true,
        ),
      ],
    );
  }
}
