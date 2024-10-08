import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/profile/blue_background_widget.dart';
import 'package:hotel_flutter/presentation/widgets/profile/bottom_section.dart';
import 'package:image_picker/image_picker.dart'; // For selecting images
import 'package:hotel_flutter/data/data_provider/auth/auth_data_provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profile,
  });

  final String firstName;
  final String lastName;
  final String email;
  String profile;

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
  File? _selectedImage; // To store the selected image file
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    usernameController = TextEditingController(text: username);
    emailController = TextEditingController(text: widget.email);
    addressController = TextEditingController(text: address);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Method to pick an image
  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Update user data method
  Future<void> updateUserData() async {
    setState(() {
      _isLoading = true; // Start loading when the update process begins
    });

    try {
      // Call the updateUserData method and get the updated user
      final updatedUser = await AuthDataProvider().updateUserData(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        profilePicture: _selectedImage,
      );

      // Update the UI with the new user data
      setState(() {
        // Use the updatedUser properties to set the profile URL
        widget.profile =
            updatedUser.profilePicture!; // Update the profile image URL
      });

      // Clear image cache if necessary
      imageCache.clear();
      imageCache.clearLiveImages();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User data updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false; // Stop loading once the update is complete
    });
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
            child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is Authenticated) {
                return BottomSection(
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
                  isLoading: _isLoading, // Pass the loading state
                );
              }
              return Container();
            }),
          ),
          // Profile Picture with GestureDetector to change it
          Positioned(
            top: MediaQuery.of(context).size.height * 0.01,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _isLoading ? null : _pickImage, // Disable tap when loading
              child: CircleAvatar(
                radius: 60,
                backgroundColor: const Color.fromARGB(255, 173, 175, 210),
                child: ClipOval(
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : widget.profile.isNotEmpty
                          ? Image.network(
                              widget.profile,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.person,
                              size: 80,
                              color: Color.fromARGB(
                                  255, 29, 53, 115), // Placeholder icon
                            ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
