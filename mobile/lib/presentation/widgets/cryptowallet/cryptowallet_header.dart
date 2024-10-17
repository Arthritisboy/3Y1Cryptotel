import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

class CryptowalletHeader extends StatefulWidget {
  final Function onWalletUpdated; // Callback for wallet updates
  final String receiver; // Receiver address
  final String amount; // Transaction amount

  // Constructor with required parameters
  const CryptowalletHeader({
    Key? key,
    required this.onWalletUpdated,
    required this.receiver,
    required this.amount,
  }) : super(key: key);

  @override
  State<CryptowalletHeader> createState() => _CryptowalletHeaderState();
  // Public method to trigger transaction
  Future<void> triggerSendTransaction(BuildContext context) async {
    final state = context.findAncestorStateOfType<_CryptowalletHeaderState>();
    if (state != null) {
      debugPrint('trigger');
      await state.handleSendTransaction(); // Call the private method
    } else {
      debugPrint('nah');
    }
  }
}

class _CryptowalletHeaderState extends State<CryptowalletHeader> {
  ReownAppKitModal? _appKitModal;
  String walletAddress = 'No Address';
  String _balance = '0';
  bool isLoading = false;

  // Method to handle button press
  Future<void> handleSendTransaction() async {
    String receiverAddress = widget.receiver; // Get the receiver address
    String amountToSend = widget.amount;       // Get the amount to send

    try {
      debugPrint('handleSendTransaction: $amountToSend and $amountToSend');
      // await sendTransaction(receiverAddress, amountToSend); // Pass the parameters
    } catch (e) {
      debugPrint('Error in transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction error: $e')),
      );
    }
  }

  final customNetwork = ReownAppKitModalNetworkInfo(
    name: 'Sepolia',
    chainId: '11155111',
    currency: 'ETH',
    rpcUrl: 'https://rpc.sepolia.org/',
    explorerUrl: 'https://sepolia.etherscan.io/',
    isTestNetwork: true,
  );

  final Set<String> featuredWalletIds = {
    'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96', // MetaMask
    '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0', // Trust Wallet
    'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa', // Coinbase Wallet
    // Add other featured wallets if necessary
  };

  @override
  void initState() {
    super.initState();
    ReownAppKitModalNetworks.addNetworks('eip155', [customNetwork]);
    initializeAppKitModal();
  }

  void initializeAppKitModal() async {
    _appKitModal = ReownAppKitModal(
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
      featuredWalletIds: featuredWalletIds,
    );

    try {
      if (_appKitModal != null) {
        await _appKitModal!.init();
        debugPrint('appKitModal initialized successfully.');

        // Check if session is available
        if (_appKitModal!.session != null) {
          debugPrint(
              'Current wallet address: ${_appKitModal!.session!.address}');
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

    // Add listeners to handle session changes
    _appKitModal?.addListener(() {
      updateWalletAddress();
    });

    setState(() {});
  }

  void updateWalletAddress() {
    if (!mounted) return; // Exit early if the widget is not mounted

    setState(() {
      if (_appKitModal?.session != null) {
        walletAddress = _appKitModal!.session!.address ?? 'No Address';
        _balance = _appKitModal!.balanceNotifier.value.isEmpty
            ? '0'
            : _appKitModal!.balanceNotifier.value;
        widget.onWalletUpdated(
            walletAddress, _balance, true); // Notify parent widget
      } else {
        walletAddress = 'No Address';
        _balance = '0';
        widget.onWalletUpdated(
            walletAddress, _balance, false); // Notify parent widget
      }
      debugPrint('Wallet address updated: $walletAddress');
      debugPrint('Balance updated: $_balance');
    });
  }

  void connectWallet() async {
    setState(() {
      isLoading = true;
    });

    // Check if _appKitModal is not null
    if (_appKitModal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Wallet connection modal is not available.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Open the modal view
      await _appKitModal!.openModalView(ReownAppKitModalAllWalletsPage());
      print('Modal opened successfully.');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect wallet: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void disconnectWallet() {
    _appKitModal?.disconnect();
    updateWalletAddress(); // Update address after disconnecting
  }

  // Future<void> sendTransaction(String receiverAddress, String amountToSend) async {
    

  //   // Validate receiver and amount
  //   if (receiver.isEmpty || amount.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Invalid receiver address or amount!')),
  //     );
  //     return;
  //   }

  //   debugPrint(
  //       'Debug Transaction: Testing transaction with receiver: $receiver and amount: $amount');

  //   // Convert amount to Ether
  //   double amountInEther;
  //   try {
  //     amountInEther = double.parse(amount);
  //   } catch (e) {
  //     debugPrint('Debug Transaction: Error parsing amount: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Invalid amount format!')),
  //     );
  //     return;
  //   }
  //   debugPrint('Debug Transaction: Amount in Ether: $amountInEther');

  //   // Convert Ether amount to Wei
  //   BigInt amountInWei = BigInt.from((amountInEther * pow(10, 18)).toInt());
  //   EtherAmount txValue =
  //       EtherAmount.fromUnitAndValue(EtherUnit.wei, amountInWei);
  //   debugPrint('Debug Transaction: Amount in Wei: $amountInWei');

  //   BigInt balanceInWeiValue;

  //   try {
  //     // Get sender address and current balance
  //     final senderAddress = _appKitModal!.session!.address;
  //     debugPrint('Debug Transaction: Sender Address: $senderAddress');

  //     final currentBalance = _appKitModal!.balanceNotifier.value;
  //     debugPrint('Debug Transaction: Current Balance: $currentBalance');

  //     // Check if balance is empty
  //     if (currentBalance.isEmpty) {
  //       throw Exception('Unable to fetch wallet balance.');
  //     }

  //     // Convert current balance to Ether and then to Wei
  //     double balanceInEther = double.parse(currentBalance.split(' ')[0]);
  //     balanceInWeiValue = BigInt.from((balanceInEther * pow(10, 18)).toInt());
  //     debugPrint('Debug Transaction: Balance in Ether: $balanceInEther');
  //   } catch (e) {
  //     debugPrint('Debug Transaction: Error parsing wallet balance: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error fetching balance: $e')),
  //     );
  //     return;
  //   }

  //   // Create EtherAmount for current balance in Wei
  //   final balanceInWei =
  //       EtherAmount.fromUnitAndValue(EtherUnit.wei, balanceInWeiValue);
  //   debugPrint('Debug Transaction: Balance in Wei: $balanceInWei');

  //   // Calculate total cost including transaction fee
  //   final gasPrice = BigInt.from(1000000000); // 1 Gwei
  //   final gasLimit = BigInt.from(200000); // Standard gas limit for ETH transfer
  //   final totalCost =
  //       txValue.getInWei + (gasPrice * gasLimit); // Include gas fees
  //   debugPrint(
  //       'Debug Transaction: Total Cost (including gas fees): $totalCost');

  //   // Check if the balance is sufficient for the transaction
  //   if (balanceInWei.getInWei < totalCost) {
  //     debugPrint(
  //         'Debug Transaction: Insufficient funds for transaction! Balance: ${balanceInWei.getInWei}, Total Cost: $totalCost');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Insufficient funds for transaction!')),
  //     );
  //     return;
  //   }

  //   // Define the contract and its ABI
  //   final tetherContract = DeployedContract(
  //     ContractAbi.fromJson(
  //       jsonEncode([
  //         {
  //           "constant": false,
  //           "inputs": [
  //             {"internalType": "address", "name": "_to", "type": "address"},
  //             {"internalType": "uint256", "name": "_value", "type": "uint256"}
  //           ],
  //           "name": "transfer",
  //           "outputs": [],
  //           "payable": false,
  //           "stateMutability": "nonpayable",
  //           "type": "function"
  //         }
  //       ]),
  //       'ETH',
  //     ),
  //     EthereumAddress.fromHex(receiver),
  //   );

  //   // Send the transaction
  //   try {
  //     if (_appKitModal == null || _appKitModal!.session == null) {
  //       throw Exception('Wallet not connected. Please connect your wallet.');
  //     }

  //     final result = await _appKitModal!.requestWriteContract(
  //       topic: _appKitModal!.session!.topic,
  //       chainId: _appKitModal!.selectedChain!.chainId,
  //       deployedContract: tetherContract,
  //       functionName: 'transfer',
  //       transaction: Transaction(
  //         from: EthereumAddress.fromHex(_appKitModal!.session!.address!),
  //         to: EthereumAddress.fromHex(receiver),
  //         value: txValue,
  //         maxGas: gasLimit.toInt(),
  //       ),
  //       parameters: [
  //         EthereumAddress.fromHex(receiver),
  //         amountInWei, // Amount in Wei
  //       ],
  //     );

  //     debugPrint('Debug Transaction: Transaction request result: $result');

  //     // Handle result
  //     if (result != null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Transaction successful!')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Transaction failed.')),
  //       );
  //     }
  //   } catch (e) {
  //     // Enhanced error handling
  //     debugPrint('Debug Transaction: Transaction error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Transaction error: $e')),
  //     );
  //   }
  // }

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
