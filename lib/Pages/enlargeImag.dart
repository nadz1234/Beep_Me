import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class EnlargeImage extends StatefulWidget {
  String imageToEnlarge;

  EnlargeImage(this.imageToEnlarge);

  @override
  State<EnlargeImage> createState() => _EnlargeImageState();
}

class _EnlargeImageState extends State<EnlargeImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: PinchZoom(
              resetDuration: const Duration(milliseconds: 100),
              maxScale: 2.5,
              child: Image.network(
                widget.imageToEnlarge,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
