import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/profile/blue_background_widget.dart';
import 'package:hotel_flutter/presentation/widgets/profile/bottom_section.dart';
import 'package:image_picker/image_picker.dart'; // For selecting images
import 'package:logging/logging.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profile,
    required this.phoneNumber,
    required this.gender,
  });

  final String firstName;
  final String lastName;
  final String email;
  String profile;
  final String phoneNumber;
  final String gender;

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Logger _logger = Logger('ProfileScreen');
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

        // Retrieve the current user from AuthBloc's state
        final currentUser =
            (context.read<AuthBloc>().state as Authenticated).user;
        // Call the provider's updateUserData to upload the image
        context.read<AuthBloc>().add(
              UpdateUserEvent(
                currentUser, // Pass the current user
                profilePicture: _selectedImage?.path,
              ),
            );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Update user data method
  Future<void> updateUserData() async {
    setState(() {
      _isLoading = true; // Start loading when the update process begins
    });

    try {
      // Retrieve the current user from AuthBloc's state
      final currentUser =
          (context.read<AuthBloc>().state as Authenticated).user;

      // Call the provider's updateUserData to update user info
      context.read<AuthBloc>().add(
            UpdateUserEvent(
              currentUser,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              profilePicture: _selectedImage?.path,
            ),
          );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading once the update is complete
      });
    }
  }

  // Loading widget with blue background and message
  Widget _buildLoadingIndicator() {
    return Stack(
      children: [
        const BlueBackground(), // Blue background widget
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(), // Loading spinner
              SizedBox(height: 20),
              Text(
                "User Account Updating. Please Wait.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
          const BlueBackground(), // Custom background widget
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            bottom: 0,
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  // Handle successful profile update
                  setState(() {
                    widget.profile = state.user.profilePicture ??
                        ''; // Update profile picture
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  _logger.info('Current Auth State: $state');

                  if (state is AuthLoading || _isLoading) {
                    return _buildLoadingIndicator(); // Show loading animation
                  }

                  if (state is Authenticated) {
                    // Ensure you're working with a single authenticated user, not a list
                    final user = state.user;
                    print('User is authenticated.');
                    print(
                        'Authenticated User: ${user.email}, ${user.firstName}, ${user.lastName}');

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
                      isLoading: _isLoading,
                    );
                  }

                  if (state is AuthError) {
                    return Center(
                      child: Text(
                        'Error: Unable to load user data.\n${state.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  _logger.warning('Unexpected state encountered: $state');
                  return const Center(
                    child: Text('Unexpected error loading user data.'),
                  );
                },
              ),
            ),
          ),
          // Profile picture at the top
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
                              color: Color.fromARGB(255, 29, 53, 115),
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
