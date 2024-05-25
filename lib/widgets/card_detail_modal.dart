// widgets/card_detail_modal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/card_image.dart';
import '../utils/csv_data.dart';

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
    var cardNoMapData = Provider.of<CardNoMapData>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var displayWidth = screenWidth * 0.8;
    var displayHeight = screenHeight * 0.8;

    if (displayWidth > (displayHeight * 1.4)) {
      displayWidth = displayHeight / 1.4;
    } else {
      displayHeight = displayWidth * 1.4;
    }

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
              color: Colors.transparent,
            ),
          ),
          // Center widget
          Center(
            child: GestureDetector(
              onTap: () {}, // Prevent taps from propagating to the stack behind
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 追加
                  children: [
                    ArrowButton(
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
                    SizedBox(
                      width: displayWidth,
                      height: displayHeight,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.cards.length,
                        itemBuilder: (context, index) {
                          // カードのタイプによって高さを変更する
                          var cardType =
                              cardNoMapData.data[widget.cards[index]]?['type'];
                          var dynamicHeight = cardType == '事件'
                              ? displayWidth / 1.4 / 1.4
                              : displayHeight;

                          return SizedBox(
                            width: displayWidth,
                            height: dynamicHeight,
                            child: CardImage9(
                              cardNo: widget.cards[index],
                            ),
                          );
                        },
                      ),
                    ),
                    ArrowButton(
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        if (_pageController.hasClients) {
                          int newPageIndex =
                              (_pageController.page!.round() + 1) %
                                  widget.cards.length;
                          _pageController.animateToPage(
                            newPageIndex,
                            duration: Duration(milliseconds: 1),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
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
