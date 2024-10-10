import 'package:flutter/material.dart';
import 'history_modal.dart'; // Import your HistoryModal class

class HistoryBody extends StatelessWidget {
  const HistoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: 5, // Using 5 fixed items
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0), // Smaller padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row to align button to the top right and content to the left
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Monarch Hotel - Deluxe Suite',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Set text color to black
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Check-in: 12th Jan, 2024',
                                    style: TextStyle(
                                      color: Colors.black, // Set text color to black
                                    ),
                                  ),
                                  Text(
                                    'Check-out: 15th Jan, 2024',
                                    style: TextStyle(
                                      color: Colors.black, // Set text color to black
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Elevated button aligned to the top right
                            ElevatedButton(
                              onPressed: () {
                                // Show modal when "Rate" button is clicked
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const HistoryModal(); // Use the external modal widget
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1C3473), // New button color
                              ),
                              child: const Text('Rate'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0), // Smaller space
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 16.0,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: const Text(
              'History',
              style: TextStyle(
                fontSize: 24.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
