import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/user_model.dart';
import 'package:hotel_flutter/logic/bloc/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/profile/blue_background_widget.dart';
import 'package:hotel_flutter/presentation/widgets/profile/bottom_section.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profile,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String profile;

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  String username = "";
  String address = "";
  String gender = "Male";
  File? _selectedImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    usernameController = TextEditingController(text: username);
    emailController = TextEditingController(text: widget.email);
    addressController = TextEditingController(text: address);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> updateUserData() async {
    setState(() {
      _isLoading = true; // Show loading state when updating profile
    });

    final updatedUser = UserModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      profilePicture: _selectedImage?.path ?? widget.profile,
    );

    try {
      // Update the user data via Bloc event
      context.read<AuthBloc>().add(
            UpdateUserEvent(updatedUser, profilePicture: _selectedImage?.path),
          );

      // Update the local storage with the new profile path
      await _storage.write(key: 'profile', value: _selectedImage?.path);

      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User data updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 53, 115),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          const BlueBackground(),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            bottom: 0,
            child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is Authenticated) {
                return BottomSection(
                  firstNameController: firstNameController,
                  lastNameController: lastNameController,
                  usernameController: usernameController,
                  emailController: emailController,
                  addressController: addressController,
                  updateUserData: updateUserData,
                  onGenderChanged: (selectedGender) {
                    setState(() {
                      gender = selectedGender;
                    });
                  },
                  gender: gender,
                  isLoading: _isLoading,
                );
              }
              return Container();
            }),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.01,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _isLoading ? null : _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: const Color.fromARGB(255, 173, 175, 210),
                child: ClipOval(
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : widget.profile.isNotEmpty &&
                              widget.profile.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: widget.profile,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 60,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 80,
                              color: Color.fromARGB(255, 29, 53, 115),
                            ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
