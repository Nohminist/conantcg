// utils/filter_functions.dart
import '../utils/csv_data.dart';
import '../providers/filter_provider.dart';

List<String> getFilteredAndSortedData(
    List<String> cardNos, FilterState filterState, CardNoMap cardNoMap) {
  var filteredCardNos = cardNos.where((cardNo) {
    var cardData = cardNoMap.data[cardNo];

    if (cardData == null) {
      return false; // カードのデータが存在しない場合、フィルタリングの結果から除外します
    }

    var type = cardData['type'];

    // if (filterState.sortKey == 'Lv.') {
    //   if (type == '事件') return false;
    // }
    // if (filterState.sortKey == 'AP') {
    //   if (type != 'キャラ') return false;
    // }
    // if (filterState.sortKey == 'LP') {
    //   if (type == 'イベント' || type == '事件') return false;
    // }

    var rarity = cardData['rarity'];
    var colors = cardData['colors'];
    var labels = cardData['labels'];

    // print(rarity);

    // bool rarityMatches = false;
    // if (rarity.endsWith('P')) {
    //   if (!filterState.isSelectedParallel.any((element) => element) ||
    //       filterState.isSelectedParallel[1]) {
    //     if (!filterState.isSelectedRarity.any((element) => element) ||
    //         filterState.isSelectedRarity[filterState.rarityValues
    //             .indexOf(rarity.substring(0, rarity.length - 1))]) {
    //       rarityMatches = true;
    //     }
    //   }
    // } else {
    //   if (!filterState.isSelectedParallel.any((element) => element) ||
    //       filterState.isSelectedParallel[0]) {
    //     if (!filterState.isSelectedRarity.any((element) => element) ||
    //         filterState
    //             .isSelectedRarity[filterState.rarityValues.indexOf(rarity)]) {
    //       rarityMatches = true;
    //     }
    //   }
    // }
    bool rarityMatches = !filterState.isSelectedRarity
            .any((element) => element) ||
        filterState.isSelectedRarity[filterState.rarityValues.indexOf(rarity)];

    bool typeMatches = !filterState.isSelectedType.any((element) => element) ||
        filterState.isSelectedType[filterState.typeValues.indexOf(type)];

    bool colorMatches = !filterState.isSelectedColor
            .any((element) => element) ||
        (colors != null &&
            colors.any((color) =>
                filterState.colorValues.contains(color) &&
                filterState
                    .isSelectedColor[filterState.colorValues.indexOf(color)]));

    bool levelMatches =
        !filterState.isSelectedLevel.any((element) => element) ||
            (cardData['Lv.'] != null &&
                filterState.isSelectedLevel[
                    filterState.levelValues.indexOf(cardData['Lv.'])]);

    bool apMatches = !filterState.isSelectedAp.any((element) => element) ||
        (cardData['AP'] != null &&
            filterState
                .isSelectedAp[filterState.apValues.indexOf(cardData['AP'])]);

    bool lpMatches = !filterState.isSelectedLp.any((element) => element) ||
        (cardData['LP'] != null &&
            filterState
                .isSelectedLp[filterState.lpValues.indexOf(cardData['LP'])]);

    bool labelMatches = !filterState.isSelectedLabel
            .any((element) => element) ||
        (labels != null &&
            labels.any((label) =>
                filterState.labelValues.contains(label) &&
                filterState
                    .isSelectedLabel[filterState.labelValues.indexOf(label)]));

    bool textMatches = filterState.inputText.isEmpty ||
        cardData['No.'] == filterState.inputText ||
        cardData['ID'] == filterState.inputText ||
        cardData['name'].contains(filterState.inputText) ||
        (cardData['abilities'] is List<String> &&
            cardData['abilities'] != null &&
            cardData['abilities'].isNotEmpty &&
            cardData['abilities'].any((ability) =>
                ability != null &&
                ability is String &&
                ability.contains(filterState.inputText))) ||
        (cardData['cutIn'] != null &&
            cardData['cutIn'].contains(filterState.inputText)) ||
        (cardData['inspiration'] != null &&
            cardData['inspiration'].contains(filterState.inputText)) ||
        (cardData['Lv.'] is num &&
            cardData['Lv.'].toString() == filterState.inputText) ||
        (cardData['AP'] is num &&
            cardData['AP'].toString() == filterState.inputText) ||
        (cardData['LP'] is num &&
            cardData['LP'].toString() == filterState.inputText);

    return rarityMatches &&
        typeMatches &&
        colorMatches &&
        labelMatches &&
        textMatches &&
        levelMatches &&
        apMatches &&
        lpMatches;
  }).toList();

  // ソートの状態を反映
  filteredCardNos.sort((a, b) {
    var aData = cardNoMap.data[a];
    var bData = cardNoMap.data[b];
    if (aData == null || bData == null) {
      return 0; // カードのデータが存在しない場合、ソートの結果に影響を与えません
    }

    var aValue = aData[filterState.sortKey];
    var bValue = bData[filterState.sortKey];

    if (aValue is num && bValue is num) {
      return filterState.isAscending
          ? aValue.compareTo(bValue)
          : bValue.compareTo(aValue);
    } else if (aValue is String && bValue is String) {
      return filterState.isAscending
          ? aValue.compareTo(bValue)
          : bValue.compareTo(aValue);
    } else {
      return 0;
    }
  });

  return filteredCardNos;
}
