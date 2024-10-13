import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/favoritescreen/favorite_body.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/favoritescreen/favorite_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_bloc.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_event.dart';

class FavoriteScreen extends StatelessWidget {
  final String userId;

  const FavoriteScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FavoriteBloc(context.read())..add(FetchFavoritesEvent(userId)),
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
