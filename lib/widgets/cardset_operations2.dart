// widget/cardset_operations2.dart
import 'package:conantcg/widgets/updated_date.dart';

import '../widgets/cardset_outline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../utils/csv_data.dart'; // PreCardSetをインポート
import '../utils/update_local_too.dart';
import 'package:intl/intl.dart'; // DateFormatをインポート

class SelectCardSetButton2 extends StatefulWidget {
  @override
  _SelectCardSetButton2State createState() => _SelectCardSetButton2State();
}

class _SelectCardSetButton2State extends State<SelectCardSetButton2> {
  @override
  Widget build(BuildContext context) {
    final cardSetsManager = Provider.of<CardSets>(context);
    final editingKey = Provider.of<EditingCardSetKey>(context);

    double screenWidth = MediaQuery.of(context).size.width; // 画面の幅を取得
    double screenHeight = MediaQuery.of(context).size.height;

    return IconButton(
      icon: Icon(Icons.menu),
      tooltip: 'デッキを選択する',
      onPressed: () {
        List<CardSetNo> tempCardSets =
            List.from(cardSetsManager.cardSets); // 一時的なリストを作成

        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // 追加
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return FractionallySizedBox(
                  heightFactor: 0.9, // 画面の高さの90%を覆う
                  child: Container(
                    width: screenWidth > screenHeight
                        ? screenWidth / 2
                        : screenWidth, // 幅を画面幅の半分に設定
                    child: ListView.builder(
                      itemCount: tempCardSets.length + 1, // 選択肢の数を追加
                      itemBuilder: (context, index) {
                        if (index < tempCardSets.length) {
                          var cardSet = tempCardSets[index];
                          return Dismissible(
                            key: Key(cardSet.date.toString()),
                            onDismissed: (direction) {
                              setState(() {
                                tempCardSets.removeAt(index); // 一時的なリストから削除
                              });
                            },
                            child: CardSetOption(
                                cardSet: cardSet,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                cardSetsManager: cardSetsManager),
                          );
                        } else {
                          return addedableCardSetOptions(
                            // addedableCardSetOptionsを追加
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
                );
              },
            );
          },
        ).then((_) {
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
    Key? key,
    required this.cardSet,
    required this.screenWidth,
    required this.screenHeight,
    required this.cardSetsManager,
  }) : super(key: key);

  final CardSetNo cardSet;
  final double screenWidth;
  final double screenHeight;
  final CardSets cardSetsManager;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cardSet.name.isEmpty ? 'デッキ名' : cardSet.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          UpdatedDate(date: cardSet.date),
          CardSetOutline(
            cardSetManage: cardSet,
            widgetWidth:
                screenWidth > screenHeight ? screenWidth / 2 : screenWidth,
            isReadOnly: true,
          ),
        ],
      ),
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
class addedableCardSetOptions extends StatelessWidget {
  final CardSets cardSetsManager;
  final EditingCardSetKey editingKey;
  final List<CardSetNo> tempCardSets; // tempCardSetsを追加
  final double screenWidth; // screenWidthを追加
  final double screenHeight; // screenWidthを追加

  addedableCardSetOptions({
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
              Container(
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
                      Icon(Icons.add), // 左側に「＋」アイコンを設ける
                      Text('$key で新規作成'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2), // 縦方向に隙間2pxを設ける
            ],
          );
        }).toList(),
        Container(
          width: screenWidth > screenHeight
              ? screenWidth / 2
              : screenWidth, // 幅をscreenWidth / 2に設定
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode
                  ? Colors.green[900]
                  : Colors.green[100], // テーマモードに基づいて色を設定
              alignment: Alignment.centerLeft, // ボタンの中身を左寄せに設定
            ),
            onPressed: () => _createNewCardSet(context, null, ''),
            child: Row(
              children: [
                Icon(Icons.add), // 左側に「＋」アイコンを設ける
                Text('空デッキで新規作成'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
