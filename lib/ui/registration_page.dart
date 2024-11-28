import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_project/repository/shared/shared_prefs_current_user_repository.dart';
import 'package:my_project/repository/shared/shared_prefs_user_repository.dart';
import 'package:my_project/service/connectivity_service.dart';
import 'package:my_project/service/user_service.dart';
import 'package:my_project/ui/widgets/no_internet_dialog.dart';
import 'package:my_project/ui/widgets/success_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  SharedPrefsUserRepository? _userRepository;
  SharedPrefsCurrentUserRepository? _currentUserRepository;
  UserService? _userService;
  ConnectivityService? _connectivityService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final prefs = await SharedPreferences.getInstance();
    _userRepository = SharedPrefsUserRepository(prefs);
    _currentUserRepository = SharedPrefsCurrentUserRepository(prefs);
    _userService = UserService(_userRepository!, _currentUserRepository!);
    if (mounted) {
      _connectivityService = ConnectivityService(context);
    }

    setState(() {});
  }

  @override
  void dispose() {
    _connectivityService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    final status = await _connectivityService?.getCurrentStatus();

    if (status == InternetStatus.disconnected && mounted) {
      showNoInternetDialog(context);
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;

    if (_isValid(email, password)) {
      final bool registered = await _userService!.register(email, password);
      if (!registered && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User already exists'),
          ),
        );
        return;
      }
      if (mounted) {
        showSuccessDialog(context, () {
          Navigator.pushNamed(context, '/home');
        }, 'Register successful!',);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid input'),
        ),
      );
    }
  }

  bool _isValid(String email, String password) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email) && password.length >= 6;

  }
}