
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

import '../entities/user_model.dart';

abstract class UsersRepository {
  Future<UserModel?> getUser();
  Future<User?> signUpUser(String email, String password);
  Future<void> saveUserDataToFirestore(UserModel userModel);
  Future<String> uploadProfileImage(
      {required Uint8List? imageFile, required String uid});
}
