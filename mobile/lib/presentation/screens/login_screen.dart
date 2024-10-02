import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/login/custom_text_form_field.dart';
import 'package:hotel_flutter/presentation/widgets/login/loading_button.dart';
import 'package:hotel_flutter/logic/bloc/auth_event.dart';

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is AuthenticatedLogin) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pushNamed('/homescreen');
          } else if (state is AuthError) {
            setState(() {
              _isLoading = false;
            });
            _showErrorDialog(state.error);
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
                      CustomTextFormField(
                        label: 'Password',
                        hint: 'Enter Password',
                        controller: _passwordController,
                        isObscure: true,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
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
}
