import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hotel_flutter/data/model/hotel/create_room_model.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_event.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_bloc.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/presentation/widgets/utils_widget/custom_dialog.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _roomName;
  double? _roomPrice;
  int? _roomCapacity;
  String? _selectedRoomType;
  File? _selectedImage;
  String? _hotelId;
  bool _isLoading = false;

  final List<String> _roomTypes = ['Single', 'Double', 'Suite', 'Deluxe'];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getHotelId();
  }

  Future<void> _getHotelId() async {
    try {
      _hotelId = await _storage.read(key: 'handleId');
      if (_hotelId == null) {
        _showCustomDialog(
          context,
          'Error',
          'Failed to retrieve hotel ID.',
        );
      }
    } catch (e) {
      print('Error retrieving hotel ID: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _hotelId != null) {
      if (_selectedImage == null) {
        _showCustomDialog(
          context,
          'Missing Image',
          'Please upload an image.',
        );
        return;
      }

      _formKey.currentState!.save();

      if (_roomPrice == null) {
        _showCustomDialog(
          context,
          'Invalid Input',
          'Please enter a valid number for Price per Night.',
        );
        return;
      }

      if (_roomCapacity == null) {
        _showCustomDialog(
          context,
          'Invalid Input',
          'Please enter a valid number for Room Capacity.',
        );
        return;
      }

      final roomModel = CreateRoomModel(
        roomNumber: _roomName!,
        type: _selectedRoomType!,
        price: _roomPrice!.toInt(),
        capacity: _roomCapacity!,
        image: _selectedImage!,
      );

      context.read<AdminBloc>().add(
            CreateRoomEvent(roomModel: roomModel, hotelId: _hotelId!),
          );

      setState(() {
        _isLoading = true;
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
              padding: EdgeInsets.zero,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildRoomNameField(),
                const SizedBox(height: 20),
                _buildPriceField(),
                const SizedBox(height: 20),
                _buildCapacityField(),
                const SizedBox(height: 20),
                _buildRoomTypeDropdown(),
                const SizedBox(height: 20),
                _buildImagePicker(),
                const SizedBox(height: 20),
                BlocListener<AdminBloc, AdminState>(
                  listener: (context, state) {
                    if (state is AdminSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Room Created Successfully!'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3),
                        ),
                      );

                      setState(() {
                        _isLoading = false;
                      });

                      // Delay the navigation pop to allow Snackbar to be visible
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context);
                      });
                    } else if (state is AdminFailure) {
                      _showCustomDialog(
                        context,
                        'Error',
                        state.error,
                      );
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF1C3473), // Your requested color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Create Room',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          'Room Creation',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRoomNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Room Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter room name' : null,
      onSaved: (value) => _roomName = value,
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Price per Night',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter room price';
        }
        if (double.tryParse(value) == null) {
          return 'Enter a valid price';
        }
        return null;
      },
      onSaved: (value) => _roomPrice = double.tryParse(value!),
    );
  }

  Widget _buildCapacityField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Room Capacity',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter room capacity';
        }
        if (int.tryParse(value) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
      onSaved: (value) => _roomCapacity = int.tryParse(value!),
    );
  }

  Widget _buildRoomTypeDropdown() {
    return DropdownButtonFormField<String>(
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
      onChanged: (value) => setState(() {
        _selectedRoomType = value;
      }),
      validator: (value) => value == null ? 'Select a room type' : null,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Room Image', style: TextStyle(fontSize: 16)),
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
                child: const Icon(Icons.image, size: 100),
              ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C3473), // Your requested color
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Pick Image',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showCustomDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: title,
          description: message,
          buttonText: 'Close',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          secondButtonText: '',
          onSecondButtonPressed: () {},
        );
      },
    );
  }
}
