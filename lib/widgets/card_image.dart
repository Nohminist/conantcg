// widgets/card_image.dart
import 'package:flutter/material.dart';
import 'dart:math';

class CardImage9 extends StatelessWidget {
  final String cardNo; // 変更

  CardImage9({required this.cardNo}); // 変更

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // print('Max width: ${constraints.maxWidth}'); // この行を追加
        // print('Max width: ${constraints.maxHeight}'); // この行を追加
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(max(constraints.maxWidth, constraints.maxHeight) / 25), // 半径を幅に合わせる
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0), // 余分なマージンを削除します
          child: Image.asset(
            'assets/images/${cardNo}.jpg', // 変更
            // fit: BoxFit.cover,
            fit: BoxFit.scaleDown,
          ),
        );
      },
    );
  }
}


class CardImage8 extends StatelessWidget {
  final String cardNo;
  final double width;
  final double height;

  CardImage8({required this.cardNo, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius:
BorderRadius.circular(max(width, height) / 25),
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0), // 余分なマージンを削除します
          child: Image.asset(
            'assets/images/${cardNo}.jpg', // 変更
            // fit: BoxFit.cover,
            fit: BoxFit.scaleDown,
          ),
        );
      },
    );
  }
}

// class CardImage extends StatelessWidget {
//   final Map<String, dynamic> cardData;

//   CardImage({required this.cardData});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         double cardWidth = constraints.maxWidth;
//         double cardHeight = cardWidth * 1.4;
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(cardHeight / 25), // 半径を幅に合わせる
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Image.asset(
//             'assets/images/${cardData['No.']}.jpg',
//             width: cardWidth,
//             height: cardHeight, // 高さを幅と一致させるから、高さをカードの高さに変更
//             fit: BoxFit.cover,
//           ),
//         );
//       },
//     );
//   }
// }

class CardImage extends StatelessWidget {
  final Map<String, dynamic> cardData;

  CardImage({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //  print('Max width: ${constraints.maxWidth}'); // この行を追加
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(constraints.maxWidth / 25), // 半径を幅に合わせる
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0), // 余分なマージンを削除します
          child: Image.asset(
            'assets/images/${cardData['No.']}.jpg',
            // fit: BoxFit.cover,
            fit: BoxFit.scaleDown,
          ),
        );
      },
    );
  }
}

class CardImage3 extends StatelessWidget {
  final Map<String, dynamic> cardData;

  CardImage3({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(constraints.maxWidth / 25),
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0),
          child: Align(
            alignment: Alignment.topCenter, // ここを追加
            child: Image.asset(
              'assets/images/${cardData['No.']}.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
        );
      },
    );
  }
}

class CardImage2 extends StatelessWidget {
  final Map<String, dynamic> cardData;
  final double cardWidth;
  final double cardHeight;

  CardImage2({
    required this.cardData,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardHeight / 25),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/${cardData['No.']}.jpg',
        width: cardWidth,
        height: cardHeight,
        fit: BoxFit.cover,
      ),
    );
  }
}
