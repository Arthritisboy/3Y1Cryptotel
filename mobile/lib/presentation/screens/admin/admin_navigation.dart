import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/admin/admin_header.dart';
import 'package:hotel_flutter/presentation/screens/admin/admin_modal.dart';


class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  _AdminNavigationState createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentRequests;
    String currentStatus;

    if (_selectedIndex == 0) {
      currentRequests = pendingRequests;
      currentStatus = "Pending Requests";
    } else if (_selectedIndex == 1) {
      currentRequests = acceptedRequests;
      currentStatus = "Accepted Requests";
    } else {
      currentRequests = rejectedRequests;
      currentStatus = "Rejected Requests";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard - $currentStatus'),
      ),
      body: Column(
        children: [
          const AdminHeader(), // Show the Admin Header at the top
          Expanded(
            child: ListView.builder(
              itemCount: currentRequests.length,
              itemBuilder: (context, index) {
                final request = currentRequests[index];

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
                          Text('Hotel: ${request["hotelName"]}',
                              style: const TextStyle(color: Colors.black)),
                          Text('Room: ${request["roomName"]}',
                              style: const TextStyle(color: Colors.black)),
                          Text('Booking Date: ${request["date"]}',
                              style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Accepted',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Rejected',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}