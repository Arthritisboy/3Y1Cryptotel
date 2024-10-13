import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/utils_widget/custom_dialog.dart';
import 'package:hotel_flutter/presentation/widgets/login/custom_text_form_field.dart';
import 'package:hotel_flutter/presentation/widgets/login/loading_button.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false; // New variable for password visibility

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedLogin) {
            setState(() {
              _isLoading = false; // Reset loading state
            });
            // Check if the user has completed onboarding
            if (!state.hasCompletedOnboarding) {
              // Navigate to home screen
              Navigator.pushReplacementNamed(context, '/onboarding');
            } else if (state.hasCompletedOnboarding && state.roles == 'admin') {
              // Navigate to onboarding screen
              Navigator.pushReplacementNamed(context, '/admin');
            } else {
              // Navigate to onboarding screen
              Navigator.pushReplacementNamed(context, '/homescreen');
            }
          } else if (state is AuthError) {
            setState(() {
              _isLoading = false; // Reset loading state
            });
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is AuthLoading) {
            setState(() {
              _isLoading = true; // Set loading state
            });
          }
        },
        child: Stack(
          children: [
            // Background and logo
            Container(color: Colors.white),
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      left: screenWidth * 0.05,
                      bottom: screenHeight * 0.05,
                    ),
                    child: Text(
                      'CRYPTOTEL',
                      style: TextStyle(
                        fontFamily: 'HammerSmith',
                        fontSize: screenHeight * 0.03,
                        color: const Color(0xFF1C3473),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.4,
                  child: Image.asset(
                    'assets/images/others/temp_image.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.05,
                  screenHeight * 0.05,
                  screenWidth * 0.05,
                  screenHeight * 0.02,
                ),
                height: screenHeight * 0.55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'HELLO! ACCESS AMAZING DEALS BY \nLOGGING IN NOW!.',
                        style: TextStyle(
                          fontFamily: 'HammerSmith',
                          fontSize: screenHeight * 0.02,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      const Text('LOG IN',
                          style: TextStyle(
                              fontFamily: 'HammerSmith',
                              fontSize: 20,
                              color: Colors.black)),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextFormField(
                        label: 'Email',
                        hint: 'Enter Email',
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Updated Password Field with suffixIcon
                      CustomTextFormField(
                        label: 'Password',
                        hint: 'Enter Password',
                        controller: _passwordController,
                        isObscure: true, // Set to true for password field
                        showPassword:
                            _isPasswordVisible, // Show password based on visibility
                        toggleShowPassword: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle password visibility
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/forgotPassword');
                              },
                              child: const Text(
                                'Forget Password?',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 29, 53, 115),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      LoadingButton(
                        isLoading: _isLoading,
                        onPressed: () {
                          if (_formSignInKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        text: 'LOGIN',
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/signup');
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: Color.fromARGB(255, 29, 53, 115),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;
    print('Email: $email');
    print('Password: $password');

    context.read<AuthBloc>().add(
          LoginEvent(email: email, password: password),
        );
  }

  void _showErrorDialog(String message) {
    String friendlyMessage;

    if (message.contains('Invalid') || message.contains('Email')) {
      friendlyMessage = 'Invalid Email or Password. Please try again';
    } else {
      friendlyMessage = 'Invalid Email or Password. Please try again';
    }

    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Login Failed',
        description: friendlyMessage,
        buttonText: 'OK',
        onButtonPressed: () => Navigator.of(context).pop(),
        onSecondButtonPressed: () {},
      ),
    );
  }
}
