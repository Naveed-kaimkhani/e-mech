import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/user_model.dart';

class StorageService {
  static late SharedPreferences _sharedPreferences;

  static Future<void> saveUser(UserModel userModel) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(
        'user', json.encode(userModel.toMap(userModel)));
  }

  static Future<UserModel?> readUser() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('user') == null
        ? null
        : UserModel.fromMap(
            json.decode(_sharedPreferences.getString('user')!));
  }

  static Future<void> clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }
}