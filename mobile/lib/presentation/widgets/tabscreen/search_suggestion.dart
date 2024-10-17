import 'package:flutter/material.dart';

class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final String searchQuery;
  final Function(String) onSelect;
  final Function(String) onRemove;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.searchQuery,
    required this.onSelect,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final filteredSuggestions = suggestions
        .where((hotel) => hotel.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Positioned(
      top: 235,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero, // Remove any padding from the ListView
            shrinkWrap: true,
            itemCount: filteredSuggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.search, color: Colors.grey),
                title: Text(
                  filteredSuggestions[index],
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => onRemove(filteredSuggestions[index]),
                ),
                onTap: () => onSelect(filteredSuggestions[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
