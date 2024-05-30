// utils/filter_functions.dart
import '../utils/csv_data.dart';
import '../providers/filter_provider.dart';

List<String> getFilteredAndSortedData(List<String> cardNos,
    FilterState filterState, CardNoMap cardNoMap) {
  var filteredCardNos = cardNos.where((cardNo) {
    var cardData = cardNoMap.data[cardNo];
    if (cardData == null) {
      return false; // カードのデータが存在しない場合、フィルタリングの結果から除外します
    }
    

    var rarity = cardData['rarity'];
    var type = cardData['type'];
    var colors = cardData['colors'];

    // print(rarity);

    bool rarityMatches;
    if (rarity.endsWith('P')) {
      rarityMatches = filterState.includeParallel &&
          (!filterState.isSelectedRarity.any((element) => element) ||
              filterState.isSelectedRarity[filterState.rarityValues
                  .indexOf(rarity.substring(0, rarity.length - 1))]);
    } else {
      rarityMatches = !filterState.isSelectedRarity.any((element) => element) ||
          filterState
              .isSelectedRarity[filterState.rarityValues.indexOf(rarity)];
    }
    bool typeMatches = !filterState.isSelectedType.any((element) => element) ||
        filterState.isSelectedType[filterState.typeValues.indexOf(type)];
    bool colorMatches = !filterState.isSelectedColor
            .any((element) => element) ||
        (colors != null &&
            colors.any((color) =>
                filterState.colorValues.contains(color) &&
                filterState
                    .isSelectedColor[filterState.colorValues.indexOf(color)]));
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

    return rarityMatches && typeMatches && colorMatches && textMatches;
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
