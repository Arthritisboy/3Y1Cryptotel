import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHotelClicked extends StatelessWidget {
  const ShimmerHotelClicked({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image Placeholder
            Container(
              height: 300.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(height: 10),

            // Hotel Name, Rating and Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Hotel Name and Rating Row
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
                  Row(
                    children: [
                      const Icon(Icons.attach_money,
                          color: Colors.grey, size: 26),
                      const SizedBox(width: 8),
                      Container(
                        width: 150.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Open Hours Placeholder
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.grey, size: 26),
                      const SizedBox(width: 8),
                      Container(
                        width: 180.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Location Placeholder
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Colors.grey, size: 26),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                    ],
                  ),
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

            // Room List Placeholders
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
}
