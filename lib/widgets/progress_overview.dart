import 'package:flutter/material.dart';
import 'package:my_project/entity/subject.dart';

class ProgressOverview extends StatelessWidget {
  final List<Subject> subjects;

  const ProgressOverview({required this.subjects, super.key});

  @override
  Widget build(BuildContext context) {
    final int totalLabs = subjects.fold(0,
            (sum, item) => sum + item.totalLabs,);
    final int completedLabs = subjects.fold(0,
            (sum, item) => sum + item.completedLabs,);
    final int pendingLabs = totalLabs - completedLabs;
    final double completionRate = totalLabs > 0 ? completedLabs / totalLabs : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Labs Progress',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: completionRate,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
        Text('Completed: $completedLabs Labs'),
        Text('Pending: $pendingLabs Labs'),
      ],
    );
  }
}