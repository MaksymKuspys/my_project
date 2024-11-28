import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback onContinue;
  final String text;

  const SuccessDialog({required this.onContinue, required this.text,
    super.key,});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Success'),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            onContinue();
          },
        ),
      ],
    );
  }
}

void showSuccessDialog(BuildContext context,
    VoidCallback onContinue, String text,) {
  showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) {
      return SuccessDialog(onContinue: onContinue, text: text);
    },
  );
}