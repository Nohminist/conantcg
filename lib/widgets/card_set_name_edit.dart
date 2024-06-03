import 'package:conantcg/widgets/common_icon_button.dart';
import 'package:conantcg/widgets/common_show_modal_bottom_sheet.dart';
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

class CardSetNameEditButton extends StatefulWidget {
  const CardSetNameEditButton({super.key});

  @override
  _CardSetNameEditButtonState createState() => _CardSetNameEditButtonState();
}

class _CardSetNameEditButtonState extends State<CardSetNameEditButton> {
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
    Future.delayed(Duration.zero, () {
      _controller.text = current.name;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = Provider.of<CardSetNo>(context);
    return CommonIconButton(
        onPressed: () {
          commonShowModalBottomSheet(
            context,
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CommonTextField(
                prefixIcon: Icons.edit,
                labelText: 'デッキ名',
                controller: _controller,
                onSubmitted: (value) {
                  current.setName(value);
                  // Navigator.of(context).pop();
                },
              ),
            ),
            heightFactor: 0.5, // ここでheightFactorを指定します
          );
        },
        text: 'デッキ名',
        icon: const Icon(Icons.edit));
  }
}
