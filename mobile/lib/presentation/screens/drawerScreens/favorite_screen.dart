import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/favoritescreen/favorite_body.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/favoritescreen/favorite_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_bloc.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_event.dart';
import 'package:hotel_flutter/data/repositories/favorite_repository.dart';
import 'package:hotel_flutter/data/repositories/hotel_repository.dart';
import 'package:hotel_flutter/data/repositories/restaurant_repository.dart';

class FavoriteScreen extends StatelessWidget {
  final String userId;

  const FavoriteScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteBloc(
        context.read<FavoriteRepository>(), // Access FavoriteRepository
        context.read<HotelRepository>(), // Access HotelRepository
        context.read<RestaurantRepository>(), // Access RestaurantRepository
      )..add(FetchFavoritesEvent(userId)), // Trigger FetchFavoritesEvent
      child: Scaffold(
        body: Column(
          children: const [
            FavoriteHeader(),
            SizedBox(height: 16),
            FavoriteBody(),
          ],
        ),
      ),
    );
  }
}
