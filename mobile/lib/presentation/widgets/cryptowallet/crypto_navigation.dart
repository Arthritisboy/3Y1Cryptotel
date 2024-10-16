import 'package:flutter/material.dart';

class CryptoNavigation extends StatefulWidget {
  const CryptoNavigation({super.key});

  @override
  _CryptoNavigationState createState() => _CryptoNavigationState();
}

class _CryptoNavigationState extends State<CryptoNavigation> {
  int _activeIndex = 0;

  void _setActiveIndex(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.payment,
              label: 'Payment',
              onTap: () => _setActiveIndex(0),
            ),
            const SizedBox(width: 8.0),
            _buildNavItem(
              index: 1,
              icon: Icons.history,
              label: 'History',
              onTap: () => _setActiveIndex(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isActive = index == _activeIndex;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1C3473) : Colors.transparent,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.0,
              color: isActive ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
