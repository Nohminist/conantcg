// utils/common_utils.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../utils/constants.dart';

// 現在のEditingCardSetKeyと一致するCardSetを探す
// int getEditingIndex(BuildContext context) {
//   final cardSets = Provider.of<CardSets>(context, listen: false);
//   final editingKey = Provider.of<EditingCardSetKey>(context, listen: false);
//   return cardSets.cardSets.indexWhere((cardSet) => cardSet.date == editingKey.date);
// }

String getStorageKey(String key) {
  return '${projectName}_$key';
}
