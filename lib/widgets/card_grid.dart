import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';
import '../utils/filter_functions.dart';
import '../widgets/operable_card.dart';
import '../providers/card_provider.dart';
import '../widgets/quantity_badge.dart';
import '../utils/csv_data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
          var filteredCardNos =
              getFilteredAndSortedData(cardNos, filterState, cardNoMap);

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
                      if (cardData['type'] == 'パートナー' &&
                          cardSet.partner == cardNo) {
                        count = 1;
                      } else if (cardData['type'] == '事件' &&
                          cardSet.caseCard == cardNo) {
                        count = 1;
                      } else {
                        count = cardSet.deck.where((no) => no == cardNo).length;
                      }
                      String type = cardData['type'];

                      return Stack(
                        children: [
                          OperableCard(
                            cardNo: cardNo,
                            cards: filteredCardNos,
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
                                  errorMessage = cardSet.addCardNoToDeck(
                                      cardNo, cardNoMap.data);
                                  break;
                              }
                              if (errorMessage != null) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
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
                MyWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}


class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late NativeAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // 広告ユニット ID を設定
    final adUnitId = 'ca-pub-2638532378115029/6141218897';

    // 広告ウィジェットを作成
    _ad = NativeAd(
      adUnitId: adUnitId,
      factoryId: 'adFactoryExample',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          setState(() {
            _isAdLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isAdLoaded ? AdWidget(ad: _ad) : Container(),
    );
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }
}