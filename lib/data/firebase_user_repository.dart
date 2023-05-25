import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../domain/entities/request_model.dart';
import '../domain/entities/seller_model.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/users_repository.dart';
import 'models/user_json.dart';

class FirebaseUserRepository implements UsersRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection =
      firestore.collection('users');
  static final CollectionReference _sellerCollection =
      firestore.collection('sellers');
  final Reference _storageReference = FirebaseStorage.instance.ref();

  @override
  Future<User?> login(String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      utils.flushBarErrorMessage("Invalid email or password", context);
    }
  }

  @override
  Future<UserModel?> getUser() async {
    // var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    // var response = await http.get(url);
    // var list = jsonDecode(response.body) as List;
    // return list.map((e) => UserJson.fromJson(e).toDomain()).toList();
    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(utils.currentUserUid).get();
    if (documentSnapshot.data() != null) {
      UserModel? userModel =
          UserJson.fromJson(documentSnapshot.data() as Map<String, dynamic>)
              .toDomain();
      if (userModel != null) {
        return userModel;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<SellerModel?> getSeller() async {
    // var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    // var response = await http.get(url);
    // var list = jsonDecode(response.body) as List;
    // return list.map((e) => UserJson.fromJson(e).toDomain()).toList();
    DocumentSnapshot documentSnapshot =
        await _sellerCollection.doc(utils.currentUserUid).get();
    if (documentSnapshot.data() != null) {
      SellerModel? sellerModel =
          SellerModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      if (sellerModel != null) {
        return sellerModel;
      } else {
        return null;
      }
    }
    return null;
  }

  @override
  Future<User?> signUpUser(String email, String password, context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      //  print(error);
      utils.flushBarErrorMessage(error.message.toString(), context);
    }
    return null;
  }

  @override
  Future<void> saveUserDataToFirestore(UserModel userModel) async {
    await _userCollection.doc(userModel.uid).set(userModel.toMap(userModel));
  }

  @override
  Future<void> saveSellerDataToFirestore(SellerModel sellerModel) async {
    await _sellerCollection
        .doc(sellerModel.uid)
        .set(sellerModel.toMap(sellerModel));
  }

  @override
  Future<String> uploadProfileImage(
      {required Uint8List? imageFile, required String uid}) async {
    await _storageReference
        .child('profile_images')
        .child(uid)
        .putData(imageFile!);
    String downloadURL =
        await _storageReference.child('profile_images/$uid').getDownloadURL();
    return downloadURL;
  }

  @override
  Future<SellerModel?> getSellerDetails() async {
    DocumentSnapshot documentSnapshot = await _sellerCollection.doc(utils.currentUserUid).get();
    if (documentSnapshot.data() != null) {
      SellerModel seller =
          SellerModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      return seller;
    }
    return null;

    // else {
    //   // utils.flushBarErrorMessage("User not found", context)
    //   utils.toastMessage("No user found");
    //   Navigator.push
    // }
  }

  Future<void> accpetRequest(
      RequestModel requestModel) async {
    await _userCollection
        .doc(requestModel.senderUid)
        .collection('AcceptedRequest')
        .add(requestModel.toMap(requestModel));
    await declineRequest(requestModel);
  }

  Future<void> declineRequest(
      RequestModel requestModel) async {
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(requestModel.receiverUid)
  //       .collection('connectionRequest')
  //       .where("goalId", isEqualTo: requestModel.goalId)
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) {
  //       FirebaseFirestore.instance
  //           .collection("users")
  //           .doc(requestModel.receiverUid)
  //           .collection('connectionRequest')
  //           .doc(element.id)
  //           .delete()
  //           .then((value) {
  //         // print("Success!");
  //         // utils.toastMessage("Request Declined");
  //       });
  //     });
  //   });
  }

// Future<void> addlatLongToUserDocument(double lat, double long, String address,context) async {
//   try {
//     final userRef = FirebaseFirestore.instance.collection('users').doc(utils.currentUserUid);

//     await userRef.update({
//       'lat':lat,
//       'long':long,
//       'address':address,
//     });
//     utils.toastMessage("Location Updated");
//   } catch (e) {
//     utils.flushBarErrorMessage(e.toString(),context);
//   }
// }


Future<void> addlatLongToFirebaseDocument(double lat, double long, String address,String documentName,context) async {
  try {
    final userRef = FirebaseFirestore.instance.collection(documentName).doc(utils.currentUserUid);

    await userRef.update({
      'lat':lat,
      'long':long,
      'address':address,
    });
    utils.toastMessage("Location Updated");
  } catch (e) {
    utils.flushBarErrorMessage(e.toString(),context);
  }
}

Future<List<SellerModel>> getSellersData() async {
  final snapshot =
      await FirebaseFirestore.instance.collection("sellers").get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return SellerModel.fromMap(data);
  }).toList();
}

static Future<void> sentRequest(List<SellerModel> sellers, RequestModel requestModel) async {
  for (SellerModel seller in sellers) {
    await _sellerCollection
        .doc(seller.uid)
        .collection('Request')
        .add(requestModel.toMap(requestModel));
  }
}

}
