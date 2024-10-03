import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth_state.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email;

  const VerificationCodeScreen({super.key, required this.email});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _formVerificationKey = GlobalKey<FormState>();
  String? _verificationCode;
  bool _isLoading = false; // Track loading state

  String _getFriendlyErrorMessage(String error) {
    switch (error) {
      case 'User not found':
        return 'We couldn\'t find a user with that email. Please check and try again.';
      case 'Invalid verification code':
        return 'The verification code you entered is invalid. Please try again.';
      case 'Network error':
        return 'Please check your internet connection and try again.';
      default:
        return 'Something went wrong. Please try again later.';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthLoading) {
                  setState(() {
                    _isLoading = true;
                  });
                } else if (state is AuthSuccessVerification) {
                  setState(() {
                    _isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: const Text('Verification successful!'),
                      backgroundColor:
                          Colors.green, // Set the background color to green
                    ),
                  );
                  Navigator.of(context).pushReplacementNamed('/login');
                } else if (state is AuthError) {
                  setState(() {
                    _isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_getFriendlyErrorMessage(state.error)),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is AuthInitial) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Text(
                      'Please enter the verification code sent to your email address.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenHeight * 0.018,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Form(
                    key: _formVerificationKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.8,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your verification code';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _verificationCode =
                                  value; // Store the verification code input
                            },
                            decoration: InputDecoration(
                              label: const Text('Verification Code'),
                              hintText: 'Enter Verification Code',
                              hintStyle: const TextStyle(color: Colors.black26),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        SizedBox(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 29, 53, 115),
                            ),
                            onPressed: _isLoading
                                ? null // Disable button while loading
                                : () {
                                    if (_formVerificationKey.currentState!
                                        .validate()) {
                                      _verifyCode(_verificationCode!);
                                    }
                                  },
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Verify',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Didn\'t receive the code? ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    '/resendCode'); // Update with your resend code screen
                              },
                              child: const Text(
                                'Resend Code',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 29, 53, 115),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _verifyCode(String code) {
    context
        .read<AuthBloc>()
        .add(VerifyUserEvent(email: widget.email, code: code));
  }
}
