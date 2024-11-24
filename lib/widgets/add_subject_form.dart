import 'package:flutter/material.dart';

class AddSubjectForm extends StatelessWidget {
  final TextEditingController subjectController;
  final TextEditingController totalLabsController;
  final TextEditingController completedLabsController;
  final VoidCallback onAddSubject;

  const AddSubjectForm({
    required this.subjectController,
    required this.totalLabsController,
    required this.completedLabsController,
    required this.onAddSubject, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: subjectController,
          decoration: const InputDecoration(labelText: 'Subject Name'),
        ),
        TextField(
          controller: totalLabsController,
          decoration: const InputDecoration(labelText: 'Total Labs'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: completedLabsController,
          decoration: const InputDecoration(labelText: 'Completed Labs'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onAddSubject,
          child: const Text('Add Subject'),
        ),
      ],
    );
  }
}