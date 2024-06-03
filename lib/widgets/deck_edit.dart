import 'dart:math';
import '../utils/csv_data.dart';
import '../widgets/quantity_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../widgets/operable_card.dart';
import 'package:tuple/tuple.dart';

class DeckEditExpanded extends StatelessWidget {
  final List<String> deckNos;

  DeckEditExpanded({required this.deckNos});

  @override
  Widget build(BuildContext context) {
    var deckData = getDeckData(deckNos, context);

    return Expanded(
      child: DeckEditWidget(deckNos: deckNos, newArray: deckData.item2),
    );
  }
}

class DeckEditWithHeightRestriction extends StatelessWidget {
  final List<String> deckNos;
  final double displayableWidth;
  final double screenHeight;

  DeckEditWithHeightRestriction(
      {required this.deckNos,
      required this.displayableWidth,
      required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    var deckData = getDeckData(deckNos, context);

    return SizedBox(
      height: min(
          (displayableWidth) / 8 * 1.4 * deckData.item1, screenHeight / 2.5),
      child: DeckEditWidget(deckNos: deckNos, newArray: deckData.item2),
    );
  }
}

Tuple2<int, List<Map<String, int>?>> getDeckData(
    List<String> deckNos, BuildContext context) {
  var cardNoMap = Provider.of<CardNoMap>(context);

  // レベルごとにカードを分類
  List<List<String>> levelSortedDeck = List.generate(8, (_) => []);
  List<Map<String, int>> levelCardCounts = List.generate(8, (_) => {});

  for (var cardNo in deckNos) {
    var cardData = cardNoMap.data[cardNo];
    if (cardData != null && cardData['Lv.'] != null) {
      levelSortedDeck[cardData['Lv.'] - 1].add(cardNo);
    }
  }

  for (int level = 0; level < 8; level++) {
    // 各カードの出現回数をカウント
    Map<String, int> cardCounts = {};
    for (var cardNo in levelSortedDeck[level]) {
      if (cardCounts.containsKey(cardNo)) {
        cardCounts[cardNo] = cardCounts[cardNo]! + 1;
      } else {
        cardCounts[cardNo] = 1;
      }
    }
    levelCardCounts[level] = cardCounts;
  }

  // 最も長い配列の長さを取得
  int maxLength =
      levelCardCounts.map((e) => e.length).reduce((a, b) => a > b ? a : b);

  List<Map<String, int>?> newArray = [];

  for (int i = 0; i < maxLength; i++) {
    for (int level = 0; level < 8; level++) {
      if (levelCardCounts[level].length > i) {
        var keys = levelCardCounts[level].keys.toList();
        var values = levelCardCounts[level].values.toList();
        newArray.add({keys[i]: values[i]});
      } else {
        newArray.add(null);
      }
    }
  }

  return Tuple2(maxLength, newArray);
}

class DeckEditWidget extends StatelessWidget {
  final List<String> deckNos;
  final List<Map<String, int>?> newArray;

  DeckEditWidget({required this.deckNos, required this.newArray});

  @override
  Widget build(BuildContext context) {
    var cardNoMap = Provider.of<CardNoMap>(context);

    return GridView.count(
      crossAxisCount: 8,
      childAspectRatio: 1 / 1.4,
      children: List.generate(newArray.length, (index) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (newArray[index] == null) {
              return Container();
            } else {
              var cardNo = newArray[index]!.keys.first;
              var count = newArray[index]!.values.first;
              var cardData = cardNoMap.data[cardNo];

              if (cardData == null || cardData['type'] == null) {
                return Container();
              }

              return Stack(
                children: [
                  OperableCard(
                    cardNo: cardNo,
                    cards: getSortedUniqueDeckNos(newArray, cardNoMap),
                    onTap: () {
                      Provider.of<CardSetNo>(context, listen: false)
                          .removeCardFromDeck(cardNo);
                    },
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: QuantityBadge(
                        count: count,
                        type: cardData['type'],
                        size: max(constraints.maxWidth / 4, 24),
                      )),
                ],
              );
            }
          },
        );
      }),
    );
  }
}

List<String> getSortedUniqueDeckNos(
    List<Map<String, int>?> newArray, CardNoMap cardNoMap) {
  var uniqueDeckNos = newArray
      .where((element) => element != null)
      .map((e) => e!.keys.first)
      .toSet()
      .toList();
  uniqueDeckNos.sort((a, b) {
    var cardDataA = cardNoMap.data[a];
    var cardDataB = cardNoMap.data[b];
    if (cardDataA == null || cardDataA['Lv.'] == null) {
      return 1;
    } else if (cardDataB == null || cardDataB['Lv.'] == null) {
      return -1;
    } else {
      return cardDataA['Lv.'].compareTo(cardDataB['Lv.']);
    }
  });
  return uniqueDeckNos;
}




// class DeckEditExpanded extends StatelessWidget {
//   final List<String> deckNos;

//   DeckEditExpanded({required this.deckNos});

//   @override
//   Widget build(BuildContext context) {
//     var cardNoMap = Provider.of<CardNoMap>(context);
//     var uniqueDeckNos = deckNos.toSet().toList();

//     // レベルごとにカードを分類
//     List<List<String>> levelSortedDeck = List.generate(8, (_) => []);
//     List<Map<String, int>> levelCardCounts = List.generate(8, (_) => {});

//     for (var cardNo in deckNos) {
//       var cardData = cardNoMap.data[cardNo];
//       if (cardData != null && cardData['Lv.'] != null) {
//         levelSortedDeck[cardData['Lv.'] - 1].add(cardNo);
//       }
//     }

//     for (int level = 0; level < 8; level++) {
//       // 各カードの出現回数をカウント
//       Map<String, int> cardCounts = {};
//       for (var cardNo in levelSortedDeck[level]) {
       
//         if (cardCounts.containsKey(cardNo)) {
         
//           cardCounts[cardNo] = cardCounts[cardNo]! + 1;
//         } else {
//           cardCounts[cardNo] = 1;
//         }
//       }
//       levelCardCounts[level] = cardCounts;
//     }

//     // 最も長い配列の長さを取得
//     int maxLength =
//         levelCardCounts.map((e) => e.length).reduce((a, b) => a > b ? a : b);

//     List<Map<String, int>?> newArray = [];

//     for (int i = 0; i < maxLength; i++) {
//       for (int level = 0; level < 8; level++) {
//         if (levelCardCounts[level].length > i) {
//           var keys = levelCardCounts[level].keys.toList();
//           var values = levelCardCounts[level].values.toList();
//           newArray.add({keys[i]: values[i]});
//         } else {
//           newArray.add(null);
//         }
//       }
//     }

//     // GridView.countをExpandedでラップする必要がある
//     return Expanded(
//       child: GridView.count(
//         crossAxisCount: 8,
//         childAspectRatio: 1 / 1.4, 
//         children: List.generate(newArray.length, (index) {
//           return LayoutBuilder(
//             builder: (BuildContext context, BoxConstraints constraints) {
//               if (newArray[index] == null) {
//                 return Container();
//               } else {
//                 var cardNo = newArray[index]!.keys.first;
//                 var count = newArray[index]!.values.first;
//                 var cardData = cardNoMap.data[cardNo];

//                 if (cardData == null || cardData['type'] == null) {
//                   return Container();
//                 }

//                 return Stack(
//                   children: [
//                     OperableCard(
//                       cardNo: cardNo,
//                       cards: uniqueDeckNos,
//                       onTap: () {
//                         Provider.of<CardSetNo>(context, listen: false)
//                             .removeCardFromDeck(cardNo);
//                       },
//                     ),
//                     Positioned(
//                         top: 0,
//                         right: 0,
//                         child: QuantityBadge(
//                           count: count,
//                           type: cardData['type'],
//                           size: max(constraints.maxWidth/4, 24) ,
//                         )),
//                   ],
//                 );
//               }
//             },
//           );
//         }),
//       ),
//     );
//   }
// }

// class DeckEditWithHeightRestriction extends StatelessWidget {
//   final List<String> deckNos;
//   double displayableWidth;
//   double screenHeight;

//   DeckEditWithHeightRestriction(
//       {required this.deckNos,
//       required this.displayableWidth,
//       required this.screenHeight});

//   @override
//   Widget build(BuildContext context) {
//     var cardNoMap = Provider.of<CardNoMap>(context); 
//     var uniqueDeckNos = deckNos.toSet().toList();

//     // レベルごとにカードを分類
//     List<List<String>> levelSortedDeck = List.generate(8, (_) => []);
//     List<Map<String, int>> levelCardCounts = List.generate(8, (_) => {});

//     for (var cardNo in deckNos) {
     
//       var cardData = cardNoMap.data[cardNo]; 
//       if (cardData != null && cardData['Lv.'] != null) {
//         levelSortedDeck[cardData['Lv.'] - 1].add(cardNo);
//       }
//     }

//     for (int level = 0; level < 8; level++) {
//       // 各カードの出現回数をカウント
//       Map<String, int> cardCounts = {};
//       for (var cardNo in levelSortedDeck[level]) {
       
//         if (cardCounts.containsKey(cardNo)) {
         
//           cardCounts[cardNo] = cardCounts[cardNo]! + 1;
//         } else {
//           cardCounts[cardNo] = 1;
//         }
//       }
//       levelCardCounts[level] = cardCounts;
//     }

//     // 最も長い配列の長さを取得
//     int maxLength =
//         levelCardCounts.map((e) => e.length).reduce((a, b) => a > b ? a : b);

//     List<Map<String, int>?> newArray = [];

//     for (int i = 0; i < maxLength; i++) {
//       for (int level = 0; level < 8; level++) {
//         if (levelCardCounts[level].length > i) {
//           var keys = levelCardCounts[level].keys.toList();
//           var values = levelCardCounts[level].values.toList();
//           newArray.add({keys[i]: values[i]});
//         } else {
//           newArray.add(null);
//         }
//       }
//     }

//     // GridView.countをExpandedでラップする必要がある
//     return SizedBox(
//       height: min((displayableWidth) / 8 * 1.4 * maxLength, screenHeight / 2.5),
//       child:  GridView.count(
//           crossAxisCount: 8,
//           childAspectRatio: 1 / 1.4, 
//           children: List.generate(newArray.length, (index) {
//             return LayoutBuilder(
//               builder: (BuildContext context, BoxConstraints constraints) {
//                 if (newArray[index] == null) {
//                   return Container();
//                 } else {
//                   var cardNo = newArray[index]!.keys.first;
//                   var count = newArray[index]!.values.first;
//                   var cardData = cardNoMap.data[cardNo];

//                   if (cardData == null || cardData['type'] == null) {
//                     return Container();
//                   }

//                   return Stack(
//                     children: [
//                       OperableCard(
//                         cardNo: cardNo,
//                         cards: uniqueDeckNos,
//                         onTap: () {
//                           Provider.of<CardSetNo>(context, listen: false)
//                               .removeCardFromDeck(cardNo);
//                         },
//                       ),
//                       Positioned(
//                           top: 0,
//                           right: 0,
//                           child: QuantityBadge(
//                             count: count,
//                             type: cardData['type'],
//                             size: max(constraints.maxWidth/4, 24) ,
//                           )),
//                     ],
//                   );
//                 }
//               },
//             );
//           }),
        
//       ),
//     );
//   }
// }


