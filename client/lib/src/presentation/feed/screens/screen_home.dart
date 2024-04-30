import 'package:flutter/material.dart';

import 'screen_feed.dart';

class ScreenHome extends StatelessWidget {
  static const String path = "/";
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenFeeds(),
    );
  }
}
