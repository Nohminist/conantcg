import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conantcg/utils/csv_data.dart';

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

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double widgetWidth = screenWidth;
    double widgetHeight = screenHeight * 0.8;

    if (widgetWidth * 1.4 > widgetHeight) {
      widgetWidth = widgetHeight / 1.4;
    } else {
      widgetHeight = widgetWidth * 1.4;
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Center(
          child: Container(
            width: widgetWidth,
            height: widgetHeight,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.cards.length,
              itemBuilder: (context, index) {
                var cardNo = widget.cards[index];
                var card = cardNoMap.data[cardNo];
                double cardWidth = widgetWidth;
                double cardHeight = widgetHeight;
                if (card?['type'] == '事件') cardHeight = cardWidth / 1.4 / 1.4;

                return GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(cardHeight / 25),
                    child: SizedBox(
                      // color: Colors.blue,
                      width: cardWidth,
                      height: cardHeight,
                      child: Image.asset(
                        'assets/images/${cardNo}.jpg',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
