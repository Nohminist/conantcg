// widgets/deck_edit.dart.dart
import 'dart:math';

import '../utils/csv_data.dart';
import '../widgets/quantity_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../widgets/operable_card.dart';

class DeckEdit3 extends StatelessWidget {
  final List<String> deckNos;
  double screenWidth;
  double screenHeight;

  DeckEdit3(
      {required this.deckNos,
      required this.screenWidth,
      required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    var cardNoMap = Provider.of<CardNoMap>(context); // 追加
    var uniqueDeckNos = deckNos.toSet().toList();

    // レベルごとにカードを分類
    List<List<String>> levelSortedDeck = List.generate(8, (_) => []);
    List<Map<String, int>> levelCardCounts = List.generate(8, (_) => {});

    for (var cardNo in deckNos) {
      // 変更
      var cardData = cardNoMap.data[cardNo]; // 追加
      if (cardData != null && cardData['Lv.'] != null) {
        levelSortedDeck[cardData['Lv.'] - 1].add(cardNo); // 変更
      }
    }

    for (int level = 0; level < 8; level++) {
      // 各カードの出現回数をカウント
      Map<String, int> cardCounts = {}; // 変更
      for (var cardNo in levelSortedDeck[level]) {
        // 変更
        if (cardCounts.containsKey(cardNo)) {
          // 変更
          cardCounts[cardNo] = cardCounts[cardNo]! + 1; // 変更
        } else {
          cardCounts[cardNo] = 1; // 変更
        }
      }
      levelCardCounts[level] = cardCounts; // 変更
    }

    // 最も長い配列の長さを取得
    int maxLength =
        levelCardCounts.map((e) => e.length).reduce((a, b) => a > b ? a : b);

    List<Map<String, int>?> newArray = []; // 変更

    for (int i = 0; i < maxLength; i++) {
      for (int level = 0; level < 8; level++) {
        if (levelCardCounts[level].length > i) {
          var keys = levelCardCounts[level].keys.toList();
          var values = levelCardCounts[level].values.toList();
          newArray.add({keys[i]: values[i]}); // 変更
        } else {
          newArray.add(null);
        }
      }
    }

    // GridView.countをExpandedでラップする必要がある
    return SizedBox(
      height: min((screenWidth - 20) / 8 * 1.4 * maxLength + 20, screenHeight / 2),
      child:  GridView.count(
          // shrinkWrap: true,// 要るのか分からない
          crossAxisCount: 8,
          childAspectRatio: 1 / 1.4, // 横1：縦1.4の比率を設定
          children: List.generate(newArray.length, (index) {
            if (newArray[index] == null) {
              return Container();
            } else {
              // print('newArray[$index]: ${newArray[index]!.keys.first}');
              var cardNo = newArray[index]!.keys.first;
              var count = newArray[index]!.values.first;
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
            }
          }),
        
      ),
    );
  }
}
