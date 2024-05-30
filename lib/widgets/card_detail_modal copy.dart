// widgets/card_detail_modal.dart
import 'package:conantcg/utils/csv_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class CardDetailModal extends StatefulWidget {
  final List<String> cards;
  final String initialCardNo;

  CardDetailModal({required this.cards, required this.initialCardNo});

  @override
  _CardDetailModalState createState() => _CardDetailModalState();
}

class _CardDetailModalState extends State<CardDetailModal> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.cards.indexOf(widget.initialCardNo));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cardNoMap = Provider.of<CardNoMap>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    print('screenWidth${screenWidth}');
    print('screenHeight${screenHeight}');

    var displayWidth = screenWidth * 0.5;
    var displayHeight = screenHeight * 0.5;

    if ((displayWidth * 1.4) > displayHeight) {
      displayWidth = displayHeight / 1.4;
    } else {
      displayHeight = displayWidth * 1.4;
    }

    print('displayWidth${displayWidth}');
    print('displayHeight${displayHeight}');

    return Dialog(
      
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // GestureDetector to detect tap outside the Center widget
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.purple,
            ),
          ),
          // Center widget
          Center(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.cards.length,
              itemBuilder: (context, index) {
                // カードのタイプによって高さを変更する
                var cardType = cardNoMap.data[widget.cards[index]]?['type'];
                var dynamicHeight =
                    cardType == '事件' ? displayWidth / 1.4 / 1.4 : displayHeight;

                return GestureDetector(
                  onTap: () {},
                  child: CardImageModal(
                    cardNo: widget.cards[index],
                    width: displayWidth,
                    // height: dynamicHeight,
                    height: displayHeight,
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            child: ArrowButton(
              icon: Icons.arrow_back,
              onPressed: () {
                if (_pageController.hasClients) {
                  int newPageIndex = (_pageController.page!.round() -
                          1 +
                          widget.cards.length) %
                      widget.cards.length;
                  _pageController.animateToPage(
                    newPageIndex,
                    duration: Duration(milliseconds: 1),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            right: 0,
            child: ArrowButton(
              icon: Icons.arrow_forward,
              onPressed: () {
                if (_pageController.hasClients) {
                  int newPageIndex =
                      (_pageController.page!.round() + 1) % widget.cards.length;
                  _pageController.animateToPage(
                    newPageIndex,
                    duration: Duration(milliseconds: 1),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  ArrowButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon),
          color: Colors.white, // アイコンの色を変更
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class CardImageModal extends StatelessWidget {
  final String cardNo;
  final double width; // 追加
  final double height; // 追加

  CardImageModal(
      {required this.cardNo, required this.width, required this.height}); // 変更

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(max(width, height) / 25),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(0),
      child: Image.asset(
        width: width,
        height: height,
        'assets/images/${cardNo}.jpg',
      ),
    );
  }
}


// class CardImageModal extends StatelessWidget {
//   final String cardNo; // 変更

//   CardImageModal({required this.cardNo}); // 変更

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         // print('Max width: ${constraints.maxWidth}'); // この行を追加
//         // print('Max width: ${constraints.maxHeight}'); // この行を追加
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(
//                 max(constraints.maxWidth, constraints.maxHeight) /
//                     25), // 半径を幅に合わせる
//           ),
//           clipBehavior: Clip.antiAlias,
//           margin: EdgeInsets.all(0), // 余分なマージンを削除します
//           child: Image.asset(
//             'assets/images/${cardNo}.jpg', // 変更
//             // fit: BoxFit.cover,
//             // fit: BoxFit.scaleDown,
//           ),
//         );
//       },
//     );
//   }
// }
