import 'package:converse_client/converse_client.dart';
import 'package:converse_client/src/blocs/comment_bloc.g.dart';
import 'package:converse_client/src/blocs/comments_bloc.g.dart';
import 'package:converse_client/src/blocs/states/comment_state.g.dart';
import 'package:converse_client/src/blocs/states/comments_state.g.dart';
import 'package:converse_client/src/domain/entities/comment.g.dart';
import 'package:converse_client/src/presentation/feed/components/box_comment.dart';
import 'package:converse_client/src/presentation/feed/components/box_comment_shimmer.dart';
import 'package:converse_client/src/presentation/feed/components/replies_shimmer.dart';
import 'package:converse_client/src/presentation/feed/functions/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedCommentReplies extends StatefulWidget {
  final String? commentId;
  const FeedCommentReplies({
    super.key,
    this.commentId,
  });

  @override
  State<FeedCommentReplies> createState() => _FeedCommentRepliesState();
}

class _FeedCommentRepliesState extends State<FeedCommentReplies> {
  void _onDeleteCommentHandler(String? id) {
    context.read<CommentsBloc>().deleteComment(id);
  }

  void _onEditCommentHandler(String? id, String value) {
    context.read<CommentBloc>().toInitState();
    context.read<CommentBloc>().setCommentContent(value);
    context.read<CommentBloc>().setCommentId(id);
    context.read<CommentBloc>().saveComment();
  }

  void _onEditReplyHandler(String? id, String value) {
    context.read<CommentBloc>().toInitState();
    context.read<CommentBloc>().setCommentContent(value);
    context.read<CommentBloc>().setCommentId(id);
    context.read<CommentBloc>().setCommentIsReply(true);
    context.read<CommentBloc>().setCommentParentId(widget.commentId);
    context.read<CommentBloc>().saveComment();
  }

  void _onReplyToCommentHandler(String? id, String value) {
    context.read<CommentBloc>().toInitState();
    context.read<CommentBloc>().setCommentIsReply(true);
    context.read<CommentBloc>().setCommentParentId(id);
    context.read<CommentBloc>().setCommentContent(value);
    context.read<CommentBloc>().saveComment();
  }

  CommentBloc _commentProvider(BuildContext context) {
    return CommentBloc(context.read<ConverseRepository>())
      ..fetchComment(
        widget.commentId,
      );
  }

  CommentsBloc _repliesProvider(BuildContext context) {
    return CommentsBloc(
      context.read<ConverseRepository>(),
    )..streamComments(
        isEqualTo: {
          'isReplyMode': true,
          'parentId': widget.commentId,
        },
      );
  }

  Widget _commentBuilder(BuildContext context, CommentState state) {
    if (state.status.isLoading) return const BoxCommentShimmer();
    final comment = state.comment;
    return SliverToBoxAdapter(
      child: BlocProvider(
        create: _repliesProvider,
        child: BlocSelector<CommentsBloc, CommentsState, int?>(
          selector: (state) => state.totalComments,
          builder: (context, state) => _commentWithReplyBuilder(
            context,
            totalReplies: state,
            comment: comment,
          ),
        ),
      ),
    );
  }

  Widget _commentWithReplyBuilder(
    BuildContext context, {
    int? totalReplies,
    required Comment comment,
  }) {
    // final currentUserId = context.read<AuthBloc>().state.user.id;
    // final creatorFirstName = comment.creatorFirstName;
    // final creatorLastName = comment.creatorLastName;
    // final commenterName = '$creatorFirstName $creatorLastName';
    // final isCurrentUser = currentUserId == comment.creatorId;
    final creationDate = dateFormat(
      comment.lastModifiedDate ?? comment.creationDate,
      comment.lastModifiedDate != null,
    );
    return BoxComment(
      commenId: widget.commentId,
      // profileImageUrl: comment.creatorImageUrl,
      // isCurrenUser: isCurrentUser,
      replyCount: _countFormat(totalReplies),
      // commenterName: commenterName,
      commenterName: '',
      comment: comment.content,
      date: creationDate,
      onDeleteTap: _onDeleteCommentHandler,
      onEditComment: _onEditCommentHandler,
      replyToComment: _onReplyToCommentHandler,
    );
  }

  String _countFormat(int? count) {
    if (count == null || count == 0) {
      return '';
    }
    if (count >= 1000000000) {
      return '${(count / 1000000000).toStringAsFixed(1)}B';
    } else if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return '$count';
    }
  }

  Widget _repliesBuilder(BuildContext context, CommentsState state) {
    if (state.isLoadedCommentsEmpty) return _buildEmtyCommentWidget();
    if (state.status.isLoading) return const RepliesShimmer();
    // final currentUserId = context.read<AuthBloc>().state.user.id;
    return SliverList.builder(
        itemCount: state.comments.length,
        itemBuilder: (context, index) {
          final comment = state.comments[index];
          // final isCurrentUser = currentUserId == comment.creatorId;
          // final creatorFirstName = comment.creatorFirstName;
          // final creatorLastName = comment.creatorLastName;
          // final commenterName = '$creatorFirstName $creatorLastName';
          final creationDate = dateFormat(
            comment.lastModifiedDate ?? comment.creationDate,
            comment.lastModifiedDate != null,
          );
          return BoxComment(
            commenId: comment.id,
            // profileImageUrl: comment.creatorImageUrl,
            comment: comment.content,
            // isCurrenUser: isCurrentUser,
            // commenterName: commenterName,
            commenterName: '',
            date: creationDate,
            onDeleteTap: _onDeleteCommentHandler,
            onEditComment: _onEditReplyHandler,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    const appBar = SliverAppBar(
      title: Text('Replies'),
    );

    final selectedComment = BlocProvider(
      create: _commentProvider,
      child: BlocBuilder<CommentBloc, CommentState>(
        builder: _commentBuilder,
      ),
    );

    final replies = BlocProvider(
      lazy: true,
      create: _repliesProvider,
      child: BlocBuilder<CommentsBloc, CommentsState>(
        builder: _repliesBuilder,
      ),
    );
    final contents = RefreshIndicator.adaptive(
      onRefresh: _onRefreshHandler,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          appBar,
          selectedComment,
          replies,
        ],
      ),
    );

    final box = Center(
      child: SizedBox(
        width: 600,
        child: contents,
      ),
    );
    return Scaffold(
      body: box,
    );
  }

  Future _onRefreshHandler() async {
    await context.read<CommentsBloc>().fetchComments(
      isEqualTo: {
        'parentId': widget.commentId,
      },
    );
    setState(() {});
  }

  _buildEmtyCommentWidget() {
    final image = Expanded(
      child: Image.asset(
        'pngs/empty_comment.png',
        width: 300,
      ),
    );
    const text = Expanded(child: Text('No Reply have been made yet'));
    return SliverFillRemaining(
      child: Column(
        children: [image, text],
      ),
    );
  }
}
