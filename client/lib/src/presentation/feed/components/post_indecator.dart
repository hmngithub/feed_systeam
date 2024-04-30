import 'package:flutter/material.dart';

class FeedIndecator extends StatelessWidget {
  final bool select;
  const FeedIndecator({super.key, this.select = false});

  @override
  Widget build(BuildContext context) {
    final them = Theme.of(context);
    final Color color;
    if (select) {
      color = them.hintColor;
    } else {
      color = them.highlightColor;
    }
    return Container(
      margin: const EdgeInsets.all(2),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color,
      ),
    );
  }
}
