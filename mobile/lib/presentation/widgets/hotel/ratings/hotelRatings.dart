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
  String selectedSort = "Highest"; // Default sorting option

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

  // Function to sort ratings based on selected option
  List<RatingModel> _sortRatings(List<RatingModel> ratings) {
    if (selectedSort == "Highest") {
      ratings.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      ratings.sort((a, b) => a.rating.compareTo(b.rating));
    }
    return ratings;
  }

  @override
  Widget build(BuildContext context) {
    // Sort the ratings based on the selected option
    List<RatingModel> sortedRatings = _sortRatings(widget.ratings);

    return Column(
      children: [
        // Sorting dropdown button with updated style
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              const Text(
                "Sort by:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 29, 53, 115),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: DropdownButton<String>(
                  value: selectedSort,
                  dropdownColor: const Color.fromARGB(255, 29, 53, 115),
                  iconEnabledColor: Colors.white,
                  underline: SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: "Highest",
                      child: Text(
                        "Highest First",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Lowest",
                      child: Text(
                        "Lowest First",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedSort = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        // Display sorted ratings
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedRatings.length,
          itemBuilder: (context, index) {
            final rating = sortedRatings[index];

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
        ),
      ],
    );
  }
}
