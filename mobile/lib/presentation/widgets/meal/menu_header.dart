import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/background_image.dart';
import 'package:hotel_flutter/presentation/widgets/home/home_header.dart';

class MenuHeader extends StatelessWidget {
  final Function(String) onDrawerSelected;

  const MenuHeader({super.key, required this.onDrawerSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.3,
          child: const BackgroundImage(
            image: 'assets/images/others/homepage.jpg',
          ),
        ),
        Header(),
        Positioned(
          top: 40.0,
          right: 10.0,
          child: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
