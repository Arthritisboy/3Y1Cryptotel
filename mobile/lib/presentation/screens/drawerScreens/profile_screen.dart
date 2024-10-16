import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/profile/blue_background_widget.dart';
import 'package:hotel_flutter/presentation/widgets/profile/bottom_section.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profile,
    required this.phoneNumber,
    required this.gender,
    required this.userId,
  });

  String firstName;
  String lastName;
  final String email;
  String profile;
  final String phoneNumber;
  String gender;
  final String userId;

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
  late TextEditingController phoneNumberController;

  String? gender;
  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
    phoneNumberController = TextEditingController(text: widget.phoneNumber);
    gender = widget.gender;

    final currentState = context.read<AuthBloc>().state;
    if (currentState is Authenticated &&
        currentState.user.id == widget.userId) {
      // User data is already loaded
    } else {
      // Fetch user data only if not loaded
      context.read<AuthBloc>().add(GetUserEvent(widget.userId));
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
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

        await updateUserData();
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

  Future<void> updateUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser =
          (context.read<AuthBloc>().state as Authenticated).user;

      // Ensure the path is used correctly
      String? imagePath;
      if (_selectedImage != null) {
        imagePath = _selectedImage!.path; // Get the path of the selected image
      }

      context.read<AuthBloc>().add(
            UpdateUserEvent(
              currentUser,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              profilePicture: imagePath, // Pass the image path if available
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
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingIndicator() {
    return Stack(
      children: [
        const BlueBackground(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
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
            Navigator.of(context).pop();
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
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AccountDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  Navigator.of(context).pushReplacementNamed('/login');
                }
                if (state is UserUpdated) {
                  // Update the local widget state
                  setState(() {
                    widget.profile = state.user.profilePicture ?? '';
                    widget.firstName = state.user.firstName ?? '';
                    widget.lastName =
                        state.user.lastName ?? ''; // Update lastName correctly
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context)
                      .pop(state.user); // Return the updated user
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
                    return _buildLoadingIndicator();
                  }

                  if (state is Authenticated || state is UserUpdated) {
                    final user = state is Authenticated
                        ? state.user
                        : (state as UserUpdated).user;

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
          Positioned(
            top: MediaQuery.of(context).size.height * 0.01,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _isLoading ? null : _pickImage,
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
