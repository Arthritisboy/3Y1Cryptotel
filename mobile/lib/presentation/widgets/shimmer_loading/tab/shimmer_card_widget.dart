import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCardWidget extends StatelessWidget {
  const ShimmerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simulated "Top Rated Hotels" title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 180.0, // Width to resemble "Top Rated Hotels" title
              height: 24.0, // Height for the title placeholder
              color: Colors.white, // Placeholder for the title
            ),
          ),
        ),
        const SizedBox(height: 10.0), // Space between title and card list

        // Shimmer Cards Row (Scroll horizontally similar to real design)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              3, // Display 3 shimmer cards in the row
              (index) => Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: SizedBox(
                  width: 250.0, // Same width as the actual CardWidget
                  height: 240.0, // Same height as the actual CardWidget
                  child: Card(
                    elevation: 4.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Simulated Image Section
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12.0),
                            ),
                            child: Container(
                              height: 130.0, // Adjusted to match image height
                              width: double.infinity,
                              color: Colors.white, // Placeholder for the image
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Simulated Hotel Name
                                Container(
                                  width:
                                      140.0, // Adjusted to simulate hotel name width
                                  height: 20.0,
                                  color: Colors
                                      .white, // Placeholder for hotel name
                                ),
                                const SizedBox(height: 4.0),
                                // Simulated Location Row
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
                                      width:
                                          100.0, // Adjusted to simulate location text
                                      height: 15.0,
                                      color: Colors
                                          .white, // Placeholder for location text
                                    ),
                                    const Spacer(),
                                    // Simulated Rating Container
                                    Container(
                                      width: 60.0,
                                      height: 25.0,
                                      color: Colors
                                          .white, // Placeholder for rating
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
                ),
              ),
            ).toList(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // Simulated "Top Rated Hotels" title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 180.0, // Width to resemble "Top Rated Hotels" title
              height: 24.0, // Height for the title placeholder
              color: Colors.white, // Placeholder for the title
            ),
          ),
        ),
        const SizedBox(height: 10.0), // Space between title and card list

        // Shimmer Cards Row (Scroll horizontally similar to real design)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              3, // Display 3 shimmer cards in the row
              (index) => Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: SizedBox(
                  width: 250.0, // Same width as the actual CardWidget
                  height: 240.0, // Same height as the actual CardWidget
                  child: Card(
                    elevation: 4.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Simulated Image Section
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12.0),
                            ),
                            child: Container(
                              height: 130.0, // Adjusted to match image height
                              width: double.infinity,
                              color: Colors.white, // Placeholder for the image
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Simulated Hotel Name
                                Container(
                                  width:
                                      140.0, // Adjusted to simulate hotel name width
                                  height: 20.0,
                                  color: Colors
                                      .white, // Placeholder for hotel name
                                ),
                                const SizedBox(height: 4.0),
                                // Simulated Location Row
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
                                      width:
                                          100.0, // Adjusted to simulate location text
                                      height: 15.0,
                                      color: Colors
                                          .white, // Placeholder for location text
                                    ),
                                    const Spacer(),
                                    // Simulated Rating Container
                                    Container(
                                      width: 60.0,
                                      height: 25.0,
                                      color: Colors
                                          .white, // Placeholder for rating
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
                ),
              ),
            ).toList(),
          ),
        ),
      ],
    );
  }
}
