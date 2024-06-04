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
    '捜査1',
    'カットイン',
    'ヒラメキ',
  ];

  DeckAnalysis2({required this.deckNos});

  @override
  Widget build(BuildContext context) {
    final cardData = Provider.of<CardNoMap>(context).data;
    final double height = 20; //constraints.maxHeight;

    Map<String, int> keywordCounts = {};
    for (var keyword in keywords) {
      keywordCounts[keyword] = 0;
    }

    for (var cardNo in deckNos) {
      var abilities = cardData[cardNo]?['abilities'] ?? [];
      for (var ability in abilities) {
        for (var keyword in keywords) {
          if( keyword == 'カットイン' || keyword == 'ヒラメキ') continue;
          if (ability.contains(keyword)) {
            keywordCounts[keyword] = (keywordCounts[keyword] ?? 0) + 1;
          }
        }
      }

      String? cutIn = cardData[cardNo]?['cutIn'];
      if (cutIn != null && cutIn.isNotEmpty) {
        keywordCounts['カットイン'] = (keywordCounts['カットイン'] ?? 0) + 1;
      }

      String? inspiration = cardData[cardNo]?['inspiration'];
      if (inspiration != null && inspiration.isNotEmpty) {
        keywordCounts['ヒラメキ'] = (keywordCounts['ヒラメキ'] ?? 0) + 1;
      }
    }

    return Wrap(
      children: keywords.map((keyword) {
        if (keywordCounts[keyword] == 0) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            height: height,
            padding: const EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: getRelativeColor(context, 0),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(height / 5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 4.0),
                keyword == 'カットイン'
                    ? Image.asset('assets/images/icon-cutIn.png')
                    : keyword == 'ヒラメキ'
                        ? Image.asset('assets/images/icon-inspiration.png')
                        : Text(
                            '$keyword',
                            style: TextStyle(
                                fontSize: height / 2,
                                fontWeight: FontWeight.bold),
                          ),
                const SizedBox(width: 8.0),
                Text(
                  '${keywordCounts[keyword]}',
                  style: TextStyle(
                      fontSize: height / 2, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4.0),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
