
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../data/firebase_user_repository.dart';
import '../../domain/entities/seller_model.dart';
//import '../../domain/repositories/users_repository.dart';
import '../../utils/storage_services.dart';

class SellerProvider with ChangeNotifier {
  // final UsersRepository usersRepository;

  // SellerProvider({required this.usersRepository});
  SellerModel? _sellerDetails;
  SellerModel? get seller => _sellerDetails;


  Future getSellerLocally() async {

    _sellerDetails = await StorageService.readSeller();
    notifyListeners();
  }

  // Future<void> getUser() async {
  //   _userDetails = await usersRepository.getUser();
  //   notifyListeners();
  // }

  
  Future getSellerFromServer(String uid, context) async {
    final FirebaseUserRepository firebaseRepository = FirebaseUserRepository();
    _sellerDetails = await firebaseRepository.getSeller();
    if (_sellerDetails == null) {
      utils.flushBarErrorMessage("No user found",context);
    }
    notifyListeners();
  }
}
