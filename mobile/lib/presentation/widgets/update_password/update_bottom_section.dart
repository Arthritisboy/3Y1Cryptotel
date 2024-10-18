import 'package:flutter/material.dart';

class UpdateBottomSection extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onUpdatePassword;
  final bool isLoading;

  const UpdateBottomSection({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onUpdatePassword,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: isLoading ? null : onUpdatePassword,
                icon: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Icon(Icons.lock, color: Colors.white),
                label: Text(isLoading ? 'Updating...' : 'Update Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 29, 53, 115),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
