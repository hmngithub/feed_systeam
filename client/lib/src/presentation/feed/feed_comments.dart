import 'package:converse_client/src/blocs/comment_bloc.g.dart';
import 'package:converse_client/src/blocs/comments_bloc.g.dart';
import 'package:converse_client/src/blocs/gateways/converse_repository.g.dart';
import 'package:converse_client/src/blocs/states/comments_state.g.dart';
import 'package:converse_client/src/domain/entities/comment.g.dart';
import 'package:converse_client/src/presentation/feed/components/box_comment.dart';
import 'package:converse_client/src/presentation/feed/components/box_comments_shimmer.dart';
import 'package:converse_client/src/presentation/feed/feed_comment_replies.dart';
import 'package:converse_client/src/presentation/feed/functions/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedComments extends StatefulWidget {
  final String? feedId;
  const FeedComments({
    super.key,
    this.feedId,
  });

  @override
  State<FeedComments> createState() => _FeedCommentsState();
}

class _FeedCommentsState extends State<FeedComments> {
  final _commentFieldController = TextEditingController();

  @override
  void initState() {
    _commentFieldController.addListener(_commentFiedlListener);
    super.initState();
  }

  @override
  void dispose() {
    _commentFieldController.dispose();
    super.dispose();
  }

  int commentTextLength = 0;
  void _commentFiedlListener() {
    final length = _commentFieldController.value.text.length;
    setState(() {
      commentTextLength = length;
    });
  }

  void _onCommentHandler() {
    String value = _commentFieldController.value.text;
    context.read<CommentBloc>().toInitState();
    context.read<CommentBloc>().setCommentContent(value);
    context.read<CommentBloc>().setCommentFeedId(widget.feedId);
    context.read<CommentBloc>().saveComment();
    _commentFieldController.clear();
  }

  void _onDeleteCommentHandler(String? id) {
    context.read<CommentsBloc>().deleteComment(id);
  }

  void _onEditCommentHandler(String? id, String value) {
    context.read<CommentBloc>().toInitState();
    context.read<CommentBloc>().setCommentContent(value);
    context.read<CommentBloc>().setCommentId(id);
    context.read<CommentBloc>().saveComment();
  }

  void _onReplyToCommentHandler(String? id, String value) {
    context.read<CommentBloc>().toInitState();
    context.read<CommentBloc>().setCommentIsReply(true);
    context.read<CommentBloc>().setCommentParentId(id);
    context.read<CommentBloc>().setCommentContent(value);
    context.read<CommentBloc>().saveComment();
  }

  void _onShowRepliesHandler(String? id) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return FeedCommentReplies(commentId: id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _comments(context),
    );
  }

  CommentsBloc _commentsProvider(BuildContext context) {
    return CommentsBloc(context.read<ConverseRepository>())
      ..streamComments(isEqualTo: {
        'feedId': widget.feedId,
        'isReplyMode': false,
      });
  }

  CommentsBloc _replyLengthProvider(BuildContext context, String? commenId) {
    return CommentsBloc(context.read<ConverseRepository>())
      ..streamComments(isEqualTo: {
        'parentId': commenId,
        'isReplyMode': true,
      });
  }

  Widget _commentsBuilder(BuildContext context, CommentsState state) {
    if (state.isLoadedCommentsEmpty) return _buildEmtyCommentWidget();
    if (state.status.isLoading) return const BoxCommentsShimmer();
    final comments = state.comments;
    return SliverList.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) => BlocProvider(
        create: (context) => _replyLengthProvider(context, comments[index].id),
        child: BlocSelector<CommentsBloc, CommentsState, int?>(
          selector: (state) => state.totalComments,
          builder: (context, state) => _commentWithReplyBuilder(
            context,
            totalReplies: state,
            comment: comments[index],
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
      commenId: comment.id,
      // profileImageUrl: comment.creatorImageUrl,
      // isCurrenUser: isCurrentUser,
      replyCount: _countFormat(totalReplies),
      // commenterName: commenterName,
      commenterName: '',
      comment: comment.content ?? '',
      date: creationDate,
      onShowReplies: _onShowRepliesHandler,
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

  Widget _bottomTextField(BuildContext context) {
    final theme = Theme.of(context);
    final commentButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.onPrimary,
    );
    final boxShadow = [
      BoxShadow(
        color: theme.colorScheme.shadow.withOpacity(0.2),
        blurRadius: 5,
        offset: const Offset(0, -2),
      )
    ];
    final decoration = BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      color: theme.colorScheme.background,
      boxShadow: boxShadow,
    );
    final inputDecoration = InputDecoration(
      suffixText: commentTextLength > 0 ? ' 600/$commentTextLength' : '',
      suffixStyle: TextStyle(
        color: commentTextLength == 600 ? Colors.red : null,
      ),
      border: InputBorder.none,
      counterText: '',
      hintText: 'Your Comment?',
    );
    final submitButton = ElevatedButton(
      style: commentButtonStyle,
      onPressed: _onCommentHandler,
      child: const Text('Send'),
    );
    final bottomCommentField = TextField(
      controller: _commentFieldController,
      maxLength: 600,
      decoration: inputDecoration,
    );
    final commentsActions = Row(
      children: [
        Expanded(child: bottomCommentField),
        const SizedBox(width: 10),
        submitButton,
      ],
    );
    return AnimatedContainer(
      padding: const EdgeInsets.all(8),
      decoration: decoration,
      duration: const Duration(milliseconds: 300),
      height: 60.0,
      child: commentsActions,
    );
  }

  _comments(BuildContext context) {
    const appBar = SliverAppBar(
      title: Text('Comments'),
    );

    final comments = BlocProvider(
      create: _commentsProvider,
      child: BlocBuilder<CommentsBloc, CommentsState>(
        builder: _commentsBuilder,
      ),
    );
    final contents = RefreshIndicator.adaptive(
      onRefresh: _onRefreshHandler,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          appBar,
          comments,
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(child: contents),
          _bottomTextField(context),
        ],
      ),
    );
  }

  Future _onRefreshHandler() async {
    await context.read<CommentsBloc>().fetchComments(
      isEqualTo: {
        'feedId': widget.feedId,
      },
    );
    setState(() {});
  }

  _buildEmtyCommentWidget() {
    final image = Expanded(
      child: Image.asset(
        'assets/pngs/empty_comment.png',
        width: 300,
      ),
    );
    const text = Expanded(child: Text('No comments have been made yet'));
    return SliverFillRemaining(
      child: Column(
        children: [image, text],
      ),
    );
  }
}
