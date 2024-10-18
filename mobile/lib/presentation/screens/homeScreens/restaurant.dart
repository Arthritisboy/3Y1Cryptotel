import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/presentation/widgets/restaurant/details/restaurant_clicked.dart';
import 'package:hotel_flutter/data/repositories/auth_repository.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';

class Restaurant extends StatefulWidget {
  final String restaurantImage;
  final String restaurantName;
  final double rating;
  final double price;
  final String location;
  final String time;
  final double latitude;
  final double longitude;
  final String restaurantId;
  final int capacity;

  const Restaurant({
    super.key,
    required this.capacity,
    required this.restaurantId,
    required this.restaurantImage,
    required this.restaurantName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<StatefulWidget> createState() {
    return _RestaurantState();
  }
}

class _RestaurantState extends State<Restaurant> {
  int _activeIndex = 0;
  bool isFavorite = false; // Track favorite state
  String? userId; // Make userId nullable

  @override
  void initState() {
    super.initState();
    _checkIfFavorite(); // Call this to check favorite status after userId is set
  }

  Future<void> _checkIfFavorite() async {
    final authRepository = context.read<AuthRepository>();
    userId = authRepository.getUserId(); // Retrieve the userId

    if (userId != null) {
      final favorites =
          await authRepository.getFavorites(userId!); // Await the favorites
      setState(() {
        isFavorite = favorites.contains(
            widget.restaurantId); // Check if restaurantId is in favorites
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is FavoritesError) {
          // Show an error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.restaurantName),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: isFavorite
                    ? Colors.red
                    : const Color.fromARGB(255, 52, 46, 46),
              ),
              onPressed: () {
                final type = 'restaurant'; // Specify the type as restaurant
                final restaurantId =
                    widget.restaurantId; // Get the restaurant ID

                if (isFavorite) {
                  // Remove from favorites
                  context.read<AuthBloc>().add(
                      RemoveFromFavoritesEvent(userId!, type, restaurantId));
                  setState(() {
                    isFavorite = false; // Update state
                  });
                } else {
                  // Add to favorites
                  context
                      .read<AuthBloc>()
                      .add(AddToFavoritesEvent(userId!, type, restaurantId));
                  setState(() {
                    isFavorite = true; // Update state
                  });
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              RestaurantClicked(
                capacity: widget.capacity,
                restaurantId: widget.restaurantId,
                restaurantImage: widget.restaurantImage,
                restaurantName: widget.restaurantName,
                rating: widget.rating,
                price: widget.price,
                location: widget.location,
                time: widget.time,
                activeIndex: _activeIndex,
                latitude: widget.latitude,
                longitude: widget.longitude,
                onNavTap: (index) {
                  setState(() {
                    _activeIndex = index;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
