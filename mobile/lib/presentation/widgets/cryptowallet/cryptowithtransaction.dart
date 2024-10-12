import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

class CryptoWithTransaction extends StatefulWidget {
  final bool isConnected;
  final String walletAddress;
  final String balance;
  final Function(String, String, bool) onWalletUpdated;

  const CryptoWithTransaction({
    super.key,
    required this.isConnected,
    required this.walletAddress,
    required this.balance,
    required this.onWalletUpdated,
  });

  @override
  State<CryptoWithTransaction> createState() => _CryptoWithTransactionState();
}

class _CryptoWithTransactionState extends State<CryptoWithTransaction> {
  ReownAppKitModal? appKitModal;
  String _balance = '0';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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

    await appKitModal?.init();
    appKitModal?.addListener(() {
      updateWalletAddress();
    });

    updateWalletAddress();
  }

  void updateWalletAddress() {
    setState(() {
      if (appKitModal?.session != null) {
        widget.onWalletUpdated(
          appKitModal!.session!.address ?? 'No Address',
          appKitModal!.balanceNotifier.value.isEmpty
              ? '₱ 0'
              : appKitModal!.balanceNotifier.value,
          appKitModal!.isConnected,
        );
        _balance = appKitModal!.balanceNotifier.value;
      } else {
        _balance = '₱ 0';
      }
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
                decoration:
                    const InputDecoration(hintText: 'Recipient Address (0x..)'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(hintText: 'Amount to Send'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String recipient = addressController.text;
                String amount = amountController.text;

                Navigator.of(context).pop();
                await sendTransaction(recipient, amount);
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
      debugPrint('Transaction From: $senderAddress, To: $receiver');
      debugPrint('Value: $txValue, Parameters: $amountInWei');

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: widget.isConnected ? () => _showSendDialog(context) : null,
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text('Send Crypto'),
        ),
      ],
    );
  }
}
