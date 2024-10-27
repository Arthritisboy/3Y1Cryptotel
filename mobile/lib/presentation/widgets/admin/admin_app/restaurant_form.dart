import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/admin/admin_model.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_bloc.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_event.dart';
import 'package:hotel_flutter/logic/bloc/admin/admin_state.dart';
import 'package:hotel_flutter/presentation/widgets/utils_widget/custom_dialog.dart';
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

  bool _isValidCapacity(String capacity) {
    return int.tryParse(capacity) != null;
  }

  bool _isValidPrice(String price) {
    return int.tryParse(price) != null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _managerPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool _isValidPassword(String password) {
    return password.length > 9;
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.length > 10;
  }

  bool _isValidEmail(String email) {
    return email.contains('@gmail');
  }

  // Create Restaurant - Dispatch Event
  void _createRestaurant() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_isValidPrice(_priceController.text.trim())) {
        _showCustomDialog(
            context, 'Invalid Price', 'Price must be a valid number.');
        return;
      }

      if (!_isValidCapacity(_capacityController.text.trim())) {
        _showCustomDialog(
            context, 'Invalid Capacity', 'Capacity must be a valid number.');
        return;
      }

      if (!_isValidPassword(_managerPasswordController.text.trim())) {
        _showCustomDialog(context, 'Invalid Password',
            'Password must be longer than 9 characters.');
        return;
      }

      if (!_isValidPhoneNumber(_managerPhoneNumberController.text.trim())) {
        _showCustomDialog(context, 'Invalid Phone Number',
            'Phone number must be longer than 10 characters.');
        return;
      }

      if (!_isValidEmail(_managerEmailController.text.trim())) {
        _showCustomDialog(
            context, 'Invalid Email', 'Email must contain @gmail.');
        return;
      }

      if (_selectedImage == null) {
        _showCustomDialog(context, 'Missing Image', 'Please upload an image.');
        return;
      }

      final adminModel = AdminModel(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        openingHours: _openingHoursController.text.trim(),
        price: int.parse(_priceController.text.trim()),
        capacity: int.parse(_capacityController.text.trim()),
        walletAddress: _walletAddressController.text.trim(),
        managerFirstName: _managerFirstNameController.text.trim(),
        managerLastName: _managerLastNameController.text.trim(),
        managerEmail: _managerEmailController.text.trim(),
        managerPhoneNumber: _managerPhoneNumberController.text.trim(),
        managerPassword: _managerPasswordController.text.trim(),
        managerConfirmPassword: _confirmPasswordController.text.trim(),
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
          setState(() => _isLoading = true);
        } else if (state is AdminSuccess) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AdminFailure) {
          setState(() => _isLoading = false);
          _showCustomDialog(context, 'Error', state.error);
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
                  const Text('Manager Account Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    onPressed: _isLoading ? null : _createRestaurant,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C3473)),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.0))
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

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        const Text('Create Restaurant',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: keyboardType,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator ?? _validatePassword,
    );
  }

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
            backgroundColor: const Color.fromARGB(255, 29, 53, 115),
          ),
          child: const Text('Pick Image'),
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

  void _showCustomDialog(
      BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: title,
          description: description,
          buttonText: 'Close',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          onSecondButtonPressed: () {},
        );
      },
    );
  }
}
