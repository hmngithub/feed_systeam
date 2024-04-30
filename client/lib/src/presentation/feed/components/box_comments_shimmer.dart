import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BoxCommentsShimmer extends StatelessWidget {
  const BoxCommentsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listTile = ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.shadow.withOpacity(0.1),
      ),
      title: Container(
        height: 12.0,
        width: 100,
        color: theme.colorScheme.shadow.withOpacity(0.2),
      ),
      subtitle: Container(
        height: 12.0,
        width: 200,
        color: theme.colorScheme.shadow.withOpacity(0.2),
      ),
    );
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: theme.shadowColor.withOpacity(0.2),
    );
    final padding2 = Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 20),
      child: Container(
        height: 70,
        width: 600,
        decoration: boxDecoration,
      ),
    );
    final boxDecoration2 = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: theme.shadowColor.withOpacity(0.2),
    );
    final padding3 = Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: boxDecoration2,
        height: 35,
        width: 600,
      ),
    );
    final column = Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [listTile, padding2, padding3],
      ),
    );
    return SliverList.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: theme.shadowColor,
          highlightColor: theme.shadowColor.withOpacity(0.3),
          child: column,
        );
      },
    );
  }
}
