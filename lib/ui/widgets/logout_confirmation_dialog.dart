import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutConfirmationDialog({required this.onLogout, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm sign out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onLogout();
          },
          child: const Text('Sign out'),
        ),
      ],
    );
  }
}

void showLogoutConfirmationDialog(BuildContext context
    , VoidCallback onLogout,) {
  showDialog<Dialog>(
    context: context,
    builder: (BuildContext context) {
      return LogoutConfirmationDialog(
        onLogout: onLogout,
      );
    },
  );
}