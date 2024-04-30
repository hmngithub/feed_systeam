import 'package:converse_client/src/domain/entities/media.g.dart';
import 'package:converse_client/src/presentation/feed/components/media_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class NetworkImageBuilder extends StatelessWidget {
  final List<Media> medias;
  const NetworkImageBuilder({
    super.key,
    required this.medias,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> networkImageBuilder = medias
        .map((e) => MediaPost(
              url: e.url,
              type: e.type,
            ))
        .toList();

    return ImageSlideshow(height: 300, children: networkImageBuilder);
  }
}
