import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final String url;
  final String? errorText;
  final double borderThikness;
  final double size;
  final double padding;
  const CircularImage({
    super.key,
    required this.url,
    required this.errorText,
    this.borderThikness = 2,
    this.size = 22,
    this.padding = 7,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final image = Image.network(
      url,
      errorBuilder: (context, ob, st) => Center(
        child: Text(errorText ?? ""),
      ),
    );

    final profile = CircleAvatar(
      maxRadius: size,
      minRadius: 10,
      backgroundColor: theme.highlightColor,
      child: CircleAvatar(
        maxRadius: size - borderThikness,
        minRadius: 8,
        backgroundImage: image.image,
      ),
    );

    final profilePading = Padding(
      padding: EdgeInsets.all(padding),
      child: profile,
    );
    return profilePading;
  }
}
