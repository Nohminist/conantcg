// widgets/card_set_edit.dart.dart
import 'package:conantcg/utils/color.dart';
import 'package:conantcg/widgets/card_set_name_edit.dart';
import 'package:conantcg/widgets/card_set_save_button.dart';
import 'package:conantcg/widgets/deck_edit3.dart';
import 'package:conantcg/widgets/level_icons.dart';
import '../widgets/cardset_outline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../widgets/cardset_operations2.dart';
import 'deck_edit.dart';

class CardSetEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final cardSetManage = Provider.of<CardSetNo>(context);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            children: [
              SelectCardSetButton2(),
              SizedBox(width: 5),
              CardSetSaveButton(),
              SizedBox(width: 5),
              Expanded(
                child: CardSetNameEdit(),
              ),
              // SaveImageButton(cardSet: cardSetManage),機能しない
            ],
          ),
          SizedBox(height: 5),
          CardSetOutline(
            cardSetManage: cardSetManage,
            widgetWidth: screenWidth / 2,
          ),
          SizedBox(height: 5),
          LevelIcons(),
          SizedBox(height: 2),
          DeckEdit(deckNos: cardSetManage.deck),
        ],
      ),
    );
  }
}

class CardSetEdit2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final cardSetManage = Provider.of<CardSetNo>(context);

    return Container(
      color: getRelativeColor(context, 0.15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                SelectCardSetButton2(),
                SizedBox(width: 5),
                CardSetSaveButton(),
                SizedBox(width: 5),

                Expanded(
                  child: CardSetNameEdit(),
                ),
                // SaveImageButton(cardSet: cardSetManage),機能しない
              ],
            ),
          ),
          CardSetOutline(
            cardSetManage: cardSetManage,
            widgetWidth: screenWidth,
          ),
          SizedBox(height: 5),
          LevelIcons(),
          SizedBox(height: 2),
          DeckEdit3(
            deckNos: cardSetManage.deck,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          )
        ],
      ),
    );
  }
}
