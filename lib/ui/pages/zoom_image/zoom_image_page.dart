import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';

class ZoomImagePage extends StatefulWidget {
  final String imageUrl;

  const ZoomImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ZoomImagePage> createState() => _ZoomImagePageState();
}

class _ZoomImagePageState extends State<ZoomImagePage> {
  final _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText('Image'),
      ),
      body: GestureDetector(
        onDoubleTapDown: _handleDoubleTapDown,
        onDoubleTap: _handleDoubleTap,
        child: Center(
          child: InteractiveViewer(
            minScale: 0.25,
            maxScale: 3,
            transformationController: _transformationController,
            child: CachedNetworkImage(
              errorWidget: (context, error, stackTrace) {
                return const Center();
              },
              width: double.infinity,
              height: double.infinity,
              imageUrl: widget.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }
}
