import 'dart:async';
import 'package:e_mech/data/firebase_user_repository.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final FirebaseUserRepository _firebaseUserRepository =
      FirebaseUserRepository();
  final Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(24.965508, 69.293713),
    zoom: 18,
  );
  final List<Marker> _marker = [];

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

      await _firebaseUserRepository.addlatLongToUserDocument(
          value.latitude, value.longitude, adress, context);

      addMarker(value, '1', 'My Position');

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

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.location_searching_outlined),
          onPressed: () async {
            animateCamera();
          }),
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,
        compassEnabled: true,
        markers: Set<Marker>.of(_marker),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
