import 'package:flutter/material.dart';

bool isValid(String email, String password, BuildContext context) {
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields')),
    );
    return false;
  }
  return true;
}