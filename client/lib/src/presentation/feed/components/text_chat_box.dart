import 'package:flutter/material.dart';

class TextChatBox extends StatefulWidget {
  final bool showName;
  final Alignment align;
  final bool showSeen;
  final DateTime date;
  const TextChatBox({
    super.key,
    required this.align,
    required this.date,
    this.showName = false,
    this.showSeen = false,
  });

  @override
  State<TextChatBox> createState() => _TextChatBoxState();
}

class _TextChatBoxState extends State<TextChatBox> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const matan = Text("salam fraidon");

    const matanPadding = Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
      child: matan,
    );
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: theme.highlightColor,
    );
    const name = Text(
      "Sina",
      style: TextStyle(
        color: Colors.amber,
      ),
    );

    final namePadding = Padding(
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
      child: widget.showName
          ? name
          : const Text('', style: TextStyle(fontSize: 0)),
    );

    final date = Text(
      "${widget.date.hour}:${widget.date.minute}",
      style: const TextStyle(fontSize: 8),
    );

    final datePadding = Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
      child: date,
    );

    final endData = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [datePadding],
    );

    final endDateBox = FittedBox(
      child: endData,
    );

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [namePadding, matanPadding],
    );

    final stackChild1 = PositionedDirectional(child: content);
    final stackchild2 = PositionedDirectional(
      bottom: 2,
      end: 7,
      child: endDateBox,
    );

    final stack = Stack(
      children: [stackChild1, stackchild2],
    );

    final box = Container(
      margin: const EdgeInsets.fromLTRB(4, 1, 4, 1),
      decoration: boxDecoration,
      child: stack,
    );
    return Align(
      alignment: widget.align,
      child: box,
    );
  }
}
