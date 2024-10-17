import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isObscure;
  final String? Function(String?)? validator;
  final bool showPassword;
  final VoidCallback? toggleShowPassword;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isObscure = false,
    this.validator,
    this.showPassword = false,
    this.toggleShowPassword,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.7, // Define a reasonable width
      child: TextFormField(
        controller: controller,
        obscureText: isObscure && !showPassword,
        obscuringCharacter: '*',
        validator: validator,
        maxLines: 1, // Single-line input
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(), // Remove the ellipsis overflow
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
          suffixIcon: isObscure
              ? IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: toggleShowPassword,
                )
              : null,
        ),
        keyboardType: TextInputType.text,
        // Enable horizontal scrolling for long text
        scrollPadding: const EdgeInsets.all(20.0),
        scrollPhysics: const BouncingScrollPhysics(), // Smooth scrolling
        textInputAction: TextInputAction.next,
        // Adding this ensures that the text can scroll horizontally
        enableInteractiveSelection: true,
      ),
    );
  }
}
