import 'package:flutter/material.dart';
import 'package:my_project/entity/subject.dart';
import 'package:my_project/repository/current_user_repository.dart';
import 'package:my_project/repository/shared/shared_prefs_current_user_repository.dart';
import 'package:my_project/repository/shared/shared_prefs_subject_repository.dart';
import 'package:my_project/repository/shared/shared_prefs_user_repository.dart';
import 'package:my_project/repository/user_repository.dart';
import 'package:my_project/service/connectivity_service.dart';
import 'package:my_project/service/subject_service.dart';
import 'package:my_project/service/user_service.dart';
import 'package:my_project/ui/widgets/add_subject_form.dart';
import 'package:my_project/ui/widgets/progress_overview.dart';
import 'package:my_project/ui/widgets/subject_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _subjectController = TextEditingController();
  final _totalLabsController = TextEditingController();
  final _completedLabsController = TextEditingController();
  SharedPrefsSubjectRepository? _subjectRepository;
  CurrentUserRepository? _currentUserRepository;
  UserRepository? _userRepository;
  SubjectService? _subjectService;
  ConnectivityService? _connectivityService;
  UserService? _userService;

  List<Subject> _subjects = [];

  Future<void> _initializeServices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _subjectRepository = SharedPrefsSubjectRepository(prefs);
    _currentUserRepository = SharedPrefsCurrentUserRepository(prefs);
    _userRepository = SharedPrefsUserRepository(prefs);
    _subjectService = SubjectService(_subjectRepository!);
    _userService = UserService(_userRepository!, _currentUserRepository!);
    if (mounted) {
      _connectivityService = ConnectivityService(context);
    }
  }

  Future<void> _initializeAndLoadSubjects() async {
    await _initializeServices();
    await _loadSubjects();
  }

  @override
  void initState() {
    super.initState();
    _initializeAndLoadSubjects();
  }

  @override
  void dispose() {
    _connectivityService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressOverview(subjects: _subjects),
            const SizedBox(height: 16),
            AddSubjectForm(
              subjectController: _subjectController,
              totalLabsController: _totalLabsController,
              completedLabsController: _completedLabsController,
              addSubject: _addSubject,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) =>
                    SubjectCard(
                      subject: _subjects[index],
                      incrementLabs: () =>
                          _incrementCompletedLabs(_subjects[index]),
                      decrementLabs: () =>
                          _decrementCompletedLabs(_subjects[index]),
                      removeSubject: () =>
                          _removeSubject(_subjects[index]),
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/profile'),
        child: const Icon(Icons.account_circle),
      ),
    );
  }

  Future<void> _loadSubjects() async {
    final subjects = await _subjectService!.getSubjects(
        (await _userService?.getCurrentUser())!.id,);
    setState(() {
      _subjects = subjects;
    });
  }

  Future<void> _addSubject() async {
    final name = _subjectController.text.trim();
    final totalLabs = int.tryParse(_totalLabsController.text.trim()) ?? 0;
    final completedLabs = int.tryParse(_completedLabsController.text.trim())
        ?? 0;

    if (name.isNotEmpty && totalLabs > 0) {
      final subject = Subject(const Uuid().v4(),
          name, totalLabs, completedLabs,
          (await _userService?.getCurrentUser())!.id,);
      await _subjectService!.addSubject(subject);
      _loadSubjects();
      _clearSubjectForm();
    }
  }

  void _clearSubjectForm() {
    _subjectController.clear();
    _totalLabsController.clear();
    _completedLabsController.clear();
  }

  Future<void> _incrementCompletedLabs(Subject subject) async {
    if (subject.completedLabs == subject.totalLabs) return;

    final updatedSubject = Subject(
      subject.id,
      subject.name,
      subject.totalLabs,
      subject.completedLabs + 1,
      subject.userId,
    );
    await _subjectService!.updateSubject(updatedSubject);
    _loadSubjects();
  }

  Future<void> _decrementCompletedLabs(Subject subject) async {
    if (subject.completedLabs == 0) return;

    final updatedSubject = Subject(
      subject.id,
      subject.name,
      subject.totalLabs,
      subject.completedLabs - 1,
      subject.userId,
    );
    await _subjectService!.updateSubject(updatedSubject);
    _loadSubjects();
  }

  Future<void> _removeSubject(Subject subject) async {
    await _subjectRepository!.deleteSubject(subject);
    _loadSubjects();
  }
}