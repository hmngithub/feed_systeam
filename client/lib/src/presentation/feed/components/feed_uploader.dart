import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FeedUploader extends StatefulWidget {
  final bool change;
  final String massege;
  const FeedUploader({
    super.key,
    this.change = false,
    this.massege = "Succeded",
  });

  @override
  State<FeedUploader> createState() => _FeedUploaderState();
}

class _FeedUploaderState extends State<FeedUploader> {
  bool hide = false;
  late Timer timer;

  void duration() async {
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        hide = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loading = LoadingAnimationWidget.prograssiveDots(
      color: theme.highlightColor,
      size: 30,
    );
    final text = Text(
      widget.massege,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    );

    final centerChild = widget.change ? text : loading;
    final result = SizedBox(
      height: 30,
      width: double.infinity,
      child: Center(child: centerChild),
    );
    if (widget.change) {
      duration();
    }
    return hide ? Container() : result;
  }
}
