import 'package:flutter/material.dart';

class PopUp<T> extends PopupMenuEntry<T> {
  const PopUp(
      {super.key,
      this.height = 50,
      this.value,
      required this.child,
      this.onTap});
  final T? value;

  final VoidCallback? onTap;

  @override
  final double height;

  final Widget child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  PopupMenuItemState<T, PopUp<T>> createState() =>
      PopupMenuItemState<T, PopUp<T>>();
}

class PopupMenuItemState<T, W extends PopUp<T>> extends State<W> {
  @protected
  Widget? buildChild() => widget.child;

  @protected
  void handleTap() {
    Navigator.pop<T>(context, widget.value);

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: widget.child,
    );
  }
}
