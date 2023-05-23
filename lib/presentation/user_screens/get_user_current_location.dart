import 'dart:async';

import 'package:e_mech/data/firebase_user_repository.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserCurrentLocation extends StatefulWidget {
  const GetUserCurrentLocation({super.key});

  @override
  State<GetUserCurrentLocation> createState() => _GetUserCurrentLocationState();
}

class _GetUserCurrentLocationState extends State<GetUserCurrentLocation> {
  FirebaseUserRepository _firebaseUserRepository= FirebaseUserRepository();
  final Completer<GoogleMapController> _controller=Completer();
static const CameraPosition _currentPosition = CameraPosition(
    target: LatLng(24.965508, 69.293713),
    zoom: 14.4746,
  );
  // List<Marker> _marker = [];

  final List<Marker> _marker  = [
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(24.965508, 69.293713),
        infoWindow: InfoWindow(title: "My Position"))
  ];
  //   Future<Position> getUserCurrentLocation() async{
  //     await Geolocator.requestPermission().then((value){
          
  //     }).onError((error, stackTrace) {
  //       print(error);
  //     });
  // return await Geolocator.getCurrentPosition();
  //   }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String address =
          '${placemark.street}, ${placemark.postalCode}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
      print(address);
      return address;
    }
  } catch (e) {
    utils.flushBarErrorMessage(e.toString(),context);
    print('Error: $e');
  }

  return '';
}

  Future<Position?> getUserCurrentLocation() async {
  try {
    await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition();
  } catch (error) {
    // print(error);
    utils.flushBarErrorMessage(error.toString(), context);
    // Handle the error as needed
    return null; // or throw the error
  }
}

    loadLocation(){
         getUserCurrentLocation().then((value) async {
                  // print(value!.latitude);
                  // print(value.longitude);
                String adress=await  getAddressFromLatLng(value!.latitude, value.longitude);
                 _firebaseUserRepository.addlatLongToUserDocument(value.latitude, value.longitude, adress, context);
                  _marker.add(
                    Marker(
                      position: LatLng(value.latitude,value.longitude),
                      markerId: MarkerId('2'),
                      infoWindow: InfoWindow(title: "My Position")
                      )
    
    
                  );
              CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(value.latitude, value.longitude),
    zoom: 14.4746,
  );
    final GoogleMapController controller= await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
              });
              setState(() {
                
              });
    }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLocation();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton(
              child:const Icon(Icons.location_searching_outlined),
              onPressed: () async {
           
              }),
        body: GoogleMap(
          initialCameraPosition:_currentPosition,
           compassEnabled: true,
            markers: Set<Marker>.of(_marker),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            ),
    );
  }
}