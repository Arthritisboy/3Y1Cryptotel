import 'package:flutter/material.dart';

class TabHeader extends StatefulWidget {
  final String firstName;
  final String lastName;
  final ValueChanged<String> onSearchChanged;

  const TabHeader({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.onSearchChanged,
  });

  @override
  State<TabHeader> createState() => _TabHeaderState();
}

class _TabHeaderState extends State<TabHeader> {
  List<String> suggestions = [
    'The Monarch Hotel',
    'Star Plaze Hotel',
    'Matutina’s',
    'Dagupeña',
    'Lenox Hotel',
  ];
  List<String> filteredSuggestions = [];

  void filterSearchResults(String query) {
    setState(() {
      filteredSuggestions = query.isEmpty
          ? []
          : suggestions
              .where(
                  (hotel) => hotel.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/others/cryptotelLogo.png',
                width: 56.0,
                height: 53.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10.0),
            ],
          ),
          const SizedBox(height: 5.0),
          const Text(
            "Where would you",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
          Text(
            "Like to Travel, ${widget.firstName}",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              _buildSearchField(),
              if (filteredSuggestions.isNotEmpty) _buildSuggestionsList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        onChanged: (query) {
          widget.onSearchChanged(query);
          filterSearchResults(query); // Filter suggestions
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          hintText: 'Search',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Positioned(
      top: 60, // Aligns suggestions under the search field
      left: 0,
      right: 0,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredSuggestions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(filteredSuggestions[index]),
              onTap: () {
                setState(() {
                  filteredSuggestions = []; // Clear suggestions on tap
                });
              },
            );
          },
        ),
      ),
    );
  }
}
