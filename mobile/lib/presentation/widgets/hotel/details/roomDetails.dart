import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/map/map_widget.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/map/full_map.dart';

class Roomdetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Room Details',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Room Type Section
          const Text(
            'Room Type:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
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
                    const Text(
                      'In Your Private Bathroom:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
                    const Text(
                      'Facilities:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
          const Text(
            'Smoking:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'No Smoking',
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
