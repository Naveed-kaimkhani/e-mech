
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mech/providers/user_provider.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../domain/entities/request_model.dart';
import '../domain/entities/seller_model.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/users_repository.dart';
import '../providers/all_sellerdata_provider.dart';

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
      if (userModel != null) {
        return userModel;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<SellerModel?> getSeller() async {
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
    // await _sellerCollection
    //     .doc(utils.currentUserUid)
    //     .collection('AcceptedRequest')
    //     .add(requestModel.toMap(requestModel));

                final DocumentReference requestRef = await _sellerCollection
            .doc(utils.currentUserUid)
            .collection('AcceptedRequest')
            .add(requestModel.toMap(requestModel));
            
        final String documentId = requestRef.id;
        await requestRef.update({'documentId': documentId});
    await deleteRequestFromEverySeller(requestModel.serviceId!, context);

    // Show success message or perform other operations
    utils.toastMessage("Request Accepted");
  } catch (e) {
    // Handle error
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
  } catch (e) {
utils.toastMessage(e.toString());
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
  
  Future<Position?> getUserCurrentLocation(context) async {
    try {
      await Geolocator.requestPermission();
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Location Permission Required"),
              content: const Text(
                "Please enable location permission from the app settings to access your current location.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
      return await Geolocator.getCurrentPosition();
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      return null; // or throw the error
    }
  }

  loadDataOnAppInit(context) async {
    try {
      final value = await getUserCurrentLocation(context);
      String address =
          await utils.getAddressFromLatLng(value!.latitude, value.longitude);

      await addlatLongToFirebaseDocument(
        value.latitude,
        value.longitude,
        address,
        'users',
      );

      await Provider.of<UserProvider>(context, listen: false)
          .getUserFromServer(context);

      await Provider.of<AllSellerDataProvider>(context, listen: false)
          .getSellersDataFromServer(context);

      // Navigate to the home screen after loading the data
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      // Handle error if any
    }
  }

static Future<void> sendRequestForSpecificService(
    String sellerId,
    RequestModel requestModel,
    context,
  ) async {
    try {
        final DocumentReference requestRef = await _sellerCollection
            .doc(sellerId)
            .collection('Request')
            .add(requestModel.toMap(requestModel));

        final String documentId = requestRef.id;

        await requestRef.update({'documentId': documentId});
      
      utils.toastMessage("Request Sent");
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


static Future<void> deleteRequestFromEverySeller(String serviceId,context) async {
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
          await requestCollection.where('serviceId', isEqualTo: serviceId).get();

      // Delete each document in the "Request" subcollection
      for (DocumentSnapshot requestDocument in requestQuerySnapshot.docs) {
        await requestDocument.reference.delete();
      }
    }
  } catch (e) {
    // print('Error deleting documents: $e');
    utils.flushBarErrorMessage('Error deleting documents: $e',context);
  }
}

static Future<void> deleteRequestDocument(String subCollection, String requestId , context) async {
  try {
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(utils.currentUserUid)
        .collection(subCollection)
        .doc(requestId)
        .delete();
        utils.toastMessage("Request deleted");
  } catch (error) {
    utils.flushBarErrorMessage(error.toString(), context);
  }
}

static Future<List<Map<String, dynamic>>> getSellersBasedOnService(String service) async {
  List<Map<String, dynamic>> sellersList = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("sellers")
        .where("service", isEqualTo: service)
        .get();

    querySnapshot.docs.forEach((doc) {
    sellersList.add(doc.data() as Map<String, dynamic>);

    });
  } catch (e) {
    // Handle any errors that may occur
  utils.toastMessage(e.toString());
  }

  return sellersList;
}

}
