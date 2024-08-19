import 'package:flutter/material.dart';
import 'package:hotel_flutter/widgets/custom_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 40.0,
            ),
            child: Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: 'Cryptotel \n',
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.w600,
                      )),
                  TextSpan(
                      text: 'where crypto meets comfort',
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                ],
              ),
            )),
          )),
          Flexible(
            child: Text('Welcome'),
          ),
        ],
      ),
    );
  }
}
