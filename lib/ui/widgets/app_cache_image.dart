import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCacheImage extends StatelessWidget {

  final String url;
  const AppCacheImage(this.url,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) {
        return Image.asset('assets/images/p2.jpg');
      },
    );
  }
}
