import 'dart:math';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import '../presentation/widgets/circle_progress.dart';

class utils {
  static toastMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static String getCurrentDate() {
    var now = DateTime.now();
    var formatterDate = DateFormat('dd/MM/yy');
    String actualDate = formatterDate.format(now);
    return actualDate;
  }

  static String getCurrentTime() {
    var now = DateTime.now();
    var formatterTime = DateFormat('kk:mm');
    String actualTime = formatterTime.format(now);
    return actualTime;
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        duration: const Duration(seconds: 5),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        // backgroundColor: const Color.fromARGB(255, 90, 89, 89),
        backgroundColor: Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(
          Icons.error,
          size: 28,
          color: Colors.white,
        ),
      )..show(context),
    );
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void checkConnectivity(context) {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      if (connected == false) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Center(
              child: Text("NO internet"),
            ),
          ),
        );
        // return connected;
      }
    });
    // return true;
  }

  static Future<Uint8List?> pickImage() async {
    //    ImagePicker picker=ImagePicker();
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    //print("before redusing size $file");
    if (file != null) {
      return file.readAsBytes();
    }
    return null;
  }

  static String get currentUserUid => FirebaseAuth.instance.currentUser!.uid;

  static hideLoading() {
    Navigator.pop(dialogContext);
  }

  static late BuildContext dialogContext;
  static showLoading(context) {
    // showDialog(context: context, builder: builder)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              height: 100.h,
              width: 20.w,
              child: const Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  CircleProgress(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Uploading... ')
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static FirebaseFirestore getFireStoreInstance() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db;
  }

  static User getCurrentUser() {
    return FirebaseAuth.instance.currentUser!;
  }

  static Future<SharedPreferences> getPreferencesObject() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  static String getRandomid() {
    return (100000 + Random().nextInt(10000)).toString();
  }

  static String getAddressFromPlacemark(Placemark placemark) {
    String address = '';

    // Extract relevant address components
    String name = placemark.name ?? '';
    String subLocality = placemark.subLocality ?? '';
    String locality = placemark.locality ?? '';
    String administrativeArea = placemark.administrativeArea ?? '';
    String postalCode = placemark.postalCode ?? '';
    String country = placemark.country ?? '';

    // Build the address string
    if (name.isNotEmpty) {
      address += '$name, ';
    }

    if (subLocality.isNotEmpty) {
      address += '$subLocality, ';
    }

    if (locality.isNotEmpty) {
      address += '$locality, ';
    }

    if (administrativeArea.isNotEmpty) {
      address += '$administrativeArea, ';
    }

    if (postalCode.isNotEmpty) {
      address += '$postalCode, ';
    }

    if (country.isNotEmpty) {
      address += country;
    }

    return address;
  }

  Future<Uint8List> getByteFromAssets(String path, int widht) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: widht);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
  static Future<String> getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address = utils.getAddressFromPlacemark(placemark);
        return address;
      } else {
        // utils.flushBarErrorMessage(
        //     "No address found for the given coordinates.", context);
      }
    } catch (e) {
      // utils.flushBarErrorMessage(e.toString(), context);
    }
    return '';
  }

//  static void animateCamera( GoogleMapController _controller , CameraPosition _cameraPosition  )async{

//      GoogleMapController controller = await _controller.future;
//             controller
//                 .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));

//   }
}
