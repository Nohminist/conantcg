// filter_provider.dart
import 'package:flutter/material.dart';

class FilterState extends ChangeNotifier {
  String inputText = '';
  List<String> rarityValues = ['C', 'CP', 'R', 'RP', 'SR', 'SRP', 'D', 'PR' , 'SEC'];
  List<String> typeValues = ['パートナー', '事件', 'キャラ', 'イベント'];
  List<String> colorValues = ['青', '緑', '白', '黄', '赤', '黒'];
    List<String> labelValues = ["赤井家", "FBI", "大阪府警", "怪盗", "科学者", "空手家", "棋士", "喫茶ポアロ", "黒ずくめの組織", "警察", "警視庁", "公安", "高校生", "執事", "小説家", "少年探偵団", "鈴木財閥", "大学院生", "探偵", "発明家", "弁護士", "毛利探偵事務所"];

  List<int> levelValues = [1, 2, 3, 4, 5, 6, 7, 8]; // 追加
  List<int> apValues = [1000, 2000, 3000, 4000, 5000, 6000, 7000]; // 追加
  List<int> lpValues = [0, 1, 2]; // 追加


  List<bool> isSelectedRarity = [
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    true,
    false,
  ];
  List<bool> isSelectedType = List.generate(4, (_) => false);
  List<bool> isSelectedColor = List.generate(6, (_) => false);
  List<bool> isSelectedLabel = List.generate(22, (_) => false);
  List<bool> isSelectedLevel = List.generate(8, (_) => false); // 追加
  List<bool> isSelectedAp = List.generate(7, (_) => false); // 追加
  List<bool> isSelectedLp = List.generate(3, (_) => false); // 追加

  List<String> sortKeys = ['No.', 'ID', 'Lv.', 'AP', 'LP'];
  String sortKey = 'No.';
  bool isAscending = true;

  void initializeFilters() {
    inputText = '';
    isSelectedRarity = [true, false, true, false, true, false, true, true , false];
    isSelectedType = List.generate(4, (_) => false);
    isSelectedColor = List.generate(6, (_) => false);
    isSelectedLabel = List.generate(22, (_) => false);
    isSelectedLevel = List.generate(8, (_) => false);
    isSelectedAp = List.generate(7, (_) => false);
    isSelectedLp = List.generate(3, (_) => false);
    sortKey = 'No.';
    isAscending = true;
    notifyListeners();
  }

    void clearFilters() {
    inputText = '';
    isSelectedRarity = [false, false, false, false, false, false, false, false, false];
    isSelectedType = List.generate(4, (_) => false);
    isSelectedColor = List.generate(6, (_) => false);
        isSelectedLabel = List.generate(22, (_) => false);
    isSelectedLevel = List.generate(8, (_) => false);
    isSelectedAp = List.generate(7, (_) => false);
    isSelectedLp = List.generate(3, (_) => false);
    sortKey = 'No.';
    isAscending = true;
    notifyListeners();
  }


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

    void toggleLabel(int index) {
    isSelectedLabel[index] = !isSelectedLabel[index];
    notifyListeners();
  }



  void toggleLevel(int index) {
    // 追加
    isSelectedLevel[index] = !isSelectedLevel[index];
    notifyListeners();
  }

  void toggleAp(int index) {
    // 追加
    isSelectedAp[index] = !isSelectedAp[index];
    notifyListeners();
  }

  void toggleLp(int index) {
    // 追加
    isSelectedLp[index] = !isSelectedLp[index];
    notifyListeners();
  }

  void updateInputText(String text) {
    inputText = text;
    notifyListeners();
  }

  void updateSortKey(String newKey) {
    sortKey = newKey;
    notifyListeners();
  }

  void toggleSortOrder() {
    isAscending = !isAscending;
    notifyListeners();
  }
}


  // List<bool> isSelectedParallel = [true, false];
  // List<String> parallelValues = ['(無印)', 'P'];
  // bool includeParallel = false; // パラレル(カード)を含むかどうか

    // void toggleParallel(int index) {
  //   isSelectedParallel[index] = !isSelectedParallel[index];
  //   notifyListeners();
  // }

    // void toggleIncludeParallel() {
  //   includeParallel = !includeParallel;
  //   notifyListeners();
  // }



