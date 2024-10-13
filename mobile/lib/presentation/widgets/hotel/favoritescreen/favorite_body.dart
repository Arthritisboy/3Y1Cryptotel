import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_bloc.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hotel_flutter/data/model/favorite/favorite_item_model.dart';

class FavoriteBody extends StatelessWidget {
  const FavoriteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return _buildShimmerLoadingEffect();
          } else if (state is FavoritesFetched) {
            return _buildFavoriteList(state.favorites);
          } else if (state is FavoriteError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return Container(); // For initial state
        },
      ),
    );
  }

  Widget _buildFavoriteList(List<FavoriteItem> favorites) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return Card(
          child: ListTile(
            leading: Image.network(favorite.imageUrl),
            title: Text(favorite.name),
            subtitle: Text(favorite.location),
          ),
        );
      },
    );
  }

  // Shimmer Loading Effect for Cards
  Widget _buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5, // Placeholder for loading items
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              height: 100.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
