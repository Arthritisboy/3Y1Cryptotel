import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/rating_model.dart';

class UserRatingsWidget extends StatelessWidget {
  final List<Rating> ratings;

  const UserRatingsWidget({Key? key, required this.ratings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ratings.length,
      itemBuilder: (context, index) {
        final rating = ratings[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          color: const Color(0xFF1C3473), 
          child: ListTile(
            title: Text(
              rating.userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (int i = 1; i <= 5; i++)
                      Icon(
                        i <= rating.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(rating.comment),
              ],
            ),
          ),
        );
      },
    );
  }
}
