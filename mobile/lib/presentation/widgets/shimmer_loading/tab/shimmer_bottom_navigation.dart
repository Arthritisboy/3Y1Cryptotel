import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBottomNavigation extends StatelessWidget {
  const ShimmerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // Base color of shimmer
      highlightColor: Colors.grey[100]!, // Highlight color for shimmer
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          return Container(
            width: 50.0, // Matching the size of the square icon
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
        }),
      ),
    );
  }
}
