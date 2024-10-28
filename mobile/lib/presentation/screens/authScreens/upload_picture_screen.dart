import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/utils_widget/custom_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotel_flutter/data/model/auth/signup_model.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadPictureScreen extends StatefulWidget {
  const UploadPictureScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.gender,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String gender;

  @override
  State<UploadPictureScreen> createState() => _UploadPictureScreenState();
}

class _UploadPictureScreenState extends State<UploadPictureScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isLoading = false;
  bool _isSigningUp = false; // To track the sign-up process

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoading) {
          setState(() {
            _isSigningUp = true; // Show loading state
          });
        } else if (state is AuthSuccess) {
          setState(() {
            _isSigningUp = false; // Hide loading state
          });

          // Navigate to verification screen after successful sign-up
          Navigator.of(context).pushReplacementNamed(
            '/verifyCode',
            arguments: {'email': widget.email},
          );
        } else if (state is AuthError) {
          setState(() {
            _isSigningUp = false; // Hide loading state on error
          });

          // Show error dialog on failure
          _showErrorDialog(context, state.error);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.08),
                        Text(
                          'CRYPTOTEL',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 29, 53, 115),
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.25),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1),
                          child: Text(
                            'Please upload your profile picture.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenHeight * 0.018,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        _buildProfilePicture(screenHeight),
                        SizedBox(height: screenHeight * 0.03),
                        SizedBox(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 29, 53, 115),
                            ),
                            onPressed: _isLoading ? null : _pickImage,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Upload Picture',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _signUpUser(context, null);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 29, 53, 115),
                    ),
                    onPressed: _isSigningUp
                        ? null
                        : () {
                            _signUpUser(context, _selectedImage?.path);
                          },
                    child: _isSigningUp
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Finish',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture(double screenHeight) {
    return Container(
      width: screenHeight * 0.18,
      height: screenHeight * 0.18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 29, 53, 115),
      ),
      child: _selectedImage == null
          ? CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 173, 175, 210),
              child: Icon(
                Icons.person,
                size: screenHeight * 0.1,
                color: const Color.fromARGB(255, 29, 53, 115),
              ),
            )
          : ClipOval(
              child: Image.file(
                File(_selectedImage!.path),
                width: screenHeight * 0.18,
                height: screenHeight * 0.18,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = pickedImage;
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

  void _signUpUser(BuildContext context, String? profilePath) async {
    setState(() {
      _isSigningUp = true;
    });

    final signUpModel = SignUpModel(
      firstName: widget.firstName,
      lastName: widget.lastName,
      email: widget.email,
      password: widget.password,
      confirmPassword: widget.confirmPassword,
      gender: widget.gender,
      phoneNumber: widget.phoneNumber,
      profilePicture: profilePath,
    );

    context.read<AuthBloc>().add(SignUpEvent(signUpModel, profilePath));
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Error',
          description: errorMessage,
          buttonText: 'Retry',
          secondButtonText: 'Cancel',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.of(context)
                .pushReplacementNamed('/signup'); // Navigate to /signup
          },
          onSecondButtonPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }
}
