// widgets/deck_analysis.dart
import 'package:flutter/material.dart';
import '../utils/csv_data.dart';
import 'package:provider/provider.dart';
import '../utils/color.dart';

class DeckAnalysis extends StatelessWidget {
  final List<String> deckNos;

  DeckAnalysis({required this.deckNos});

  @override
  Widget build(BuildContext context) {
    final cardData = Provider.of<CardNoMap>(context).data;

    // Lvごとのカードの枚数を集計するマップ
    final Map<int, Map<String, int>> lvCount = {};

    // 最も枚数が多いLvとその枚数を保存する変数
    int maxLv = 0;
    int maxCount = 0;

// deckNos配列を走査
    for (String cardNo in deckNos) {
      // cardDataからLvとtypeを取得
      int? lv = cardData[cardNo]?['Lv.'];
      String? type = cardData[cardNo]?['type'];

      // Lvとtypeが存在する場合のみカウント
      if (lv != null && type != null) {
        // Lvが既にマップに存在する場合はカウントを増やし、存在しない場合は新たに追加
        if (lvCount.containsKey(lv)) {
          if (lvCount[lv]!.containsKey(type)) {
            lvCount[lv]![type] = lvCount[lv]![type]! + 1;
          } else {
            lvCount[lv]![type] = 1;
          }
        } else {
          lvCount[lv] = {type: 1};
        }

        // 現在の枚数が最大枚数よりも大きい場合は、最大Lvと最大枚数を更新
        int currentCount = lvCount[lv]!.values.reduce((a, b) => a + b);
        if (currentCount > maxCount) {
          maxLv = lv;
          maxCount = currentCount;
        }
      }
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 親ウィジェットの幅と高さを取得
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final topHeight = width / 8;
        final middleHeight = height - topHeight * 3;
        final bottomHeight = topHeight;
        final fontSize = width / 12;

        // 全レベルのキャラとイベントの枚数を集計する変数
        int totalCharaCount = 0;
        int totalEventCount = 0;

// lvCountマップを走査
        lvCount.forEach((lv, typeCounts) {
          totalCharaCount += typeCounts['キャラ'] ?? 0;
          totalEventCount += typeCounts['イベント'] ?? 0;
        });

        int cutInCount = 0;
        int inspirationCount = 0;

// deckNos配列を走査
        for (String cardNo in deckNos) {
          // cardDataから'cutIn'を取得
          String? cutIn = cardData[cardNo]?['cutIn'];

          // 'cutIn'が存在する場合のみカウント
          if (cutIn != null && cutIn.isNotEmpty) {
            cutInCount += 1;
          }

          String? inspiration = cardData[cardNo]?['inspiration'];
          if (inspiration != null && inspiration.isNotEmpty) {
            inspirationCount += 1;
          }
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: topHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(topHeight / 5),
                        bottomLeft: Radius.circular(topHeight / 5),
                      ),
                    ),
                    child: Text(
                      'C$totalCharaCount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                                              color: Colors.white,

                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: topHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red[300],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(topHeight / 5),
                        bottomRight: Radius.circular(topHeight / 5),
                      ),
                    ),
                    child: Text(
                      'E$totalEventCount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: topHeight / 10),
                Expanded(
                  child: Container(
                    height: topHeight,
                      decoration: BoxDecoration(
                        color: getRelativeColor(context, 0.1), // 背景色を設定
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(topHeight / 5),
                        bottomLeft: Radius.circular(topHeight / 5),
                      ),
                      ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icon-cutIn.png',
                          width: topHeight,
                          height: topHeight,
                        ),
                        Text(
                          '$cutInCount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: topHeight,
                                          decoration: BoxDecoration(
                        color: getRelativeColor(context, 0.1), // 背景色を設定
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(topHeight / 5),
                        bottomRight: Radius.circular(topHeight / 5),
                      ),
                      ),

                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icon-inspiration.png',
                          width: topHeight,
                          height: topHeight,
                        ),
                        Text(
                          '$inspirationCount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: List.generate(8, (index) {
                double eventHeight = maxCount > 0
                    ? middleHeight *
                        ((lvCount[index + 1]?['キャラ'] ?? 0) +
                            (lvCount[index + 1]?['イベント'] ?? 0)) /
                        maxCount
                    : 0.0;
                double charaHeight = maxCount > 0
                    ? middleHeight *
                        (lvCount[index + 1]?['キャラ'] ?? 0) /
                        maxCount
                    : 0.0;

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // ここで配置を設定します
                    children: [
                      Container(
                        height: topHeight,
                        alignment: Alignment.center,
                        child: Text(
                          '${(lvCount[index + 1]?['キャラ'] ?? 0) + (lvCount[index + 1]?['イベント'] ?? 0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                      Container(
                        height: middleHeight,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: eventHeight,
                              color: Colors.red[300], // ここで背景色を設定します
                              width: width / 8 - 1,
                            ),
                            Container(
                              height: charaHeight,
                              color: Colors.blue[300], // ここで背景色を設定します
                              width: width / 8 - 1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: bottomHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: getRelativeColor(context, 0.8), // 背景色を設定します
                          shape: BoxShape.circle, // 背景を円形にします
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getRelativeColor(context, 0), // 文字色を設定します
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
