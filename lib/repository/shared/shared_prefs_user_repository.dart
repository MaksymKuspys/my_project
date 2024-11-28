import 'dart:convert';

import 'package:my_project/entity/user.dart';
import 'package:my_project/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUserRepository extends UserRepository {
  static const _usersKey = 'users';

  final SharedPreferences _prefs;

  SharedPrefsUserRepository(this._prefs);

  @override
  Future<void> add(User user) async {
    final users = await get();
    users.add(user);
    await _prefs.setString(_usersKey, json.encode(users));
  }

  @override
  Future<List<User>> get() async {
    final usersJson = _prefs.getString(_usersKey);
    if (usersJson != null) {
      final usersList = json.decode(usersJson) as List<dynamic>;

      return usersList.map((userJson) => User
          .fromJson(userJson as Map<String, dynamic>),).toList();
    }
    return [];
  }

  @override
  Future<User?> getUser(String email) async {
    final users = await get();

    for (var user in users) {
      if (user.email == email) {
        return user;
      }
    }

    return null;
  }
}