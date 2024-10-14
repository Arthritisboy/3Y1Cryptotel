import 'package:flutter/material.dart';

class AdminCreate extends StatelessWidget {
  const AdminCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.person,
            size: 100,
            color: Colors.blue,
          ),
          SizedBox(height: 20),
          Text(
            'Welcome to Jem\'s Page!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'This is a custom design just for Jem!',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}