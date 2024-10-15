import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HotelFormScreen extends StatefulWidget {
  const HotelFormScreen({super.key});

  @override
  _HotelFormScreenState createState() => _HotelFormScreenState();
}

class _HotelFormScreenState extends State<HotelFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  final TextEditingController _averagePriceController = TextEditingController();

  File? _selectedImage; // For storing the selected image

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
              padding: EdgeInsets.zero, // Remove extra padding
              children: [
                // Header with back button and title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context); // Go back to previous screen
                      },
                    ),
                    const Text(
                      'Create Hotel',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Hotel Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Hotel Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Location
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Opening Hours
                TextFormField(
                  controller: _openingHoursController,
                  decoration: const InputDecoration(
                    labelText: 'Opening Hours',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Average Price
                TextFormField(
                  controller: _averagePriceController,
                  decoration: const InputDecoration(
                    labelText: 'Average Price per Night',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Image Upload
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Upload Hotel Image',
                        style: TextStyle(fontSize: 16)),
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
                            child: const Icon(Icons.image,
                                size: 100, color: Colors.grey),
                          ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1C3473), // Set button color
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // UI-only Submit Button
                ElevatedButton(
                  onPressed: () {
                    // No functionality, UI only
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1C3473), // Set button color
                  ),
                  child: const Text('Create Hotel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
