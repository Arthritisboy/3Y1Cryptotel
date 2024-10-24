import 'package:flutter/material.dart';

class FavoriteHeader extends StatelessWidget {
  const FavoriteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/others/cryptotelLogo.png',
                width: 56.0,
                height: 53.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10.0),
              const Text(
                'CRYPTOTEL',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C3473),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
