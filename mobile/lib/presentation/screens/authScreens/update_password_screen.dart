import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/profile/blue_background_widget.dart';
import 'package:hotel_flutter/presentation/widgets/update_password/update_bottom_section.dart';
import 'package:hotel_flutter/presentation/widgets/utils_widget/custom_dialog.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UpdatePasswordScreenState();
  }
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  final storage = const FlutterSecureStorage();
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showCustomDialog(
    BuildContext context,
    String title,
    String description,
    String buttonText,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: title,
          description: description,
          buttonText: buttonText,
          onButtonPressed: () {
            Navigator.of(context).pop();
          },
          secondButtonText: '',
          onSecondButtonPressed: () {},
        );
      },
    );
  }

  void _updatePassword() {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showCustomDialog(
        context,
        'Error',
        'All fields are required.',
        'Close',
      );
      return;
    }

    if (newPassword != confirmPassword) {
      _showCustomDialog(
        context,
        'Error',
        'New passwords do not match.',
        'Close',
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    BlocProvider.of<AuthBloc>(context).add(
      ChangePasswordEvent(currentPassword, newPassword, confirmPassword),
    );
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
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthPasswordChangeSuccess) {
                  setState(() {
                    _isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  storage.deleteAll();
                  Navigator.of(context).pushNamed('/login');
                } else if (state is PasswordChangeFailure) {
                  setState(() {
                    _isLoading = false;
                  });
                  _showCustomDialog(
                    context,
                    'Password Change Failed',
                    state.error,
                    'Close',
                  );
                }
              },
              builder: (context, state) {
                return UpdateBottomSection(
                  currentPasswordController: currentPasswordController,
                  newPasswordController: newPasswordController,
                  confirmPasswordController: confirmPasswordController,
                  onUpdatePassword: _updatePassword,
                  isLoading: _isLoading,
                );
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.01,
            left: 0,
            right: 0,
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Color.fromARGB(255, 173, 175, 210),
              child: Icon(
                Icons.lock,
                size: 80,
                color: Color.fromARGB(255, 29, 53, 115),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
