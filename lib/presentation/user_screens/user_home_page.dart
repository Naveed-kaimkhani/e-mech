import 'dart:async';
import 'package:e_mech/data/firebase_user_repository.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/send_request_dialogue.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/seller_model.dart';
import '../widgets/hire_now_button.dart';
import '../widgets/user_homepage_header.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final FirebaseUserRepository _firebaseUserRepository =
      FirebaseUserRepository();
  final Completer<GoogleMapController> _controller = Completer();
  List<SellerModel>? _sellerModel;
  static CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(24.965508, 69.293713),
    zoom: 18,
  );

  SizedBox k = SizedBox(
    height: 20.h,
  );
  List<Marker> _marker = [];

  Future<Position?> getUserCurrentLocation() async {
    try {
      await Geolocator.requestPermission();
      return await Geolocator.getCurrentPosition();
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      return null; // or throw the error
    }
  }

  loadSellersData() async {
    List<SellerModel> sellers = await _firebaseUserRepository.getSellersData();
    setState(() {
      _sellerModel = sellers;
    });
    _createSellersMarkers();
  }

  loadLocation() {
    getUserCurrentLocation().then((value) async {
      String adress = await utils.getAddressFromLatLng(
          value!.latitude, value.longitude, context);

      await _firebaseUserRepository.addlatLongToFirebaseDocument(
          value.latitude, value.longitude, adress, 'users', context);

      addMarker(value, '1', 'My Position 1');

      setState(() {
        _cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          // zoom: 14.4746,
          zoom: 18,
        );
        animateCamera();
      });
    });
    // setState(() {});
  }

  void addMarker(Position value, String markerId, String title) {
    _marker.add(Marker(
        position: LatLng(value.latitude, value.longitude),
        markerId: MarkerId(markerId),
        infoWindow: InfoWindow(title: title)));
  }

  Future<void> animateCamera() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  void _createSellersMarkers() {
    _marker = _sellerModel!.map((seller) {
      final markerId = MarkerId(seller.name!);
      final marker = Marker(
        markerId: markerId,
        position: LatLng(seller.lat!, seller.long!),
        infoWindow: InfoWindow(title: seller.name),
      );
      return marker;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    //  loadLocation();
    //loadSellersData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            callButton(),
            k,
            locationButton(),
            k,
            InkWell(
              child: HireNowButton(text: "Hire Now",),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SendRequestDialogue();
                  },
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            // Container(
            //   height: 320.h,
            //   width: 575.w,
            //   color: Colors.black,
            // ),
            GoogleMap(
              initialCameraPosition: _cameraPosition,
              compassEnabled: true,
              markers: Set<Marker>.of(_marker),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            UserHomePageHeader(),
          ],
        ),
      ),
    );
  }

  Padding locationButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 110.0),
      child: FloatingActionButton(
          backgroundColor: Styling.primaryColor,
          heroTag: "btn2",
          child: const Icon(
            Icons.location_searching_outlined,
            color: Colors.white,
          ),
          onPressed: () async {
            animateCamera();
          }),
    );
  }

  Padding callButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 110.0),
      child: FloatingActionButton(
          backgroundColor: Styling.primaryColor,
          heroTag: "btn1",
          child: const Icon(
            Icons.call,
            color: Colors.white,
          ),
          onPressed: () async {
            animateCamera();
          }),
    );
  }
}