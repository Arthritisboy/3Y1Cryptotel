import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/hotel/rating_model.dart';

class Restaurantratingwidget extends StatelessWidget {
  final List<RatingModel> ratings;

  const Restaurantratingwidget({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty) {
      return const Center(child: Text('No Ratings Available'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ratings.length,
      itemBuilder: (context, index) {
        final rating = ratings[index];
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
                const Icon(Icons.person, size: 50, color: Colors.grey),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rating.message,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < rating.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          ),
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
