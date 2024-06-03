// screens/card_set_building_top.dart
import 'dart:math';

import 'package:conantcg/widgets/card_set_name_edit.dart';
import 'package:conantcg/widgets/card_set_save_button.dart';
import 'package:conantcg/widgets/card_set_select_open_button.dart';
import 'package:conantcg/widgets/cardset_outline.dart';
import 'package:conantcg/widgets/deck_edit3.dart';
import 'package:conantcg/widgets/hover_card.dart';
import 'package:conantcg/widgets/level_icons.dart';
import 'package:conantcg/widgets/rotating_arrow_drop_icon.dart';
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor:
                              Theme.of(context).canvasColor.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: max(
                                MediaQuery.of(context).size.width * 0.5, 600),
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: CardDisplaySettingOptions(),
                          ),
                        );
                      },
                    );
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VerticalScreen(),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: CardsDisplaySettingOpenButton(),
        ),
      ],
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
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).canvasColor.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: Column(
                children: [
                  Expanded(
                    child: CardDisplaySettingOptions(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 10.0, top: 0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close),
                          Text('閉じる'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
      child: Icon(Icons.filter_list),
    );
  }
}

class VerticalScreen extends StatelessWidget {
  const VerticalScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalEditingCardSet(),
        SizedBox(height: 5),
        Expanded(
          child: CardGrid(extraScroll: 80),
        ),
      ],
    );
  }
}

class VerticalEditingCardSet extends StatefulWidget {
  @override
  _VerticalEditingCardSetState createState() => _VerticalEditingCardSetState();
}

class _VerticalEditingCardSetState extends State<VerticalEditingCardSet> {
  bool _isExpanded = true;
  bool _isThirdChild = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final cardSetManage = Provider.of<CardSetNo>(context);

    return Column(
      children: [
        Row(
          children: [
            CardSetSelectOpenButton(),
            CardSetSaveButton(),
            IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => FractionallySizedBox(
                    heightFactor: 0.9,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: CardSetEdit2(),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('閉じる'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                setState(() {
                  _isExpanded = false;
                  _isThirdChild = false;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.add_to_photos),
              onPressed: () {
                setState(() {
                  _isExpanded = true;
                  _isThirdChild = false;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.hide_source),
              onPressed: () {
                setState(() {
                  _isThirdChild = true;
                });
              },
            ),
          ],
        ),
        _isThirdChild
            ? Container() // ここにthirdChildの内容を追加してください
            : AnimatedCrossFade(
                duration: Duration(milliseconds: 200),
                firstChild: CardSetOutline(
                  cardSetManage: cardSetManage,
                  widgetWidth: screenWidth,
                ),
                secondChild: Column(
                  children: [
                    LevelIcons(),
                    SizedBox(height: 2),
                    DeckEditWithHeightRestriction(
                      deckNos: cardSetManage.deck,
                      displayableWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                  ],
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
      ],
    );
  }
}
