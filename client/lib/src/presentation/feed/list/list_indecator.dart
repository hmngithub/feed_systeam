import 'package:flutter/material.dart';

import '../components/post_indecator.dart';

class ListIndecator extends StatelessWidget {
  final int count;
  final int select;
  const ListIndecator({super.key, required this.count, required this.select});

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = List.generate(count, (index) {
      if (index == select) return const FeedIndecator(select: true);
      return const FeedIndecator();
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );
  }
}
