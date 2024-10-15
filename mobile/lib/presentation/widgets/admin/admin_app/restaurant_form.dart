import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RestaurantFormScreen extends StatefulWidget {
  const RestaurantFormScreen({super.key});

  @override
  _RestaurantFormScreenState createState() => _RestaurantFormScreenState();
}

class _RestaurantFormScreenState extends State<RestaurantFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  bool _availability = false; // For storing availability status
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
                      'Create Restaurant',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Restaurant Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Restaurant Name',
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

                // Price
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price per Meal',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Capacity
                TextFormField(
                  controller: _capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Availability Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Availability',
                      style: TextStyle(fontSize: 16),
                    ),
                    Switch(
                      value: _availability,
                      onChanged: (bool value) {
                        setState(() {
                          _availability = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Image Upload
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Upload Restaurant Image',
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
                  child: const Text('Create Restaurant'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
