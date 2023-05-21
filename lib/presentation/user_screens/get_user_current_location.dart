import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserCurrentLocation extends StatefulWidget {
  const GetUserCurrentLocation({super.key});

  @override
  State<GetUserCurrentLocation> createState() => _GetUserCurrentLocationState();
}

class _GetUserCurrentLocationState extends State<GetUserCurrentLocation> {
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
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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