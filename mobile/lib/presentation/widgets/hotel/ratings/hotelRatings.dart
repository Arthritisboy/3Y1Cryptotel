import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:hotel_flutter/data/model/hotel/rating_model.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';

class HotelRatingWidget extends StatefulWidget {
  final List<RatingModel> ratings;

  const HotelRatingWidget({super.key, required this.ratings});

  @override
  _HotelRatingWidgetState createState() => _HotelRatingWidgetState();
}

class _HotelRatingWidgetState extends State<HotelRatingWidget> {
  List<UserModel> allUsers = [];

  @override
  void initState() {
    super.initState();
    _getStoredUsers();
  }

  // Helper function to get stored users from SharedPreferences
  Future<void> _getStoredUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('allUsers');
    if (usersJson != null) {
      List<dynamic> decodedUsers = jsonDecode(usersJson);
      setState(() {
        allUsers =
            decodedUsers.map((user) => UserModel.fromJson(user)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.ratings.length,
      itemBuilder: (context, index) {
        final rating = widget.ratings[index];

        // Find the user by userId
        UserModel? user = allUsers.firstWhere(
          (u) => u.id == rating.userId,
          orElse: () => UserModel(), // Returns empty UserModel if not found
        );

        // If user is null or the name is null, don't display the card
        if (user.firstName == null || user.lastName == null) {
          return SizedBox.shrink(); // Do not display anything
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User profile picture or default icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: user.profilePicture != null &&
                          user.profilePicture!.isNotEmpty
                      ? Image.network(
                          user.profilePicture!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey[700],
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User name
                      Text(
                        "${user.firstName} ${user.lastName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Rating stars and rating value
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < rating.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${rating.rating}.0",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Review message
                      Text(
                        rating.message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
