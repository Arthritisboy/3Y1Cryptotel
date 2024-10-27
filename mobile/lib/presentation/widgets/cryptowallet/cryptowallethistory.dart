import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class Cryptowallethistory extends StatelessWidget {
  final List<dynamic> transactions;
  final String walletAddress;

  const Cryptowallethistory({
    Key? key,
    required this.transactions,
    required this.walletAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> reversedTransactions = transactions.reversed.toList();

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          border: Border.all(color: const Color.fromARGB(255, 209, 207, 207)),
        ),
        child: reversedTransactions.isNotEmpty
            ? ListView.builder(
                itemCount: reversedTransactions.length,
                itemBuilder: (context, index) {
                  final tx = reversedTransactions[index];
                  bool isSent =
                      tx['from'].toLowerCase() == walletAddress.toLowerCase();
                  String transactionType = isSent ? 'Sent' : 'Received';

                  double valueInEther = double.parse(tx['value']) / pow(10, 18);

                  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(tx['timeStamp']) * 1000);
                  String formattedDate =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

                  String shorten(String input) =>
                      '${input.substring(0, 6)}...${input.substring(input.length - 4)}';

                  bool isTokenTransfer = tx['to'].toLowerCase() !=
                      '0x0000000000000000000000000000000000000000';

                  String tokenName = isTokenTransfer
                      ? (tx['tokenName'] ?? 'Unknown Token')
                      : 'Ether';
                  String tokenSymbol =
                      isTokenTransfer ? (tx['tokenSymbol'] ?? 'ETH') : 'ETH';
                  String valueDisplay = isTokenTransfer
                      ? '${valueInEther.toStringAsFixed(4)} $tokenSymbol'
                      : '${valueInEther.toStringAsFixed(4)} ETH';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: isSent
                                      ? Colors.redAccent
                                      : Colors.greenAccent,
                                  child: Icon(
                                    isSent
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Type: $transactionType',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        valueDisplay,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow(Icons.calendar_today, formattedDate),
                            _buildInfoRow(
                                Icons.person, 'To: ${shorten(tx['to'])}'),
                            _buildInfoRow(
                                Icons.person, 'From: ${shorten(tx['from'])}'),
                            _buildInfoRow(Icons.vpn_key,
                                'Tx Hash: ${shorten(tx['hash'])}'),
                            if (isTokenTransfer) ...[
                              _buildInfoRow(
                                Icons.token,
                                'Token: $tokenName ($tokenSymbol)',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : _buildEmptyState(context),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/icons/placeholder.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Transactions Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your transaction history will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C3473),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
