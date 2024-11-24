import 'package:flutter/material.dart';
import 'package:my_project/entity/subject.dart';
import 'package:my_project/widgets/add_subject_form.dart';
import 'package:my_project/widgets/progress_overview.dart';
import 'package:my_project/widgets/subject_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Subject> subjects = [];
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController totalLabsController = TextEditingController();
  final TextEditingController completedLabsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressOverview(subjects: subjects),
            const SizedBox(height: 20),
            AddSubjectForm(
              subjectController: subjectController,
              totalLabsController: totalLabsController,
              completedLabsController: completedLabsController,
              onAddSubject: _addSubject,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return SubjectCard(
                    subject: subjects[index],
                    onIncrement: () => _incrementCompletedLabs(subjects[index]),
                    onDecrement: () => _decrementCompletedLabs(subjects[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildFloatingActions() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: _showAddSubjectDialog,
            tooltip: 'Add Subject',
            child: const Icon(Icons.add),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              tooltip: 'Profile',
              child: const Icon(Icons.account_circle),
            ),
          ),
        ),
      ],
    );
  }

  void _addSubject() {
    final String name = subjectController.text;
    final int totalLabs = int.tryParse(totalLabsController.text) ?? 0;
    final int completedLabs = int.tryParse(completedLabsController.text) ?? 0;

    if (name.isNotEmpty && totalLabs > 0) {
      setState(() {
        subjects.add(Subject(name, totalLabs, completedLabs));
        subjectController.clear();
        totalLabsController.clear();
        completedLabsController.clear();
      });
    }
  }

  void _incrementCompletedLabs(Subject subject) {
    setState(() {
      if (subject.completedLabs < subject.totalLabs) {
        subject.completedLabs++;
      }
    });
  }

  void _decrementCompletedLabs(Subject subject) {
    setState(() {
      if (subject.completedLabs > 0) {
        subject.completedLabs--;
      }
    });
  }

  void _showAddSubjectDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Subject'),
          content: AddSubjectForm(
            subjectController: subjectController,
            totalLabsController: totalLabsController,
            completedLabsController: completedLabsController,
            onAddSubject: _addSubject,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}