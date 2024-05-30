import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';
import '../utils/filter_functions.dart';
import '../widgets/operable_card.dart';
import '../providers/card_provider.dart';
import '../widgets/quantity_badge.dart';
import '../utils/csv_data.dart';


class CardGrid extends StatelessWidget {
  final double extraScroll; // 追加のスクロール領域
  final ScrollController? scrollController; // 追加：スクロールコントローラ

  CardGrid({this.extraScroll = 0.0, this.scrollController}); // デフォルト値を0.0に設定


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
          var filteredCardNos = getFilteredAndSortedData(
              cardNos, filterState, cardNoMap);

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomScrollView(
              controller: scrollController, 
              slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1 / 1.4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var cardNo = filteredCardNos[index];
                      var cardData = cardNoMap.data[cardNo];

                      if (cardData == null) {
                        return Container();
                      }

                      int count = 0;
                      if (cardData['type'] == 'パートナー' && cardSet.partner == cardNo) {
                        count = 1;
                      } else if (cardData['type'] == '事件' && cardSet.caseCard == cardNo) {
                        count = 1;
                      } else {
                        count = cardSet.deck
                            .where((no) => no == cardNo)
                            .length;
                      }
                      String type = cardData['type'];

                      return Stack(
                        children: [
                          OperableCard(
                            cardNo: cardNo,
                            cards:filteredCardNos,
                            onTap: () {
                              String? errorMessage;
                              switch (cardData['type']) {
                                case 'パートナー':
                                  cardSet.setPartner(cardNo);
                                  break;
                                case '事件':
                                  cardSet.setCase(cardNo);
                                  break;
                                default:
                                  errorMessage =
                                      cardSet.addCardNoToDeck(cardNo, cardNoMap.data);
                                  break;
                              }
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
                          QuantityBadge(
                            count: count,
                            type: type,
                          ),
                        ],
                      );
                    },
                    childCount: filteredCardNos.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: extraScroll), // 追加のスクロール領域
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
