import 'package:hotel_flutter/data/model/room_model.dart';

List<RoomModel> roomList = [
  RoomModel(
    roomType: 'Deluxe Double Bedroom',
    price: 3000,
    isAvailable: true,
    numberofGuest: 2,
    imageUrls: [
      'assets/images/rooms/MonarchHotel/deluxedoublebedroom1.jpg', 
      'assets/images/rooms/MonarchHotel/deluxedoublebedroom2.jpg', 
      'assets/images/rooms/MonarchHotel/deluxedoublebedroom3.jpg',  
      'assets/images/rooms/MonarchHotel/deluxedoublebedroom4.jpg', 
    ],
    hotelName: 'The Monarch Hotel',
    rating: 1.2,
    location: ''
  ),
  RoomModel(
    roomType: 'Executive Room',
    price: 2000,
    isAvailable: true,
    numberofGuest: 2,
    imageUrls: [
      'assets/images/rooms/hotelroom_3.jpg',  // Fixed by adding a comma
      'assets/images/rooms/hotelroom_1.png',
      'assets/images/rooms/hotelroom_2.png'
    ],
    hotelName: 'The Monarch Hotel',
    rating: 1.2,
    location: ''
  ),
  RoomModel(
    roomType: 'Standard Room',
    price: 1000,
    isAvailable: true,
    numberofGuest: 2,
    imageUrls: [
      'assets/images/rooms/hotelroom_3.jpg',  // Fixed by adding a comma
      'assets/images/rooms/hotelroom_1.png',
      'assets/images/rooms/hotelroom_2.png'
    ],
    hotelName: 'The Monarch Hotel',
    rating: 1.2,
    location: ''
  ),
  RoomModel(
    roomType: 'Executive Room',
    price: 2000,
    isAvailable: true,
    numberofGuest: 2,
    imageUrls: [
      'assets/images/rooms/hotelroom_3.jpg',  // Fixed by adding a comma
      'assets/images/rooms/hotelroom_1.png',
      'assets/images/rooms/hotelroom_2.png'
    ],
    hotelName: 'Star Plaza Hotel',
    rating: 1.2,
    location: ''
  ),
  RoomModel(
    roomType: 'Standard Room',
    price: 1000,
    isAvailable: false,
    numberofGuest: 2,
    imageUrls: [
      'assets/images/rooms/hotelroom_3.jpg',  // Fixed by adding a comma
      'assets/images/rooms/hotelroom_1.png',
      'assets/images/rooms/hotelroom_2.png'
    ],
    hotelName: 'Lenox Hotel',
    rating: 1.2,
    location: ''
  ),
];

