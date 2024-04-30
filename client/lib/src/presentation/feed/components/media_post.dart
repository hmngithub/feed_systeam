import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:converse_client/src/domain/enums/media_type.g.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaPost extends StatefulWidget {
  final String? url;
  final MediaType? type;

  const MediaPost({
    super.key,
    required this.url,
    required this.type,
  });

  @override
  State<MediaPost> createState() => _MediaPostState();
}

class _MediaPostState extends State<MediaPost> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _intializeVideoPlayer;
  bool showPlay = false;
  bool showPlayButton = false;
  late Timer timer;
  bool firstBuild = false;

  @override
  void initState() {
    firstBuild = true;
    if (widget.type == MediaType.video) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url ?? ''),
      );

      _intializeVideoPlayer = _videoPlayerController.initialize().then((_) {
        _videoPlayerController.play();
        _videoPlayerController.setLooping(false);
        _videoPlayerController.pause;
        setState(() {});
      });
    }
    super.initState();
  }

  void timerOnCall() {
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        showPlay != showPlay;
      });
    });
  }

  void onTap() {
    if (widget.type == MediaType.video) {
      if (showPlay == false) {
        timerOnCall();
      }
      setState(() {
        showPlay != showPlay;
      });
    }
  }

  @override
  void didUpdateWidget(covariant MediaPost oldWidget) {
    if (widget.type == MediaType.video) {
      _videoPlayerController.pause();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.type == MediaType.video) {
      _videoPlayerController.pause();
      _videoPlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (firstBuild && widget.type == MediaType.video) {
      _videoPlayerController.play();
    }
    late dynamic media;
    if (widget.type == MediaType.video) {
      media = FutureBuilder(
        future: _intializeVideoPlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () => onTap(),
              child: VideoPlayer(_videoPlayerController),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      media = CachedNetworkImage(
        imageUrl: widget.url ?? '',
        fit: BoxFit.cover,
        fadeOutDuration: const Duration(milliseconds: 500),
        fadeInDuration: const Duration(milliseconds: 250),
      );
    }

    const playIcon = Icon(Icons.play_arrow);
    final playButton = IconButton(onPressed: () {}, icon: playIcon);
    const pauseIcon = Icon(Icons.pause);
    final pauseButton = IconButton(onPressed: () {}, icon: pauseIcon);
    final stackChild1 = PositionedDirectional(child: media);
    final stackChild2 = showPlay
        ? PositionedDirectional(
            child: showPlayButton ? pauseButton : playButton)
        : PositionedDirectional(child: Container());
    return widget.type == MediaType.video
        ? Stack(children: [stackChild1, stackChild2])
        : media;
  }
}
