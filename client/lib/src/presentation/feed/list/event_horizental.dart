import 'package:flutter/material.dart';

import '../../../domain/entities/feed.g.dart';
import '../card/event_card.dart';

class EventHorizental extends StatelessWidget {
  final List<Feed> feeds;
  const EventHorizental({
    super.key,
    required this.feeds,
  });

  @override
  Widget build(BuildContext context) {
    final containerChild = CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: [
        SliverList.builder(
          itemCount: feeds.length,
          itemBuilder: (context, index) => EventCard(
            feed: feeds[index],
          ),
        )
      ],
    );

    final centerChild = Container(
      constraints: const BoxConstraints(
        maxWidth: 550,
        minWidth: 360,
        maxHeight: 250,
      ),
      child: containerChild,
    );
    return centerChild;
  }
}
