// widgets/card_set_name_edit.dart
import 'package:conantcg/widgets/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';

class CardSetNameEdit extends StatefulWidget {
  const CardSetNameEdit({super.key});

  @override
  _CardSetNameEditState createState() => _CardSetNameEditState();
}

class _CardSetNameEditState extends State<CardSetNameEdit> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final current = Provider.of<CardSetNo>(context);
    _controller.text = current.name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = Provider.of<CardSetNo>(context);

    return CommonTextField(
        prefixIcon: Icons.edit,
        labelText: 'デッキ名',
        controller: _controller,
        onSubmitted: (value) {
          current.setName(value);
        });
  }
}
