import 'package:converse_client/src/blocs/feed_bloc.g.dart';
import 'package:converse_client/src/blocs/feeds_bloc.g.dart';
import 'package:converse_client/src/blocs/like_bloc.g.dart';
import 'package:converse_client/src/domain/entities/feed.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

// import 'package:url_launcher/url_launcher.dart';

import '../components/circular_image.dart';
import '../components/end_feed.dart';
import '../components/popup.dart';
import '../components/media_post.dart';
import '../form/form_create_feed.dart';
import '../functions/format_feed_date.dart';

class FeedCard extends StatefulWidget {
  final Feed feed;
  final int index;
  const FeedCard({super.key, required this.feed, required this.index});

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  int pageIndex = 0;

  void onHideOnPressed() {
    Navigator.of(context).pop();
  }

  void onLikeOnPressed() {
    context.read<FeedBloc>().setFeed(widget.feed);
  }

  void onDelete(BuildContext context) {
    if (widget.feed.liked!) {
      context
          .read<LikeBloc>()
          .deleteLike(widget.feed.creatorId! + widget.feed.id!);
    }
    context.read<FeedsBloc>().deleteFeed(widget.feed.id);
    Navigator.of(context).pop();
  }

  void onUpdate(BuildContext context, Size size) {
    Navigator.of(context).pop();
    context.read<FeedBloc>().setFeed(widget.feed);
    if (size.width > 500) {
      showDialog(
        context: context,
        builder: (context) => const CreateFeed(
          isUpdate: true,
        ),
      );
    } else {
      showBottomSheet(
        context: context,
        builder: (context) => const CreateFeed(
          isBottomSheet: true,
          isUpdate: true,
        ),
      );
    }
  }

  void onActionPressed() {
    // final url = Uri.parse(widget.feed.followURL ?? '');
    // launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final them = Theme.of(context);

    final size = MediaQuery.of(context).size;

    final name = Text(
      "${widget.feed.creatorFirstName} ${widget.feed.creatorLastName}",
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    );

    final namePaddign = Padding(
      padding: EdgeInsets.zero,
      child: name,
    );

    final data = Text(
      formatDate(widget.feed.creationDate ?? DateTime.now(), context),
      style: const TextStyle(
        fontSize: 11,
      ),
    );
    final profileName = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [namePaddign, data],
    );

    const spacer = Spacer();

    const hideLeading = Icon(Icons.close);
    const hideTitle = Text("Hide Feed");
    final hide = ListTile(
      leading: hideLeading,
      title: hideTitle,
      onTap: onHideOnPressed,
    );
    const updateLeading = Icon(Icons.note_alt_rounded);
    const updateTitle = Text("Update Feed");
    final update = ListTile(
      leading: updateLeading,
      title: updateTitle,
      onTap: () => onUpdate(context, size),
    );

    final deleteLeading = Icon(Icons.delete, color: them.iconTheme.color);
    const deleteTitle = Text("Delete Feed");
    final delete = ListTile(
      leading: deleteLeading,
      title: deleteTitle,
      onTap: () => onDelete(context),
    );
    List<PopUp> items = [
      PopUp(child: hide),
      PopUp(child: update),
      PopUp(child: delete)
    ];
    final moreOption = PopupMenuButton(
      elevation: 0.9,
      tooltip: "more action",
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.more_horiz),
      color: them.scaffoldBackgroundColor,
      clipBehavior: Clip.antiAlias,
      itemBuilder: (c) => items,
    );

    final morePadding = Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
      child: moreOption,
    );

    final profilePic = CircularImage(
      size: 20,
      url: widget.feed.creatorImageUrl ?? "",
      errorText: widget.feed.creatorFirstName!.substring(0, 1),
      borderThikness: 2,
    );

    final profileRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [profilePic, profileName, spacer, morePadding],
    );

    final step1 = SizedBox(
      height: 60,
      child: profileRow,
    );

    const moreStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    const lessStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    final readMore = ReadMoreText(
      widget.feed.content ?? "",
      trimLines: 2,
      trimMode: TrimMode.Line,
      textAlign: TextAlign.start,
      trimCollapsedText: "Show_More",
      trimExpandedText: "   Show_Less",
      moreStyle: moreStyle,
      lessStyle: lessStyle,
    );

    final step2 = Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: widget.feed.content!.isEmpty ? Container() : readMore,
    );

    const constraint = BoxConstraints(
      maxHeight: 300,
      maxWidth: 800,
    );

    final pageView = PageView.builder(
      itemCount: widget.feed.medias!.length,
      itemBuilder: (context, index) => MediaPost(
        url: widget.feed.medias![index].url,
        type: widget.feed.medias![index].type,
      ),
      onPageChanged: (vl) {
        setState(() {
          pageIndex = vl;
        });
      },
    );

    final boxColor = widget.feed.hasbackRound ?? false
        ? Color.fromARGB(
            widget.feed.backRound!.backroundAccentValue ?? 0,
            widget.feed.backRound!.backroundRedValue ?? 0,
            widget.feed.backRound!.backroundGreenValue ?? 0,
            widget.feed.backRound!.backroundBlueValue ?? 0)
        : them.highlightColor;

    final boxChild = widget.feed.hasbackRound ?? false
        ? Text(
            widget.feed.backRound!.content ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(
                    widget.feed.backRound!.contenAccentValue ?? 0,
                    widget.feed.backRound!.contentRedValue ?? 0,
                    widget.feed.backRound!.contentgreenValue ?? 0,
                    widget.feed.backRound!.contentBlueValue ?? 0),
                fontSize: widget.feed.backRound!.fontSize ?? 0),
          )
        : pageView;
    final media = Container(
      alignment: Alignment.center,
      constraints: constraint,
      color: boxColor,
      child: boxChild,
    );

    final step3 = media;

    // const actionText = Text(
    //   "Learn More",
    //   style: TextStyle(fontWeight: FontWeight.bold),
    // );

    // const actionTextPadding = Padding(
    //   padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
    //   child: actionText,
    // );

    // final actionSpacer = Expanded(
    //   child: Container(),
    // );

    // const actionIcon = Icon(
    //   Icons.arrow_forward_ios,
    // );
    // const actionPaddingIcon = Padding(
    //   padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
    //   child: actionIcon,
    // );

    // final action = Row(
    //   children: [
    //     actionTextPadding,
    //     actionSpacer,
    //     actionPaddingIcon,
    //   ],
    // );
    // final actionBox = Container(
    //   constraints: const BoxConstraints(maxHeight: 28),
    //   color: const Color.fromARGB(131, 240, 237, 241),
    //   child: action,
    // );

    // final actionRegion = MouseRegion(
    //   cursor: SystemMouseCursors.click,
    //   child: actionBox,
    // );

    // final step4 = GestureDetector(
    //   onTap: onActionPressed,
    //   child: actionRegion,
    // );

    final step5 = SizedBox(
        height: 40,
        child: FeedEnd(
          postId: widget.feed.id ?? '',
          onLikePressed: onLikeOnPressed,
          likeNumber: widget.feed.likes ?? 0,
          photoLenght: widget.feed.medias?.length ?? 0,
          selectedPage: pageIndex,
          liked: widget.feed.liked ?? false,
        ));

    // final step4Action = widget.feed.followURL!.isEmpty ? Container() : step4;

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        step1,
        step2,
        step3,
        step5,
      ],
    );

    final decoration = BoxDecoration(
      color: them.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(4),
    );
    final box = Container(
      constraints: const BoxConstraints(maxWidth: 550, minWidth: 300),
      margin: const EdgeInsets.fromLTRB(2, 2, 0, 2),
      decoration: decoration,
      child: column,
    );

    return box;
  }
}
