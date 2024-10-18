import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/admin/admin_model.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_bloc.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_event.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_state.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantFormScreen extends StatefulWidget {
  const RestaurantFormScreen({super.key});

  @override
  _RestaurantFormScreenState createState() => _RestaurantFormScreenState();
}

class _RestaurantFormScreenState extends State<RestaurantFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _walletAddressController =
      TextEditingController();
  final TextEditingController _managerFirstNameController =
      TextEditingController();
  final TextEditingController _managerLastNameController =
      TextEditingController();
  final TextEditingController _managerEmailController = TextEditingController();
  final TextEditingController _managerPhoneNumberController =
      TextEditingController();
  final TextEditingController _managerPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;
  String _selectedGender = 'male'; // Default gender value

  // Pick Image from Gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Validate Password and Confirm Password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _managerPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Create Restaurant - Dispatch Event
  void _createRestaurant() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image')),
        );
        return;
      }

      final adminModel = AdminModel(
        name: _nameController.text,
        location: _locationController.text,
        openingHours: _openingHoursController.text,
        price: int.parse(_priceController.text),
        capacity: int.parse(_capacityController.text),
        walletAddress: _walletAddressController.text,
        managerFirstName: _managerFirstNameController.text,
        managerLastName: _managerLastNameController.text,
        managerEmail: _managerEmailController.text,
        managerPhoneNumber: _managerPhoneNumberController.text,
        managerPassword: _managerPasswordController.text,
        managerConfirmPassword: _confirmPasswordController.text,
        managerGender: _selectedGender,
        image: _selectedImage!,
      );

      context.read<AdminBloc>().add(CreateRestaurantEvent(adminModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is AdminLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is AdminSuccess) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AdminFailure) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildTextField('Restaurant Name', _nameController),
                  const SizedBox(height: 20),
                  _buildTextField('Location', _locationController),
                  const SizedBox(height: 20),
                  _buildTextField('Opening Hours', _openingHoursController),
                  const SizedBox(height: 20),
                  _buildTextField('Price per Meal', _priceController,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _buildTextField('Capacity', _capacityController,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _buildTextField('Wallet Address', _walletAddressController),
                  const SizedBox(height: 20),
                  const Text(
                    'Manager Account Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                      'Manager First Name', _managerFirstNameController),
                  const SizedBox(height: 20),
                  _buildTextField(
                      'Manager Last Name', _managerLastNameController),
                  const SizedBox(height: 20),
                  _buildTextField('Manager Email', _managerEmailController,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  _buildTextField(
                      'Manager Phone Number', _managerPhoneNumberController),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                      'Manager Password', _managerPasswordController),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                      'Confirm Password', _confirmPasswordController,
                      validator: _validateConfirmPassword),
                  const SizedBox(height: 20),
                  _buildGenderSelector(),
                  const SizedBox(height: 20),
                  _buildImagePicker(),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _createRestaurant(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C3473),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Text('Create Restaurant'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          'Create Restaurant',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Text Field
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  // Password Field
  Widget _buildPasswordField(String label, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      obscureText: true,
      validator: validator ?? _validatePassword,
    );
  }

  // Image Picker
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Restaurant Image', style: TextStyle(fontSize: 16)),
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
                child: const Icon(Icons.image, size: 100, color: Colors.grey),
              ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C3473),
          ),
          child: const Text('Pick Image'),
        ),
      ],
    );
  }

  // Gender Selector
  Widget _buildGenderSelector() {
    return Row(
      children: [
        const Text('Gender: ', style: TextStyle(fontSize: 16)),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
            ],
            onChanged: (value) => setState(() => _selectedGender = value!),
          ),
        ),
      ],
    );
  }
}
