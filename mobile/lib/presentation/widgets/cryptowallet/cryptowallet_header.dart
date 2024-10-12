import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

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

  // Define the custom network for Sepolia
  final customNetwork = ReownAppKitModalNetworkInfo(
    name: 'Sepolia',
    chainId: '11155111', // Sepolia chain ID
    currency: 'ETH',
    rpcUrl: 'https://rpc.sepolia.org/', // Sepolia RPC URL
    explorerUrl: 'https://sepolia.etherscan.io/', // Explorer URL for Sepolia
    isTestNetwork: true, // Set to true for test networks
  );

  @override
  void initState() {
    super.initState();
    // Add the custom Sepolia network to the supported networks
    ReownAppKitModalNetworks.addNetworks('eip155', [customNetwork]);
    initializeAppKitModal();
  }

  void initializeAppKitModal() async {
    appKitModal = ReownAppKitModal(
      context: context,
      projectId:
          '40e5897bd6b0d9d2b27b717ec50906c3', // Replace with your actual project ID
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
      if (appKitModal != null) {
        await appKitModal!.init();
        debugPrint('appKitModal initialized successfully.');

        // Check if session is available
        if (appKitModal!.session != null) {
          debugPrint(
              'Current wallet address: ${appKitModal!.session!.address}');
          updateWalletAddress();
        } else {
          debugPrint('Session is null after initialization.');
        }
      } else {
        debugPrint('appKitModal is null, skipping initialization.');
      }
    } catch (e) {
      debugPrint('Error during appKitModal initialization: $e');
    }

    appKitModal?.addListener(() {
      updateWalletAddress();
    });

    setState(() {});
  }

  void updateWalletAddress() {
    setState(() {
      if (appKitModal?.session != null) {
        walletAddress = appKitModal!.session!.address ?? 'No Address';
        _balance = appKitModal!.balanceNotifier.value.isEmpty
            ? '0'
            : appKitModal!.balanceNotifier.value; // Use the balance
      } else {
        walletAddress = 'No Address';
        _balance = '0';
      }
      widget.onWalletUpdated(walletAddress, _balance, appKitModal!.isConnected);
      debugPrint('Wallet address updated: $walletAddress');
      debugPrint('Balance updated: $_balance');
    });
  }

  void connectWallet() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      await appKitModal!.openModalView();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to connect wallet.')));
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  void disconnectWallet() {
    appKitModal?.disconnect();
    updateWalletAddress(); // Update to reflect disconnection
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  fontFamily: 'HammerSmith',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C3473),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (walletAddress == 'No Address') {
                          connectWallet();
                        } else {
                          disconnectWallet();
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator() // Show loading indicator while connecting
                    : Text(walletAddress == 'No Address'
                        ? 'Connect Wallet'
                        : 'Disconnect'),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Current Balance",
                style: TextStyle(
                  fontFamily: 'HammerSmith',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/others/bitcoin.png',
                width: 70.0,
                height: 70.0,
                fit: BoxFit.cover,
              ),
            ],
          ),
          const SizedBox(height: 2.0),
          Text(
            _balance,
            style: const TextStyle(
              fontFamily: 'HammerSmith',
              fontSize: 40,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
