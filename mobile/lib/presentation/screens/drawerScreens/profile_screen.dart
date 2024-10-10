import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/data_provider/auth/auth_data_provider.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/profile/blue_background_widget.dart';
import 'package:hotel_flutter/presentation/widgets/profile/bottom_section.dart';
import 'package:image_picker/image_picker.dart'; // For selecting images
import 'package:logging/logging.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
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
  String profile;
  final String phoneNumber; // Added Phone Number
  final String gender; // Added Gender

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

        // Listen to the AuthBloc for state changes to update the UI
        context.read<AuthBloc>().stream.listen((state) {
          if (state is Authenticated) {
            setState(() {
              widget.profile = state.user.profilePicture ??
                  ''; // Provide a default value if null
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile picture updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        });
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

      // Listen for changes
      context.read<AuthBloc>().stream.listen((state) {
        if (state is Authenticated) {
          setState(() {
            widget.profile = state.user.profilePicture ??
                ''; // Provide a default value if null
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User data updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
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
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  _logger.info(
                      '${state.user.email}\n${state.user.firstName}\n${state.user.lastName}\n${state.user.profilePicture}\n${state.user.gender}\n${state.user.phoneNumber}');
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
                } else {
                  _logger.info(state);
                }
                return Container();
              },
            ),
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
