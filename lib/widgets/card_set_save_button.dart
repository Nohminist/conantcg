// widgets/card_set_save_button.dart

import 'package:conantcg/providers/card_provider.dart';
import 'package:conantcg/utils/update_local_too.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardSetSaveButton extends StatelessWidget {
  const CardSetSaveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cardSets = Provider.of<CardSets>(context);
    final current = Provider.of<CardSetNo>(context);

    return IconButton(
      onPressed: () async {
        //先に編集中のindexを取得する
        int editingIndex = cardSets.getEditingIndex(context);

        DateTime now = DateTime.now();
        current.date = now;

        await updateEditingKeyAndStorage(now, context);

        cardSets.saveCurrentCardSet(editingIndex, current);
      },
      icon: Icon(Icons.save),
      tooltip: '保存',
    );
  }
}
