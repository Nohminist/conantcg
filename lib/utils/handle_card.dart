import 'package:flutter/material.dart';
import '../providers/card_provider.dart';

String? handleCardAdd(BuildContext context, CardSetNo cardSet, String cardNo,
    Map<String, Map<String, dynamic>> cardNoMapData) {
  String? errorMessage;
  switch (cardNoMapData[cardNo]?['type']) {
    case 'パートナー':
      cardSet.setPartner(cardNo);
      break;
    case '事件':
      cardSet.setCase(cardNo);
      break;
    default:
      errorMessage = cardSet.addCardNoToDeck(cardNo, cardNoMapData);
      break;
  }
  return errorMessage;
}

