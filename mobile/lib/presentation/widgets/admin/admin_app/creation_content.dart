import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_app/hotel_form.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_app/restaurant_form.dart';

class CreationContent extends StatelessWidget {
  const CreationContent({super.key});

  void _navigateToHotelForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HotelFormScreen()),
    );
  }

  void _navigateToRestaurantForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RestaurantFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 150),
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: [
                SelectionCard(
                  title: 'Create Hotel',
                  icon: Icons.hotel,
                  color: Colors.blue,
                  onPressed: () {
                    _navigateToHotelForm(context);
                  },
                ),
                const SizedBox(height: 16),
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
      elevation: 0, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color), 
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
