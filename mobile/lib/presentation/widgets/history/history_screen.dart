import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_accepted.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_header.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_pending.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_rate.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const HistoryHeader(),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF1C3473), 
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rate'),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10.0), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop(); 
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: const Text(
                        'Bookings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  HistoryPendingBody(),
                  HistoryAcceptedBody(),
                  HistoryRateBody(status: 'Rate'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
