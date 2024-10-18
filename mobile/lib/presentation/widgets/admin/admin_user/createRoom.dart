import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hotel_flutter/data/model/hotel/create_room_model.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_event.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_bloc.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
        _showSnackbar('Failed to retrieve hotel ID.', Colors.red);
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
      _formKey.currentState!.save();

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

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
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
                Row(
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
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter room name' : null,
                  onSaved: (value) => _roomName = value,
                ),
                const SizedBox(height: 20),
                TextFormField(
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
                ),
                const SizedBox(height: 20),
                TextFormField(
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
                ),
                const SizedBox(height: 20),
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
                  onChanged: (value) => setState(() {
                    _selectedRoomType = value;
                  }),
                  validator: (value) =>
                      value == null ? 'Select a room type' : null,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Upload Room Image',
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
                            child: const Icon(Icons.image, size: 100),
                          ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BlocListener<AdminBloc, AdminState>(
                  listener: (context, state) {
                    if (state is AdminSuccess) {
                      _showSnackbar('Room Created Successfully!', Colors.green);
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pop(context);
                    } else if (state is AdminFailure) {
                      _showSnackbar(state.error, Colors.red);
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Create Room'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
