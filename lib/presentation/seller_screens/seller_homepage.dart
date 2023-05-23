import 'package:e_mech/presentation/widgets/seller_screen_widget/request_widget.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/firebase_user_repository.dart';

class SellerHomepage extends StatefulWidget {
  const SellerHomepage({super.key});

  @override
  State<SellerHomepage> createState() => _SellerHomepageState();
}

class _SellerHomepageState extends State<SellerHomepage> {
  final FirebaseUserRepository _firebaseUserRepository =
      FirebaseUserRepository();

  Future<Position?> getUserCurrentLocation() async {
    try {
      await Geolocator.requestPermission();
      return await Geolocator.getCurrentPosition();
    } catch (error) {
    
      utils.flushBarErrorMessage(error.toString(), context);
      return null; // or throw the error
    }
  }

loadLocation() {
    getUserCurrentLocation().then((value) async {
      String adress = await utils.getAddressFromLatLng(
          value!.latitude, value.longitude, context);

      await _firebaseUserRepository.addlatLongToSellerDocument(
          value.latitude, value.longitude, adress, context);
  });
}
  // void addMarker(Position value, String markerId, String title) {
  //   _marker.add(Marker(
  //       position: LatLng(value.latitude, value.longitude),
  //       markerId: MarkerId(markerId),
  //       infoWindow: InfoWindow(title: title)));
  // }


@override
void initState() {
  super.initState();
  loadLocation();
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: SingleChildScrollView(
        child: Column(
          children: [
            RequestWidget(),
          ],
        ),
      ),
    );
  }
}