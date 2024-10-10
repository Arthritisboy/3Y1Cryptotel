import 'package:flutter/material.dart';

class GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;

  const GenderOption({
    super.key,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color:
              isSelected ? const Color.fromARGB(255, 29, 53, 115) : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: isSelected
                    ? const Color.fromARGB(255, 29, 53, 115)
                    : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
