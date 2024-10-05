import 'package:flutter/material.dart';

class UserGuideScreen extends StatefulWidget {
  const UserGuideScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _UserGuideScreenState();
  }
}

class _UserGuideScreenState extends State<UserGuideScreen> {
  final List<String> images = [
    'assets/images/onboarding/user_guide_1.jpg',
    'assets/images/onboarding/user_guide_2.jpg',
    'assets/images/onboarding/user_guide_3.jpg',
    'assets/images/onboarding/user_guide_4.png',
  ];
  final List<String> messages = [
    'Welcome to Cryptotel, your destination for luxury stays and fine dining. We offer you the ease of booking rooms and restaurant reservations using cryptocurrencies while you relax in style.',
    'To book a room, select your preferred room type, choose your check-in and check-out dates, and enter the number of guests. Review your booking details carefully before moving on to the payment step.',
    'Reserving a table is simple. Start by selecting your preferred date and time, then indicate the number of guests. Confirm all the details before proceeding to payment to finalize your reservation.',
    'When paying with cryptocurrency, select the "Crypto Payment" option at checkout. You’ll be given a unique wallet address. Use your digital wallet to send the exact amount in cryptocurrency, and once the payment is confirmed, you will receive a confirmation of your booking.',
  ];
  int _currentIndex = 0;

  void _nextSlide() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % images.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Image.asset(
                    images[_currentIndex],
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    messages[_currentIndex],
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentIndex
                              ? const Color.fromARGB(255, 29, 53, 115)
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _nextSlide,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 29, 53, 115),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                'CRYPTOTEL',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 29, 53, 115),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
