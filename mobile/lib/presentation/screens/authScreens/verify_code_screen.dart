import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email;

  const VerificationCodeScreen({super.key, required this.email});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _formVerificationKey = GlobalKey<FormState>();
  String? _verificationCode;
  bool _isLoading = false;
  bool _isResendButtonDisabled = true;
  late Timer _timer;
  int _remainingSeconds = 600; // 10 minutes = 600 seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        setState(() {
          _isResendButtonDisabled = false;
          _timer.cancel();
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
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
                      content: Text('Verification successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pushReplacementNamed('/login');
                } else if (state is AuthError) {
                  setState(() {
                    _isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text((state.error)),
                      backgroundColor: Colors.red,
                    ),
                  );
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
                        fontSize: screenHeight * 0.02,
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
                              _verificationCode = value;
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
                                ? null
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
                                color: Color.fromARGB(255, 29, 53, 115),
                              ),
                            ),
                            GestureDetector(
                              onTap: _isResendButtonDisabled
                                  ? null
                                  : () {
                                      setState(() {
                                        _isResendButtonDisabled = true;
                                        _remainingSeconds =
                                            600; // Restart the timer
                                      });
                                      _startTimer();
                                      context.read<AuthBloc>().add(
                                          ResendCodeEvent(email: widget.email));
                                    },
                              child: Text(
                                _isResendButtonDisabled
                                    ? 'Resend Code (${_formatTime(_remainingSeconds)})'
                                    : 'Resend Code',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isResendButtonDisabled
                                      ? Colors.grey
                                      : const Color.fromARGB(255, 29, 53, 115),
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
