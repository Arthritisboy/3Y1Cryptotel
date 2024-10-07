import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailDialog extends StatelessWidget {
  const EmailDialog({super.key});

  Future<void> sendEmail(String message) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'cryptotel002@gmail.com',
      queryParameters: {
        'subject': 'Help & Support',
        'body': message,
      },
    );

    await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

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
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
  }
}
