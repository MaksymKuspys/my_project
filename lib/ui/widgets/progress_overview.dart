import 'package:flutter/material.dart';
import 'package:my_project/entity/subject.dart';

class ProgressOverview extends StatelessWidget {
  final List<Subject> subjects;

  const ProgressOverview({required this.subjects, super.key});

  @override
  Widget build(BuildContext context) {
    final totalLabs = subjects
        .fold(0, (sum, subject) => sum + subject.totalLabs);
    final completedLabs = subjects
        .fold(0, (sum, subject) => sum + subject.completedLabs);
    final pendingLabs = totalLabs - completedLabs;
    final double completionRate = totalLabs > 0 ? completedLabs / totalLabs : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Labs Progress',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: completionRate,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        const SizedBox(height: 8),
        Text('Completed: $completedLabs Labs'),
        Text('Pending: $pendingLabs Labs'),
      ],
    );
  }
}