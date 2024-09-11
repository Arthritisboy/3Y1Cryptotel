import 'package:flutter/material.dart';

class ImageWithHeart extends StatefulWidget {
  final String imagePath;
  final bool isHeartFilled;
  final Function(bool) onHeartPressed;

  const ImageWithHeart({
    Key? key,
    required this.imagePath,
    required this.isHeartFilled,
    required this.onHeartPressed,
  }) : super(key: key);

  @override
  _ImageWithHeartState createState() => _ImageWithHeartState();
}

class _ImageWithHeartState extends State<ImageWithHeart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(
            widget.imagePath,
            height: 174.0,
            width: 179.0,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 7.0,
          right: 5.0,
          child: IconButton(
            icon: Icon(
              widget.isHeartFilled ? Icons.favorite : Icons.favorite_border,
              color: widget.isHeartFilled ? Colors.red : Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              widget.onHeartPressed(!widget.isHeartFilled);
            },
          ),
        ),
      ],
    );
  }
}
