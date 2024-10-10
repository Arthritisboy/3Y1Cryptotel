import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_body.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_header.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HistoryHeader(),
          SizedBox(height: 16),
          HistoryBody(),
        ],
      ),
    );
  }
}