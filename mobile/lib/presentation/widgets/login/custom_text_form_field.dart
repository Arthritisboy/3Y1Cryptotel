import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isObscure;
  final String? Function(String?)? validator;
  final bool showPassword; // Parameter to manage password visibility
  final VoidCallback? toggleShowPassword; // Callback for toggling visibility

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isObscure = false,
    this.validator,
    this.showPassword = false, // Default to false
    this.toggleShowPassword, // Optional callback for toggling
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 0.7,
      height: screenWidth * 0.1,
      child: TextFormField(
        controller: controller,
        obscureText:
            isObscure && !showPassword, // Show password based on the state
        obscuringCharacter: '*',
        validator: validator,
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
          // Add the suffix icon only if it's a password field
          suffixIcon: isObscure
              ? IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: toggleShowPassword, // Use the callback to toggle
                )
              : null,
        ),
      ),
    );
  }
}
