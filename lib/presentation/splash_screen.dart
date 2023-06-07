import 'dart:async';

import 'package:e_mech/presentation/controllers/all_sellerdata_provider.dart';
import 'package:e_mech/presentation/user_screens/user_home_page.dart';
import 'package:e_mech/presentation/widgets/emergency_service_provider_text.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../data/firebase_user_repository.dart';
import '../navigation_page.dart';
import '../style/images.dart';
import 'controllers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseUserRepository _firebaseUserRepository =
      FirebaseUserRepository();
  @override
  void initState() {
    utils.checkConnectivity(context);
    loadData();
    super.initState();

    // Timer(const Duration(seconds: 3), () {
    //   Navigator.of(context).pushReplacementNamed('/HomeScreen');
    // });
  }

  Future<Position?> getUserCurrentLocations() async {
    try {
      print("location");
      await Geolocator.requestPermission();
      //  print(Geolocator.getCurrentPosition());
      return await Geolocator.getCurrentPosition();
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      return null; // or throw the error
    }
  }

  Future<Position?> getUserCurrentLocation() async {
    try {
      print("location");
      await Geolocator.requestPermission();
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Location Permission Required"),
              content: Text(
                "Please enable location permission from the app settings to access your current location.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else if (permission == LocationPermission.denied) {
        return null;
      }
      return await Geolocator.getCurrentPosition();
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      return null; // or throw the error
    }
  }

  loadData() async {
    print("in splash");
    try {
      final value = await getUserCurrentLocation();
      print(value);
      String address =
          await utils.getAddressFromLatLng(value!.latitude, value.longitude);

      await _firebaseUserRepository.addlatLongToFirebaseDocument(
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationPage()),
      );
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      // Handle error if any
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 250.w,
            ),
            Image.asset(
              Images.logo,
              height: 180.h,
              width: 180.w,
            ),
            SizedBox(
              height: 230.w,
            ),
            const EmergencyServiceProviderText(),
            const Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SpinKitSpinningLines(
                color: Colors.black,
                size: 30.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
