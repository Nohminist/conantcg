import 'package:conantcg/widgets/card_set_outline2.dart';
import 'package:conantcg/widgets/common_icon_button.dart';
import 'package:conantcg/widgets/common_show_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../utils/csv_data.dart';
import '../utils/update_local_too.dart';

class CardSetSelectOpenButton extends StatefulWidget {
  @override
  _CardSetSelectOpenButtonState createState() =>
      _CardSetSelectOpenButtonState();
}

class _CardSetSelectOpenButtonState extends State<CardSetSelectOpenButton> {
  @override
  Widget build(BuildContext context) {
    final cardSetsManager = Provider.of<CardSets>(context);
    final editingKey = Provider.of<EditingCardSetKey>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return CommonIconButton(
      icon: const Icon(Icons.menu),
      text: '選択',
      onPressed: () {
        List<CardSetNo> tempCardSets =
            List.from(cardSetsManager.cardSets); // 一時的なリスト

        List<int> removedIndexes = []; //一時的な削除インデックス

        commonShowModalBottomSheet(
          context,
          SizedBox(
            width: screenWidth > screenHeight ? screenWidth / 2 : screenWidth,
            child: ListView.builder(
              itemCount: tempCardSets.length + 1, // 選択肢の数を追加
              itemBuilder: (context, index) {
                if (index < tempCardSets.length) {
                  var cardSet = tempCardSets[index];
                  return Dismissible(
                    key: Key(cardSet.date.toString()),
                    onDismissed: (direction) {
                      setState(() {
                        removedIndexes.add(index); // 削除されたアイテムのインデックスを保存
                      });
                    },
                    child: CardSetOption(
                        cardSet: cardSet,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        cardSetsManager: cardSetsManager),
                  );
                } else {
                  return AddedableCardSetOptions(
                    // AddedableCardSetOptionsを追加
                    cardSetsManager: cardSetsManager,
                    editingKey: editingKey,
                    tempCardSets: tempCardSets,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  );
                }
              },
            ),
          ),
        ).then((_) {
          for (int i = tempCardSets.length - 1; i >= 0; i--) {
            if (removedIndexes.contains(i)) {
              tempCardSets.removeAt(i);
            }
          }

          // モーダルが閉じるときに状態を更新(削除したり追加したのをここで反映させる)
          cardSetsManager.cardSets = tempCardSets;

          // tempCardSetsが空配列の場合の処理を追加
          if (tempCardSets.isEmpty) {
            var newCardSet = CardSetNo(); // 初期化されたcardSetを作成
            editingKey.setDate(DateTime.now()); // editingKey.setDateに今の日時を入れる
            cardSetsManager.cardSets = [
              CardSetNo.copy(newCardSet)
            ]; // 配列長さ1で初期化されたcardSetをディープコピーする
            Provider.of<CardSetNo>(context, listen: false)
                .copyFrom(cardSetsManager.cardSets[0]);
          } else {
            // cardSets[i].dateのいずれもeditingKeyに一致しない場合。つまり、編集中のCardSetを削除した場合。
            if (!cardSetsManager.cardSets
                .any((cardSet) => cardSet.date == editingKey.date)) {
              editingKey.setDate(cardSetsManager.cardSets[0].date);
              Provider.of<CardSetNo>(context, listen: false)
                  .copyFrom(cardSetsManager.cardSets[0]);
            }
          }
        });
      },
    );
  }
}

class CardSetOption extends StatelessWidget {
  const CardSetOption({
    super.key,
    required this.cardSet,
    required this.screenWidth,
    required this.screenHeight,
    required this.cardSetsManager,
  });

  final CardSetNo cardSet;
  final double screenWidth;
  final double screenHeight;
  final CardSets cardSetsManager;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: CardSetOutline2(
          cardSet: cardSet,
          screenWidth: screenWidth,
          screenHeight: screenHeight),
      onTap: () async {
        var selectedCardSet = cardSetsManager.cardSets
            .firstWhere((set) => set.date == cardSet.date);
        Provider.of<CardSetNo>(context, listen: false)
            .copyFrom(selectedCardSet);
        await updateEditingKeyAndStorage(cardSet.date, context);
        Navigator.pop(context);
      },
    );
  }
}

//スターターデッキなど新規作成用
class AddedableCardSetOptions extends StatelessWidget {
  final CardSets cardSetsManager;
  final EditingCardSetKey editingKey;
  final List<CardSetNo> tempCardSets; // tempCardSetsを追加
  final double screenWidth; // screenWidthを追加
  final double screenHeight; // screenWidthを追加

  const AddedableCardSetOptions({
    super.key,
    required this.cardSetsManager,
    required this.editingKey,
    required this.tempCardSets, // tempCardSetsを追加
    required this.screenWidth, // screenWidthを追加
    required this.screenHeight, // screenWidthを追加
  });

  void _createNewCardSet(BuildContext context,
      Map<String, dynamic>? productData, String key) async {
    var newCardSet = CardSetNo();
    newCardSet.date = DateTime.now(); // 現在日時を設定
    // print('date${newCardSet.date}');

    if (productData != null) {
      productData['deckNumbers']?.forEach((no) {
        newCardSet.deck.add(no);
      });
      newCardSet.partner = productData['partnerNumber'];
      newCardSet.caseCard = productData['caseNumber'];
      newCardSet.name = key;
    }

    tempCardSets.add(newCardSet); // tempCardSetsに新しいカードセットを追加

    await updateEditingKeyAndStorage(
        newCardSet.date, context); // updateEditingKeyAndStorage関数を呼び出す

    Provider.of<CardSetNo>(context, listen: false)
        .copyFrom(newCardSet); // newCardSetをコピー

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final preCardSet = Provider.of<PreCardSet>(context);
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark; // テーマモードを取得

    return Column(
      children: [
        ...preCardSet.data.keys.map((key) {
          return Column(
            children: [
              SizedBox(
                width:
                    screenWidth > screenHeight ? screenWidth / 2 : screenWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? Colors.green[900]
                        : Colors.green[100], // テーマモードに基づいて色を設定
                    alignment: Alignment.centerLeft, // ボタンの中身を左寄せに設定
                  ),
                  onPressed: () =>
                      _createNewCardSet(context, preCardSet.data[key], key),
                  child: Row(
                    children: [
                      const Icon(Icons.add), // 左側に「＋」アイコンを設ける
                      Text('$key で新規作成'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2), // 縦方向に隙間2pxを設ける
            ],
          );
        }).toList(),
        SizedBox(
          width: screenWidth > screenHeight
              ? screenWidth / 2
              : screenWidth, // 幅をscreenWidth / 2に設定
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? Colors.green[900] : Colors.green[100],
              alignment: Alignment.centerLeft, // ボタンの中身を左寄せに設定
            ),
            onPressed: () => _createNewCardSet(context, null, ''),
            child: const Row(
              children: [
                Icon(Icons.add),
                Text('空デッキで新規作成'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
