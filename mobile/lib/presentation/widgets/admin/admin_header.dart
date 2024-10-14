import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  final VoidCallback onCreateRoomPressed; // Callback for button press

  const AdminHeader({super.key, required this.onCreateRoomPressed});

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
                  fontFamily: 'HammerSmith',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C3473),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 5.0),
          // Row to hold "Admin Panel" and "Create Room" button
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Pushes elements apart
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Admin Panel",
                style: TextStyle(
                  fontFamily: 'HammerSmith',
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
              ElevatedButton(
                onPressed: onCreateRoomPressed, // Button action to create room
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF1C3473), // Button background color
                ),
                child: const Text('Create Room'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
