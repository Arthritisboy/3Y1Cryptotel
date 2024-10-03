import 'package:flutter/material.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Delete"),
              content: const Text(
                  "Are you sure you want to delete your account? The account will be disabled for 30 days before it is permanently deleted."),
              actions: [
                TextButton(
                  onPressed: () {
                    // Close the dialog without deleting
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // Handle the delete action here
                    Navigator.of(context).pop(); // Close the dialog
                    // Add your delete account logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Account deleted successfully')),
                    );
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.delete, color: Colors.red),
      label: const Text("Delete Account"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.red),
        foregroundColor: Colors.red,
      ),
    );
  }
}
