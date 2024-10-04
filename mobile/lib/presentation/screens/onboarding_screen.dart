import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_event.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    'assets/images/onboarding/temp.jpg',
    'assets/images/onboarding/temp.jpg',
    'assets/images/onboarding/temp.jpg',
  ];

  final List<String> _descriptions = [
    'Welcome to Cryptotel! Discover amazing deals!',
    'Find the best hotels and accommodations!',
    'Enjoy your stay and book now!',
  ];

  void _onNextPressed() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // This is the last page, complete onboarding
      context.read<AuthBloc>().add(CompleteOnboardingEvent());
      Navigator.of(context).pushNamed('/homescreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _images[index],
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _descriptions[index],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onNextPressed,
              child: Text(
                _currentPage == _images.length - 1 ? 'Get Started' : 'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
