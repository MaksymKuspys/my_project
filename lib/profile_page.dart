import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
            ),
            const SizedBox(height: 20),
            const Text('Username', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            const Text('email@example.com'),
            const SizedBox(height: 30),
            _buildButton('Logout', () {
              Navigator.pushNamed(context, '/login');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}