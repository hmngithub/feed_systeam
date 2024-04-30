import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:url_launcher/url_launcher.dart';

import '../../../blocs/feed_bloc.g.dart';
import '../../../blocs/feeds_bloc.g.dart';
import '../../../domain/entities/feed.g.dart';
import '../components/circular_image.dart';
import '../components/popup.dart';
import '../form/form_create_feed.dart';
import '../functions/format_feed_date.dart';

class EventCard extends StatefulWidget {
  final Feed feed;
  const EventCard({
    super.key,
    required this.feed,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isHovered = false;

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }

  void onHideOnPressed() {
    Navigator.of(context).pop();
    // context.read<FeedsBloc>().removeWithIndex(widget.index);
  }

  void onDelete(BuildContext context) {
    Navigator.of(context).pop();
    context.read<FeedsBloc>().deleteFeed(widget.feed.id);
    //  context.read<FeedsBloc>().removeWithIndex(widget.index);
  }

  void onUpdate(BuildContext context, Size size) {
    Navigator.of(context).pop();
    context.read<FeedBloc>().setFeed(widget.feed);
    // context.read<FeedBloc>().setIndex(widget.index);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final decoration = BoxDecoration(
      color: theme.highlightColor,
      borderRadius: BorderRadius.circular(10),
    );

    final image = CachedNetworkImageProvider(
      widget.feed.medias?.first.url ?? '',
    );

    final imageError = Text(widget.feed.content!.substring(0, 1));

    final imageCoverDecoration = BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      image: DecorationImage(
        image: image,
        fit: BoxFit.cover,
        onError: (c, i) => imageError,
      ),
    );

    final imageCover = Container(
      decoration: imageCoverDecoration,
    );

    // final title = Text(
    //   widget.feed.title ?? "",
    //   style: const TextStyle(
    //     color: Color.fromARGB(255, 55, 56, 57),
    //     fontWeight: FontWeight.bold,
    //     fontSize: 17,
    //   ),
    // );

    final firstStep = PositionedDirectional(
      child: imageCover,
    );
    //  final secondStep = PositionedDirectional(start: 10, top: 5, child: title);

    final stack = Stack(
      children: [firstStep],
    );

    final step1 = Flexible(child: stack);

    final profile = CircularImage(
      url: widget.feed.creatorImageUrl ?? '',
      errorText: "A",
      size: 18,
      padding: 4,
    );
    final name = Text(
      "${widget.feed.creatorFirstName} ${widget.feed.creatorLastName}",
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
    );

    final namePaddign = Padding(
      padding: EdgeInsets.zero,
      child: name,
    );

    final dataContent = formatDate(
      widget.feed.creationDate ?? DateTime.now(),
      context,
    );

    final data = Text(
      dataContent,
      style: const TextStyle(fontSize: 10),
    );
    final profileName = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [namePaddign, data, const SizedBox(height: 3)],
    );

    const hideLeading = Icon(Icons.close);
    const hideTitle = Text("Hide");
    final hide = ListTile(
      leading: hideLeading,
      title: hideTitle,
      onTap: onHideOnPressed,
    );
    const updateLeading = Icon(Icons.note_alt_rounded);
    const updateTitle = Text("Update");
    final update = ListTile(
      leading: updateLeading,
      title: updateTitle,
      onTap: () => onUpdate(context, size),
    );

    final deleteLeading = Icon(Icons.delete, color: theme.iconTheme.color);
    const deleteTitle = Text("Delete");
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
      color: theme.scaffoldBackgroundColor,
      clipBehavior: Clip.antiAlias,
      itemBuilder: (c) => items,
    );

    final morePadding = Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
      child: moreOption,
    );

    final step2Content = Row(
      children: [
        profile,
        profileName,
        const Spacer(),
        morePadding,
      ],
    );
    final step2 = SizedBox(
      height: 50,
      child: step2Content,
    );

    final column = Column(
      children: [step1, step2],
    );

    const duration = Duration(milliseconds: 300);
    final hovered = Matrix4.identity()..translate(4, 0, 0);
    final transform = isHovered ? hovered : Matrix4.identity();
    final eventCard = AnimatedContainer(
      constraints: const BoxConstraints(maxHeight: 250, maxWidth: 300),
      duration: duration,
      margin: const EdgeInsets.all(5),
      decoration: decoration,
      transform: transform,
      child: column,
    );

    final tap = GestureDetector(
      child: eventCard,
    );

    final region = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onEntered(true),
      onExit: (_) => onEntered(false),
      child: tap,
    );
    return region;
  }
}
