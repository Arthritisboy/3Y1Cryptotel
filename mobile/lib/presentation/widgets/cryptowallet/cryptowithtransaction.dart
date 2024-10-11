import 'dart:convert';
import 'dart:math'; // Import for pow function

import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:url_launcher/url_launcher.dart';

class CryptoWithTransaction extends StatefulWidget {
  const CryptoWithTransaction({super.key});

   @override
  State<CryptoWithTransaction> createState() => _CryptoWithTransactionState();
}

class _CryptoWithTransactionState extends State<CryptoWithTransaction> {
  ReownAppKitModal? appKitModal;
  String walletAddress = 'No Address';
  String _balance = '0';
  bool isLoading = false; // Add isLoading state variable

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
      debugPrint('Wallet address updated: $walletAddress');
      debugPrint('Balance updated: $_balance');
    });
  }

  void _showSendDialog(BuildContext context) {
    final TextEditingController addressController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Send Crypto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: 'Recipient Address (0x..)',
                ),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  hintText: 'Amount to Send',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String recipient = addressController.text;
                String amount =
                    amountController.text; // Directly pass the string

                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                  print('gumana');
                  final Uri metamaskUri = Uri.parse("metamask://");
                  // Launch the MetaMask URI without checking
                  launchUrl(metamaskUri, mode: LaunchMode.externalApplication);
                });

                try {
                  await sendTransaction(recipient, amount); // Pass the string amount here
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendTransaction(String receiver, String amountString) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    // Convert the amountString to double
    double amountInEther;
    try {
      amountInEther = double.parse(amountString);
      debugPrint('Parsed amountString into amountInEther: $amountInEther');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid amount: $e')),
      );
      setState(() {
        isLoading = false; // Hide loader on error
      });
      return; // Exit if parsing fails
    }

    // Convert the amount from double to BigInt in Wei
    BigInt amountInWei = BigInt.from((amountInEther * pow(10, 18)).toInt());
    EtherAmount txValue =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, amountInWei);
    debugPrint('Transaction value in Ether: $txValue');

    final tetherContract = DeployedContract(
      ContractAbi.fromJson(
        jsonEncode([
          {
            "constant": false,
            "inputs": [
              {"internalType": "address", "name": "_to", "type": "address"},
              {"internalType": "uint256", "name": "_value", "type": "uint256"}
            ],
            "name": "transfer",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          }
        ]),
        'ETH',
      ),
      EthereumAddress.fromHex(receiver),
    );

    try {
      final senderAddress = appKitModal!.session!.address!;
      debugPrint('Sender Address: $senderAddress');

      final currentBalance = appKitModal!.balanceNotifier.value;
      debugPrint('Current Balance: $currentBalance');

      if (currentBalance.isEmpty) {
        throw Exception('Unable to fetch wallet balance.');
      }

      // Convert balance to BigInt
      BigInt balanceInWeiValue;
      try {
        double balanceInEther = double.parse(currentBalance.split(' ')[0]);
        balanceInWeiValue = BigInt.from((balanceInEther * pow(10, 18)).toInt());
        debugPrint('Balance in Ether: $balanceInEther');
        debugPrint('Balance in Wei Value: $balanceInWeiValue');
      } catch (e) {
        debugPrint('Error parsing wallet balance: $e');
        throw Exception('Error parsing wallet balance: $e');
      }

      final balanceInWei =
          EtherAmount.fromUnitAndValue(EtherUnit.wei, balanceInWeiValue);
      debugPrint('Balance in Wei: $balanceInWei');

      // Calculate total cost including transaction fee (adjust the gas fee as needed)
      final gasPrice = BigInt.from(1000000000); // 1 Gwei
      final gasLimit =
          BigInt.from(200000); // Standard gas limit for ETH transfer
      final totalCost =
          txValue.getInWei + (gasPrice * gasLimit); // Include gas fees

      debugPrint('Gas Price (in Wei): $gasPrice');
      debugPrint('Gas Limit: $gasLimit');
      debugPrint('Total Cost in Wei: $totalCost');

      if (balanceInWei.getInWei < totalCost) {
        throw Exception(
            'Insufficient funds for transaction! Balance: ${balanceInWei.getInWei}, Total Cost: $totalCost');
      }

      debugPrint('Sending transaction to $receiver with value $txValue');
      debugPrint(
          'Requesting write contract with topic: ${appKitModal!.session!.topic}');
      debugPrint('Chain ID: ${appKitModal!.selectedChain!.chainId}');
      debugPrint('Function Name: transfer');
      debugPrint('Transaction From: ${senderAddress}, To: $receiver');
      debugPrint('Value: $txValue, Parameters: ${amountInWei}');

      final result = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: appKitModal!.selectedChain!.chainId,
        deployedContract: tetherContract,
        functionName: 'transfer',
        transaction: Transaction(
          from: EthereumAddress.fromHex(senderAddress),
          to: EthereumAddress.fromHex(receiver),
          value: txValue, // Ensure txValue is EtherAmount
          maxGas: gasLimit.toInt(),
        ),
        parameters: [
          EthereumAddress.fromHex(receiver),
          amountInWei, // Pass the BigInt value directly
        ],
      );

      debugPrint('Transaction result: $result');

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction failed.')),
        );
      }
    } catch (e) {
      debugPrint('Error during send transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during transaction: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loader on finish
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Home Page'),
      ),
      body: appKitModal == null
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Show loading indicator until appKitModal is initialized
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Wallet Address: $walletAddress',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  'Balance: $_balance',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 20),
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
                        _showSendDialog(context); // Call the new dialog method
                      },
                    ),
                  ],
                ),
                if (isLoading)
                  const CircularProgressIndicator(), // Show loader if isLoading is true
              ],
            ),
    );
  }
  Widget _buildSimpleButton(BuildContext context, String label,
      {Color color = Colors.blue, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label),
    );
  }
}