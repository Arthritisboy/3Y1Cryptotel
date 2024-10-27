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
    // Reverse the transaction list to show the latest first
    List<dynamic> reversedTransactions = transactions.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: reversedTransactions.length,
          itemBuilder: (context, index) {
            final tx = reversedTransactions[index];
            bool isSent =
                tx['from'].toLowerCase() == walletAddress.toLowerCase();
            String transactionType = isSent ? 'Sent' : 'Received';

            // Convert value from wei to ether
            double valueInEther = double.parse(tx['value']) / pow(10, 18);

            // Extract the timestamp and convert it to DateTime
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                int.parse(tx['timeStamp']) * 1000);
            String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(dateTime); // Format date

            // Function to shorten addresses and tx hash
            String shorten(String input) =>
                '${input.substring(0, 6)}...${input.substring(input.length - 4)}';

            // Check if the transaction involves a token
            bool isTokenTransfer = tx['to'].toLowerCase() !=
                '0x0000000000000000000000000000000000000000'; // Example condition

            String tokenName = isTokenTransfer
                ? (tx['tokenName'] ??
                    'Unknown Token') // Fetch token name if available
                : 'Ether';
            String tokenSymbol = isTokenTransfer
                ? (tx['tokenSymbol'] ??
                    'ETH') // Fetch token symbol if available
                : 'ETH';
            String valueDisplay = isTokenTransfer
                ? '${valueInEther.toStringAsFixed(4)} $tokenSymbol'
                : '${valueInEther.toStringAsFixed(4)} ETH';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type: $transactionType'),
                    Text(
                        'Value: $valueDisplay'), // Display value with token info
                    Text('To: ${shorten(tx['to'])}'), // Shortened 'To' address
                    Text(
                        'From: ${shorten(tx['from'])}'), // Shortened 'From' address
                    Text(
                        'Tx Hash: ${shorten(tx['hash'])}'), // Shortened Tx Hash
                    Text('Date: $formattedDate'), // Display the formatted date
                    if (isTokenTransfer) ...[
                      Text(
                          'Token Name: $tokenName'), // Display token name if applicable
                      Text(
                          'Token Symbol: $tokenSymbol'), // Display token symbol if applicable
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
