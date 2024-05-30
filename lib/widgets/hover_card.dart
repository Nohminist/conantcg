// screens/card_set_building_top.dart
// import 'dart:math';
import 'package:conantcg/utils/csv_data.dart';
import 'package:conantcg/widgets/card_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HoverCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var displayableWidth = screenWidth / 2 * 0.8;
    var displayableHeight = screenHeight * 0.8;

    var cardWidth, cardHeight;

    var cardNoMap = Provider.of<CardNoMap>(context);

    return Consumer<HoverCardManage>(
      builder: (context, current, child) {
        var cardNo = current.selectedCardNo;
        var isLeftSideSelected = current.isLeftSideSelected;
        var cardData = cardNo != null ? cardNoMap.data[cardNo] : null;
        if (cardData != null) {
          if (cardData['type'] == '事件') {
            if (displayableWidth / displayableHeight > 1.4) {
              cardHeight = displayableHeight;
              cardWidth = cardHeight * 1.4;
            } else {
              cardWidth = displayableWidth;
              cardHeight = cardWidth / 1.4;
            }
          } else {
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
                ? screenWidth * 3 / 4 - cardWidth / 2
                : screenWidth / 4 - cardWidth / 2,
            top: screenHeight / 2 - cardHeight / 2,
            child: Container(
              child: CardImage2(
                cardData: cardData,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class HoverCardManage with ChangeNotifier {
  String? _selectedCardNo;
  bool _isDragging = false;
  bool _isLeftSideSelected = true;

  String? get selectedCardNo => _selectedCardNo;
  bool get isDragging => _isDragging;
  bool get isLeftSideSelected => _isLeftSideSelected;

  void selectCardNo(String cardNo, bool isLeftSideSelected) {
    if (!_isDragging) {
      _selectedCardNo = cardNo;
      _isLeftSideSelected = isLeftSideSelected;
      notifyListeners();
    }
  }

  void startDragging() {
    _isDragging = true;
  }

  void stopDragging() {
    _isDragging = false;
  }

  void deselectCardNo() {
    _selectedCardNo = null;
    notifyListeners();
  }
}