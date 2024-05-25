// widgets/editing_card_set.dart
import '../providers/card_provider.dart';
import '../utils/color.dart';
import '../widgets/card_image.dart';
import '../widgets/deck_analysis.dart';
import '../widgets/deck_analysis2.dart';
import '../widgets/operable_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';


class CardSetOutline extends StatelessWidget {
  final CardSetNo current;
  final double widgetWidth;
  final bool isReadOnly;

  CardSetOutline({
    required this.current,
    required this.widgetWidth,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CardWidget(
          cardNo: current.partner!,
          width: widgetWidth / 8,
          height: (widgetWidth / 8) * 1.4,
          isReadOnly: isReadOnly,
          cardType: 'パートナー',
          removeCard: () {
            Provider.of<CardSetNo>(context, listen: false).removePartner();
          },
        ),
        SizedBox(width: 5),
        CardWidget(
          cardNo: current.caseCard!,
          width: (widgetWidth / 8) * 1.4 * 1.4,
          height: widgetWidth / 8 * 1.4,
          isReadOnly: isReadOnly,
          cardType: '事件',
          removeCard: () {
            Provider.of<CardSetNo>(context, listen: false).removeCase();
          },
        ),
        SizedBox(width: 5),
        SizedBox(
          width: (widgetWidth / 8) * 1.4 * 1.4,
          height: (widgetWidth / 8) * 1.4,
          child: DeckAnalysis(deckNos: current.deck),
        ),
        SizedBox(width: 5),
        SizedBox(
          width: (widgetWidth / 8) * 1.4,
          height: (widgetWidth / 8) * 1.4,
          child: DeckAnalysis2(deckNos: current.deck),
        ),
      ],
    );
  }
}

class CardWidget extends StatelessWidget {
  final String cardNo;
  final double width;
  final double height;
  final bool isReadOnly;
  final String cardType;
  final Function removeCard;

  CardWidget({
    required this.cardNo,
    required this.width,
    required this.height,
    required this.isReadOnly,
    required this.cardType,
    required this.removeCard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: cardNo != ''
          ? isReadOnly
              ? CardImage8(
                  cardNo: cardNo,
                  width: width,
                  height: height,
                )
              : OperableCard(
                  cardNo: cardNo,
                  cards:[cardNo],
                  onTap: removeCard,
                )
          : Container(
              decoration: BoxDecoration(
                color: getRelativeColor(context, 0.1), // 背景色を設定
                borderRadius: BorderRadius.circular(max(width, height) / 25), // 角を丸くする
              ),
              child: Center(
                child: Text(
                  cardType,
                  style: TextStyle(fontSize: height/8), // 文字サイズを設定
                ),
              ),
            ),
    );
  }
}
