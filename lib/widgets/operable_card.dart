// widgets/operable_grid.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../widgets/card_image.dart';

class InteractiveCard extends StatelessWidget {
  final String cardNo;
  final Function onTap;

  InteractiveCard({required this.cardNo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) {
        var screenWidth = MediaQuery.of(context).size.width;
        var hoverPosition = _.position.dx;
        var isLeftSideSelected = hoverPosition < (screenWidth / 2 + 20);
        Provider.of<DetailCardNo>(context, listen: false)
            .selectCardNo(cardNo, isLeftSideSelected); // 更新
      },
      onExit: (_) {
        Provider.of<DetailCardNo>(context, listen: false)
            .deselectCardNo(); // 追加
      },
      child: GestureDetector(
        onPanStart: (_) {
          Provider.of<DetailCardNo>(context, listen: false)
              .startDragging(); // 変更
        },
        onPanEnd: (_) {
          Provider.of<DetailCardNo>(context, listen: false)
              .stopDragging(); // 変更
        },
        onTap: () {
          onTap();
          Provider.of<DetailCardNo>(context, listen: false)
              .deselectCardNo(); // 変更
        },
        onLongPress: () {
          var screenWidth = MediaQuery.of(context).size.width;
          var screenHeight = MediaQuery.of(context).size.height;
          var cardAspectRatio = 1.4; // カードの縦横比
          var margin = 50.0; // マージンを設定

          // 画面の縦横比に基づいてカードのサイズを調整
          var displayWidth = screenWidth - margin;
          var displayHeight = displayWidth * cardAspectRatio;

          if (displayHeight > screenHeight - margin) {
            displayHeight = screenHeight - margin;
            displayWidth = displayHeight / cardAspectRatio;
          }

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: displayWidth,
                    height: displayHeight,
                    child: CardImage9(cardNo: cardNo), // 変更
                  ),
                ),
              );
            },
          );
        },
        child: CardImage9(cardNo: cardNo), // 変更
      ),
    );
  }
}
