import '../providers/card_provider.dart';
import '../utils/color.dart';
import '../widgets/card_image.dart';
import 'package:flutter/material.dart';
import '../widgets/deck_analysis.dart';
import '../widgets/deck_analysis2.dart';

class SaveArea extends StatelessWidget {
  final CardSetNo cardSet;
  final double size; // 新たなパラメータを追加

  const SaveArea({
    Key? key,
    required this.cardSet,
    required this.size, // 新たなパラメータを追加
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getRelativeColor(context, 0),
        border: Border.all(
          color: getRelativeColor(context, 0.5), // 白い枠線を設定
          width: 1.0, // 枠線の幅を設定
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  cardSet.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (cardSet.partner != null)
                    CardImage8(
                        cardNo: cardSet.partner!,
                        width: (size / 14) * 2,
                        height: (size / 14) * 2 / 1.4),
                  SizedBox(width: 5),
                  if (cardSet.caseCard != null)
                    CardImage8(
                        cardNo: cardSet.caseCard!,
                        width: (size / 14) * 2 * 1.4,
                        height: (size / 14) * 2),
                  SizedBox(width: 5),
                  SizedBox(
                    width: (size / 14) * 2 * 1.4,
                    height: (size / 14) * 2,
                    child: DeckAnalysis(deckNos: cardSet.deck),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: (size / 14) * 2,
                    height: (size / 14) * 2,
                    child: DeckAnalysis2(deckNos: cardSet.deck),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              flex: 11,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  childAspectRatio: 1 / 1.4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                itemCount: cardSet.deck.length,
                itemBuilder: (BuildContext context, int index) {
                  return CardImage9(cardNo: cardSet.deck[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
