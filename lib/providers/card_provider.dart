import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/common_utils.dart';

class CardSetNo with ChangeNotifier {
  List<String> _deck;
  String _partner;
  String _case;
  String _name;
  DateTime _date; // 追加

  CardSetNo({
    List<String>? deck,
    String? partner,
    String? caseCard,
    String? name,
    DateTime? date, // 追加
  })  : _deck = deck ?? [],
        _partner = partner ?? '',
        _case = caseCard ?? '',
        _name = name ?? '',
        _date = date ?? DateTime.now(); // 追加

  CardSetNo.copy(CardSetNo other)
      : _deck = List.from(other._deck),
        _partner = other._partner,
        _case = other._case,
        _name = other._name,
        _date = other._date; // 追加

  factory CardSetNo.fromJson(Map<String, dynamic> json) {
    return CardSetNo(
      deck: List<String>.from(json['deck']),
      partner: json['partner'],
      caseCard: json['case'],
      name: json['name'],
      date: DateTime.parse(json['date']), // 追加
    );
  }

  List<String> get deck => _deck;
  String? get partner => _partner;
  String? get caseCard => _case;
  String get name => _name;
  DateTime get date => _date; // 追加

  //追加後、エラーメッセージを返す
  String? addCardNoToDeck(
      String cardNo, Map<String, Map<String, dynamic>> cardNoMap) {
    Map<String, dynamic>? card = cardNoMap[cardNo];
    if (card == null) {
      return 'カードが見つかりません';
    }
    if (card['type'] == 'キャラ' || card['type'] == 'イベント') {
      List<String> sameIdCards =
          _deck.where((no) => cardNoMap[no]?['ID'] == card['ID']).toList();
      int sameCardCount = sameIdCards.length;
      if (sameCardCount < 3) {
        _deck.add(cardNo);

        // try {
        //   _deck.sort((a, b) {
        //     var lvA = cardNoMap[a]?['Lv.'];
        //     var lvB = cardNoMap[b]?['Lv.'];
        //     if (lvA == null || lvB == null) {
        //       throw Exception('カードのレベルが見つかりませんでした(バグ)');
        //     }
        //     return lvA.compareTo(lvB);
        //   });
        // } catch (e) {
        //   return e.toString();
        // }

        notifyListeners();
        return null;
      } else {
        List<String> sameIdDifferentNumbers = sameIdCards
            .where((no) => cardNoMap[no]?['No.'] != card['No.'])
            .toList();
        if (sameIdDifferentNumbers.isEmpty) {
          return '同じカードは3枚まで';
        } else {
          removeCardFromDeck(sameIdDifferentNumbers[0]); // 最初の異なるNo.のカードを削除
          _deck.add(cardNo);
          return '同じIDで異なるNo.のカードと入替え';
        }
      }
    }
    return '無効なカードタイプ';
  }

  void setPartner(String cardNo) {
    _partner = cardNo;
    notifyListeners();
  }

  void setCase(String cardNo) {
    _case = cardNo;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void removeCardFromDeck(String cardNo) {
    _deck.remove(cardNo);
    notifyListeners();
  }

  void removePartner() {
    _partner = '';
    notifyListeners();
  }

  void removeCase() {
    _case = '';
    notifyListeners();
  }

  void copyFrom(CardSetNo other) {
    _deck = List.from(other._deck);
    _partner = other._partner;
    _case = other._case;
    _name = other._name;
    notifyListeners();
  }

  set deck(List<String> deck) {
    _deck = deck;
    notifyListeners();
  }

  set partner(String? partner) {
    _partner = partner ?? '';
    notifyListeners();
  }

  set caseCard(String? caseCard) {
    _case = caseCard ?? '';
    notifyListeners();
  }

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set date(DateTime date) {
    _date = date; // 追加
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'deck': _deck,
      'partner': _partner,
      'case': _case,
      'name': _name,
      'date': _date.toIso8601String(), // 追加
    };
  }
}

// CardSetsクラス：複数のカードセットを管理します。カードセットはCardSetNoオブジェクトのリストとして保持されます。
class CardSets with ChangeNotifier {
  List<CardSetNo> _cardSets;

  CardSets([List<CardSetNo>? cardSets]) : _cardSets = cardSets ?? [];

  List<CardSetNo> get cardSets => _cardSets;

  set cardSets(List<CardSetNo> cardSets) {
    _cardSets = cardSets;
    notifyListeners();
    _updateLocalStorage();
  }

  void addCardSetNo(CardSetNo cardSet) {
    // print('_cardSets[0].name${_cardSets[0].name}');
    // print('cardSet.name${cardSet.name}');
    _cardSets.add(cardSet);
    notifyListeners();
    _updateLocalStorage();
  }

  void saveCurrentCardSet(int index, CardSetNo newCardSet) {
    _cardSets[index] = CardSetNo.copy(newCardSet);
    notifyListeners();
    _updateLocalStorage(); // ローカルストレージを更新
  }

  Future<void> _updateLocalStorage() async {
    // ローカルストレージに保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cardSetsData =
        _cardSets.map((cardSet) => jsonEncode(cardSet.toJson())).toList();
    await prefs.setStringList(getStorageKey('cardSets'), cardSetsData);
  }

  int getEditingIndex(BuildContext context) {
    final editingKey = Provider.of<EditingCardSetKey>(context, listen: false);
    return _cardSets.indexWhere((cardSet) => cardSet.date == editingKey.date);
  }
}

// CardSetクラス：カードセットの状態を管理します。カードセットはdeck, partner, caseから構成されます。
// _deck：キャラカードとイベントカードのリスト（40枚）を保持します。
// _partner：パートナーカード（1枚）を保持します。
// _case：事件カード（1枚）を保持します。
// _name：カードセットの名前を保持します。

// class CardSet with ChangeNotifier {
//   List<Map<String, dynamic>> _deck;
//   Map<String, dynamic>? _partner;
//   Map<String, dynamic>? _case;
//   String _name;

//   // デフォルトコンストラクタを修正
//   CardSet({
//     List<Map<String, dynamic>>? deck,
//     Map<String, dynamic>? partner,
//     Map<String, dynamic>? caseCard,
//     String? name,
//   })  : _deck = deck ?? [],
//         _partner = partner,
//         _case = caseCard,
//         _name = name ?? '';

//   // コピーコンストラクタを追加
//   CardSet.copy(CardSet other)
//       : _deck = List.from(other._deck),
//         _partner = other._partner != null ? Map.from(other._partner!) : null,
//         _case = other._case != null ? Map.from(other._case!) : null,
//         _name = other._name;

//   factory CardSet.fromJson(Map<String, dynamic> json) {
//     return CardSet(
//       // JSONデータから各プロパティの値を取得し、CardSetオブジェクトを作成します。
//       deck: List<Map<String, dynamic>>.from(json['deck']),
//       partner: json['partner'],
//       caseCard: json['case'],
//       name: json['name'],
//     );
//   }

//   List<Map<String, dynamic>> get deck => _deck;
//   Map<String, dynamic>? get partner => _partner;
//   Map<String, dynamic>? get caseCard => _case;
//   String get name => _name;

//   String? addCardToDeck(Map<String, dynamic> card) {
//     if (card['type'] == 'キャラ' || card['type'] == 'イベント') {
//       List<Map<String, dynamic>> sameIdCards =
//           _deck.where((c) => c['ID'] == card['ID']).toList();
//       int sameCardCount = sameIdCards.length;
//       if (sameCardCount < 3) {
//         _deck.add(card);
//         notifyListeners();
//         return null; // カードが追加された場合はnullを返す
//       } else {
//         List<String> sameIdDifferentNumbers = sameIdCards
//             .where((c) => c['No.'] != card['No.'])
//             .map((c) => c['No.'] as String)
//             .toList();
//         if (sameIdDifferentNumbers.isEmpty) {
//           return '同じカードは3枚まで'; // 同じIDの同じNo.のカードがすでに3枚ある場合
//         } else {
//           removeCardFromDeck(sameIdDifferentNumbers[0]); // 最初の異なるNo.のカードを削除
//           _deck.add(card); // 新しいカードを追加
//           return '異なるNo.のカードと入れ替え'; // 異なるNo.のカードと入れ替えた場合
//         }
//       }
//     }
//     return '無効なカードタイプ'; // カードタイプが無効な場合はエラーメッセージを返す
//   }

//   void setPartner(Map<String, dynamic> card) {
//     if (card['type'] == 'パートナー') {
//       _partner = card;
//       notifyListeners();
//     }
//   }

//   void setCase(Map<String, dynamic> card) {
//     if (card['type'] == '事件') {
//       _case = card;
//       notifyListeners();
//     }
//   }

//   void setName(String name) {
//     _name = name;
//     notifyListeners();
//   }

//   void removeCardFromDeck(String cardNo) {
//     final cardIndex = _deck.indexWhere((card) => card['No.'] == cardNo);
//     if (cardIndex != -1) {
//       _deck.removeAt(cardIndex);
//       notifyListeners();
//     }
//   }

//   void removePartner() {
//     _partner = null;
//     notifyListeners();
//   }

//   void removeCase() {
//     _case = null;
//     notifyListeners();
//   }

// //別のCardSetインスタンスから状態をコピーします：
//   void copyFrom(CardSet other) {
//     _deck = List.from(other._deck);
//     _partner = other._partner != null ? Map.from(other._partner!) : null;
//     _case = other._case != null ? Map.from(other._case!) : null;
//     _name = other._name;
//     notifyListeners();
//   }

//   set deck(List<Map<String, dynamic>> deck) {
//     _deck = deck;
//     notifyListeners();
//   }

//   set partner(Map<String, dynamic>? partner) {
//     _partner = partner;
//     notifyListeners();
//   }

//   set caseCard(Map<String, dynamic>? caseCard) {
//     // 'case'から'caseCard'に変更
//     _case = caseCard; // 'case'から'caseCard'に変更
//     notifyListeners();
//   }

//   set name(String name) {
//     _name = name;
//     notifyListeners();
//   }

// // Map<String, dynamic> toJson() {
// //   return {
// //     'deck': jsonEncode(_deck),
// //     'partner': jsonEncode(_partner),
// //     'case': jsonEncode(_case),
// //     'name': _name,
// //   };
// // }
//   Map<String, dynamic> toJson() {
//     return {
//       'deck': _deck, // jsonEncodeを使用しない
//       'partner': _partner,
//       'case': _case,
//       'name': _name,
//     };
//   }
// }

// EditingCardSetIndexクラス：編集中のカードセットのインデックスを管理します。サイトに最初にアクセスしたとき、CardSets[0]が編集中のカードセットになります。
class EditingCardSetIndex with ChangeNotifier {
  int _index = 0;

  // デフォルトコンストラクタを修正
  EditingCardSetIndex(this._index);

  int get index => _index;

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }
}

class EditingCardSetKey with ChangeNotifier {
  DateTime _date;

  // デフォルトコンストラクタを修正
  EditingCardSetKey(this._date);

  DateTime get date => _date;

  void setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }
}
