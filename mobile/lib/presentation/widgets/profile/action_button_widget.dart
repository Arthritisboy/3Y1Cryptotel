import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Handle Change Password
          },
          icon: const Icon(Icons.lock, color: Colors.white), // Add lock icon
          label: const Text("Change Password"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(
                255, 29, 53, 115), // Button background color
            foregroundColor: Colors.white, // Text and icon color
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 12), // Button padding
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Handle Update Account
          },
          icon:
              const Icon(Icons.update, color: Colors.white), // Add update icon
          label: const Text("Update Account"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(
                255, 29, 53, 115), // Button background color
            foregroundColor: Colors.white, // Text and icon color
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 12), // Button padding
          ),
        ),
      ],
    );
  }
}
