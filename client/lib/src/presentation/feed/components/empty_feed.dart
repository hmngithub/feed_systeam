import 'package:flutter/material.dart';

class EmptyFeed extends StatelessWidget {
  const EmptyFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final emptyLogo = Image.asset(
      'assets/icons/notFoundFeed.png',
      fit: BoxFit.contain,
      width: 150,
      height: 150,
    );
    return Center(child: emptyLogo);
  }
}
