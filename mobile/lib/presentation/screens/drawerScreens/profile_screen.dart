import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/profile/blue_background_widget.dart';
import 'package:hotel_flutter/presentation/widgets/profile/bottom_section.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart'; // For selecting images

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profile,
    required this.phoneNumber, // Added Phone Number
    required this.gender, // Added Gender
  });

  final String firstName;
  final String lastName;
  final String email;
  final String profile;
  final String phoneNumber; // Added Phone Number
  final String gender; // Added Gender

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController; // Phone Number Controller

  String? gender; // Gender state
  File? _selectedImage; // To store the selected image file
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
    phoneNumberController = TextEditingController(
        text: widget.phoneNumber); // Initialize phone number controller
    gender = widget.gender; // Initialize gender
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose(); // Dispose phone number controller
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

    final updatedUser = UserModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phoneNumber: phoneNumberController.text, // Include updated phone number
      profilePicture: _selectedImage?.path ??
          widget.profile, // Use new image path if selected
      gender: gender ?? "Male", // Include updated gender
    );

    try {
      // Dispatch UpdateUserEvent
      context.read<AuthBloc>().add(
            UpdateUserEvent(updatedUser, profilePicture: _selectedImage?.path),
          );
      final userId = await const FlutterSecureStorage().read(key: 'userId');
      if (userId != null) {
        context.read<AuthBloc>().add(GetUserEvent(userId));
      }
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
                  emailController: emailController,
                  phoneNumberController: phoneNumberController,
                  gender: gender ?? 'Male',
                  updateUserData: updateUserData,
                  onGenderChanged: (selectedGender) {
                    setState(() {
                      gender = selectedGender;
                    });
                  },
                  isLoading: _isLoading, // Pass the loading state
                );
              }
              return Container();
            }),
          ),
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
