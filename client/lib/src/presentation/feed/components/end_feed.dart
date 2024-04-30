import 'package:converse_client/converse_client.dart';
import 'package:converse_client/src/blocs/like_bloc.g.dart';
import 'package:converse_client/src/blocs/states/like_state.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../list/list_indecator.dart';
import 'comment_dialog.dart';

class FeedEnd extends StatefulWidget {
  final String postId;
  final int likeNumber;
  final int photoLenght;
  final int selectedPage;
  final bool liked;
  final Function() onLikePressed;

  const FeedEnd({
    super.key,
    required this.postId,
    required this.onLikePressed,
    required this.likeNumber,
    required this.photoLenght,
    required this.selectedPage,
    required this.liked,
  });

  @override
  State<FeedEnd> createState() => _FeedEndState();
}

class _FeedEndState extends State<FeedEnd> {
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    likeCount = widget.likeNumber;
    super.initState();
  }

  void _commentOnPressed(Size size) {
    if (size.width > 500) {
      showDialog(context: context, builder: (context) => const CommentDialog());
    } else {
      showBottomSheet(
          context: context,
          builder: (context) => const CommentDialog(isBottomSheet: true));
    }
  }

  void onPressed() {
    widget.onLikePressed();
    if (isLiked) {
      int count = context.read<FeedBloc>().state.feed.likes ?? 0;
      if (count > 0) {
        context.read<FeedBloc>().setFeedLikes(count - 1);
      }
      context.read<FeedBloc>().setFeedLiked(false);
      context.read<FeedBloc>().updateFeed();
      // String userId = context.read<AuthBloc>().state.user.id ?? '';
      // context.read<LikeBloc>().deleteLike(userId + widget.postId);
      context.read<FeedBloc>().setFeedLiked(false);
      setState(() {
        likeCount -= 1;
      });
    }
    if (isLiked == false) {
      // String userId = context.read<AuthBloc>().state.user.id ?? '';
      // String firstName = context.read<AuthBloc>().state.user.firstName ?? "";
      // String lastName = context.read<AuthBloc>().state.user.lastName ?? "";
      // int count = context.read<FeedBloc>().state.feed.likeNumber ?? 0;

      // context.read<FeedBloc>().setFeedLikeNumber(count + 1);
      context.read<FeedBloc>().updateFeed();
      // context.read<LikeBloc>().setLikeUserId(userId);
      context.read<LikeBloc>().setLikeFeedId(widget.postId);
      // context.read<LikeBloc>().setLikeCreatorFirstName(firstName);
      // context.read<LikeBloc>().setLikeCreatorLastName(lastName);
      // context.read<LikeBloc>().setLikeLastModifierId(userId);
      context.read<LikeBloc>().setLikeLastModifiedDate(DateTime.now());
      // context.read<LikeBloc>().createLike(userId + widget.postId);
      context.read<FeedBloc>().setFeedLiked(true);
      setState(() {
        likeCount += 1;
      });
    }
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final like = IconButton(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onPressed: onPressed,
      icon: const Icon(
        Icons.favorite_border_outlined,
      ),
    );
    final liked = IconButton(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onPressed: onPressed,
      icon: const Icon(
        Icons.favorite,
        color: Colors.red,
      ),
    );

    final providerChild =
        BlocBuilder<LikeBloc, LikeState>(builder: (context, state) {
      if (isLiked) {
        return liked;
      } else if (state.status.isDeleted) {
        isLiked = false;
        return like;
      } else if (state.status.isSuccess) {
        if (state.like.id != null) {
          isLiked = true;
          return liked;
        } else {
          isLiked = false;
          return like;
        }
      } else {
        isLiked = false;
        return like;
      }
    });

    // final userid = context.read<AuthBloc>().state.user.id;
    final provider = BlocProvider(
      create: (c) => LikeBloc(c.read<ConverseRepository>()),
      // ..fetchLike(userid! + widget.postId),
      child: providerChild,
    );

    final likePadding = Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: provider,
    );

    final comment = IconButton(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onPressed: () => _commentOnPressed(size),
      icon: const Icon(
        Icons.comment_bank_outlined,
      ),
    );
    final share = IconButton(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onPressed: () {},
      icon: const Icon(
        Icons.share_rounded,
      ),
    );

    final showLike = Text("$likeCount Likes");

    final showLikePadding = Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 15, 0),
      child: showLike,
    );
    final step1 = Row(
      children: [likePadding, comment, share],
    );
    final step2 = Center(
      child: ListIndecator(
        count: widget.photoLenght,
        select: widget.selectedPage,
      ),
    );
    final step3 = Align(
      alignment: AlignmentDirectional.centerEnd,
      child: showLikePadding,
    );
    return Row(
      children: [
        Expanded(child: step1),
        Expanded(child: step2),
        Expanded(child: step3),
      ],
    );
  }
}
