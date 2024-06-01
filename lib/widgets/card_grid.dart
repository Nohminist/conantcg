import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';
import '../utils/filter_functions.dart';
import '../widgets/operable_card.dart';
import '../providers/card_provider.dart';
import '../widgets/quantity_badge.dart';
import '../utils/csv_data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/handle_card.dart';

class CardGrid extends StatelessWidget {
  final double topExtraScroll;
  final double extraScroll;
  final ScrollController? scrollController;

  CardGrid({
    this.topExtraScroll = 0.0,
    this.extraScroll = 0.0,
    this.scrollController,
  }); // デフォルト値を0.0に設定

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
            addAutomaticKeepAlives: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1 / 1.4,
            ),
            itemCount: filteredCardNos.length,
            itemBuilder: (BuildContext context, int index) {
              var cardNo = filteredCardNos[index];
              var cardData = cardNoMap.data[cardNo];

              if (cardData == null) {
                return Container();
              }

              int count = 0;
              String type = cardData['type'];
              if (type == 'パートナー' && cardSet.partner == cardNo) {
                count = 1;
              } else if (type == '事件' &&
                  cardSet.caseCard == cardNo) {
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
                    top:0,
                    right:0,
                    child: QuantityBadge(
                    count: count,
                    type: type,
                  )),
                  
                ],
              );
            },
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
