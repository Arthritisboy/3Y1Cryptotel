import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/profile/action_button_widget.dart';
import 'package:hotel_flutter/presentation/widgets/profile/delete_account.dart';
import 'package:hotel_flutter/presentation/widgets/profile/gender_selection_widget.dart';

class BottomSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final String gender;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback updateUserData;

  const BottomSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.emailController,
    required this.addressController,
    required this.gender,
    required this.onGenderChanged,
    required this.updateUserData,
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
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
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
              GenderSelection(
                gender: gender,
                onGenderChanged: onGenderChanged,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Pass updateUserData to ActionButtons correctly
              ActionButtons(
                updateUserData: updateUserData,
              ),
              const SizedBox(height: 20),
              const DeleteAccountButton(),
            ],
          ),
        ),
      ),
    );
  }
}
