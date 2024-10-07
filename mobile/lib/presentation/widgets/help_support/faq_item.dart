import 'package:flutter/material.dart';

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;

  const FAQItem({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onExpansionChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(
        isExpanded ? Icons.remove : Icons.add,
      ),
      onExpansionChanged: onExpansionChanged,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            answer,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
