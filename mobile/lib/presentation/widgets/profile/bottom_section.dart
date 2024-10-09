import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/profile/action_button_widget.dart';
import 'package:hotel_flutter/presentation/widgets/profile/delete_account.dart';
import 'package:hotel_flutter/presentation/widgets/profile/gender_selection_widget.dart';

class BottomSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController; // Phone number controller
  final String gender;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback updateUserData;
  final bool isLoading; // Add loading state

  const BottomSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneNumberController, // Added phone number controller
    required this.gender,
    required this.onGenderChanged,
    required this.updateUserData,
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
              const SizedBox(height: 80), // Space for the avatar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              // Gender Selection widget
              GenderSelection(
                gender: gender,
                onGenderChanged: onGenderChanged,
              ),
              const SizedBox(height: 10),
              // Updated: Changed labelText from "Address" to "Phone Number"
              TextField(
                controller: phoneNumberController, // Phone number controller
                decoration: const InputDecoration(
                  labelText: 'Phone Number', // Updated label
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Action Buttons with loading state
              ActionButtons(
                updateUserData: updateUserData,
                isLoading: isLoading, // Pass the loading state to the button
              ),
              const SizedBox(height: 20),
              // Delete Account Button
              const DeleteAccountButton(),
            ],
          ),
        ),
      ),
    );
  }
}
