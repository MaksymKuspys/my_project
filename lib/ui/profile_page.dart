import 'package:flutter/material.dart';
import 'package:my_project/entity/user.dart';
import 'package:my_project/repository/shared/shared_prefs_current_user_repository.dart';
import 'package:my_project/repository/shared/shared_prefs_user_repository.dart';
import 'package:my_project/service/user_service.dart';
import 'package:my_project/ui/widgets/logout_confirmation_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _emailController = TextEditingController();
  SharedPrefsUserRepository? _userRepository;
  SharedPrefsCurrentUserRepository? _currentUserRepository;
  UserService? _userService;
  User? _user;

  Future<void> _initializeServices() async {
    final prefs = await SharedPreferences.getInstance();
    _userRepository = SharedPrefsUserRepository(prefs);
    _currentUserRepository = SharedPrefsCurrentUserRepository(prefs);
    _userService = UserService(_userRepository!, _currentUserRepository!);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _user != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                radius: 50,),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.all(20),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                showLogoutConfirmationDialog(context, _logout);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _loadUserProfile() async {
    await _initializeServices();
    _user = await _userService!.getCurrentUser();
    _emailController.text = _user!.email;
    setState(() {});
  }

  Future<void> _updateProfile() async {
    final email = _emailController.text.trim();
    final updatedUser = _user!.copyWith(email: email);
    await _userService!.setCurrentUser(updatedUser);
    _user = updatedUser;
    setState(() {});
  }

  Future<void> _logout() async {
    await _userService!.logout();
    if (mounted) {
      Navigator.pushNamed(context, '/login');
    }
  }
}