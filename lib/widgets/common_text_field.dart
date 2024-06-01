// widget/comon_text_field.dart

import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final IconData prefixIcon;
  final String labelText;
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const CommonTextField({
    required this.prefixIcon,
    required this.labelText,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        labelText: labelText,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
