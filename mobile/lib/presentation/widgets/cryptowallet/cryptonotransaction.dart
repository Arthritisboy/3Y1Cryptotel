import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/tab_screen.dart';

class CryptoNoTransaction extends StatelessWidget {
  const CryptoNoTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0), // Moves the image higher
      child: Center(
        child: Column(
          children: [
            Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/images/others/wallet.jpg',
                width: 250.0,
                height: 250.0,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "No transactions, Yet!",
              style: TextStyle(
                fontFamily: 'HammerSmith',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Make a booking with CRYPTOTEL",
              style: TextStyle(
                fontFamily: 'HammerSmith',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TabScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C3473),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                textStyle: const TextStyle(
                  fontFamily: 'HammerSmith',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text("Book Now"),
            ),
          ],
        ),
      ),
    );
  }
}
