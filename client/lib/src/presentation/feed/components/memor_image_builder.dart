import 'package:converse_client/src/blocs/states/upload_state.dart';
import 'package:converse_client/src/domain/enums/media_type.g.dart';
import 'package:converse_client/src/presentation/feed/components/media_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class MemorImageBuilder extends StatelessWidget {
  final List<AppFile> files;
  const MemorImageBuilder({
    super.key,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> memoryImageBuilder = files.map((e) {
      if (e.type == MediaType.photo) {
        return Image.memory(
          e.data,
          fit: BoxFit.cover,
        );
      }
      return MediaPost(url: e.path, type: e.type);
    }).toList();

    return ImageSlideshow(height: 300, children: memoryImageBuilder);
  }
}
