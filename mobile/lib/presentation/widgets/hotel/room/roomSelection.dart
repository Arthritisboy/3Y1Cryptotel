// import 'package:flutter/material.dart';
// import 'package:hotel_flutter/data/model/hotel/room_model.dart';
// import 'package:hotel_flutter/presentation/widgets/hotel/room/activeRoom.dart';

// class RoomSelection extends StatelessWidget {
//   final List<RoomModel> roomList;

//   const RoomSelection({super.key, required this.roomList});

//   @override
//   Widget build(BuildContext context) {
//     final availableRooms = roomList.where((room) => room.isAvailable).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Available Rooms',
//           style: TextStyle(
//             fontSize: 22.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 10),
//         if (availableRooms.isEmpty)
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 20),
//             child: Text(
//               'No rooms available',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 color: Colors.red,
//               ),
//             ),
//           )
//         else
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: availableRooms.length,
//             itemBuilder: (context, index) {
//               final room = availableRooms[index];
//               return InkWell(
//                 onTap: () {
//                   // Navigate to ActiveRoom screen on tap
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ActiveRoom(
//                         hotelName: room.hotelName,
//                         rating: room.rating,
//                         price: room.price,
//                         location: room.location,
//                         room: room, // Pass room model without activeIndex
//                       ),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: 140,
//                           height: 120,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             image: DecorationImage(
//                               image: AssetImage(room.imageUrl),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 room.roomType,
//                                 style: const TextStyle(
//                                   fontSize: 18.0,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontFamily: 'Hammersmith',
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 '₱${room.price}',
//                                 style: const TextStyle(
//                                   fontSize: 16.0,
//                                   color: Colors.black,
//                                   fontFamily: 'Hammersmith',
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 'Up to: ${room.numberofGuest} Guests',
//                                 style: const TextStyle(
//                                   fontSize: 16.0,
//                                   color: Colors.black,
//                                   fontFamily: 'Hammersmith',
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 room.isAvailable
//                                     ? 'Available'
//                                     : 'Not Available',
//                                 style: TextStyle(
//                                   fontSize: 16.0,
//                                   color: room.isAvailable
//                                       ? Colors.green
//                                       : Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//       ],
//     );
//   }
// }
