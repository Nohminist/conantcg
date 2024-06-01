// filter_provider.dart
import 'package:flutter/material.dart';

class FilterState extends ChangeNotifier {
  List<bool> isSelectedRarity = List.generate(5, (_) => false);
  List<String> rarityValues = ['C', 'R', 'SR', 'D', 'PR'];
  List<bool> isSelectedType = List.generate(4, (_) => false);
  List<String> typeValues = ['パートナー', '事件', 'キャラ', 'イベント'];
  List<bool> isSelectedColor = List.generate(6, (_) => false);
  List<String> colorValues = ['青', '緑', '白', '黄', '赤', '黒'];
  List<bool> isSelectedParallel = [true, false];
  List<String> parallelValues = ['(無印)', 'P']; // 追加
  String inputText = ''; // 追加
  bool includeParallel = false; // パラレル(カード)を含むかどうか

  // ソートの状態を追加
  List<String> sortKeys = ['No.', 'ID', 'Lv.', 'AP', 'LP']; // ソートの選択肢
  String sortKey = 'No.'; // 初期値は 'No.'
  bool isAscending = true; // 昇順か降順かを表すフラグ

  void toggleRarity(int index) {
    isSelectedRarity[index] = !isSelectedRarity[index];
    notifyListeners();
  }

  void toggleType(int index) {
    isSelectedType[index] = !isSelectedType[index];
    notifyListeners();
  }

  void toggleColor(int index) {
    isSelectedColor[index] = !isSelectedColor[index];
    notifyListeners();
  }

  void toggleParallel(int index) {
    // 追加
    isSelectedParallel[index] = !isSelectedParallel[index];
    notifyListeners();
  }

  void updateInputText(String text) {
    inputText = text;
    notifyListeners();
  }

  // パラレル(カード)を含むかどうかの状態を更新するメソッドを追加
  void toggleIncludeParallel() {
    includeParallel = !includeParallel;
    notifyListeners();
  }

  // ソートの状態を更新するメソッドを追加
  void updateSortKey(String newKey) {
    sortKey = newKey;
    notifyListeners();
  }

  void toggleSortOrder() {
    isAscending = !isAscending;
    notifyListeners();
  }
}
