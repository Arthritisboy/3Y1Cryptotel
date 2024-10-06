import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

class CryptoWallet extends StatefulWidget {
  const CryptoWallet({super.key});

  @override
  State<CryptoWallet> createState() => _CryptoWalletState();
}

class _CryptoWalletState extends State<CryptoWallet> {
  ReownAppKitModal? appKitModal;
  String walletAddress = 'No Address';
  String _balance = '0';

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
      projectId: '40e5897bd6b0d9d2b27b717ec50906c3', // Replace with your actual project ID
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
          // Ensure that the session has the required properties
          if (appKitModal!.session!.chainId != null) {
            debugPrint('Current chain ID: ${appKitModal!.session!.chainId}');
          } else {
            debugPrint('Session chain ID is null.');
          }
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

        // Ensure balanceNotifier has a value before accessing it
        if (appKitModal!.balanceNotifier.value.isEmpty) {
          // Check if balance is empty
          _balance = '0'; // Default value
          debugPrint('Balance is empty, setting to 0.'); // Log empty balance
        } else {
          _balance = appKitModal!.balanceNotifier.value; // Use the balance
        }
      } else {
        walletAddress = 'No Address'; // Set default if session is null
        _balance = '0'; // Set default balance
      }
      debugPrint('Wallet address updated: $walletAddress');
      debugPrint('Balance updated: $_balance');
    });
  }
  
  void _selectScreen(String identifier) {
    Navigator.of(context).pop();
    print('Selected screen: $identifier');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Home Page'),
      ),
      body: appKitModal == null
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator until appKitModal is initialized
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display Wallet Address and Balance Above the Buttons
                Text(
                  'Wallet Address: $walletAddress',
                  style: const TextStyle(
                    color: Colors.black, // Change text color to ensure visibility
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Balance: $_balance', // Show ETH unit
                  style: const TextStyle(
                    color: Colors.black, // Change text color to ensure visibility
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20), // Spacer between text and buttons

                // Row for Wallet Connection and Receive Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSimpleButton(
                      context,
                      appKitModal!.isConnected
                          ? 'Disconnect'
                          : 'Connect Wallet',
                      color:
                          appKitModal!.isConnected ? Colors.red : Colors.green,
                      onPressed: () {
                        if (appKitModal!.isConnected) {
                          appKitModal!.disconnect();
                        } else {
                          appKitModal!.openModalView();
                        }
                      },
                    ),
                    _buildSimpleButton(
                      context,
                      'Send',
                      color: Colors.blue,
                      onPressed: () {
                        // Implement send functionality
                      },
                    ),
                    _buildSimpleButton(
                      context,
                      'Receive',
                      color: Colors.orange,
                      onPressed: () {
                        // Handle the receive button press
                      },
                    ),
                  ],
                ),
                const Spacer(), // Spacer at the bottom
              ],
            ),
    );
  }

  @override
  Widget _buildSimpleButton(BuildContext context, String title,
      {required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
