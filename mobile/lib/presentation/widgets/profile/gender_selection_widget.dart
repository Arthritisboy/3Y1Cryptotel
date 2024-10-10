import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/profile/gender_option.dart';

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
            onTap: () => onGenderChanged("male"), // Lowercase values
            child: GenderOption(
              label: 'Male', // Display label with capitalized letter
              isSelected: gender.toLowerCase() == "male", // Compare lowercase
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => onGenderChanged("female"), // Lowercase values
            child: GenderOption(
              label: 'Female', // Display label with capitalized letter
              isSelected: gender.toLowerCase() == "female", // Compare lowercase
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => onGenderChanged("other"), // Handle "other"
            child: GenderOption(
              label: 'Other', // Display label with capitalized letter
              isSelected: gender.toLowerCase() == "other", // Compare lowercase
            ),
          ),
        ),
      ],
    );
  }
}
