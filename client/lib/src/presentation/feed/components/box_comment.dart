import 'package:flutter/material.dart';

class BoxComment extends StatefulWidget {
  final String? commenId;
  final String? comment;
  final bool isCurrenUser;
  final String commenterName;
  final String date;
  final String? replyCount;
  final void Function(String? id)? onShowReplies;
  final void Function(String? id)? onDeleteTap;
  final String? profileImageUrl;
  final void Function(String? id, String message)? replyToComment;
  final void Function(String? id, String message)? onEditComment;

  const BoxComment({
    super.key,
    required this.commenId,
    required this.comment,
    required this.commenterName,
    required this.date,
    this.onShowReplies,
    this.isCurrenUser = false,
    this.replyToComment,
    this.onDeleteTap,
    this.replyCount,
    this.profileImageUrl,
    this.onEditComment,
  });

  @override
  State<BoxComment> createState() => _BoxCommentState();
}

class _BoxCommentState extends State<BoxComment> {
  int? _maxLines = 5;

  void _commentOnTapHandler() {
    setState(() {
      if (_maxLines == 5) {
        _maxLines = 100;
      } else {
        _maxLines = 5;
      }
    });
  }

  final _textController = TextEditingController();
  late TextEditingController _commentEditController;
  @override
  void initState() {
    super.initState();
    _commentEditController = TextEditingController(
      text: widget.comment,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _commentEditController.dispose();
  }

  void _replySendHandler() {
    if (widget.replyToComment != null) {
      widget.replyToComment!(widget.commenId, _textController.text);
      _textController.clear();
    }
  }

  bool _isEditingMode = false;
  _onEditHandler() {
    setState(() {
      _isEditingMode = true;
    });
  }

  void _replyToCommendHandler(String value) {
    if (widget.replyToComment != null) {
      widget.replyToComment!(widget.commenId, value);
    }
  }

  void _onEditCommentHandler() {
    if (widget.onEditComment != null) {
      widget.onEditComment!(
        widget.commenId,
        _commentEditController.text,
      );
    }
    setState(() => _isEditingMode = false);
  }

  void _onDeleteCommentHandler() {
    if (widget.onDeleteTap != null) {
      widget.onDeleteTap!(widget.commenId);
    }
  }

  void _cancelEditHandler() {
    return setState(
      () => _isEditingMode = false,
    );
  }

  void _onShowRepliesHandler() {
    if (widget.onShowReplies != null) {
      widget.onShowReplies!(widget.commenId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Styles: ----------------------------------------------
    final theme = Theme.of(context);
    final creationDateStyle = theme.textTheme.bodySmall;
    final deleteIconColor = theme.colorScheme.error;
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    );
    final replyInputDecoration = InputDecoration(
      isDense: true,
      border: outlineInputBorder,
      hintText: 'Type a Reply ...',
    );
    final replyButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.onPrimary,
    );
    final commentDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: theme.highlightColor.withOpacity(0.1),
    );
    final replyactionButtonTextStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.primary,
    );
    final deleteMenuItemTextStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.error,
    );

    const editCommentFieldDecoration = InputDecoration(
      border: InputBorder.none,
    );

    final replyactionButtonStyle = IconButton.styleFrom(
      backgroundColor: theme.colorScheme.onPrimary,
      foregroundColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
    // Styles: ----------------------------------------------
    var name = Text(widget.commenterName);
    var creationDate = Text(
      widget.date,
      style: creationDateStyle,
    );

    var commentConten = Text(
      '${widget.comment}',
      maxLines: _maxLines,
      overflow: TextOverflow.ellipsis,
    );

    var comment = Expanded(
      child: GestureDetector(
        onTap: _commentOnTapHandler,
        child: commentConten,
      ),
    );

    var replyactionButton = Column(
      children: [
        IconButton(
          style: replyactionButtonStyle,
          onPressed: _onShowRepliesHandler,
          icon: const Icon(Icons.reply_rounded),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            widget.replyCount ?? '',
            style: replyactionButtonTextStyle,
          ),
        )
      ],
    );
    var commentItems = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        comment,
        widget.replyToComment != null ? replyactionButton : const SizedBox(),
      ],
    );
    final commentSection = Container(
      padding: const EdgeInsets.all(10),
      decoration: commentDecoration,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: commentItems,
    );

    final editActionButtons = Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: replyButtonStyle,
            onPressed: _cancelEditHandler,
            child: const Icon(Icons.close),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            style: replyButtonStyle,
            onPressed: _onEditCommentHandler,
            child: const Icon(Icons.check),
          ),
        ],
      ),
    );

    final editCommentField = TextField(
      controller: _commentEditController,
      maxLines: 3,
      maxLength: 600,
      decoration: editCommentFieldDecoration,
    );

    final commentEditSection = Container(
      padding: const EdgeInsets.all(10),
      decoration: commentDecoration,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: editCommentField,
    );
    final commenterProfile = widget.profileImageUrl != null
        ? CircleAvatar(
            backgroundImage: NetworkImage(widget.profileImageUrl!),
          )
        : CircleAvatar(
            child: Text(widget.commenterName[0]),
          );

    final deleteMenuItem = PopupMenuItem(
      onTap: _onDeleteCommentHandler,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Delete',
            style: deleteMenuItemTextStyle,
          ),
          Icon(
            Icons.delete_outline_rounded,
            color: deleteIconColor,
          ),
        ],
      ),
    );

    final editMenuItem = PopupMenuItem(
      onTap: _onEditHandler,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Edit'),
          Icon(Icons.edit),
        ],
      ),
    );

    final popupMenuButton = PopupMenuButton(
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (context) {
        return [
          deleteMenuItem,
          editMenuItem,
        ];
      },
    );

    final replyTextField = Expanded(
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: _textController,
          onSubmitted: _replyToCommendHandler,
          cursorHeight: 15,
          style: theme.textTheme.labelMedium,
          decoration: replyInputDecoration,
        ),
      ),
    );

    final replyButton = ElevatedButton(
      style: replyButtonStyle,
      onPressed: _replySendHandler,
      child: const Text('Reply'),
    );
    final replyFieldItems = Row(
      children: [
        replyTextField,
        const SizedBox(width: 8),
        replyButton,
      ],
    );
    final replyFields = Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      padding: const EdgeInsets.all(8.0),
      child: replyFieldItems,
    );
    var header = ListTile(
      leading: commenterProfile,
      title: name,
      subtitle: creationDate,
      trailing: widget.isCurrenUser ? popupMenuButton : const SizedBox(),
      isThreeLine: true,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        header,
        _isEditingMode ? commentEditSection : commentSection,
        widget.replyToComment != null && !_isEditingMode
            ? replyFields
            : const SizedBox(),
        _isEditingMode ? editActionButtons : const SizedBox()
      ],
    );
  }
}
