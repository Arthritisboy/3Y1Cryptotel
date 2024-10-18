import 'package:flutter/material.dart';
import 'crypto_navigation.dart'; // Import the CryptoNavigation widget

class CryptoWalletHeader extends StatelessWidget {
  final VoidCallback onWalletUpdated;
  final String walletAddress;
  final String balance;
  final bool isLoading;

  const CryptoWalletHeader({
    super.key,
    required this.onWalletUpdated,
    required this.walletAddress,
    required this.balance,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/others/cryptotelLogo.png',
                    width: 56.0,
                    height: 53.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'CRYPTOTEL',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C3473),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: isLoading ? null : onWalletUpdated,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C3473),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(walletAddress == 'No Address'
                            ? 'Connect'
                            : 'Disconnect'),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Crypto Wallet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                walletAddress.length > 10
                    ? 'Address: ${walletAddress.substring(0, 6)}...${walletAddress.substring(walletAddress.length - 4)}'
                    : walletAddress,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    balance == '₱ 0'
                        ? balance
                        : '${double.tryParse(balance.split(' ')[0])?.toStringAsFixed(4) ?? '0.0000'} ETH',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20.0),
              // CryptoNavigation Widget Added Below the Address Section
              const CryptoNavigation(),
            ],
          ),
          Positioned(
            top: 90,
            right: 10,
            child: Image.asset(
              'assets/images/icons/bitcoin.png',
              width: 75.0,
              height: 75.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
