import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/login/custom_text_form_field.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formSignupKey = GlobalKey<FormState>();
  final bool _isLoading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _selectedGender;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Form(
      key: _formSignupKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'HELLO! CREATE AN ACCOUNT TO ACCESS AMAZING DEALS.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          const SizedBox(height: 16),
          const Text('SIGN UP',
              style: TextStyle(fontSize: 20, color: Colors.black)),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'First Name',
            hint: 'Enter your first name',
            controller: _firstNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              if (value.length < 3) {
                return 'First name must be less than 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            label: 'Last Name',
            hint: 'Enter your last name',
            controller: _lastNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              if (value.length < 3) {
                return 'Last name must be less than 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // Contact Number Input
          CustomTextFormField(
            label: 'Contact Number',
            hint: 'Enter your contact number',
            controller: _phoneNumberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your contact number';
              }
              if (value.length <= 10) {
                return 'Contact number must be less than 10 digits';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),

          const SizedBox(height: 8),

          // Gender Dropdown
          _buildGenderDropdown(screenWidth),
          const SizedBox(height: 8),

          // Email Input
          CustomTextFormField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@gmail')) {
                return 'Email must be a Gmail address';
              }
              if (!RegExp(r'^[\w-\.]+@gmail\.com$').hasMatch(value)) {
                return 'Please enter a valid Gmail address';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // Password Input
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
            validator: (value) {
              value = value?.trim(); // Remove leading and trailing spaces.
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length <= 8) {
                return 'Password must be exactly 8 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // Confirm Password Input
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

          // Signup Button
          SizedBox(
            width: screenWidth * 0.5,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFF1C3473)),
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_formSignupKey.currentState!.validate()) {
                        // Ensure role is selected
                        Navigator.of(context).pushReplacementNamed(
                          '/uploadPicture',
                          arguments: {
                            'firstName': _firstNameController.text,
                            'lastName': _lastNameController.text,
                            'email': _emailController.text,
                            'password': _passwordController.text,
                            'confirmPassword': _confirmPasswordController.text,
                            'phoneNumber': _phoneNumberController.text,
                            'gender': _selectedGender,
                          },
                        );
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('SIGN UP'),
            ),
          ),
          const SizedBox(height: 8),
          _buildLoginRedirect(),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _buildGenderDropdown(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: screenWidth * 0.7,
        height: screenWidth * 0.12,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Gender',
            labelStyle: const TextStyle(color: Colors.black),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          value: _selectedGender,
          items: const [
            DropdownMenuItem(value: 'male', child: Text('Male')),
            DropdownMenuItem(value: 'female', child: Text('Female')),
            DropdownMenuItem(value: 'other', child: Text('Other')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select your gender';
            }
            return null;
          },
        ),
      ),
    );
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
}
