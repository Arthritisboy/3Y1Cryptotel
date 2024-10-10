import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTabHeader extends StatelessWidget {
  const ShimmerTabHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // Base color of shimmer
      highlightColor: Colors.grey[100]!, // Highlight color for shimmer
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Placeholder for the logo image
                Container(
                  width: 56.0,
                  height: 53.0,
                  color: Colors.white, // Placeholder for the image
                ),
                const SizedBox(width: 10.0),
              ],
            ),
            const SizedBox(height: 5.0),
            // Placeholder for "Where Would you"
            Container(
              width: 180, // Simulate text width
              height: 20, // Simulate text height
              color: Colors.white,
            ),
            const SizedBox(height: 5.0),
            // Placeholder for "Like to Travel, $firstName"
            Container(
              width: 220, // Simulate text width
              height: 20, // Simulate text height
              color: Colors.white,
            ),
            const SizedBox(height: 10.0),
            // Placeholder for the search bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16), // Padding for the search icon
                  Container(
                    width: 20, // Placeholder for search icon
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 40,
                      color: Colors.white, // Placeholder for the text field
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
