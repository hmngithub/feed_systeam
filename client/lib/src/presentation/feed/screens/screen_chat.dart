import 'package:flutter/material.dart';

import '../components/chat_type_section.dart';
import '../components/circular_image.dart';
import '../form/form_chat.dart';

class ScreenChat extends StatelessWidget {
  static const String path = "/chat";
  const ScreenChat({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const backIcon = Icon(
      Icons.arrow_back_ios_new_outlined,
      color: Colors.blue,
    );
    final backButton = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: () {},
      icon: backIcon,
    );
    const image = CircularImage(url: "url", errorText: "A");
    const title = Text(
      "Laams Team",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    );

    const videoIcon = Icon(
      Icons.camera_alt_outlined,
      color: Colors.blue,
    );

    final videoCall = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: () {},
      icon: videoIcon,
    );
    const audioIcon = Icon(
      Icons.call,
      color: Colors.blue,
    );
    final audioCall = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: () {},
      icon: audioIcon,
    );
    final appbar = AppBar(
      actions: [
        backButton,
        image,
        title,
        const Expanded(child: SizedBox()),
        videoCall,
        audioCall
      ],
      automaticallyImplyLeading: false,
      backgroundColor: theme.highlightColor,
      surfaceTintColor: theme.highlightColor,
    );

    return Scaffold(
      appBar: appbar,
      bottomNavigationBar: Container(
        height: 50,
        color: theme.highlightColor,
        child: const CahtTypeSection(),
      ),
      body: const FormChat(),
    );
  }
}
