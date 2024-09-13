import 'package:flutter/material.dart';

class ImageWithHeart extends StatefulWidget {
  final String imagePath;
  final bool isHeartFilled;
  final Function(bool) onHeartPressed;
  final String roomName;
  final String typeOfRoom;

  const ImageWithHeart({
    super.key,
    required this.imagePath,
    required this.isHeartFilled,
    required this.onHeartPressed,
    required this.roomName,
    required this.typeOfRoom,
  });

  @override
  // ignore: library_private_types_in_public_api
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
        Positioned(
          bottom: 10.0,
          left: 10.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.roomName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                widget.typeOfRoom,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
