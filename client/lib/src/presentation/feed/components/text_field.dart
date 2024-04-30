import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String hintText;
  final int? maxLine;
  final double maxHeight;
  final double? hintSize;
  final String? initialValue;
  final Function(String?)? onSave;
  final Function(String?)? onChange;
  const TextBox({
    super.key,
    required this.hintText,
    this.onSave,
    this.maxLine,
    required this.maxHeight,
    this.hintSize,
    this.initialValue,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final input = TextFormField(
      initialValue: initialValue,
      style: TextStyle(fontSize: hintSize),
      onSaved: onSave,
      onChanged: onChange,
      maxLines: maxLine,
      minLines: 1,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        constraints: BoxConstraints(minHeight: maxHeight),
        hintStyle: TextStyle(fontSize: hintSize),
        hintText: hintText,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );

    return input;
  }
}
