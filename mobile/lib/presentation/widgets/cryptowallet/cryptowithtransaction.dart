import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/tab_screen.dart';
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
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  ReownAppKitModal? appKitModal;
  bool isLoading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    print('Initializing CryptoWithTransaction widget...');
    _fetchUserId();
    initializeAppKitModal();
  }

  Future<void> _fetchUserId() async {
    userId = await _storage.read(key: 'userId');
    if (userId != null) {
      BlocProvider.of<BookingBloc>(context).add(FetchBookings(userId: userId!));
    } else {}
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
    print('AppKitModal initialized successfully.');
  }

  void _showSendDialog(BuildContext context, String hotelName) {
    final addressController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Send Crypto to $hotelName'),
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

                print('Sending $amount ETH to $recipient');
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
    setState(() => isLoading = true);

    try {
      double amountInEther = double.parse(amountString);
      BigInt amountInWei = BigInt.from((amountInEther * pow(10, 18)).toInt());

      print('Sending $amountInEther ETH to $receiver');
      // Simulate transaction
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction successful!')),
      );
    } catch (e) {
      print('Error during transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction failed: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        print('Current Bloc State: $state');
        if (state is BookingLoading) {
          print('Loading bookings...');
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookingFailure) {
          print('Error: ${state.error}');
          return Center(child: Text('Error: ${state.error}'));
        } else if (state is BookingSuccess) {
          // Filter accepted bookings only
          final acceptedBookings = state.bookings
              .where((booking) => booking.status?.toLowerCase() == 'accepted')
              .toList();
          print('Fetched ${acceptedBookings.length} accepted bookings.');

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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TabScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C3473),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("Book Now"),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: acceptedBookings.length,
            itemBuilder: (context, index) {
              final booking = acceptedBookings[index];
              print('Displaying booking: ${booking.hotelName}');

              return Card(
                margin: const EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.hotelName != null
                            ? 'Hotel: ${booking.hotelName}'
                            : 'Restaurant: ${booking.restaurantName ?? ''}',
                      ),
                      const SizedBox(height: 8),
                      Text(booking.hotelName != null
                          ? 'Room: ${booking.roomName ?? 'N/A'}'
                          : 'Table Number: ${booking.tableNumber ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      Text(
                          'Check-in: ${booking.checkInDate} at ${booking.timeOfArrival}'),
                      Text(
                          'Check-out: ${booking.checkOutDate} at ${booking.timeOfDeparture}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _showSendDialog(
                                context, booking.hotelName ?? ''),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C3473),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Send Crypto'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No bookings found.'));
        }
      },
    );
  }
}
