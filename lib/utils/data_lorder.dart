// utils/data_lorder.dart
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:csv/csv.dart';

// Future<List<Map<String, dynamic>>> loadCsvData(
//     String path, String pathById) async {
// bool _isNumeric(String str) {
//   return double.tryParse(str) != null;
// }


//   try {
//     final cardsByNumberCsv = await rootBundle.loadString(path);
//     final cardsByNumberRows =
//         const CsvToListConverter().convert(cardsByNumberCsv);

//     final cardsByIdCsv = await rootBundle.loadString(pathById);
//     final cardsByIdRows = const CsvToListConverter().convert(cardsByIdCsv);

//     // ヘッダー行を取得
//     final headers = cardsByNumberRows.first;
//     final headersById = cardsByIdRows.first;

//     // データ行を取得
//     final dataRows = cardsByNumberRows.skip(1);
//     final dataRowsById = cardsByIdRows.skip(1);

// // データ行をMap形式に変換
//     final allCards =
//         <Map<String, dynamic>>[]; // 値が文字列またはリストである可能性があるため、dynamicを使用します
//     final cardsById = <String,
//         Map<String, dynamic>>{}; // 値が文字列またはリストである可能性があるため、dynamicを使用します

//     for (var row in dataRowsById) {
//       final cardData = <String, dynamic>{};
//       cardData['colors'] = []; // colorsを最初に空配列として初期化
//       cardData['abilities'] = []; // abilitiesを最初に空配列として初期化
//       for (var i = 0; i < headersById.length; i++) {
//         if (headersById[i] == 'ID') {
//           // id列の値を文字列に変換（先頭のゼロを保持）
//           cardData[headersById[i]] = row[i].toString().padLeft(4, '0');
//         } else if ((headersById[i] == 'color1' || headersById[i] == 'color2') &&
//             row[i] != null) {
//           // color1またはcolor2の場合、'colors'キーの配列に追加します
//           (cardData['colors'] as List).add(row[i].toString());
//         } else if ((headersById[i] == 'ability1' ||
//                 headersById[i] == 'ability2' ||
//                 headersById[i] == 'ability3') &&
//             row[i] != null) {
//           // ability1, ability2, ability3の場合、'abilities'キーの配列に追加します
//           (cardData['abilities'] as List).add(row[i].toString());
//         } else {
//           if (headersById[i] == 'Lv.' ||
//               headersById[i] == 'AP' ||
//               headersById[i] == 'LP') {
//             var value = row[i].toString();
//             if (value.isNotEmpty && _isNumeric(value)) {
//               cardData[headersById[i]] = int.parse(value);
//             }
//           } else {
//             cardData[headersById[i]] = row[i].toString();
//           }
//           // cardData[headersById[i]] = row[i].toString();
//         }
//       }
//       cardsById[cardData['ID']!] = cardData;
//     }

//     for (var row in dataRows) {
//       final cardData = <String, dynamic>{};
//       for (var i = 0; i < headers.length; i++) {
//         if (headers[i] == 'ID') {
//           // id列の値を文字列に変換（先頭のゼロを保持）
//           cardData[headers[i]] = row[i].toString().padLeft(4, '0');
//         } else {
//           cardData[headers[i]] = row[i].toString();
//         }
//       }
//       if (cardData['ID'] != null &&
//           cardsById[cardData['ID']!] != null &&
//           cardData['rarity'] != 'SEC') {
//         // cardData['rarity']が'SEC'でない場合にのみ、cardDataをallCardsに追加します
//         cardData.addAll(cardsById[cardData['ID']!]!);
//         allCards.add(cardData);
//       }
//     }
//     // print('All Cards: $allCards'); // allCardsの内容を表示

//     return allCards;
//   } catch (e) {
//     print('Error occurred: $e'); // エラーが発生した場合はエラーメッセージを表示
//     return []; // エラーが発生した場合は空のリストを返す
//   }
// }
