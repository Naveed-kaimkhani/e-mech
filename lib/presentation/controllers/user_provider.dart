
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../data/firebase_user_repository.dart';
import '../../domain/entities/user_model.dart';
//import '../../domain/repositories/users_repository.dart';
import '../../utils/storage_services.dart';

class UserProvider with ChangeNotifier {
  // final UsersRepository usersRepository;

  // UserProvider({required this.usersRepository});
  UserModel? _userDetails;
  UserModel? get user => _userDetails;


  Future getUserLocally() async {

    _userDetails = await StorageService.readUser();
    notifyListeners();
  }

  // Future<void> getUser() async {
  //   _userDetails = await usersRepository.getUser();
  //   notifyListeners();
  // }

  
  Future getUserFromServer(context) async {
    final FirebaseUserRepository firebaseRepository = FirebaseUserRepository();
   _userDetails = await firebaseRepository.getUser();
   print(_userDetails!.lat!);
   print(_userDetails!.long);
    if (_userDetails == null) {
      utils.flushBarErrorMessage("No user found",context);
    }
    notifyListeners();
  }
}
