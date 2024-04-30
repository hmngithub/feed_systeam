import 'package:flutter/material.dart';

class ColorBox extends StatelessWidget {
  final int red;
  final int green;
  final int blue;

  final Function() onClick;
  const ColorBox({
    super.key,
    required this.red,
    required this.green,
    required this.blue,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final containterDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color.fromARGB(200, red, green, blue),
    );

    final box = Container(
      margin: const EdgeInsets.all(3),
      height: 35,
      width: 35,
      decoration: containterDecoration,
    );

    return GestureDetector(
      onTap: () => onClick(),
      child: box,
    );
  }
}
