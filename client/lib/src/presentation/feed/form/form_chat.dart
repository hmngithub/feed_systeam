import 'package:flutter/material.dart';

import '../components/text_chat_box.dart';

class FormChat extends StatelessWidget {
  const FormChat({super.key});

  @override
  Widget build(BuildContext context) {
    final testIteam = SliverList.builder(
      itemCount: 20,
      itemBuilder: (c, i) {
        if (i % 2 == 0) {
          return TextChatBox(
            align: Alignment.centerLeft,
            showName: false,
            date: DateTime.now(),
          );
        } else {
          return TextChatBox(
            align: Alignment.centerLeft,
            showName: true,
            date: DateTime.now(),
          );
        }
      },
    );

    return CustomScrollView(
      slivers: [testIteam],
    );
  }
}
