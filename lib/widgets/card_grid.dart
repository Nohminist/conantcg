import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';
import '../utils/filter_functions.dart';
import '../widgets/operable_card.dart';
import '../providers/card_provider.dart';
import '../widgets/quantity_badge.dart';
import '../utils/csv_data.dart';
import '../utils/handle_card.dart';
import 'dart:math';

class CardGrid extends StatelessWidget {
  final double topExtraScroll;
  final double extraScroll;
  final ScrollController? scrollController;

  CardGrid({
    this.topExtraScroll = 0.0,
    this.extraScroll = 0.0,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    var filterState = Provider.of<FilterState>(context);
    var cardSet = Provider.of<CardSetNo>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: filterState),
        ChangeNotifierProvider.value(value: cardSet),
      ],
      child: Consumer2<FilterState, CardSetNo>(
        builder: (context, filterState, cardSet, _) {
          var cardNoMap = Provider.of<CardNoMap>(context);
          var cardNos = cardNoMap.data.keys.toList();
          var filteredCardNos =
              getFilteredAndSortedData(cardNos, filterState, cardNoMap);

          return GridView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: extraScroll),
            addAutomaticKeepAlives: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1 / 1.4,
            ),
            itemCount: filteredCardNos.length,
            itemBuilder: (BuildContext context, int index) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var cardNo = filteredCardNos[index];
                  var cardData = cardNoMap.data[cardNo];

                  if (cardData == null) {
                    return Container();
                  }

                  int count = 0;
                  String type = cardData['type'];
                  if (type == 'パートナー' && cardSet.partner == cardNo) {
                    count = 1;
                  } else if (type == '事件' && cardSet.caseCard == cardNo) {
                    count = 1;
                  } else {
                    count = cardSet.deck.where((no) => no == cardNo).length;
                  }

                  return Stack(
                    children: [
                      OperableCard(
                        cardNo: cardNo,
                        cards: filteredCardNos,
                        onTap: () {
                          String? errorMessage = handleCardAdd(
                              context, cardSet, cardNo, cardNoMap.data);
                          if (errorMessage != null) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: QuantityBadge(
                            count: count,
                            type: type,
                            size: max(constraints.maxWidth / 4, 24),
                          )),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

