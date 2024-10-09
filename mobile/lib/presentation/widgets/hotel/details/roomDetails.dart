import 'package:flutter/material.dart';

class Roomdetails extends StatelessWidget {
  const Roomdetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Type Section
          Row(
            children: const [
              Icon(Icons.bed, color: Colors.black, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Room Type:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Single Bed',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Row containing Private Bathroom and Facilities
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Private Bathroom Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bathtub, color: Colors.black, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'In Your Private Bathroom:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('• Free Toiletries'),
                        Text('• Shower'),
                        Text('• Bidet'),
                        Text('• Toilet'),
                        Text('• Towels'),
                        Text('• Slippers'),
                        Text('• Toilet Paper'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Facilities Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.miscellaneous_services,
                            color: Colors.black, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Facilities:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('• Air Conditioning'),
                        Text('• Safety Deposit Box'),
                        Text('• Linen'),
                        Text('• Socket Near the Bed'),
                        Text('• TV'),
                        Text('• Refrigerator'),
                        Text('• Telephone'),
                        Text('• Satellite Channels'),
                        Text('• Wifi'),
                        Text('• Cable Channels'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Smoking Section
          Row(
            children: const [
              Icon(Icons.smoke_free, color: Colors.black, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Smoking:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            '• No Smoking',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
