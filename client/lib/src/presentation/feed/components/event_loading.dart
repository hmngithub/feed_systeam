import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'loading_divider.dart';

class EventLoadin extends StatelessWidget {
  const EventLoadin({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final step1Decoration = BoxDecoration(
      color: theme.highlightColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );

    final step1Box = Container(
      decoration: step1Decoration,
    );

    final step1Shimmer = Shimmer.fromColors(
      baseColor: theme.highlightColor,
      highlightColor: theme.primaryColor,
      child: step1Box,
    );
    final step1 = Expanded(child: step1Shimmer);
    const profileName = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingDivider(width: 150),
        SizedBox(height: 5),
        LoadingDivider(width: 100),
      ],
    );

    final profiledecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(17),
      color: theme.primaryColor,
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

    final profilePadding = Padding(
      padding: const EdgeInsets.all(5),
      child: profile,
    );

    final step2Content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        profilePadding,
        profileName,
      ],
    );
    final step2 = SizedBox(
      height: 50,
      child: step2Content,
    );

    final column = Column(
      children: [step1, step2],
    );
    const contstraint = BoxConstraints(
      maxHeight: 250,
      maxWidth: 300,
    );
    final decoration = BoxDecoration(
      color: theme.highlightColor,
      borderRadius: BorderRadius.circular(10),
    );
    return Container(
      constraints: contstraint,
      margin: const EdgeInsets.all(5),
      decoration: decoration,
      child: column,
    );
  }
}
