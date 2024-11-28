import 'package:flutter/material.dart';

void showNoInternetDialog(BuildContext context) {
  showDialog<Dialog>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No WI-FI Connection'),
        content: const Text('Please check your WI-FI connection'
            ' and try again later.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}