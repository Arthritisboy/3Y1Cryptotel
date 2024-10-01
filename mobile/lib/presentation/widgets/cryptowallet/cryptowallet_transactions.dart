import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/tab_screen.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptonotransaction.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptowithtransaction.dart';

class CryptoWalletTransactions extends StatelessWidget {
  final bool hasTransactions;

  const CryptoWalletTransactions({super.key, this.hasTransactions = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0), // Only top-left corner
                topRight: Radius.circular(40.0), // Only top-right corner
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: hasTransactions
                ? const CryptoWithTransaction()
                : const CryptoNoTransaction(),
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TabScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
