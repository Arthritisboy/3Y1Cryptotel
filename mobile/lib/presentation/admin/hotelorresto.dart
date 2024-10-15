import 'package:flutter/material.dart';

class Hotelorresto extends StatelessWidget {
  const Hotelorresto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button for Hotel
            ElevatedButton(
              onPressed: () {
                // Add your logic here for Hotel button press
                print('Hotel button pressed');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: const Color(0xFF1C3473), // Button color
              ),
              child: const Text(
                'Hotel',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20), // Space between buttons

            // Button for Resto
            ElevatedButton(
              onPressed: () {
                // Add your logic here for Resto button press
                print('Resto button pressed');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: const Color(0xFF1C3473), // Button color
              ),
              child: const Text(
                'Resto',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
