import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget {
  final String firstName;
  final String lastName;

  const TabHeader({super.key, required this.firstName, required this.lastName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/others/cryptotelLogo.png',
                width: 56.0,
                height: 53.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10.0),
            ],
          ),
          const SizedBox(height: 5.0),
          const Text(
            "Where Would you",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
          Text(
            "Like to Travel, $firstName", // Use the firstName variable here
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          hintText: 'Search',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          errorBorder: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
      ),
    );
  }
}
