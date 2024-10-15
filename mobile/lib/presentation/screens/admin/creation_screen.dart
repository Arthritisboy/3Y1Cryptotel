import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_header.dart';
import 'package:hotel_flutter/presentation/widgets/admin/creation_content.dart';

class CreationScreen extends StatelessWidget {
  const CreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const AdminHeader(),
            const SizedBox(height: 20),
            const Expanded(
              child: CreationContent(),
            ),
          ],
        ),
      ),
    );
  }
}
