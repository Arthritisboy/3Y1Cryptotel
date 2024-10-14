// import 'package:flutter/material.dart';
// import 'package:hotel_flutter/presentation/screens/homeScreens/tab_screen.dart';

// class CryptoNoTransaction extends StatelessWidget {
//   const CryptoNoTransaction({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(30.0),
//           topRight: Radius.circular(30.0),
//         ),
//       ),
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//             'assets/images/others/wallet.jpg',
//             width: 200.0,
//             height: 200.0,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             "No transaction, yet!",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "Make a booking with CRYPTOTEL & start kinemoe",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const TabScreen()),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF1C3473),
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               textStyle: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             child: const Text("Book Now"),
//           ),
//         ],
//       ),
//     );
//   }
// }
