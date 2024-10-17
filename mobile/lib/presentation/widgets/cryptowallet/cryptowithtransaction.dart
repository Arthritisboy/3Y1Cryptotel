import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'cryptowallet_header.dart';

class CryptoWithTransaction extends StatefulWidget {
  final bool isConnected;
  final String walletAddress;
  final String balance;
  final CryptowalletHeader walletHeader;
  final Function(String, String, bool, String?, String?) onWalletUpdated;
  

  const CryptoWithTransaction({
    super.key,
    required this.isConnected,
    required this.walletAddress,
    required this.balance,
    required this.onWalletUpdated,
    required this.walletHeader,
  });

  @override
  State<CryptoWithTransaction> createState() => _CryptoWithTransactionState();
}

class _CryptoWithTransactionState extends State<CryptoWithTransaction> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool isLoading = false;
  String? userId;
  // Use default values here
  final String receiver = '0xc818CfdA6B36b5569E6e681277b2866956863fAd';
  final String amount = '0.001'; // Default amount

  ReownAppKitModal? _appKitModal;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    userId = await _storage.read(key: 'userId');
    if (userId != null) {
      BlocProvider.of<BookingBloc>(context).add(FetchBookings(userId: userId!));
    }
  }
  
  void testTransaction(BuildContext context) async {
    if (widget.isConnected) {
      // Use the default amount and receiver

      debugPrint(
          'Wallet Address: ${widget.walletAddress}, Balance: ${widget.balance}');

      String amountToSend = amount; // Default amount
      String receiverAddress = receiver; // Default receiver

      try {
        await widget.walletHeader.triggerSendTransaction(context);
      } catch (e) {
        debugPrint('Error in transaction: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction error: $e')),
        );
      }
    } else {
      debugPrint('No wallet connected or session is invalid.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please connect your wallet first.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the wallet is connected
    if (!widget.isConnected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No wallet connected or session is invalid.",
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can add logic to connect the wallet or navigate to a wallet connection screen
              },
              child: const Text("Connect Wallet"),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookingFailure) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state is BookingSuccess) {
          // Filter accepted bookings only
          final acceptedBookings = state.bookings
              .where((booking) => booking.status?.toLowerCase() == 'accepted')
              .toList();

          if (acceptedBookings.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/others/wallet.jpg',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  "No transaction, yet!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: const Text(
                    "Make a booking with CRYPTOTEL & Enjoy your stay",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      testTransaction(context), // Call testTransaction
                  child: const Text("Test Transaction"), // Update button text
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: acceptedBookings.length,
            itemBuilder: (context, index) {
              final booking = acceptedBookings[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    'Booking ID: ${booking.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${booking.status}'),
                      Text('Total Price: ${booking.totalPrice}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => testTransaction(context),
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('No bookings available.'));
      },
    );
  }
}
