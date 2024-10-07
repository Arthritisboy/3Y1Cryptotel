import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/faq/faq_data.dart';
import 'package:hotel_flutter/presentation/widgets/help_support/email_dialog.dart';
import 'package:hotel_flutter/presentation/widgets/help_support/faq_item.dart';

class HelpSupportScreen extends StatefulWidget {
  @override
  _HelpSupportScreenState createState() => _HelpSupportScreenState();
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
      backgroundColor: Color.fromARGB(255, 29, 53, 115),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Help & Support',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      "We’re here to help you with anything and everything on CRYPTOTEL",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 8),
                      child: TextField(
                        onChanged: filterFaqItems,
                        decoration: InputDecoration(
                          hintText: 'Search help',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'FAQ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredFaqItems.length,
                        itemBuilder: (context, index) {
                          return FAQItem(
                            question: filteredFaqItems[index]['question'] ?? '',
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Still stuck? Help is a mail away',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: showMessageDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 29, 53, 115),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text('Send a message'),
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
