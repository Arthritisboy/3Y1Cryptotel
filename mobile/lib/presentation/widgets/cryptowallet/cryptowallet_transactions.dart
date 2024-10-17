import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptowithtransaction.dart';

class CryptoWalletTransactions extends StatelessWidget {
  final bool isConnected;
  final String walletAddress;
  final String balance;
  final Future<void> Function(String, String) sendTransaction; 

  const CryptoWalletTransactions({
    super.key,
    required this.isConnected,
    required this.walletAddress,
    required this.balance,
    required this.sendTransaction, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        border: Border.all(color: const Color.fromARGB(255, 209, 207, 207)),
      ),
      child: CryptoWithTransaction(
        isConnected: isConnected,
        walletAddress: walletAddress,
        balance: balance,
        sendTransaction: sendTransaction, // Pass the method to child
      ),
    );
  }
}
