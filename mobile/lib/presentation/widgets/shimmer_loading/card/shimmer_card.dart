import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  final Axis scrollDirection;

  const ShimmerCard({super.key, required this.scrollDirection});

  @override
  Widget build(BuildContext context) {
    return _buildShimmerLoadingEffect();
  }

  Widget _buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Row(
          children: List.generate(1, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 20),
              child: SizedBox(
                width: 330.0,
                height: 240.0,
                child: Card(
                  elevation: 4.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        child: Container(
                          height: 130.0,
                          width: double.infinity,
                          color: Colors.white, // Placeholder for the image
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 140.0,
                              height: 20.0,
                              color: Colors
                                  .white, // Placeholder for restaurant name
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                Container(
                                  width: 15.0,
                                  height: 15.0,
                                  color: Colors
                                      .white, // Placeholder for the place icon
                                ),
                                const SizedBox(width: 4.0),
                                Container(
                                  width: 100.0,
                                  height: 15.0,
                                  color: Colors
                                      .white, // Placeholder for location text
                                ),
                                const Spacer(),
                                Container(
                                  width: 60.0,
                                  height: 25.0,
                                  color: Colors.white, // Placeholder for rating
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
          }),
        ),
      ),
    );
  }
}
