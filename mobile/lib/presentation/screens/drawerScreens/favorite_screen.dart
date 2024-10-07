import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/favoritescreen/favorite_body.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/favoritescreen/favorite_header.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          FavoriteHeader(),
          SizedBox(height: 16),
          FavoriteBody(),
        ],
      ),
    );
  }
}
