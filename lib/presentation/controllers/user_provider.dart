import 'package:flutter/material.dart';

import '../../domain/entities/user_model.dart';
import '../../domain/repositories/users_repository.dart';
import '../../utils/storage_services.dart';

class UserProvider with ChangeNotifier {
  final UsersRepository usersRepository;

  UserProvider({required this.usersRepository});
  UserModel? _userDetails;
  UserModel? get users => _userDetails;


  Future getUserLocally() async {

    _userDetails = await StorageService.readUser();
    notifyListeners();
  }

  Future<void> getUser() async {
    _userDetails = await usersRepository.getUser();
    notifyListeners();
  }
}
