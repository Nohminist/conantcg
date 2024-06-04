import 'dart:math';
import 'package:conantcg/utils/color.dart';
import 'package:conantcg/widgets/card_set_name_edit.dart';
import 'package:conantcg/widgets/card_set_save_button.dart';
import 'package:conantcg/widgets/card_set_select_open_button.dart';
import 'package:conantcg/widgets/cardset_outline.dart';
import 'package:conantcg/widgets/common_icon_button.dart';
import 'package:conantcg/widgets/deck_count_text.dart';
import 'package:conantcg/widgets/deck_edit.dart';
import 'package:conantcg/widgets/hover_card.dart';
import 'package:conantcg/widgets/level_icons.dart';
import 'package:conantcg/widgets/common_show_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import '../widgets/card_display_setting.dart';
import '../widgets/card_set_edit.dart';
import '../widgets/card_grid.dart';
import '../providers/card_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CardSetBuildingTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: screenWidth > screenHeight
          ? Stack(
              children: [
                HorizontalLayout(),
                HoverCard(),
              ],
            )
          : VerticalLayout(),
    );
  }
}

class HorizontalLayout extends StatelessWidget {
  const HorizontalLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CardSetEdit(),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    commonShowModalBottomSheet(
                        context,
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: max(
                                MediaQuery.of(context).size.width * 0.5, 600),
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: CardDisplaySettingOptions(),
                          ),
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_list),
                      SizedBox(width: 5),
                      Text('カードリスト絞込み'),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: CardGrid(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class VerticalLayout extends StatefulWidget {
  @override
  _VerticalLayoutState createState() => _VerticalLayoutState();
}

class _VerticalLayoutState extends State<VerticalLayout> {
  bool _isDeckDisplay = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final cardSetManage = Provider.of<CardSetNo>(context);
    Color cardSetBgColor = getRelativeColor(context, 0.1);

    double displayableWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: cardSetBgColor,
                    child: AnimatedCrossFade(
                      duration: Duration(milliseconds: 200),
                      firstChild: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            CardSetNameEdit(),
                            SizedBox(height: 5),
                            CardSetOutline(
                              cardSetManage: cardSetManage,
                              widgetWidth: screenWidth,
                            ),
                          ],
                        ),
                      ),
                      secondChild: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            LevelIcons(),
                            SizedBox(height: 2),
                            cardSetManage.deck.length == 0
                                ? Container(
                                    height: displayableWidth / 8 * 1.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Text('デッキ（レベル別）'),
                                    ),
                                  )
                                : DeckEditWithHeightRestriction(
                                    deckNos: cardSetManage.deck,
                                    displayableWidth: screenWidth - 10,
                                    screenHeight: screenHeight,
                                  ),
                          ],
                        ),
                      ),
                      crossFadeState: _isDeckDisplay
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),
                  ),
                  // SizedBox(height: 5),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CardGrid(extraScroll: 80),
                  )),
                ],
              ),
              const Positioned(
                bottom: 16.0,
                right: 16.0,
                child: CardsDisplaySettingOpenButton(),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 5),
        Container(
          color: cardSetBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardSetSelectOpenButton(),
              CardSetSaveButton(),
              FullViewButton(),
              Column(
                children: [
                  SizedBox(height: 5),
                  SizedBox(
                    height: 35,
                    child: ToggleButtons(
                      children: <Widget>[
                        Text('概要', style: TextStyle(fontSize: 14)),
                        Text('詳細', style: TextStyle(fontSize: 14)),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          _isDeckDisplay = index == 1;
                        });
                      },
                      isSelected: [
                        _isDeckDisplay == false,
                        _isDeckDisplay == true
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 10),
                  DeckCountText(deck: cardSetManage.deck),
                ],
              )
            ],
          ),
        ),
        Container(
          height: 5,
          color: cardSetBgColor,
        ),
      ],
    );
  }
}

class FullViewButton extends StatelessWidget {
  const FullViewButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CommonIconButton(
      icon: const Icon(Icons.fullscreen),
      text: '全表示',
      onPressed: () {
        commonShowModalBottomSheet(context, CardSetEditVertical());
      },
    );
  }
}

class CardsDisplaySettingOpenButton extends StatelessWidget {
  const CardsDisplaySettingOpenButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        commonShowModalBottomSheet(context, CardDisplaySettingOptions());
      },
      child: const Icon(Icons.filter_list),
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
