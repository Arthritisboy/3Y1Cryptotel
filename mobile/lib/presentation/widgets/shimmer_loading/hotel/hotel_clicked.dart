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
            // Simulated hotel image
            Container(
              height: 300.0,
              width: double.infinity,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Simulated hotel name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        height: 30.0,
                        color: Colors.white,
                      ),
                      Container(
                        width: 50.0,
                        height: 25.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Simulated price row
                  Row(
                    children: [
                      Container(
                        width: 150.0,
                        height: 20.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // Simulated open hours row
                  Row(
                    children: [
                      Container(
                        width: 180.0,
                        height: 20.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // Simulated location row
                  Row(
                    children: [
                      Container(
                        width: 220.0,
                        height: 20.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: [
                  // Simulated navigation row
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    color: Colors.white,
                  ),
                  const Divider(thickness: 2, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Simulated room list or hotel details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 120.0,
                    color: Colors.white,
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
