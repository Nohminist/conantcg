// widgets/deck_edit2.dart
import '../utils/csv_data.dart';
import '../widgets/quantity_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../widgets/operable_card.dart';

class DeckEdit2 extends StatelessWidget {
  final List<String> deckNos;

  DeckEdit2({required this.deckNos});

  @override
  Widget build(BuildContext context) {
    var cardNoMap = Provider.of<CardNoMap>(context);
    var uniqueDeckNos = deckNos.toSet().toList();

    // カードの出現回数をカウント
    Map<String, int> cardCounts = {};
    for (var cardNo in deckNos) {
      if (cardCounts.containsKey(cardNo)) {
        cardCounts[cardNo] = cardCounts[cardNo]! + 1;
      } else {
        cardCounts[cardNo] = 1;
      }
    }

    // GridView.countをExpandedでラップする必要がある
    return Container(
      height:100,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GridView.count(
          crossAxisCount: 8,
          childAspectRatio: 1 / 1.4, // 横1：縦1.4の比率を設定
          children: cardCounts.entries.map((entry) {
            var cardNo = entry.key;
            var count = entry.value;
            var cardData = cardNoMap.data[cardNo];

            if (cardData == null || cardData['type'] == null) {
              return Container();
            }

            return Stack(
              children: [
                OperableCard(
                  cardNo: cardNo,
                  cards: uniqueDeckNos,
                  onTap: () {
                    Provider.of<CardSetNo>(context, listen: false)
                        .removeCardNoFromDeck(cardNo);
                  },
                ),
                QuantityBadge(count: count, type: cardData['type']),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
