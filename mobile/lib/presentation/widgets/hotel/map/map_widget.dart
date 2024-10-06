import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/map/full_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapWidget({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Navigating to full screen map'); // Debugging
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenMap(
              latitude: latitude,
              longitude: longitude, hotelName: '',
            ),
          ),
        );
      },
      child: Container(
        height: 140,
        width: 340,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude),
            initialZoom: 15.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(latitude, longitude),
                  width: 80,
                  height: 80,
                  child: Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
