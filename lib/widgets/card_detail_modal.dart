import 'package:conantcg/utils/color.dart';
import 'package:conantcg/utils/handle_card.dart';
import 'package:conantcg/widgets/quantity_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conantcg/utils/csv_data.dart';
import 'dart:math';
import '../providers/card_provider.dart';

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
    var cardSet = Provider.of<CardSetNo>(context);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double displayableWidth = screenWidth;
    double displayableHeight = screenHeight * 0.8 + 50;
    if (displayableWidth * 1.4 > (displayableHeight - 50)) {
      displayableWidth = (displayableHeight - 50) / 1.4;
    } else {
      displayableHeight = displayableWidth * 1.4 + 50;
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
          child: SizedBox(
            width: displayableWidth,
            height: displayableHeight,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.cards.length,
                  itemBuilder: (context, index) {
                    var cardNo = widget.cards[index];
                    var card = cardNoMap.data[cardNo];
                    double cardWidth = displayableWidth;
                    double cardHeight = displayableHeight - 50;

                    int count = 0;
                    String type = card?['type'];
                    if (type == 'パートナー' && cardSet.partner == cardNo) {
                      count = 1;
                    } else if (type == '事件' && cardSet.caseCard == cardNo) {
                      count = 1;
                    } else {
                      count = cardSet.deck.where((no) => no == cardNo).length;
                    }

                    if (type == '事件') cardHeight = cardWidth / 1.4;

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                max(cardWidth, cardHeight) / 25),
                            child: SizedBox(
                              // color: Colors.blue,
                              width: cardWidth,
                              height: cardHeight,
                              child: Image.asset(
                                'assets/images/$cardNo.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          width: cardWidth,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius:
                                    BorderRadius.circular(5), // ここで角を丸くします
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: IconButton(
                                    icon: const Icon(Icons.remove,
                                        color: Colors.white),
                                    onPressed: () {
                                      card = cardNoMap.data[cardNo];
                                      if (card?['type'] == 'パートナー') {
                                        Provider.of<CardSetNo>(context,
                                                listen: false)
                                            .removePartner();
                                      } else if (card?['type'] == '事件') {
                                        Provider.of<CardSetNo>(context,
                                                listen: false)
                                            .removeCase();
                                      } else {
                                        Provider.of<CardSetNo>(context,
                                                listen: false)
                                            .removeCardFromDeck(cardNo);
                                      }
                                    },
                                  )),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child:
                                        QuantityBadge(count: count, type: type),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                      child: IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Colors.white),
                                    onPressed: () {
                                      String? errorMessage = handleCardAdd(
                                          context,
                                          cardSet,
                                          cardNo,
                                          cardNoMap.data);
                                      if (errorMessage != null) {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(errorMessage),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  top: 0,
                  bottom: 50,
                  left: 0,
                  right: displayableWidth / 2,
                  child: GestureDetector(
                    onTapUp: (TapUpDetails details) {
                      if (_pageController.page != null) {
                        _pageController.jumpToPage(
                          max(0, _pageController.page!.round() - 1),
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 50,
                  left: displayableWidth / 2,
                  right: 0,
                  child: GestureDetector(
                    onTapUp: (TapUpDetails details) {
                      if (_pageController.page != null) {
                        _pageController.jumpToPage(
                          min(_pageController.page!.round() + 1,
                              widget.cards.length - 1),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
