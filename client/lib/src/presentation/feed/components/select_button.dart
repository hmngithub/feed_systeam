import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  final Icon icon;
  final String text;
  final bool selected;
  final Color? color;
  final Function() callBack;
  const SelectButton({
    super.key,
    required this.icon,
    required this.callBack,
    this.selected = false,
    this.text = "",
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      style: TextButton.styleFrom(
          backgroundColor:
              selected ? const Color.fromARGB(175, 180, 226, 230) : null),
      isSelected: true,
      onPressed: () {
        callBack();
      },
      icon: icon,
    );

    final label = Text(text, style: TextStyle(color: color));

    final textButton = TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor:
            selected ? const Color.fromARGB(175, 180, 226, 230) : null,
      ),
      onPressed: () {
        callBack();
      },
      icon: icon,
      label: label,
    );

    return text.isNotEmpty ? textButton : button;
  }
}
