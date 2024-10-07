import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  @override
  _HelpSupportScreenState createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, String>> faqItems = [
    {
      'question': 'What is Cryptotel?',
      'answer':
          'Cryptotel is a hotel and restaurant booking system with a crypto payment option.'
    },
    {
      'question': 'Why choose Cryptotel?',
      'answer':
          'Cryptotel offers secure and fast payments using cryptocurrency, ensuring privacy and efficiency.'
    },
    {
      'question': 'What is your refund policy?',
      'answer':
          'Refunds are processed within 5-7 business days after your cancellation is confirmed.'
    },
    {
      'question': 'How does your payment work?',
      'answer':
          'We accept cryptocurrency payments and ensure that they are processed securely using blockchain technology.'
    },
    {
      'question': 'Can I modify or cancel my booking?',
      'answer':
          'Yes, bookings can be modified or cancelled from your account settings before the reservation date.'
    },
    {
      'question': 'Can I get a refund?',
      'answer':
          'Refunds are available if you cancel before the cancellation deadline mentioned in your booking.'
    },
    {
      'question': 'How do I make a booking through the app?',
      'answer':
          'You can book a hotel or restaurant through the app by selecting your desired dates and completing the payment process.'
    },
    {
      'question': 'How do I leave a review after my stay or meal?',
      'answer':
          'Once your booking is completed, you can leave a review through your booking history in the app.'
    },
  ];

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

  Future<void> sendEmail(String message) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'cryptotel002@gmail.com',
      queryParameters: {
        'subject': 'Help & Support',
        'body': message,
      },
    );

    // Use externalApplication mode to open Gmail or default mail app
    await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
  }

  void showMessageDialog() {
    TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Message',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text("To: cryptotel002@gmail.com"),
                SizedBox(height: 10),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Type here...',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 29, 53, 115),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 29, 53, 115),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    ),
                    onPressed: () {
                      sendEmail(messageController.text);
                      Navigator.of(context).pop(); // Close dialog after sending
                    },
                    child: Text("SEND"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 53, 115), // Full screen blue
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
                          return _buildFAQItem(
                            filteredFaqItems[index]['question'] ?? '',
                            false,
                            filteredFaqItems[index]['answer'] ?? '',
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

  Widget _buildFAQItem(String question, bool isExpanded, String answer) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return ExpansionTile(
          title: Text(
            question,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: Icon(
            isExpanded
                ? Icons.remove
                : Icons.add, // Use plus when collapsed and minus when expanded
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              isExpanded = expanded;
            });
          },
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
      },
    );
  }
}
