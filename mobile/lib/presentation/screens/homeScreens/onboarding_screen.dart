import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OnboardingScreenState();
  }
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    'assets/images/onboarding/user_guide_1.jpg',
    'assets/images/onboarding/user_guide_2.jpg',
    'assets/images/onboarding/user_guide_3.jpg',
    'assets/images/onboarding/user_guide_4.png',
  ];

  final List<String> _descriptions = [
    'Welcome to Cryptotel, your destination for luxury stays and fine dining. We offer you the ease of booking rooms and restaurant reservations using cryptocurrencies while you relax in style.',
    'To book a room, select your preferred room type, choose your check-in and check-out dates, and enter the number of guests. Review your booking details carefully before moving on to the payment step.',
    'Reserving a table is simple. Start by selecting your preferred date and time, then indicate the number of guests. Confirm all the details before proceeding to payment to finalize your reservation.',
    'When paying with cryptocurrency, select the "Crypto Payment" option at checkout. You’ll be given a unique wallet address. Use your digital wallet to send the exact amount in cryptocurrency, and once the payment is confirmed, you will receive a confirmation of your booking.',
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

      // Listen for the state change to navigate
      context.read<AuthBloc>().stream.listen((state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed('/homescreen');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _descriptions[index],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_images.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentPage
                              ? const Color.fromARGB(255, 29, 53, 115)
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onNextPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 29, 53, 115),
                    ),
                    child: Text(
                      _currentPage == _images.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(color: Colors.white),
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
