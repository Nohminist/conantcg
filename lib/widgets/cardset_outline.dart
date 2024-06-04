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
  final CardSetNo cardSetManage;
  final double widgetWidth;
  final bool isReadOnly;

  CardSetOutline({
    required this.cardSetManage,
    required this.widgetWidth,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CardWidget(
              cardNo: cardSetManage.partner!,
              width: widgetWidth / 6,
              height: (widgetWidth / 6) * 1.4,
              isReadOnly: isReadOnly,
              cardType: 'パートナー',
              removeCard: () {
                Provider.of<CardSetNo>(context, listen: false).removePartner();
              },
            ),
            SizedBox(width: 5),
            CardWidget(
              cardNo: cardSetManage.caseCard!,
              width: (widgetWidth / 6) * 1.4 * 1.4,
              height: widgetWidth / 6 * 1.4,
              isReadOnly: isReadOnly,
              cardType: '事件',
              removeCard: () {
                Provider.of<CardSetNo>(context, listen: false).removeCase();
              },
            ),
            SizedBox(width: 5),
            SizedBox(
              width: (widgetWidth / 6) * 1.4 * 1.4,
              height: (widgetWidth / 6) * 1.4,
              child: DeckAnalysis(deckNos: cardSetManage.deck),
            ),
          ],
        ),
        SizedBox(height: 1),
        DeckAnalysis2(deckNos: cardSetManage.deck),
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
                  cards: [cardNo],
                  onTap: removeCard,
                )
          : Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(max(width, height) / 25),
              ),
              child: Center(
                child: Text(
                  cardType,
                  style: TextStyle(fontSize: height / 6),
                ),
              ),
            ),
    );
  }
}
