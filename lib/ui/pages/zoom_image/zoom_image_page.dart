import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ZoomImagePage extends StatelessWidget {
  final String imageUrl;
  const ZoomImagePage({Key? key , required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      panEnabled: false, // Set it to false
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.5,
      maxScale: 2,
      child: CachedNetworkImage(
        errorWidget: (context, error, stackTrace) {
          return const Center();
        },
        imageUrl:
        imageUrl,
        fit: BoxFit.contain,
      ),
    );;
  }
}
