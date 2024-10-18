import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/data/repositories/booking_repository.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptowallet_header.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/cryptowallet_transactions.dart';
import 'package:hotel_flutter/presentation/widgets/cryptowallet/wallet_manager.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CryptoWallet extends StatefulWidget {
  const CryptoWallet({super.key});

  @override
  _CryptoWalletState createState() => _CryptoWalletState();
}

class _CryptoWalletState extends State<CryptoWallet> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? userId;

  String walletAddress = 'No Address';
  String balance = '₱ 0';
  ReownAppKitModal? _appKitModal;
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

  final Set<String> featuredWalletIds = {
    'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96', // MetaMask
    '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0', // Trust Wallet
    'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa', // Coinbase Wallet
  };

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    walletAddress = WalletManager().walletAddress;
    balance = WalletManager().balance;

    if (walletAddress != 'No Address') {
      isLoading = false;
    }
    ReownAppKitModalNetworks.addNetworks('eip155', [customNetwork]);
    ReownAppKitModalNetworks.removeNetworks('eip155', [
      '10',
      '100',
      '137',
      '324',
      '1101',
      '5000',
      '8217',
      '42161',
      '42220',
      '43114',
      '59144',
      '7777777',
      '1313161554'
    ]);

    initializeAppKitModal();
  }

  Future<void> _fetchUserId() async {
    userId = await _storage.read(key: 'userId');
    if (userId != null) {
      BlocProvider.of<BookingBloc>(context).add(FetchBookings(userId: userId!));
    }
  }

  void initializeAppKitModal() async {
    _appKitModal = ReownAppKitModal(
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
      }
    } catch (e) {
      debugPrint('Error during appKitModal initialization: $e');
    }

    _appKitModal?.addListener(() {
      updateWalletAddress();
    });

    setState(() {});
  }

  void updateWalletAddress() {
    if (!mounted) return;
    setState(() {
      if (_appKitModal?.session != null) {
        WalletManager().walletAddress =
            _appKitModal!.session!.address ?? 'No Address';
        WalletManager().balance = _appKitModal!.balanceNotifier.value.isEmpty
            ? '₱ 0'
            : _appKitModal!.balanceNotifier.value;
        WalletManager().isConnected = true; // Set connected state
      } else {
        WalletManager().reset(); // Reset wallet info
      }
      debugPrint('Wallet address updated: ${WalletManager().walletAddress}');
      debugPrint('Balance updated: ${WalletManager().balance}');
    });
  }

  Future<void> connectWallet() async {
    // Change here
    setState(() {
      isLoading = true;
    });

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

  Future<void> updateWalletInfo() async {
    connectWallet(); // Call the connectWallet logic
  }

  bool isWalletConnected() {
    return _appKitModal?.session !=
        null; // Assuming this checks if the session exists
  }

  Future<void> sendTransaction(
      String receiver, String amount, BookingModel booking) async {
    if (!isWalletConnected()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please connect your wallet first')),
      );
      return; // Exit the function if not connected
    }
    if (receiver.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid receiver address!')),
      );
      return; // Exit the function if the address is invalid
    }
    debugPrint(
        'Debug Transaction: Testing transaction with receiver: $receiver and amount: $amount');

    // Convert amount to Ether
    double amountInEther = double.parse(amount);
    debugPrint('Debug Transaction: Amount in Ether: $amountInEther');

    // Convert Ether amount to Wei
    BigInt amountInWei = BigInt.from((amountInEther * pow(10, 18)).toInt());
    EtherAmount txValue =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, amountInWei);
    debugPrint('Debug Transaction: Amount in Wei: $amountInWei');

    BigInt balanceInWeiValue;

    try {
      // Get sender address and current balance
      final senderAddress = _appKitModal!.session!.address!;
      debugPrint('Debug Transaction: Sender Address: $senderAddress');

      final currentBalance = _appKitModal!.balanceNotifier.value;
      debugPrint('Debug Transaction: Current Balance: $currentBalance');

      // Check if balance is empty
      if (currentBalance.isEmpty) {
        throw Exception('Unable to fetch wallet balance.');
      }

      // Convert current balance to Ether and then to Wei
      double balanceInEther = double.parse(currentBalance.split(' ')[0]);
      balanceInWeiValue = BigInt.from((balanceInEther * pow(10, 18)).toInt());
      debugPrint('Debug Transaction: Balance in Ether: $balanceInEther');
    } catch (e) {
      debugPrint('Debug Transaction: Error parsing wallet balance: $e');
      throw Exception('Error parsing wallet balance: $e');
    }

    // Create EtherAmount for current balance in Wei
    final balanceInWei =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, balanceInWeiValue);
    debugPrint('Debug Transaction: Balance in Wei: $balanceInWei');

    // Calculate total cost including transaction fee
    final gasPrice = BigInt.from(1000000000); // 1 Gwei
    final gasLimit = BigInt.from(200000); // Standard gas limit for ETH transfer
    final totalCost =
        txValue.getInWei + (gasPrice * gasLimit); // Include gas fees
    debugPrint(
        'Debug Transaction: Total Cost (including gas fees): $totalCost');

    // Check if the balance is sufficient for the transaction
    if (balanceInWei.getInWei < totalCost) {
      debugPrint(
          'Insufficient funds for transaction! Balance: $balanceInWei, Total Cost: $totalCost');

      // Show a snackbar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insufficient funds for transaction!')),
      );

      return; // Exit the function
    }
    _appKitModal!.launchConnectedWallet();
    // Define the contract and its ABI
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

    // Send the transaction
    try {
      final result = await _appKitModal!.requestWriteContract(
        topic: _appKitModal!.session!.topic,
        chainId: _appKitModal!.selectedChain!.chainId,
        deployedContract: tetherContract,
        functionName: 'transfer',
        transaction: Transaction(
          from: EthereumAddress.fromHex(_appKitModal!.session!.address!),
          to: EthereumAddress.fromHex(receiver),
          value: txValue,
          maxGas: gasLimit.toInt(),
        ),
        parameters: [
          EthereumAddress.fromHex(receiver),
          amountInWei, // Amount in Wei
        ],
      );
      debugPrint('Debug Transaction: Transaction request result: $result');

      final updatedBooking = booking.copyWith(status: 'done');

      // Dispatch the UpdateBooking event using Bloc
      BlocProvider.of<BookingBloc>(context).add(
        UpdateBooking(
          bookingId: booking.id!,
          booking: updatedBooking,
          userId: userId!,
        ),
      );
      // _appKitModal!.launchConnectedWallet();
      // Handle result
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction successful!')),
        );

        // // Dispatch the UpdateBooking event using Bloc
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction failed.')),
        );
      }
    } catch (e) {
      // Enhanced error handling
      debugPrint('Debug Transaction: Transaction error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Wallet Header
            CryptoWalletHeader(
              onWalletUpdated: updateWalletInfo,
              walletAddress: WalletManager().walletAddress,
              balance: WalletManager().balance,
              isLoading: isLoading,
            ),
            const SizedBox(height: 20),

            // Expanded widget containing BlocBuilder
            Expanded(
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BookingFailure) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state is BookingSuccess) {
                    // Filter the accepted bookings
                    final acceptedBookings = state.bookings
                        .where((booking) =>
                            booking.status?.toLowerCase() == 'accepted')
                        .toList();

                    // Pass the filtered bookings to the child
                    return CryptoWalletTransactions(
                      isConnected: WalletManager().isConnected,
                      walletAddress: WalletManager().walletAddress,
                      balance: WalletManager().balance,
                      sendTransaction:
                          sendTransaction, // Pass the method to child
                      acceptedBookings: acceptedBookings,
                    );
                  }
                  return const Center(child: Text('No bookings available.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
