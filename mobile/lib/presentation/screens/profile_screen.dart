import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/profile/blue_background_widget.dart';
import 'package:hotel_flutter/presentation/widgets/profile/bottom_section.dart';
import 'package:hotel_flutter/data/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_bloc.dart'; // Import your AuthBloc

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  final String firstName;
  final String lastName;
  final String email;

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  String username = "";
  String address = "";
  String gender = "Male";

  @override
  void initState() {
    super.initState();
    // Initialize controllers with widget properties
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    usernameController = TextEditingController(text: username);
    emailController = TextEditingController(text: widget.email);
    addressController = TextEditingController(text: address);
  }

  @override
  void dispose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Method to update user data
  Future<void> updateUserData() async {
    final authBloc = context.read<AuthBloc>();
    final userModel = UserModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
    );

    try {
      await authBloc.authRepository.updateUser(userModel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User data updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print('Error updating user: $error'); // Add this line for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 53, 115),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          const BlueBackground(),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomSection(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              usernameController: usernameController,
              emailController: emailController,
              addressController: addressController,
              updateUserData: updateUserData,
              onGenderChanged: (selectedGender) {
                setState(() {
                  gender = selectedGender;
                });
              },
              gender: gender,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.01,
            left: 0,
            right: 0,
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Color.fromARGB(255, 173, 175, 210),
              child: Icon(
                Icons.person,
                size: 80,
                color: Color.fromARGB(255, 29, 53, 115),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
