import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/admin/admin_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_bloc.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_event.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_state.dart';

class HotelFormScreen extends StatefulWidget {
  const HotelFormScreen({super.key});

  @override
  State<HotelFormScreen> createState() => _HotelFormScreenState();
}

class _HotelFormScreenState extends State<HotelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  final TextEditingController _walletAddressController =
      TextEditingController();
  final TextEditingController _managerFirstNameController =
      TextEditingController();
  final TextEditingController _managerLastNameController =
      TextEditingController();
  final TextEditingController _managerEmailController = TextEditingController();
  final TextEditingController _managerPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _managerPhoneNumberController =
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

  // Create Hotel and Dispatch Bloc Event
  void _createHotelAndAdmin() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image')),
        );
        return;
      }
      // Print all field values to the console
      print('Hotel Name: ${_nameController.text.trim()}');
      print('Location: ${_locationController.text.trim()}');
      print('Opening Hours: ${_openingHoursController.text.trim()}');
      print('Wallet Address: ${_walletAddressController.text.trim()}');
      print('Manager Email: ${_managerEmailController.text.trim()}');
      print('Manager First Name: ${_managerFirstNameController.text.trim()}');
      print('Manager Last Name: ${_managerLastNameController.text.trim()}');
      print('Manager Password: ${_managerPasswordController.text.trim()}');
      print('Confirm Password: ${_confirmPasswordController.text.trim()}');
      print(
          'Manager Phone Number: ${_managerPhoneNumberController.text.trim()}');
      print('Manager Gender: $_selectedGender');
      print('Selected Image: ${_selectedImage?.path}');

      final adminModel = AdminModel(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        openingHours: _openingHoursController.text.trim(),
        walletAddress: _walletAddressController.text.trim(),
        managerEmail: _managerEmailController.text.trim(),
        managerFirstName: _managerFirstNameController.text.trim(),
        managerLastName: _managerLastNameController.text.trim(),
        managerPassword: _managerPasswordController.text.trim(),
        managerConfirmPassword: _confirmPasswordController.text.trim(),
        managerPhoneNumber: _managerPhoneNumberController.text.trim(),
        managerGender: _selectedGender,
        image: _selectedImage!,
      );

      setState(() {
        _isLoading = true;
      });

      BlocProvider.of<AdminBloc>(context).add(CreateHotelEvent(adminModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AdminBloc, AdminState>(
          listener: (context, state) {
            if (state is AdminSuccess) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              _formKey.currentState?.reset();
              setState(() => _selectedImage = null);
            } else if (state is AdminFailure) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),

                  // Hotel Name Field
                  _buildTextField('Hotel Name', _nameController),
                  const SizedBox(height: 20),

                  // Location Field
                  _buildTextField('Location', _locationController),
                  const SizedBox(height: 20),

                  // Opening Hours Field
                  _buildTextField('Opening Hours', _openingHoursController),
                  const SizedBox(height: 20),

                  // Wallet Address Field
                  _buildTextField('Wallet Address', _walletAddressController),
                  const SizedBox(height: 20),

                  // Manager Info Section
                  const Text(
                    'Manager Account Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Manager First Name Field
                  _buildTextField(
                      'Manager First Name', _managerFirstNameController),
                  const SizedBox(height: 20),

                  // Manager Last Name Field
                  _buildTextField(
                      'Manager Last Name', _managerLastNameController),
                  const SizedBox(height: 20),

                  // Manager Email Field
                  _buildTextField('Manager Email', _managerEmailController,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),

                  // Manager Password Field
                  _buildPasswordField(
                      'Manager Password', _managerPasswordController),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  _buildPasswordField(
                      'Confirm Password', _confirmPasswordController,
                      validator: _validateConfirmPassword),
                  const SizedBox(height: 20),

                  // Manager Phone Number Field
                  _buildTextField(
                      'Manager Phone Number', _managerPhoneNumberController),
                  const SizedBox(height: 20),

                  // Gender Selector
                  _buildGenderSelector(),
                  const SizedBox(height: 30),

                  // Image Upload Section
                  _buildImagePicker(),
                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _createHotelAndAdmin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 29, 53, 115),
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
                        : const Text('Create'),
                  ),
                ],
              ),
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
          'Create Hotel',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      keyboardType: keyboardType,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      obscureText: true,
      validator: validator ?? _validatePassword,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Hotel Image', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        _selectedImage != null
            ? Image.file(_selectedImage!, height: 150, fit: BoxFit.cover)
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
            backgroundColor: const Color.fromARGB(255, 29, 53, 115),
          ),
          child: Text('Pick Image'),
        ),
      ],
    );
  }

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
