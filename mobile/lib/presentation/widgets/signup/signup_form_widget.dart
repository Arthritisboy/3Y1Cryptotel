import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/signup_model.dart';
import 'package:hotel_flutter/logic/bloc/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/login/custom_text_form_field.dart';
import 'package:image_picker/image_picker.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formSignupKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _profilePicture;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      // Listen for auth state changes
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is Authenticated) {
          setState(() {
            _isLoading = false;
          });

          _showSuccessMessage();
          Navigator.of(context).pushReplacementNamed('/verifyCode',
              arguments: {'email': _emailController.text});
        } else if (state is AuthError) {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog(state.error);
        }
      },
      child: SingleChildScrollView(
        child: Form(
          key: _formSignupKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'HELLO! CREATE AN ACCOUNT TO ACCESS AMAZING DEALS.',
                style: TextStyle(
                    fontFamily: 'HammerSmith',
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(height: 16),
              const Text('SIGN UP',
                  style: TextStyle(
                      fontFamily: 'HammerSmith',
                      fontSize: 20,
                      color: Colors.black)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _pickImageFromGallery();
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profilePicture != null
                      ? FileImage(_profilePicture!)
                      : null,
                  child: _profilePicture == null
                      ? const Icon(Icons.add_a_photo, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                label: 'First Name',
                hint: 'Enter your first name',
                controller: _firstNameController,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                label: 'Last Name',
                hint: 'Enter your last name',
                controller: _lastNameController,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                label: 'Password',
                hint: 'Enter your password',
                controller: _passwordController,
                isObscure: true,
                showPassword: _isPasswordVisible,
                toggleShowPassword: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                label: 'Confirm Password',
                hint: 'Verify your password',
                controller: _confirmPasswordController,
                isObscure: true,
                showPassword: _isConfirmPasswordVisible,
                toggleShowPassword: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: screenWidth * 0.5,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF1C3473)),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formSignupKey.currentState!.validate()) {
                            final signUpModel = SignUpModel(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
                              profilePicture: _profilePicture?.path ?? '',
                            );
                            context
                                .read<AuthBloc>()
                                .add(SignUpEvent(signUpModel, _profilePicture));
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('SIGN UP'),
                ),
              ),
              const SizedBox(height: 8),
              _buildLoginRedirect(),
            ],
          ),
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _profilePicture = File(returnedImage!.path);
    });
  }

  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? '),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: const Text(
            'Login',
            style: TextStyle(
              color: Color.fromARGB(255, 29, 53, 115),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration Successful!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
