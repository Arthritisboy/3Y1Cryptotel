import 'package:flutter/material.dart';
import 'package:hotel_flutter/widgets/custom_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      child: Text('welcome'),
    );
  }
}
