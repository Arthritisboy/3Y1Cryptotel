import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Blue Background
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height *
                  0.4, // Adjust height as needed
              child: const Center(
                child: Text(
                  'Top Section',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            // White Bottom Section with Border Radius
            Positioned(
              top: MediaQuery.of(context).size.height *
                  0.2, // Overlap the blue section
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30)), // Apply border radius here
                ),
                height: MediaQuery.of(context).size.height *
                    0.6, // Adjust height as needed
                child: const Center(
                  child: Text(
                    'Bottom Section',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
