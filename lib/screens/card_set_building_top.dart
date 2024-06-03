// screens/card_set_building_top.dart
import 'dart:math';

import 'package:conantcg/utils/color.dart';
import 'package:conantcg/widgets/card_set_name_edit.dart';
import 'package:conantcg/widgets/card_set_save_button.dart';
import 'package:conantcg/widgets/card_set_select_open_button.dart';
import 'package:conantcg/widgets/cardset_outline.dart';
import 'package:conantcg/widgets/common_icon_button.dart';
import 'package:conantcg/widgets/deck_edit3.dart';
import 'package:conantcg/widgets/hover_card.dart';
import 'package:conantcg/widgets/level_icons.dart';
import 'package:conantcg/widgets/rotating_arrow_drop_icon.dart';
import 'package:conantcg/widgets/common_show_modal_bottom_sheet.dart';
import 'package:conantcg/widgets/transparent_button.dart';
import 'package:flutter/material.dart';
import '../widgets/card_display_setting.dart';
import '../widgets/card_set_edit.dart';
import '../widgets/card_grid.dart';
import 'package:flutter/gestures.dart'; // 追加
import 'package:flutter/rendering.dart';
import '../providers/card_provider.dart';
import 'package:provider/provider.dart';

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
  bool _isExpanded = true;
  bool _isThirdChild = false;

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
                    child: _isThirdChild
                        ? Container()
                        : AnimatedCrossFade(
                            duration: Duration(milliseconds: 200),
                            firstChild: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CardSetOutline(
                                cardSetManage: cardSetManage,
                                widgetWidth: screenWidth,
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
                                        height: displayableWidth /8 *1.4,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey),
                                            borderRadius: BorderRadius.circular(
                                                5),
                                          ),
                                          child: const Center(
                                            child:
                                                Text('デッキ（レベル別）'), 
                                          ),
                                        )
                                      : DeckEditWithHeightRestriction(
                                          deckNos: cardSetManage.deck,
                                          displayableWidth: screenWidth,
                                          screenHeight: screenHeight,
                                        ),
                                ],
                              ),
                            ),
                            crossFadeState: _isExpanded
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
              CardSetNameEditButton(),
              CommonIconButton(
                icon: const Icon(Icons.add_box),
                text: 'デッキ外',
                onPressed: () {
                  setState(() {
                    _isExpanded = false;
                    _isThirdChild = false;
                  });
                },
              ),
              CommonIconButton(
                icon: const Icon(Icons.add_to_photos),
                text: 'デッキ内',
                onPressed: () {
                  setState(() {
                    _isExpanded = true;
                    _isThirdChild = false;
                  });
                },
              ),
              FullViewButton(),
              CommonIconButton(
                icon: const Icon(Icons.hide_source),
                text: '非表示',
                onPressed: () {
                  setState(() {
                    _isThirdChild = true;
                  });
                },
              ),
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
      text: '全容',
      onPressed: () {
        commonShowModalBottomSheet(context, CardSetEdit2());
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
