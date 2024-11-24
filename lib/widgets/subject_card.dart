import 'package:flutter/material.dart';
import 'package:my_project/entity/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const SubjectCard({
    required this.subject,
    required this.onIncrement,
    required this.onDecrement, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: subject.totalLabs > 0
                  ? subject.completedLabs / subject.totalLabs
                  : 0,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            Text('Total Labs: ${subject.totalLabs}'),
            Text('Completed: ${subject.completedLabs} '
                '| Pending: ${subject.totalLabs - subject.completedLabs}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onIncrement,
                  child: const Text('Add Completed Lab'),
                ),
                ElevatedButton(
                  onPressed: onDecrement,
                  child: const Text('Remove Completed Lab'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}