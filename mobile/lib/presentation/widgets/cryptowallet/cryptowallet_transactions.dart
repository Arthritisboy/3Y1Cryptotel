import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptowithtransaction.dart';

class CryptoWalletTransactions extends StatelessWidget {
  final bool isConnected;
  final String walletAddress;
  final String balance;
  final Function(String, String, bool) onWalletUpdated;

  const CryptoWalletTransactions({
    super.key,
    required this.isConnected,
    required this.walletAddress,
    required this.balance,
    required this.onWalletUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            border:
                Border.all(color: const Color.fromARGB(255, 209, 207, 207))),
        child: CryptoWithTransaction(
          isConnected: isConnected,
          walletAddress: walletAddress,
          balance: balance,
          onWalletUpdated: onWalletUpdated,
        ),
      ),
    );
  }
}
