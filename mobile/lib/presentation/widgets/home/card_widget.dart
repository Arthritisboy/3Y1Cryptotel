import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String imagePath;
  final String hotelName;
  final String location;
  final double? rating;
  final double? width;

  const CardWidget({
    super.key,
    required this.imagePath,
    required this.hotelName,
    required this.location,
    required this.width,
    this.rating, // Nullable rating
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10),
      child: SizedBox(
        width: width, // Set a fixed width for the card
        height: 300.0, // Set a longer height to make the card taller
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  imagePath, // Load image from network URL
                  height: 190.0, // Increase the height of the image section
                  width: double.infinity,
                  fit: BoxFit.cover, // Ensure the image fits the container
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Return the image when fully loaded
                    }
                    return const Center(
                      child:
                          CircularProgressIndicator(), // Show a loader while the image is being loaded
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ), // Display an icon if the image fails to load
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotelName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(Icons.place, color: Colors.grey),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 142, 142, 147),
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            color: const Color.fromARGB(255, 29, 53, 115),
                            child: Row(
                              children: [
                                Text(
                                  (rating ?? 0.0)
                                      .toString(), // Default value if rating is null
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                const Icon(Icons.star, color: Colors.amber),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
