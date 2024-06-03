// widgets/card_set_edit.dart.dart
import 'package:conantcg/utils/color.dart';
import 'package:conantcg/widgets/card_set_name_edit.dart';
import 'package:conantcg/widgets/card_set_save_button.dart';
import 'package:conantcg/widgets/level_icons.dart';
import 'package:conantcg/widgets/updated_date.dart';
import '../widgets/cardset_outline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import 'card_set_select_open_button.dart';
import 'deck_edit.dart';

class CardSetEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double displayableWidth = MediaQuery.of(context).size.width;
    final cardSetManage = Provider.of<CardSetNo>(context);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            children: [
              CardSetSelectOpenButton(),
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
            widgetWidth: displayableWidth / 2,
          ),
          SizedBox(height: 5),
          LevelIcons(),
          SizedBox(height: 2),
          DeckEditExpanded(deckNos: cardSetManage.deck),
        ],
      ),
    );
  }
}

class CardSetEditVertical extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double displayableWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final cardSetManage = Provider.of<CardSetNo>(context);

    return Container(
      // color: getRelativeColor(context, 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cardSetManage.name.isEmpty ? 'デッキ名' : cardSetManage.name,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          UpdatedDate(date: cardSetManage.date),
          CardSetOutline(
            cardSetManage: cardSetManage,
            widgetWidth: displayableWidth,
          ),
          SizedBox(height: 5),
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
              : DeckEditExpanded(
                  deckNos: cardSetManage.deck,
                ),
        ],
      ),
    );
  }
}
