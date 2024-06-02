// utils/card_sets_csv_import.dart
import 'dart:io';
import 'package:conantcg/providers/card_provider.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import 'dart:async'; // 追加

// CSVデータをパースする関数
Future<List<CardSetNo>> parseCardSetsCsv(String csvData) async {
  List<List<dynamic>> rowsAsListOfValues =
      const CsvToListConverter().convert(csvData);

  // ヘッダー行を削除
  rowsAsListOfValues.removeAt(0);

  // 各行をCardSetNoオブジェクトに変換
  List<CardSetNo> cardSets = rowsAsListOfValues.map((row) {
    // deckのデータを取得
    List<String> deck = [];
    for (int i = 4; i < row.length; i++) {
      if (row[i] != '') {
        deck.add(row[i]);
      } else {
        break;
      }
    }

    return CardSetNo(
      date: DateTime.parse(row[0]),
      name: row[1],
      partner: row[2],
      caseCard: row[3],
      deck: deck,
    );
  }).toList();

  return cardSets;
}

void selectFiles(BuildContext context) {
  final input = html.FileUploadInputElement()..accept = 'text/csv';

  input.onChange.listen((e) async {
    if (input.files!.isNotEmpty) {
      final file = input.files!.first;
      final reader = html.FileReader();

      // Completerを作成
      final completer = Completer<String>();

      reader.onLoadStart.listen((e) {
        print('Load start');
      });

      reader.onProgress.listen((e) {
        print('Progress: ${e.loaded} bytes loaded');
      });

      reader.onAbort.listen((e) {
        print('Aborted');
      });

      reader.onError.listen((e) {
        print('Error occurred: ${reader.error!.message}');
      });

      reader.onLoadEnd.listen((e) {
        if (reader.result != null && reader.result is String) {
          completer.complete(reader.result as String);
        } else {
          print('Unexpected result: ${reader.result}');
        }
      });




      reader.readAsText(file);

      // ファイルの読み込みが完了するのを待つ
      String csvData = await completer.future;

      List<CardSetNo> newCardSets = await parseCardSetsCsv(csvData);

      CardSets cardSets = Provider.of<CardSets>(context, listen: false);
      for (CardSetNo newCardSet in newCardSets) {
        while (cardSets.cardSets.any(
            (existingCardSet) => existingCardSet.date == newCardSet.date)) {
          newCardSet.date = newCardSet.date.add(Duration(milliseconds: 1));
        }
        cardSets.cardSets.add(newCardSet);
      }
    }
  });

  input.click();
}
