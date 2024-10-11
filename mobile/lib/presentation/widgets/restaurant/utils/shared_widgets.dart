import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildLabelledTextField(TextEditingController controller, String label,
    IconData icon, String placeholder, VoidCallback onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
              color: Color.fromARGB(255, 142, 142, 147), fontSize: 14)),
      const SizedBox(height: 4),
      SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            prefixIcon: Icon(icon),
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          style: const TextStyle(color: Colors.black),
          onChanged: (value) => onChanged(),
        ),
      ),
    ],
  );
}

Widget buildLabelledNumericTextField(TextEditingController controller,
    String label, IconData icon, String placeholder, VoidCallback onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
              color: Color.fromARGB(255, 142, 142, 147), fontSize: 14)),
      const SizedBox(height: 4),
      SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            prefixIcon: Icon(icon),
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          style: const TextStyle(color: Colors.black),
          onChanged: (value) => onChanged(),
        ),
      ),
    ],
  );
}

Widget buildDatePickerField(TextEditingController controller, String label,
    BuildContext context, String placeholder, VoidCallback onTap) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
              color: Color.fromARGB(255, 142, 142, 147), fontSize: 14)),
      const SizedBox(height: 4),
      SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            prefixIcon: Icon(Icons.calendar_today),
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          onTap: onTap,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ],
  );
}

Widget buildTimePickerField(TextEditingController controller, String label,
    BuildContext context, VoidCallback onTap) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
              color: Color.fromARGB(255, 142, 142, 147), fontSize: 14)),
      const SizedBox(height: 4),
      SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            prefixIcon: Icon(Icons.access_time),
            hintText: 'Select Time',
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          onTap: onTap,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ],
  );
}
