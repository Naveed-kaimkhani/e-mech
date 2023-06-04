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
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      print(userModel.lat);
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

static Future<void> acceptRequest(RequestModel requestModel, context) async {
  try {
    // Add the request to the "AcceptedRequest" subcollection of the current seller
    await _sellerCollection
        .doc(utils.currentUserUid)
        .collection('AcceptedRequest')
        .add(requestModel.toMap(requestModel));
        print("request accepted");
    // Delete the request from every seller
    await deleteRequestFromEverySeller(requestModel.documentId!, context);

    // Show success message or perform other operations
    utils.toastMessage("Request Accepted");
  } catch (e) {
    // Handle error
    print('Error accepting request: $e');
  }
}


Future<void> addlatLongToFirebaseDocument(double lat, double long, String address,String documentName) async {
  try {
    final userRef = FirebaseFirestore.instance.collection(documentName).doc(utils.currentUserUid);

    await userRef.update({
      'lat':lat,
      'long':long,
      'address':address,
    });
    // utils.toastMessage("Location Updated");
  } catch (e) {
    // utils.flushBarErrorMessage(e.toString(),context);
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
static Future<void> sentRequest(
    List<SellerModel> sellers,
    RequestModel requestModel,
    context,
  ) async {
    try {
      for (SellerModel seller in sellers) {
        final DocumentReference requestRef = await _sellerCollection
            .doc(seller.uid)
            .collection('Request')
            .add(requestModel.toMap(requestModel));

        final String documentId = requestRef.id;

        await requestRef.update({'documentId': documentId});
      }
      
      // utils.toastMessage("Request Sent");
    } catch (error) {
      // Handle the error appropriately
      utils.flushBarErrorMessage('Error sending request: $error', context);
      throw FirebaseException(
        plugin: 'FirebaseUserRepository',
        message: 'Failed to send request to sellers.',
      );
    }
  }

static Stream<List<RequestModel>> getRequests(context) async* {
  try {
    final CollectionReference requestCollection = FirebaseFirestore.instance
        .collection("sellers")
        .doc(utils.currentUserUid)
        .collection('Request');

    yield* requestCollection.snapshots().map((snapshot) {
      final List<RequestModel> models = snapshot.docs
          .map((docsSnap) => RequestModel.fromMap(docsSnap.data() as dynamic))
          .toList();
      return models;
    });
  } catch (e) {
    // Handle any potential errors here
    utils.flushBarErrorMessage('Error fetching requests: $e', context);
    // print('Error fetching requests: $e');
    yield []; // Yield an empty list in case of an error
  }
}

static Stream<List<RequestModel>> getAcceptedRequests(context) async* {
  try {
    final CollectionReference requestCollection = FirebaseFirestore.instance
        .collection("sellers")
        .doc(utils.currentUserUid)
        .collection('AcceptedRequest');

    yield* requestCollection.snapshots().map((snapshot) {
      final List<RequestModel> models = snapshot.docs
          .map((docsSnap) => RequestModel.fromMap(docsSnap.data() as dynamic))
          .toList();
      return models;
    });
  } catch (e) {
    // Handle any potential errors here
    utils.flushBarErrorMessage('Error fetching requests: $e', context);
    // print('Error fetching requests: $e');
    yield []; // Yield an empty list in case of an error
  }
}


static Future<void> deleteRequestFromEverySeller(String documentId,context) async {
  try {

    // Retrieve all documents in the sellers collection
    QuerySnapshot querySnapshot = await _sellerCollection.get();

    // Iterate over the documents
    for (DocumentSnapshot sellerDocument in querySnapshot.docs) {
      // Get a reference to the "Request" subcollection of the current seller document
      CollectionReference requestCollection =
          sellerDocument.reference.collection('Request');

      // Query for documents that contain the specified document ID
      QuerySnapshot requestQuerySnapshot =
          await requestCollection.where('documentId', isEqualTo: documentId).get();

      // Delete each document in the "Request" subcollection
      for (DocumentSnapshot requestDocument in requestQuerySnapshot.docs) {
        await requestDocument.reference.delete();
      }
    }
    print("request deleted ");
  } catch (e) {
    // print('Error deleting documents: $e');
    utils.flushBarErrorMessage('Error deleting documents: $e',context);
  }
}

}
