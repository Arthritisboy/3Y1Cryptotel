import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth_state.dart';

class EmailResetTokenScreen extends StatefulWidget {
  const EmailResetTokenScreen({super.key});

  @override
  State<EmailResetTokenScreen> createState() => EmailResetTokenScreenState();
}

class EmailResetTokenScreenState extends State<EmailResetTokenScreen> {
  final _formTokenKey = GlobalKey<FormState>();
  String? _token;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
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
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Please enter the token sent to your email to reset your password.',
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
                  key: _formTokenKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: TextFormField(
                          onChanged: (value) {
                            _token =
                                value; // Update the token as the user types
                          },
                          decoration: InputDecoration(
                            label: const Text('Token'),
                            hintText: 'Enter Token',
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
                                  Navigator.of(context).pushNamed(
                                    '/resetPassword',
                                    arguments: {
                                      'token': _token,
                                    },
                                  );
                                },
                          child: const Text(
                            'Continue',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
