import 'package:flutter/material.dart';

class GenderSelection extends StatelessWidget {
  final String gender;
  final ValueChanged<String> onGenderChanged;

  const GenderSelection({
    super.key,
    required this.gender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onGenderChanged("Male"),
            child: GenderOption(
              label: 'Male',
              isSelected: gender == "Male",
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => onGenderChanged("Female"),
            child: GenderOption(
              label: 'Female',
              isSelected: gender == "Female",
            ),
          ),
        ),
      ],
    );
  }
}

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
        color: Colors.white, // Center color
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
              color: Colors.white, // Center color
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
