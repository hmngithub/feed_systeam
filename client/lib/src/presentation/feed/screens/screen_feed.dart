import 'package:converse_client/src/presentation/feed/components/feed_uploader_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/feed_bloc.g.dart';
import '../../../blocs/feeds_bloc.g.dart';
import '../../../blocs/states/feeds_state.g.dart';
import '../../../domain/entities/feed.g.dart';
import '../card/event_card.dart';
import '../card/feed_card.dart';
import '../components/empty_feed.dart';
import '../components/feed_loading.dart';
import '../components/fetch_more_loader.dart';
import '../components/search.dart';
import '../form/form_create_feed.dart';

class ScreenFeeds extends StatefulWidget {
  const ScreenFeeds({super.key});

  @override
  State<ScreenFeeds> createState() => _ScreenFeedsState();
}

class _ScreenFeedsState extends State<ScreenFeeds> {
  final feedController = ScrollController();
  @override
  void initState() {
    super.initState();
    feedListener(context);
  }

  void feedListener(BuildContext context) {
    feedController.addListener(() {
      if (feedController.position.atEdge) {
        if (feedController.position.pixels > 0) {
          context.read<FeedsBloc>().fetchMoreFeeds();
        }
      }
    });
  }

  dynamic feedSearched(FeedsState state, Size size) {
    if (state.searchResult.isEmpty) {
      return const SliverToBoxAdapter(child: EmptyFeed());
    } else {
      return SliverList.builder(
        itemCount: state.searchResult.length,
        itemBuilder: (context, index) {
          return EventCard(feed: state.searchResult[index]);
        },
      );
    }
  }

  dynamic feedFetched(FeedsState state, Size size) {
    if (state.feeds.isEmpty) {
      final box = SizedBox(height: (size.height / 2) - 100);
      return SliverToBoxAdapter(
          child: Column(
        children: [box, const EmptyFeed()],
      ));
    }
    return SliverList.builder(
      itemBuilder: (c, i) {
        return FeedCard(feed: state.feeds[i], index: i);
      },
      itemCount: state.feeds.length,
    );
  }

  void createFeedOnPressed(Size size) {
    context.read<FeedBloc>().setFeed(const Feed.init());
    if (size.width > 500) {
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) => const CreateFeed(),
      );
    } else {
      showBottomSheet(
        constraints:
            BoxConstraints(maxHeight: size.height, maxWidth: size.width),
        context: context,
        builder: (context) => const CreateFeed(isBottomSheet: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    context.read<FeedBloc>().setFeed(const Feed.init());

    final addFeedButton = IconButton(
      onPressed: () => createFeedOnPressed(size),
      icon: const Icon(Icons.new_label_rounded),
    );

    const appBarLeading = Center(
      child: Text(
        "Feed",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );

    final appBar = SliverAppBar(
      scrolledUnderElevation: 0.1,
      pinned: true,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Search(),
      actions: [addFeedButton],
      leading: appBarLeading,
    );

    const spacer = SizedBox(height: 10);
    const loadingShimmerDelegate = Column(
      children: [FeedLoading(), spacer, FeedLoading()],
    );

    Widget feedsBuilder(BuildContext context, FeedsState state) {
      if (state.status.isFetchingMore || state.status.isFetchedMore) {
        return feedFetched(state, size);
      } else if (state.status.isSearching || state.status.isFetching) {
        return const SliverToBoxAdapter(child: loadingShimmerDelegate);
      } else if (state.status.isStreaming) {
        return const SliverToBoxAdapter(child: loadingShimmerDelegate);
      } else if (state.status.isDeleted || state.status.isDeleting) {
        return feedFetched(state, size);
      } else if (state.status.isSearched) {
        return feedSearched(state, size);
      } else if (state.status.isFetched ||
          state.status.isDeleted ||
          state.status.isStreamed) {
        return feedFetched(state, size);
      } else {
        return SliverToBoxAdapter(child: Container());
      }
    }

    final feedsBloc = BlocBuilder<FeedsBloc, FeedsState>(
      builder: feedsBuilder,
    );

    const moreLoader = SliverToBoxAdapter(
      child: FetchMoreLoader(),
    );

    const changeLoader = SliverToBoxAdapter(
      child: FeedUploaderDisplay(),
    );

    return CustomScrollView(
      controller: feedController,
      slivers: [
        appBar,
        changeLoader,
        feedsBloc,
        moreLoader,
      ],
    );
  }
}
