// utils/csv_data.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class CardNoMapData with ChangeNotifier {
  Map<String, Map<String, dynamic>> _data = {};

  Map<String, Map<String, dynamic>> get data => _data;

  Future<void> load() async {
    final csvData = await rootBundle
        .loadString('assets/csv/conan-cardgame - cardsByNumber2.csv');
    final lines = csvData.split('\n');

    if (lines.length > 1) {
      final headers = lines.first.split(',');

      lines.sublist(1).forEach((line) {
        final row = line.split(',');
        final map = Map<String, dynamic>.fromIterables(headers, row);

        // 'colors'と'abilities'の値を配列に変換
        if (map.containsKey('colors')) {
          map['colors'] = map['colors'].split('|');
        }
        if (map.containsKey('abilities')) {
          map['abilities'] = map['abilities'].split('|');
        }

        // 'ID'の値を文字列に変換し、4桁になるように先頭に0を追加
        if (map.containsKey('ID')) {
          map['ID'] = map['ID'].toString().padLeft(4, '0');
        }

        // 'Lv.', 'AP', 'LP'の値を数値に変換
        if (map.containsKey('Lv.')) {
          map['Lv.'] = int.tryParse(map['Lv.']);
        }
        if (map.containsKey('AP')) {
          map['AP'] = int.tryParse(map['AP']);
        }
        if (map.containsKey('LP')) {
          map['LP'] = int.tryParse(map['LP']);
        }

        // 'No.'をキーとして_dataに追加
        if (map.containsKey('No.')) {
          _data[map['No.']] = map;
        }
      });
    }

    notifyListeners();
  }
}



class CsvData with ChangeNotifier {
  List<Map<String, dynamic>> _data = [];

  List<Map<String, dynamic>> get data => _data;

  Future<void> load() async {
    final csvData = await rootBundle
        .loadString('assets/csv/conan-cardgame - cardsByNumber2.csv');
    final lines = csvData.split('\n');

    if (lines.length > 1) {
      final headers = lines.first.split(',');

      _data = lines.sublist(1).map((line) {
        final row = line.split(',');
        final map = Map<String, dynamic>.fromIterables(headers, row);

        // 'colors'と'abilities'の値を配列に変換
        if (map.containsKey('colors')) {
          map['colors'] = map['colors'].split('|');
        }
        if (map.containsKey('abilities')) {
          map['abilities'] = map['abilities'].split('|');
        }

        // 'ID'の値を文字列に変換し、4桁になるように先頭に0を追加
        if (map.containsKey('ID')) {
          map['ID'] = map['ID'].toString().padLeft(4, '0');
        }

        // 'Lv.', 'AP', 'LP'の値を数値に変換
        if (map.containsKey('Lv.')) {
          map['Lv.'] = int.tryParse(map['Lv.']);
        }
        if (map.containsKey('AP')) {
          map['AP'] = int.tryParse(map['AP']);
        }
        if (map.containsKey('LP')) {
          map['LP'] = int.tryParse(map['LP']);
        }

        return map;
      }).toList();
    }

    notifyListeners();
  }

  Map<String, dynamic>? getCardByNo(String no) {
    // print(_data.firstWhere((card) => card['No.'] == no,
    // orElse: () => <String, dynamic>{}));
    return _data.firstWhere((card) => card['No.'] == no,
        orElse: () => <String, dynamic>{});
  }
}

class PreCardSet with ChangeNotifier {
  Map<String, Map<String, dynamic>> _data = {};

  Map<String, Map<String, dynamic>> get data => _data;

  Future<void> load() async {
    final csvData = await rootBundle
        .loadString('assets/csv/conan-cardgame - productContents.csv');
    List<List<dynamic>> rowsAsListOfValues = const LineSplitter()
        .convert(csvData)
        .map((line) => line.split(','))
        .toList();

    // ヘッダー行を取得
    var headers = rowsAsListOfValues[0];

    // データ行をループしてマップに変換
    for (var i = 1; i < rowsAsListOfValues.length; i++) {
      var row = rowsAsListOfValues[i];
      Map<String, dynamic> rowMap = {};

      for (var j = 0; j < row.length; j++) {
        if (headers[j] == 'deckNumbers') {
          // deckNumbersを'|'で区切って配列に変換
          rowMap[headers[j]] = row[j].split('|');
        } else {
          rowMap[headers[j]] = row[j];
        }
      }

      // productの値をキーとしてデータを格納
      _data[rowMap['product']] = rowMap;
    }

    // print(_data);

    notifyListeners();
  }
}
