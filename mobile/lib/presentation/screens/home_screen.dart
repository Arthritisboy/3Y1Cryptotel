import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/card_widget.dart';
import 'package:hotel_flutter/presentation/screens/hotel_screen.dart';
import 'package:hotel_flutter/data/dummydata/hotel_data.dart';
import 'package:hotel_flutter/data/model/hotel_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Rated Hotels',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 200.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildRoomList(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRoomList(BuildContext context) {
    return hotelData.map((Hotel hotel) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HotelScreen(
                    backgroundImage: hotel.imagePath,
                    hotelName: hotel.hotelName,
                    rating: hotel.rating,
                    price: hotel.price,
                    location: hotel.location,
                    time: hotel.time),
              ),
            );
          },
          child: CardWidget(
            imagePath: hotel.imagePath,
            hotelName: hotel.hotelName,
            location: hotel.location,
            rating: hotel.rating,
          ),
        ),
      );
    }).toList();
  }
}
