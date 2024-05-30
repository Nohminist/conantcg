// widgets/editing_card_set.dart
import '../widgets/cardset_outline.dart';
import '../utils/update_local_too.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../widgets/cardset_operations2.dart';
import '../widgets/editing_deck.dart';
import '../widgets/level_icon.dart';

class EditingCardSet extends StatefulWidget {
  @override
  _EditingCardSetState createState() => _EditingCardSetState();
}

class _EditingCardSetState extends State<EditingCardSet> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // screenWidthをここで定義

    return Consumer3<CardSetNo, CardSets, EditingCardSetKey>(
      builder: (context, current, cardSets, editingKey, child) {
        _controller.text = current.name;

        return Column(
          children: [
            EditMenus(
              current: current,
              cardSets: cardSets,
              editingKey: editingKey,
              controller: _controller,
            ),
            CardSetOutline(
              current: current, // currentを渡す
              widgetWidth: screenWidth / 2, // screenWidthを渡す
            ),
            SizedBox(height:10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: List.generate(8, (level) {
                  return Expanded(child: LevelIcon(level: level));
                }),
              ),
            ),
            DeckDisplay(deckNos: current.deck),
          ],
        );
      },
    );
  }
}

class EditMenus extends StatelessWidget {
  final CardSetNo current;
  final CardSets cardSets;
  final EditingCardSetKey
      editingKey; // EditingCardSetIndexをEditingCardSetKeyに変更
  final TextEditingController controller;

  EditMenus({
    required this.current,
    required this.cardSets,
    required this.editingKey,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    int editingIndex = cardSets.getEditingIndex(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          // Text('$editingIndex'),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (value) {
                current.setName(value);
              },
              decoration: InputDecoration(
                labelText: 'デッキ名',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
          ),
          SizedBox(width: 5),
          IconButton(
            onPressed: () async {
              // ProviderからEditingCardSetKeyを取得
              // EditingCardSetKey editingKey =
              //     Provider.of<EditingCardSetKey>(context, listen: false);

              // // 現在のEditingCardSetKeyと一致するCardSetを探す
              // int editingIndex = cardSets.cardSets
              //     .indexWhere((cardSet) => cardSet.date == editingKey.date);

              //編集中のindexを取得する
              int editingIndex = cardSets.getEditingIndex(context);

              print('editingIndex$editingIndex');

              // 現在日時を取得
              DateTime now = DateTime.now();

              // 現在日時を設定
              current.date = now;

              // EditingCardSetKeyとローカルストレージの更新
              await updateEditingKeyAndStorage(now, context);

// CardSetsに保存
              cardSets.saveCurrentCardSet(editingIndex, current);
            },
            icon: Icon(Icons.save),
            tooltip: '編集状態を確定する',
          ),
          SizedBox(width: 5),
          // SaveImageButton(cardSet: current),機能しない
          SelectCardSetButton2(),
        ],
      ),
    );
  }
}
