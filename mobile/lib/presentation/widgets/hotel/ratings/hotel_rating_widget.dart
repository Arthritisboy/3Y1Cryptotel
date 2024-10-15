import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/hotel/rating_model.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/user_storage_helper.dart';

class HotelRatingWidget extends StatefulWidget {
  final List<RatingModel> ratings;

  const HotelRatingWidget({super.key, required this.ratings});

  @override
  State<StatefulWidget> createState() {
    return _HotelRatingWidgetState();
  }
}

class _HotelRatingWidgetState extends State<HotelRatingWidget> {
  List<UserModel> allUsers = [];
  String selectedSort = "Highest"; // Default sorting option

  @override
  void initState() {
    super.initState();
    _getStoredUsers();
    print(
        "HotelRatingWidget initialized with ${widget.ratings.length} ratings");
  }

  Future<void> _getStoredUsers() async {
    final users = await UserStorageHelper.getUsers();
    if (users.isNotEmpty) {
      setState(() {
        allUsers = users;
      });
    } else {}
  }

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
    if (allUsers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    List<RatingModel> sortedRatings = _sortRatings(widget.ratings);

    return Column(
      children: [
        // Sorting dropdown button
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 20, bottom: 20),
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
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: "Highest",
                      child: const Text(
                        "Highest First",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Lowest",
                      child: const Text(
                        "Lowest First",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedSort = value!;
                      print("Selected sorting option: $selectedSort");
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
            UserModel? user = allUsers.firstWhere(
              (u) => u.id == rating.userId,
              orElse: () => UserModel(), // Returns empty UserModel if not found
            );
            if (user.firstName == null || user.lastName == null) {
              return const SizedBox.shrink(); // Do not display anything
            }
            return Card(
              color: const Color.fromARGB(255, 238, 237, 237),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
