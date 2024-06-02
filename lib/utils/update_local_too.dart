// utils/update_local_too.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../utils/common_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';





Future<void> updateEditingKeyAndStorage(DateTime date, BuildContext context) async {
  // EditingCardSetKeyの更新
  Provider.of<EditingCardSetKey>(context, listen: false).setDate(date);

  // ローカルストレージの更新
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(getStorageKey('cardSetDate'), date.toIso8601String());
}
