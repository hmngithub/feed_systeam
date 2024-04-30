import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'loading_divider.dart';

class FeedLoading extends StatelessWidget {
  const FeedLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final profiledecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(17),
      color: theme.highlightColor,
    );

    final profileBox = Container(
      height: 34,
      width: 34,
      decoration: profiledecoration,
    );

    final shimmerPorfile = Shimmer.fromColors(
      baseColor: theme.highlightColor,
      highlightColor: theme.primaryColor,
      child: profileBox,
    );
    final profile = SizedBox(
      height: 34,
      width: 34,
      child: shimmerPorfile,
    );

    const first1 = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoadingDivider(width: 100),
        SizedBox(height: 5),
        LoadingDivider(width: 150),
      ],
    );

    final first = Row(
      children: [
        size.width < 400 ? profileBox : profile,
        const SizedBox(width: 3),
        first1,
      ],
    );
    const secondConstraint = BoxConstraints(maxHeight: 400);

    final secondChild = Container(
      constraints: secondConstraint,
      color: theme.highlightColor,
    );

    final secondShimmer = Shimmer.fromColors(
      baseColor: theme.highlightColor,
      highlightColor: theme.primaryColor,
      child: secondChild,
    );
    final second = SizedBox(
      height: 400,
      child: size.width < 400 ? secondChild : secondShimmer,
    );

    final items = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        first,
        const SizedBox(height: 5),
        second,
      ],
    );
    return Container(child: items);
  }
}
