import 'package:flutter/material.dart';

class CreationContent extends StatelessWidget {
  const CreationContent({super.key});

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
                  // Navigate to Hotel creation form
                  Navigator.pushNamed(context, '/hotelForm');
                },
              ),
              SelectionCard(
                title: 'Create Restaurant',
                icon: Icons.restaurant,
                color: Colors.green,
                onPressed: () {
                  // Navigate to Restaurant creation form
                  Navigator.pushNamed(context, '/restaurantForm');
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
