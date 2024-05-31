// widgets/card_set_edit.dart.dart
import 'package:conantcg/utils/color.dart';
import 'package:conantcg/widgets/card_set_name_edit.dart';
import 'package:conantcg/widgets/card_set_save_button.dart';
import 'package:conantcg/widgets/deck_edit2.dart';
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: CardSetNameEdit(),
              ),
              SizedBox(width: 5),
              CardSetSaveButton(),
              SizedBox(width: 5),
              // SaveImageButton(cardSet: cardSetManage),機能しない
              SelectCardSetButton2(),
            ],
          ),
        ),
        CardSetOutline(
          cardSetManage: cardSetManage,
          widgetWidth: screenWidth / 2,
        ),
        SizedBox(height: 10),
        LevelIcons(),
        DeckEdit(deckNos: cardSetManage.deck),
      ],
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
      color: getRelativeColor(context, 0.05),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: CardSetNameEdit(),
                ),
                SizedBox(width: 5),
                CardSetSaveButton(),
                SizedBox(width: 5),
                // SaveImageButton(cardSet: cardSetManage),機能しない
                SelectCardSetButton2(),
              ],
            ),
          ),
          CardSetOutline(
            cardSetManage: cardSetManage,
            widgetWidth: screenWidth,
          ),
          SizedBox(height: 10),
          LevelIcons(),
          DeckEdit3(deckNos: cardSetManage.deck,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          )
        ],
      ),
    );
  }
}
