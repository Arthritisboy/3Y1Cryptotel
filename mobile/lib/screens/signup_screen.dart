import 'package:flutter/material.dart';
import 'package:hotel_flutter/screens/signin_screen.dart';
import 'package:hotel_flutter/widgets/custom_scaffold.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                // get started form
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      const Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Full name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Username'),
                            hintText: 'Enter your username',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // email
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            hintText: 'Enter Email',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // password
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          obscureText: true,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            hintText: 'Enter password',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          obscureText: true,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Confirm Password'),
                            hintText: 'Verify your password',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // i agree to the processing
                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: agreePersonalData,
                      //       onChanged: (bool? value) {
                      //         setState(() {
                      //           agreePersonalData = value!;
                      //         });
                      //       },
                      //       activeColor: lightColorScheme.primary,
                      //     ),
                      //     const Text(
                      //       'I agree to the processing of ',
                      //       style: TextStyle(
                      //         color: Colors.black45,
                      //       ),
                      //     ),
                      //     Text(
                      //       'Personal data',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         color: lightColorScheme.primary,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: 300,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formSignupKey.currentState!.validate() &&
                                agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing Data'),
                                ),
                              );
                            } else if (!agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please agree to the processing of personal data')),
                              );
                            }
                          },
                          child: const Text('Sign up'),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      // sign up divider
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Expanded(
                      //       child: Divider(
                      //         thickness: 0.7,
                      //         color: Colors.grey.withOpacity(0.5),
                      //       ),
                      //     ),
                      //     const Padding(
                      //       padding: EdgeInsets.symmetric(
                      //         vertical: 0,
                      //         horizontal: 10,
                      //       ),
                      //       child: Text(
                      //         'Sign up with',
                      //         style: TextStyle(
                      //           color: Colors.black45,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Divider(
                      //         thickness: 0.7,
                      //         color: Colors.grey.withOpacity(0.5),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SigninScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
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
