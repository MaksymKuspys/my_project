import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_project/repository/shared/shared_prefs_current_user_repository.dart';
import 'package:my_project/repository/shared/shared_prefs_user_repository.dart';
import 'package:my_project/service/connectivity_service.dart';
import 'package:my_project/service/user_service.dart';
import 'package:my_project/ui/login/login_helpers.dart';
import 'package:my_project/ui/widgets/no_internet_dialog.dart';
import 'package:my_project/ui/widgets/success_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final BuildContext context;
  SharedPrefsUserRepository? _userRepository;
  SharedPrefsCurrentUserRepository? _currentUserRepository;
  UserService? _userService;
  ConnectivityService? _connectivityService;

  LoginService(this.context);

  Future<void> initializeApp() async {
    await _initializeServices();
    await _loadCurrentUser();
  }

  Future<void> _initializeServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userRepository = SharedPrefsUserRepository(prefs);
      _currentUserRepository = SharedPrefsCurrentUserRepository(prefs);
      _userService = UserService(_userRepository!, _currentUserRepository!);

      if (context.mounted){
        _connectivityService = ConnectivityService(context);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing services: $e');
      }
    }
  }

  Future<void> _loadCurrentUser() async {
    final user = await _currentUserRepository?.getCurrentUser();
    final status = await _connectivityService?.getCurrentStatus();

    if (context.mounted && status == InternetStatus.disconnected
        && user != null) {
      showSuccessDialog(context, () {
        Navigator.pushNamed(context, '/home');
      }, 'No WI-FI connection. Logging in with cached user data.',);
      return;
    }

    if (context.mounted && user != null) {
      Navigator.pushNamed(context, '/home');
    }
  }

  Future<void> loginUser(String email, String password) async {
    final status = await _connectivityService?.getCurrentStatus();

    if (status == InternetStatus.disconnected && context.mounted) {
      showNoInternetDialog(context);
      return;
    }

    if (context.mounted && isValid(email, password, context)) {
      await _attemptLogin(email, password);
    }
  }

  Future<void> _attemptLogin(String email, String password) async {
    try {
      final bool login = await _userService?.login(email, password) ?? false;
      if (login) {
        _handleSuccessfulLogin();
      } else {
        _showLoginError();
      }
    } catch (e) {
      _showLoginError();
    }
  }

  void _handleSuccessfulLogin() {
    showSuccessDialog(context, () {
      Navigator.pushNamed(context, '/home');
    }, 'Login successful!',);
  }

  void _showLoginError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid email or password')),
    );
  }

  void dispose() {
    _connectivityService?.dispose();
  }
}