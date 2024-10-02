import 'package:flutter/material.dart';

class InputFields extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController paxController = TextEditingController();
  final TextEditingController checkInTimeController = TextEditingController();
  final TextEditingController checkOutTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Full Name and Email Address
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildLabelledTextField(fullNameController, 'Full Name'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildLabelledTextField(emailController, 'Email Address'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Mobile Number and Number of Pax
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildLabelledTextField(
                  mobileNumberController, 'Mobile Number'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildLabelledTextField(paxController, 'Number of Pax'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Check-in Time and Check-out Time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildLabelledTextField(
                  checkInTimeController, 'Check-in Time'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildLabelledTextField(
                  checkOutTimeController, 'Check-out Time'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabelledTextField(
      TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 142, 142, 147),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4), // Space between label and text field
        Container(
          height: 40, // Adjust height here
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
            style: const TextStyle(color: Colors.black), // Black input text
          ),
        ),
      ],
    );
  }
}
