// screens/deck_building.dart
// import 'dart:math';
import '../utils/csv_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import './all_cards.dart';
import '../widgets/card_image.dart';
import '../widgets/editing_cardset.dart'; // 新しく追加したインポート

class DeckBuildingScreen extends StatefulWidget {
  @override
  _DeckBuildingScreenState createState() => _DeckBuildingScreenState();
}

class _DeckBuildingScreenState extends State<DeckBuildingScreen> {
  bool isLeftSideSelected = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 40),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: MouseRegion(
                  // onHover: (_) {
                  //   setState(() {
                  //     isLeftSideSelected = true;
                  //   });
                  // },
                  child: EditingCardSet(),
                ),
              ),
              Expanded(
                flex: 1,
                child: MouseRegion(
                  // onHover: (_) {
                  //   setState(() {
                  //     isLeftSideSelected = false;
                  //   });
                  // },
                  child: AllCards(),
                ),
              ),
            ],
          ),
          DetailCardWidget(),
        ],
      ),
    );
  }
}

class DetailCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var displayableWidth = screenWidth / 2 * 0.8;
    var displayableHeight = screenHeight * 0.8;

    var cardWidth, cardHeight;

    var cardNoMapData = Provider.of<CardNoMapData>(context); // 追加

    return Consumer<DetailCardNo>( // 変更
      builder: (context, current, child) {
        var cardNo = current.selectedCardNo; // 変更
        var isLeftSideSelected = current.isLeftSideSelected; // 新しく追加
        var cardData = cardNo != null ? cardNoMapData.data[cardNo] : null; // 追加
        // print('DetailCardWidget:cardNo$cardNo');
        if (cardData != null) {
          if (cardData['type'] == '事件') {
            // 横長のカード
            if (displayableWidth / displayableHeight > 1.4) {
              cardHeight = displayableHeight;
              cardWidth = cardHeight * 1.4;
            } else {
              cardWidth = displayableWidth;
              cardHeight = cardWidth / 1.4;
            }
          } else {
            // 縦長のカード
            if (displayableWidth / displayableHeight > 1 / 1.4) {
              cardHeight = displayableHeight;
              cardWidth = cardHeight / 1.4;
            } else {
              cardWidth = displayableWidth;
              cardHeight = cardWidth * 1.4;
            }
          }

          return Positioned(
            left: isLeftSideSelected
                ? screenWidth * 3 / 4 - cardWidth / 2 -20
                : screenWidth / 4 - cardWidth / 2 -20, 
            top: screenHeight / 2 - cardHeight / 2, // 高さ方向を画面中央にする
            child: Container(
                // borderRadius: BorderRadius.circular(cardHeight / 16),
                child: CardImage2(
                  cardData: cardData,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                ),
              
            ),
          );
        } else {
          return Container(); // カードが選択されていない場合は何も表示しない
        }
      },
    );
  }
}
