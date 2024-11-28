import 'package:my_project/entity/user.dart';

abstract class UserRepository {
  Future<void> add(User user);
  Future<List<User>> get();
  Future<User?> getUser(String email);
}