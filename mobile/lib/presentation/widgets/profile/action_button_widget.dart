import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.updateUserData,
    required this.isLoading,
  });

  final VoidCallback updateUserData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pushNamed('/updatePassword');
          },
          icon: const Icon(Icons.lock, color: Colors.white),
          label: const Text("Change Password"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 29, 53, 115),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed:
              isLoading ? null : updateUserData, // Disable button when loading
          icon: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.update, color: Colors.white),
          label: isLoading
              ? const Text("Updating...")
              : const Text("Update Account"),
          style: ElevatedButton.styleFrom(
            backgroundColor: isLoading
                ? Colors.grey // Change background when loading
                : const Color.fromARGB(255, 29, 53, 115),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }
}
