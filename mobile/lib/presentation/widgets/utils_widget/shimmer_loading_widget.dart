import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 150,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
