import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'crypto_navigation.dart'; // Import the new CryptoNavigation file

class CryptowalletHeader extends StatefulWidget {
  final Function(String, String, bool) onWalletUpdated;

  const CryptowalletHeader({
    super.key,
    required this.onWalletUpdated,
  });

  @override
  State<CryptowalletHeader> createState() => _CryptowalletHeaderState();
}

class _CryptowalletHeaderState extends State<CryptowalletHeader> {
  ReownAppKitModal? appKitModal;
  String walletAddress = 'No Address';
  String _balance = '0';
  bool isLoading = false;

  final customNetwork = ReownAppKitModalNetworkInfo(
    name: 'Sepolia',
    chainId: '11155111',
    currency: 'ETH',
    rpcUrl: 'https://rpc.sepolia.org/',
    explorerUrl: 'https://sepolia.etherscan.io/',
    isTestNetwork: true,
  );

  @override
  void initState() {
    super.initState();
    ReownAppKitModalNetworks.addNetworks('eip155', [customNetwork]);
    initializeAppKitModal();
  }

  void initializeAppKitModal() async {
    appKitModal = ReownAppKitModal(
      context: context,
      projectId: '40e5897bd6b0d9d2b27b717ec50906c3',
      metadata: const PairingMetadata(
        name: 'Crypto Flutter',
        description: 'A Crypto Flutter Example App',
        url: 'https://www.reown.com/',
        icons: ['https://reown.com/reown-logo.png'],
        redirect: Redirect(
          native: 'cryptoflutter://',
          universal: 'https://reown.com',
          linkMode: true,
        ),
      ),
    );

    try {
      await appKitModal!.init();
      appKitModal!.addListener(() {
        updateWalletAddress();
      });
      updateWalletAddress();
    } catch (e) {
      debugPrint('Initialization error: $e');
    }
  }

  void updateWalletAddress() {
    setState(() {
      walletAddress = appKitModal?.session?.address ?? 'No Address';
      _balance = appKitModal!.balanceNotifier.value.isEmpty
          ? '0'
          : appKitModal!.balanceNotifier.value;
      widget.onWalletUpdated(walletAddress, _balance, appKitModal!.isConnected);
    });
  }

  void connectWallet() async {
    setState(() {
      isLoading = true;
    });
    try {
      await appKitModal!.openModalView();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect wallet.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void disconnectWallet() {
    appKitModal?.disconnect();
    updateWalletAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
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
                onPressed: isLoading ? null : () => connectWallet(),
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

          // Wallet Info Section
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
                _balance,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
            ],
          ),

          // Payment Navigation Section
          const SizedBox(height: 20.0),
          const CryptoNavigation(), // Use the imported widget here
        ],
      ),
    );
  }
}
