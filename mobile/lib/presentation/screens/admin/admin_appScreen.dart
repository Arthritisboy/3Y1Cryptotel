import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_app/admin_appNav.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_header.dart';

class AdminAppscreen extends StatelessWidget {
  const AdminAppscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          AdminHeader(),
          Expanded(
            child: AdminAppnav(), 
          ),
        ],
      ),
    );
  }
}
