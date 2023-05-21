import 'dart:async';

import 'package:e_mech/style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  static const CameraPosition _currentPosition = CameraPosition(
    target: LatLng(24.965508, 69.293713),
    zoom: 14.4746,
  );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  List<Marker> _marker = [];

  final List<Marker> _list = [
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(24.965508, 69.293713),
        infoWindow: InfoWindow(title: "My Position"))
  ];

  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.location_searching_outlined),
              onPressed: () async {
                GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(const CameraPosition(
                  target: LatLng(24.965508, 69.293713),
                  zoom: 14,
                )));
              }),
          body: GoogleMap(
            myLocationEnabled: true,
            markers: Set<Marker>.of(_marker),
            initialCameraPosition: HomePage._currentPosition,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          )),
    );
  }
}
