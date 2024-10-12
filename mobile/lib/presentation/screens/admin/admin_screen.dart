import 'package:flutter/material.dart';
import 'admin_modal.dart'; // Import BookingDetailsModal
import 'admin_header.dart'; // Import AdminHeader

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for each status (Pending, Accepted, Rejected)
    final List<Map<String, String>> pendingRequests = [
      {
        "id": "1",
        "userName": "John Doe",
        "hotelName": "Grand Hotel",
        "roomName": "Suite 101",
        "date": "Oct 12, 2024",
        "checkIn": "Oct 12, 2024",
        "checkOut": "Oct 15, 2024",
        "timeIn": "2:00 PM",
        "timeOut": "11:00 AM",
        "fullName": "Johnathan Doe",
        "email": "johndoe@example.com",
        "phoneNumber": "+1234567890",
        "address": "123 Main St, New York, NY",
        "adults": "2",
        "children": "1"
      },
    ];

    final List<Map<String, String>> acceptedRequests = [
      {
        "id": "2",
        "userName": "Jane Smith",
        "hotelName": "Oceanview Resort",
        "roomName": "Deluxe Ocean View",
        "date": "Nov 5, 2024",
        "checkIn": "Nov 5, 2024",
        "checkOut": "Nov 10, 2024",
        "timeIn": "3:00 PM",
        "timeOut": "11:00 AM",
        "fullName": "Jane Smith",
        "email": "janesmith@example.com",
        "phoneNumber": "+1234567890",
        "address": "456 Park Ave, New York, NY",
        "adults": "2",
        "children": "0"
      },
    ];

    final List<Map<String, String>> rejectedRequests = [
      {
        "id": "3",
        "userName": "Alice Brown",
        "hotelName": "Mountain Lodge",
        "roomName": "Cabin 9",
        "date": "Oct 20, 2024",
        "checkIn": "Oct 20, 2024",
        "checkOut": "Oct 25, 2024",
        "timeIn": "4:00 PM",
        "timeOut": "10:00 AM",
        "fullName": "Alice Brown",
        "email": "alicebrown@example.com",
        "phoneNumber": "+9876543210",
        "address": "789 Elm St, Denver, CO",
        "adults": "3",
        "children": "1"
      },
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            const AdminHeader(),
            const TabBar(
              tabs: [
                Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
                Tab(text: 'Accepted', icon: Icon(Icons.check_circle)),
                Tab(text: 'Rejected', icon: Icon(Icons.cancel)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.builder(
                    itemCount: pendingRequests.length,
                    itemBuilder: (context, index) {
                      final request = pendingRequests[index];

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BookingDetailsModal(bookingRequest: request);
                              },
                            );
                          },
                          child: ListTile(
                            title: Text(
                              'User: ${request["userName"]}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hotel: ${request["hotelName"]}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Room: ${request["roomName"]}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Booking Date: ${request["date"]}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: acceptedRequests.length,
                    itemBuilder: (context, index) {
                      final request = acceptedRequests[index];

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BookingDetailsModal(bookingRequest: request);
                              },
                            );
                          },
                          child: ListTile(
                            title: Text(
                              'User: ${request["userName"]}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hotel: ${request["hotelName"]}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Room: ${request["roomName"]}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Booking Date: ${request["date"]}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: rejectedRequests.length,
                    itemBuilder: (context, index) {
                      final request = rejectedRequests[index];

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BookingDetailsModal(bookingRequest: request);
                              },
                            );
                          },
                          child: ListTile(
                            title: Text(
                              'User: ${request["userName"]}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hotel: ${request["hotelName"]}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Room: ${request["roomName"]}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Booking Date: ${request["date"]}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}