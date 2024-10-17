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
  String receiver = '';
  String amount = '';

  late CryptowalletHeader walletHeader;
  @override
  void initState() {
    super.initState();

    // Initialize walletHeader here
    walletHeader = CryptowalletHeader(
      onWalletUpdated: (address, bal, connected) {
        updateWalletInfo(address, bal, connected);
      },
      receiver: receiver, // Default receiver
      amount: amount,     // Default amount
    );
  }
  // Update the wallet info and include receiver and amount
  void updateWalletInfo(String address, String bal, bool connected,
      {String? newReceiver, String? newAmount}) {
    setState(() {
      walletAddress = address;
      balance = bal;
      isConnected = connected;
      if (newReceiver != null) {
        receiver = newReceiver;
      }
      if (newAmount != null) {
        amount = newAmount;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CryptowalletHeader(
              onWalletUpdated: (address, bal, connected) {
                updateWalletInfo(address, bal, connected);
              },
              receiver: receiver, // Pass receiver to the header 
              amount: amount, // Pass amount to the header
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CryptoWalletTransactions(
                isConnected: isConnected,
                walletAddress: walletAddress,
                balance: balance,
                walletHeader: walletHeader, 
                onWalletUpdated:(address, bal, connected, newReceiver, newAmount) {
                  updateWalletInfo(address, bal, connected,
                      newReceiver: newReceiver, newAmount: newAmount);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
