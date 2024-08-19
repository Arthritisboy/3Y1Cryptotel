import 'package:flutter/material.dart';
import 'package:hotel_flutter/widgets/custom_scaffold.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
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
            flex: 2,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Form(
                key: _formSignInKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 25.0),
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
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
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
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row(
                        //   children: [
                        //     Checkbox(
                        //       value: rememberPassword,
                        //       onChanged: (bool? value) {
                        //         setState(() {
                        //           rememberPassword = value!;
                        //         });
                        //       },
                        //       activeColor: Colors.blue,
                        //     ),
                        //     const Text(
                        //       'Remember me',
                        //       style: TextStyle(
                        //         color: Colors.black45,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    SizedBox(
                      width: 300,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formSignInKey.currentState!.validate() &&
                              rememberPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Processing Data'),
                              ),
                            );
                          } else if (!rememberPassword) {
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
                      height: 25.0,
                    ),
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
                      height: 25.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
