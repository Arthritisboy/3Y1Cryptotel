import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:hotel_flutter/logic/bloc/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth_state.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formSignupKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() {
            _isLoading = true; // Start loading
          });
        } else if (state is Authenticated) {
          setState(() {
            _isLoading = false; // Stop loading
          });

          _showSuccessMessage();

          // Navigate to the home screen after successful registration
          Navigator.of(context).pushReplacementNamed('/login');
        } else if (state is AuthError) {
          setState(() {
            _isLoading = false; // Stop loading
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
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SIGN UP',
                style: TextStyle(
                  fontFamily: 'HammerSmith',
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                  'First Name', 'Enter your first name', _firstNameController),
              const SizedBox(height: 8),
              _buildTextFormField(
                  'Last Name', 'Enter your last name', _lastNameController),
              const SizedBox(height: 8),
              _buildTextFormField('Email', 'Enter your email', _emailController,
                  isEmail: true),
              const SizedBox(height: 8),
              _buildTextFormField(
                  'Password', 'Enter your password', _passwordController,
                  isObscure: true),
              const SizedBox(height: 8),
              _buildTextFormField('Confirm Password', 'Verify your password',
                  _confirmPasswordController,
                  isObscure: true),
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
                            if (_firstNameController.text.isEmpty ||
                                _lastNameController.text.isEmpty ||
                                _emailController.text.isEmpty ||
                                _passwordController.text.isEmpty ||
                                _confirmPasswordController.text.isEmpty) {
                              _showEmptyFieldsDialog();
                            } else if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              _showErrorDialog('Passwords do not match');
                            } else {
                              final signUpModel = SignUpModel(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                confirmPassword:
                                    _confirmPasswordController.text,
                              );
                              context
                                  .read<AuthBloc>()
                                  .add(SignUpEvent(signUpModel));
                            }
                          }
                        },
                  child: const Text('SIGN UP'),
                ),
              ),
              const SizedBox(height: 8),
              _buildLoginRedirect(),
              if (_isLoading)
                const CircularProgressIndicator(), // Show loading indicator
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      String label, String hint, TextEditingController controller,
      {bool isEmail = false, bool isObscure = false}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
        obscureText: isObscure,
        decoration: InputDecoration(
          label: Text(label),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?'),
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed('/login'); // Update to your login screen
          },
          child: const Text('Log in'),
        ),
      ],
    );
  }

  void _showEmptyFieldsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Error'),
        content: const Text('Please fill in all fields.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
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
        content: Text('User successfully registered!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
