// widgets/card_set_name_edit.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';


class CardSetNameEdit extends StatefulWidget {
  const CardSetNameEdit({Key? key}) : super(key: key);

  @override
  _CardSetNameEditState createState() => _CardSetNameEditState();
}

class _CardSetNameEditState extends State<CardSetNameEdit> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final current = Provider.of<CardSetNo>(context, listen: false);
    _controller = TextEditingController(text: current.name);
  }

  @override
  Widget build(BuildContext context) {
    final current = Provider.of<CardSetNo>(context);

    return TextField(
      controller: _controller,
      onChanged: (value) {
        current.setName(value);
      },
      decoration: InputDecoration(
        labelText: 'デッキ名',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.edit),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
