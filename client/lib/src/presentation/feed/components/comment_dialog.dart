import 'package:flutter/material.dart';

class CommentDialog extends StatelessWidget {
  final bool isBottomSheet;
  const CommentDialog({super.key, this.isBottomSheet = false});
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();
    final size = MediaQuery.of(context).size.height;

    void closeButtonOnPressed() {
      Navigator.pop(context);
    }

    double maxHeight;
    if (isBottomSheet) {
      maxHeight = size;
    } else {
      maxHeight = 550;
    }
    final constraint = BoxConstraints(
      maxHeight: maxHeight,
      maxWidth: 500,
      minHeight: 350,
      minWidth: 350,
    );

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      color: theme.dialogBackgroundColor,
    );
    const label = Text(
      "Comments",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
    final child1 = Expanded(
      child: Container(),
    );
    final child2 = Expanded(
      child: Container(
        alignment: AlignmentDirectional.center,
        child: label,
      ),
    );

    final closeButton = IconButton(
      isSelected: true,
      onPressed: closeButtonOnPressed,
      icon: const Icon(Icons.close),
    );
    final child3 = Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        alignment: AlignmentDirectional.bottomEnd,
        child: closeButton,
      ),
    );
    final step1 = Row(
      children: [child1, child2, child3],
    );
    final column = Column(
      children: [step1],
    );
    final box = Container(
      constraints: constraint,
      decoration: decoration,
      child: column,
    );

    if (isBottomSheet) {
      return SafeArea(child: box);
    }
    return SafeArea(child: Center(child: box));
  }
}
