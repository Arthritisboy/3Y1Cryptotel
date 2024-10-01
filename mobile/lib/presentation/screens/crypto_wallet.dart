import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptowallet_header.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptowallet_transactions.dart';
import 'package:hotel_flutter/presentation/widgets/drawer/main_drawer.dart'; // Import your MainDrawer

class CryptoWallet extends StatefulWidget {
  const CryptoWallet({super.key});

  @override
  State<CryptoWallet> createState() => _CryptoWalletState();
}

class _CryptoWalletState extends State<CryptoWallet> {
  void _selectScreen(String identifier) {
    Navigator.of(context).pop();
    print('Selected screen: $identifier');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(onSelectScreen: _selectScreen),
      body: const Column(
        children: [
          const CryptowalletHeader(),
          const SizedBox(height: 20),
          const CryptoWalletTransactions(),
        ],
      ),
    );
  }
}
