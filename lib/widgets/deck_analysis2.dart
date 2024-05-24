// widgets/deck_analysis2.dart
import 'package:flutter/material.dart';
import '../utils/csv_data.dart';
import 'package:provider/provider.dart';
import '../utils/color.dart';

class DeckAnalysis2 extends StatelessWidget {
  final List<String> deckNos;
  final List<String> keywords = [
    '迅速',
    '突撃',
    '突撃［キャラ］',
    '突撃［事件］',
    'ブレット',
    'ミスリード1',
    '捜査1'
  ];

  DeckAnalysis2({required this.deckNos});

  @override
  Widget build(BuildContext context) {
    final cardData = Provider.of<CardNoMapData>(context).data;

    // キーワードごとのカード枚数をカウントするマップを初期化
    Map<String, int> keywordCounts = {};
    for (var keyword in keywords) {
      keywordCounts[keyword] = 0;
    }

    // デッキ内の各カードについて、能力をチェック
    for (var cardNo in deckNos) {
      var abilities = cardData[cardNo]?['abilities'] ?? [];
      for (var ability in abilities) {
        for (var keyword in keywords) {
          if (ability.contains(keyword)) {
            keywordCounts[keyword] = (keywordCounts[keyword] ?? 0) + 1;
          }
        }
      }
    }

    // LayoutBuilderを使用して親ウィジェットからサイズを読み込む
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        // Columnを作成
        return Column(
          children: keywords
              .expand((keyword) => [
                    Container(
                      height: height / 7 - 1,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: getRelativeColor(context, 0.1), // 背景色を設定
                        borderRadius: BorderRadius.circular(height/7/4), // 角を丸くする
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // 行の高さ方向の中央寄せ
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width / 20), //
                            child: Text(
                              '$keyword',
                              style: TextStyle(
                                  fontSize: height / 12,
                                  fontWeight: FontWeight.bold), // 文字を太くする
                            ),
                          ),
                          Spacer(),
                          if (keywordCounts[keyword] !=
                              0) // keywordCounts[keyword]が0の場合、0は表示しない
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 20), //
                              child: Text(
                                '${keywordCounts[keyword]}',
                                style: TextStyle(
                                    fontSize: height / 12,
                                    fontWeight: FontWeight.bold), // 文字を太くする
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1), // 行と行の間に1pxの隙間を設ける
                  ])
              .toList(),
        );
      },
    );
  }
}
