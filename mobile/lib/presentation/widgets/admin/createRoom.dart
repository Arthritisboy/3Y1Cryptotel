import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _formKey = GlobalKey<FormState>();

  String? _roomName;
  String? _roomDescription;
  double? _roomPrice;
  int? _roomCapacity;
  String? _selectedRoomType;
  File? _selectedImage; // To store the selected image

  final List<String> _roomTypes = ['Single', 'Double', 'Suite', 'Deluxe'];

  // Amenity Categories
  final Map<String, bool> _bathroomAmenities = {
    'Toiletries': false,
    'Shower': false,
    'Bidet': false,
    'Towels': false,
    'Slippers': false,
    'Toilet paper': false,
  };

  final Map<String, bool> _facilitiesAmenities = {
    'Air Conditioning': false,
    'Safety Deposit Box': false,
    'Linen': false,
    'Socket Near the Bed': false,
    'TV': false,
    'Refrigerator': false,
    'Telephone': false,
    'Satellite Channels': false,
    'Wifi': false,
    'Cable Channels': false,
  };

  bool _isNonSmoking = false; // For Smoking category

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.zero, // Remove padding from ListView
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(
                            context); // Go back to the previous screen
                      },
                    ),
                    const Text(
                      'Room Creation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Room Name
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the room name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _roomName = value;
                  },
                ),
                const SizedBox(height: 20),

                // Room Description
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Room Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _roomDescription = value;
                  },
                ),
                const SizedBox(height: 20),

                // Room Price
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price per Night',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the room price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _roomPrice = double.tryParse(value!);
                  },
                ),
                const SizedBox(height: 20),

                // Room Capacity
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Room Capacity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the room capacity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _roomCapacity = int.tryParse(value!);
                  },
                ),
                const SizedBox(height: 20),

                // Room Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Room Type',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedRoomType,
                  items: _roomTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRoomType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a room type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Image Upload
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload Room Image',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1C3473), // Set button color
                      ),
                      child: const Text('Pick Image'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Bathroom Amenities
                ExpansionTile(
                  title: const Text('Bathroom Amenities'),
                  children: _bathroomAmenities.keys.map((amenity) {
                    return CheckboxListTile(
                      title: Text(
                        amenity,
                        style: const TextStyle(
                            color: Colors.black), // Set text color to black
                      ),
                      value: _bathroomAmenities[amenity],
                      onChanged: (bool? value) {
                        setState(() {
                          _bathroomAmenities[amenity] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                // Facilities Section
                ExpansionTile(
                  title: const Text('Facilities'),
                  children: _facilitiesAmenities.keys.map((amenity) {
                    return CheckboxListTile(
                      title: Text(
                        amenity,
                        style: const TextStyle(
                            color: Colors.black), // Set text color to black
                      ),
                      value: _facilitiesAmenities[amenity],
                      onChanged: (bool? value) {
                        setState(() {
                          _facilitiesAmenities[amenity] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                // Smoking Section
                ExpansionTile(
                  title: const Text('Smoking'),
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Non-Smoking',
                        style: TextStyle(
                            color: Colors.black), // Set text color to black
                      ),
                      value: _isNonSmoking,
                      onChanged: (bool value) {
                        setState(() {
                          _isNonSmoking = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Process the data here
                      print('Room Name: $_roomName');
                      print('Room Description: $_roomDescription');
                      print('Room Price: $_roomPrice');
                      print('Room Capacity: $_roomCapacity');
                      print('Room Type: $_selectedRoomType');
                      print('Bathroom Amenities: $_bathroomAmenities');
                      print('Facilities: $_facilitiesAmenities');
                      print('Non-Smoking: $_isNonSmoking');

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Room Created!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1C3473), // Set button color
                  ),
                  child: const Text('Create Room'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
