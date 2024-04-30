// import 'package:converse_client/src/presentation/feed/components/text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../blocs/feed_bloc.g.dart';
// import '../../../domain/enums/feed_type.g.dart';

// class FeedContent extends StatefulWidget {
//   final bool isUpdate;
//   const FeedContent({
//     super.key,
//     this.isUpdate = false,
//   });
//   @override
//   State<FeedContent> createState() => _FeedTState();
// }

// class _FeedTState extends State<FeedContent> {
//   bool news = true;
//   bool event = false;
//   bool announce = false;
//   void newsOnPressed(BuildContext context) {
//     if (widget.isUpdate) return;
//     setState(() {
//       context.read<FeedBloc>().setFeedType(FeedTypeParser.fromName('news'));
//       news = true;
//       event = false;
//       announce = false;
//     });
//   }

//   void eventOnPressed(BuildContext context) {
//     if (widget.isUpdate) return;
//     setState(() {
//       context.read<FeedBloc>().setFeedType(FeedTypeParser.fromName('event'));
//       news = false;
//       event = true;
//       announce = false;
//     });
//   }

//   void announceOnPressed(BuildContext context) {
//     if (widget.isUpdate) return;
//     setState(() {
//       context
//           .read<FeedBloc>()
//           .setFeedType(FeedTypeParser.fromName('announcement'));
//       news = false;
//       event = false;
//       announce = true;
//     });
//   }

//   void cheak(BuildContext context) {
//     if (widget.isUpdate == false) {
//       context.read<FeedBloc>().setFeedType(FeedType.news);
//     }
//     FeedType type = context.read<FeedBloc>().state.feed.type;
//     if (type == FeedType.event) {
//       news = false;
//       event = true;
//       announce = false;
//     }
//     if (type == FeedType.announcement) {
//       news = false;
//       event = false;
//       announce = true;
//     }
//   }

//   @override
//   void initState() {
//     cheak(context);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final newsDecoration = BoxDecoration(
//       borderRadius: BorderRadius.circular(4),
//       color: news
//           ? const Color.fromARGB(255, 173, 239, 219)
//           : theme.highlightColor,
//     );
//     final eventDecoration = BoxDecoration(
//       borderRadius: BorderRadius.circular(4),
//       color: event
//           ? const Color.fromARGB(255, 173, 239, 219)
//           : theme.highlightColor,
//     );
//     final announceDecoration = BoxDecoration(
//       borderRadius: BorderRadius.circular(4),
//       color: announce
//           ? const Color.fromARGB(255, 173, 239, 219)
//           : theme.highlightColor,
//     );
//     const constraint = BoxConstraints(
//       maxHeight: 30,
//       maxWidth: 120,
//     );
//     final contentNews = Container(
//       margin: const EdgeInsets.all(5),
//       decoration: newsDecoration,
//       constraints: constraint,
//       child: const Text(" News "),
//     );
//     final newsTap = GestureDetector(
//       child: contentNews,
//       onTap: () => newsOnPressed(context),
//     );
//     final contentEvent = Container(
//       margin: const EdgeInsets.all(5),
//       decoration: eventDecoration,
//       constraints: constraint,
//       child: const Text(" Event "),
//     );
//     final eventTap = GestureDetector(
//       child: contentEvent,
//       onTap: () => eventOnPressed(context),
//     );
//     final contentAnnounce = Container(
//       margin: const EdgeInsets.all(5),
//       decoration: announceDecoration,
//       constraints: constraint,
//       child: const Text(" Announcement "),
//     );
//     final announceTap = GestureDetector(
//       child: contentAnnounce,
//       onTap: () => announceOnPressed(context),
//     );
//     const typeLabale = Text(
//       "FeedType :",
//       style: TextStyle(fontWeight: FontWeight.w100),
//     );
//     const labalePadding = Padding(
//       padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//       child: typeLabale,
//     );
//     const followLabale = Text(
//       "FollowLink :",
//       style: TextStyle(
//         fontWeight: FontWeight.w100,
//       ),
//     );
//     const followPadding = Padding(
//       padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//       child: followLabale,
//     );
//     final feedType = Row(
//       children: [labalePadding, newsTap, eventTap, announceTap],
//     );
//     String url = context.read<FeedBloc>().state.feed.followURL ?? '';
//     final followLik = TextBox(
//       initialValue: widget.isUpdate ? url : null,
//       hintText: "Enter URL",
//       onSave: context.read<FeedBloc>().setFeedFollowURL,
//       maxHeight: 10,
//       maxLine: 1,
//       hintSize: 12,
//     );
//     final followlingBox = Expanded(child: followLik);
//     final followLink = Row(
//       children: [followPadding, const SizedBox(width: 5), followlingBox],
//     );
//     final typeContent = Column(
//       children: [feedType, followLink],
//     );

//     final typeContentPaddign = Padding(
//       padding: const EdgeInsets.all(5),
//       child: typeContent,
//     );
//     final typeDecoration = BoxDecoration(
//       borderRadius: BorderRadius.circular(4),
//       color: const Color.fromARGB(131, 240, 237, 241),
//     );
//     final type = Container(
//       decoration: typeDecoration,
//       child: typeContentPaddign,
//     );
//     return type;
//   }
// }
