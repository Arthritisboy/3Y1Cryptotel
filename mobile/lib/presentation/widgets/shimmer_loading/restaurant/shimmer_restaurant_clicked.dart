import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerRestaurantClicked extends StatelessWidget {
  const ShimmerRestaurantClicked({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image Placeholder
            Container(
              height: 300.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(height: 10),

            // Restaurant Info Section Placeholder
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Restaurant Name and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 220.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      Container(
                        width: 50.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Price Placeholder
                  _buildRowPlaceholder(Icons.attach_money, 150.0),
                  const SizedBox(height: 10),

                  // Open Hours Placeholder
                  _buildRowPlaceholder(Icons.access_time, 180.0),
                  const SizedBox(height: 10),

                  // Location Placeholder
                  _buildRowPlaceholder(Icons.location_on_outlined, 220.0),
                  const SizedBox(height: 10),

                  // Capacity Placeholder
                  _buildRowPlaceholder(Icons.group_outlined, 140.0),
                ],
              ),
            ),

            // Navigation Row Placeholder
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              width: double.infinity,
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            const Divider(thickness: 2, color: Colors.grey),

            const SizedBox(height: 16.0),

            // Input Fields / Details Placeholders
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder for Input or Details section
                  Container(
                    width: double.infinity,
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowPlaceholder(IconData icon, double width) {
    return Row(
      children: [
        Icon(icon, size: 26, color: Colors.grey),
        const SizedBox(width: 8.0),
        Container(
          width: width,
          height: 20.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ],
    );
  }
}
