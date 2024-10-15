import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptowallet_header.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptowallet_transactions.dart';

class CryptoWallet extends StatefulWidget {
  const CryptoWallet({super.key});

  @override
  State<CryptoWallet> createState() => _CryptoWalletState();
}

class _CryptoWalletState extends State<CryptoWallet> {
  String walletAddress = 'No Address';
  String balance = '₱ 0';
  bool isConnected = false;

  void updateWalletInfo(String address, String bal, bool connected) {
    setState(() {
      walletAddress = address;
      balance = bal;
      isConnected = connected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CryptowalletHeader(
              onWalletUpdated: updateWalletInfo,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CryptoWalletTransactions(
                isConnected: isConnected,
                walletAddress: walletAddress,
                balance: balance,
                onWalletUpdated: updateWalletInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
