import 'dart:convert';

import 'package:my_project/entity/user.dart';
import 'package:my_project/repository/current_user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsCurrentUserRepository extends CurrentUserRepository {
  final SharedPreferences _prefs;
  final String _currentUserKey = 'currentUser';

  SharedPrefsCurrentUserRepository(this._prefs);

  @override
  Future<void> saveCurrentUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_currentUserKey, userJson);
  }

  @override
  Future<User?> getCurrentUser() async {
    final userJson = _prefs.getString(_currentUserKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    }
    return null;
  }

  @override
  Future<void> removeCurrentUser() async {
    await _prefs.remove(_currentUserKey);
  }
}