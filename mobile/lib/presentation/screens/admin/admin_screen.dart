import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fixed data for booking requests
    final List<Map<String, String>> bookingRequests = [
      {"id": "1", "name": "John Doe", "date": "Oct 12, 2024"},
      {"id": "2", "name": "Jane Smith", "date": "Oct 15, 2024"},
      {"id": "3", "name": "Alice Brown", "date": "Oct 20, 2024"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Booking Requests'),
      ),
      body: ListView.builder(
        itemCount: bookingRequests.length,
        itemBuilder: (context, index) {
          final request = bookingRequests[index];

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Booking Details',
                        style: TextStyle(color: Colors.black), // Force black title text
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking by: ${request["name"]}',
                            style: const TextStyle(color: Colors.black), // Force black text
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date: ${request["date"]}',
                            style: const TextStyle(color: Colors.black), // Force black text
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Handle accept logic here
                            Navigator.of(context).pop(); // Close the modal
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Accepted booking by ${request["name"]}')),
                            );
                          },
                          child: const Text('Accept'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle reject logic here
                            Navigator.of(context).pop(); // Close the modal
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Rejected booking by ${request["name"]}')),
                            );
                          },
                          child: const Text('Reject'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Just close the modal
                          },
                          child: const Text('Close'),
                        ),
                      ],
                      backgroundColor: Colors.white, // Ensure the background is white
                    );
                  },
                );
              },
              child: ListTile(
                title: Text(
                  'Booking by: ${request["name"]}',
                  style: const TextStyle(color: Colors.black), // Set title text to black
                ),
                subtitle: Text(
                  'Date: ${request["date"]}',
                  style: const TextStyle(color: Colors.black), // Set subtitle text to black
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}