import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/details/hotel_clicked.dart';
import 'package:hotel_flutter/data/repositories/auth_repository.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';

class HotelScreen extends StatefulWidget {
  final String hotelImage;
  final String hotelName;
  final double rating;
  final double price;
  final String location;
  final String time;
  final double latitude;
  final double longitude;
  final String hotelId;

  const HotelScreen({
    super.key,
    required this.hotelId,
    required this.hotelImage,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<StatefulWidget> createState() {
    return _HotelScreenState();
  }
}

class _HotelScreenState extends State<HotelScreen> {
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
        // Check if the restaurantId is in the favorites for restaurants
        isFavorite = favorites['hotels']?.contains(widget.hotelId) ?? false;
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
          title: Text(widget.hotelName),
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
                final type = 'hotel'; // Specify the type as hotel
                final hotelId = widget.hotelId; // Get the hotel ID

                if (isFavorite) {
                  // Remove from favorites
                  context
                      .read<AuthBloc>()
                      .add(RemoveFromFavoritesEvent(userId!, type, hotelId));
                  setState(() {
                    isFavorite = false; // Update state
                  });
                } else {
                  // Add to favorites
                  context
                      .read<AuthBloc>()
                      .add(AddToFavoritesEvent(userId!, type, hotelId));
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
              HotelClicked(
                hotelId: widget.hotelId,
                hotelImage: widget.hotelImage,
                hotelName: widget.hotelName,
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
