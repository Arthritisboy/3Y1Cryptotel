import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/faq_data/faq_data.dart';
import 'package:hotel_flutter/presentation/widgets/help_support/email_dialog.dart';
import 'package:hotel_flutter/presentation/widgets/help_support/faq_item.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  List<Map<String, String>> filteredFaqItems = [];

  @override
  void initState() {
    super.initState();
    filteredFaqItems = faqItems;
  }

  void filterFaqItems(String query) {
    setState(() {
      filteredFaqItems = faqItems
          .where((faq) =>
              faq['question']?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    });
  }

  void showMessageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const EmailDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D3573), // Dark blue background
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Help & Support',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "We’re here to help you with anything on CRYPTOTEL.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        onChanged: filterFaqItems,
                        decoration: InputDecoration(
                          hintText: 'Search for help...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    // FAQ Title
                    const Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 10),
                      child: Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // FAQ List
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.builder(
                          itemCount: filteredFaqItems.length,
                          itemBuilder: (context, index) {
                            return FAQItem(
                              question:
                                  filteredFaqItems[index]['question'] ?? '',
                              answer: filteredFaqItems[index]['answer'] ?? '',
                              isExpanded: false,
                              onExpansionChanged: (expanded) {
                                setState(() {
                                  // Handle expansion logic
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Divider(
                        height: 40,
                        thickness: 1,
                        color: const Color.fromARGB(255, 213, 210, 210),
                      ),
                    ),
                    // Footer Section
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 40, top: 0, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Still stuck? Help is just a message away.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: showMessageDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF1D3573), // Button color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5, // Add shadow
                            ),
                            child: const Text(
                              'Send a Message',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
