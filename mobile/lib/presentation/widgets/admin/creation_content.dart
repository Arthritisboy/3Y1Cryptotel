import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/admin/hotel_form.dart';
import 'package:hotel_flutter/presentation/widgets/admin/restaurant_form.dart';

class CreationContent extends StatelessWidget {
  const CreationContent({super.key});

  // Function to handle "Create Hotel" button press
  void _navigateToHotelForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HotelFormScreen()),
    );
  }

  // Function to handle "Create Restaurant" button press
  void _navigateToRestaurantForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RestaurantFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text Header
        Text(
          "Let's get started!",
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'What are you creating?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),

        // Action-oriented Guide
        Text(
          'Select whether you want to create a hotel or a restaurant. Once you choose, you\'ll be guided step-by-step to set up your establishment and manage its details.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        // Grid of Selection Cards
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              SelectionCard(
                title: 'Create Hotel',
                icon: Icons.hotel,
                color: Colors.blue,
                onPressed: () {
                  _navigateToHotelForm(context);
                },
              ),
              SelectionCard(
                title: 'Create Restaurant',
                icon: Icons.restaurant,
                color: Colors.green,
                onPressed: () {
                  _navigateToRestaurantForm(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const SelectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
