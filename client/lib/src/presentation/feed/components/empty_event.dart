import 'package:flutter/material.dart';

class EmptyEvent extends StatelessWidget {
  const EmptyEvent({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final decoration = BoxDecoration(
      color: theme.highlightColor,
      borderRadius: BorderRadius.circular(10),
    );

    final emptyLogo = Image.asset(
      'assets/icons/empty.png',
      fit: BoxFit.contain,
      width: 70,
      height: 70,
    );

    const text = Text(
      " No Event",
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    );

    const space = SizedBox(height: 10);

    final row = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        emptyLogo,
        space,
        text,
      ],
    );

    final content = Center(child: row);
    return Container(
      decoration: decoration,
      height: size.height - 20,
      child: content,
    );
  }
}
