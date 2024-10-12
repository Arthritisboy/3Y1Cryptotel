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
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
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
            child: CryptoWithTransaction(
              isConnected: isConnected,
              walletAddress: walletAddress,
              balance: balance,
              onWalletUpdated: onWalletUpdated,
            ),
          ),
        ],
      ),
    );
  }
}
