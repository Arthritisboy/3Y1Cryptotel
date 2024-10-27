import 'package:flutter/material.dart';

class CryptoWalletHeader extends StatefulWidget {
  final VoidCallback onWalletUpdated;
  final VoidCallback onViewTransactionHistory;
  final String walletAddress;
  final String balance;
  final String tokenBalance;
  final bool isLoading;

  const CryptoWalletHeader({
    super.key,
    required this.onWalletUpdated,
    required this.onViewTransactionHistory,
    required this.walletAddress,
    required this.balance,
    required this.tokenBalance, // Added to hold token balance
    this.isLoading = false,
  });

  @override
  _CryptoWalletHeaderState createState() => _CryptoWalletHeaderState();
}

class _CryptoWalletHeaderState extends State<CryptoWalletHeader> {
  bool isInPesos = true; // Toggle state for balance display

  void toggleBalanceDisplay() {
    setState(() {
      isInPesos = !isInPesos;
    });
  }

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
                    onPressed: widget.isLoading ? null : widget.onWalletUpdated,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C3473),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: widget.isLoading
                        ? const CircularProgressIndicator()
                        : Text(widget.walletAddress == 'No Address'
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
                widget.walletAddress.length > 10
                    ? 'Address: ${widget.walletAddress.substring(0, 6)}...${widget.walletAddress.substring(widget.walletAddress.length - 4)}'
                    : widget.walletAddress,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    isInPesos
                        ? widget.balance
                        : '${double.tryParse(widget.tokenBalance.split(' ')[0])?.toStringAsFixed(4) ?? '0.0000'} ETH', // Toggle display
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(
                        milliseconds: 300), // Duration for the animation
                    child: IconButton(
                      key:
                          ValueKey<bool>(isInPesos), // Unique key for animation
                      icon: Transform.rotate(
                        angle: isInPesos ? 0 : 0.5, // Rotate based on state
                        child: const Icon(
                          Icons.change_circle,
                          size: 30, // Adjust the size as needed
                        ),
                      ),
                      onPressed: toggleBalanceDisplay,
                      tooltip: isInPesos ? 'Show in Token' : 'Show in Pesos',
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 20.0),
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
