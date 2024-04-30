import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingDivider extends StatelessWidget {
  final double width;
  const LoadingDivider({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: theme.highlightColor,
    );

    final box = Container(
      height: 8,
      width: width,
      decoration: decoration,
    );

    final loader = Shimmer.fromColors(
      baseColor: theme.highlightColor,
      highlightColor: theme.primaryColor,
      child: box,
    );
    return size.width < 400
        ? box
        : SizedBox(
            height: 8,
            width: width,
            child: loader,
          );
  }
}
