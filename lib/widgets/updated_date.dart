// widget/cardset_operations2.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdatedDate extends StatelessWidget {
  final DateTime date;

  const UpdatedDate({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.update, size: 14),
        Text(
          DateFormat('yyyy/MM/dd HH:mm').format(date),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
