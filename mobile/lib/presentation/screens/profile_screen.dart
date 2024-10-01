import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/profile/blue_background_widget.dart';
import 'package:hotel_flutter/presentation/widgets/profile/bottom_section.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variables to store user data
  String firstName = "Barney";
  String lastName = "Crocodile";
  String username = "Barney Crocodile";
  String email = "barneycrocodile@gmail.com";
  String address = "";
  String gender = "Male"; // Default gender

  // Controllers for text fields
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    firstNameController = TextEditingController(text: firstName);
    lastNameController = TextEditingController(text: lastName);
    usernameController = TextEditingController(text: username);
    emailController = TextEditingController(text: email);
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
              onGenderChanged: (selectedGender) {
                setState(() {
                  gender = selectedGender;
                });
              },
              gender: gender,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1 - 60,
            left: MediaQuery.of(context).size.width * 0.5 - 60,
            child: GestureDetector(
              onTap: () {
                print("Avatar clicked!");
              },
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
          ),
        ],
      ),
    );
  }
}
