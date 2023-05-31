import 'dart:async';

import 'package:e_mech/domain/entities/request_model.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/seller_model.dart';
import '../controllers/seller_provider.dart';

class SellerUserTracing extends StatefulWidget {
  RequestModel requestModel;
  SellerUserTracing({super.key, required this.requestModel});

  @override
  State<SellerUserTracing> createState() => _SellerUserTracingState();
}

class _SellerUserTracingState extends State<SellerUserTracing> {
  LatLng? sourceLocation;
  LatLng? destinationLocation;
  SellerModel? seller;

  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> _marker = [];

  List<LatLng> polyLineCoordinates = [];
  Position? currentLocation;

  void getUserCurrentLocation() async {
    try {
      // await Geolocator.requestPermission();
      currentLocation = await Geolocator.getCurrentPosition();

      Geolocator.getPositionStream().listen(
        (Position position) async {
          // Do something with the updated position
          GoogleMapController controller = await _controller.future;
          
          setState(() {
            currentLocation = position;
          controller
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18,
          )));
          });

          

          // print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
        },
        onError: (e) {
          print(e);
        },
      );
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      return null; // or throw the error
    }
  }

  void getPolyPoints() async {
    print("in getpolyPoints");
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyD6sruWDaBsYEfYdMDCuEwTvq_5Mk5bK7o',
        PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
        PointLatLng(
            destinationLocation!.latitude, destinationLocation!.longitude));
    print("end getRouteBetweenCoordinates");
    if (result.points.isNotEmpty) {
      print(result.points);
      print("in if");
      result.points.forEach((PointLatLng point) =>
          polyLineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
      print("if end");
    }

    print("end get");
  }

  // //start listen location
  // void startListeningLocation() async {
  //   Geolocator.getPositionStream().listen(
  //     (Position position) async {
  //       // Do something with the updated position
  //       GoogleMapController controller = await _controller.future;

  //       setState(() {
  //         currentLocation = position;
  //         controller
  //             .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //           target:
  //               LatLng(currentLocation!.latitude, currentLocation!.longitude),
  //           zoom: 28,
  //         )));
  //       });

  //       // print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  //     },
  //     onError: (e) {
  //       utils.flushBarErrorMessage(e.toString(), context);
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();

    utils.checkConnectivity(context);
    seller = Provider.of<SellerProvider>(context, listen: false).seller;
    sourceLocation = LatLng(seller!.lat!, seller!.long!);
    destinationLocation =
        LatLng(widget.requestModel.senderLat!, widget.requestModel.senderLong!);
    getPolyPoints();
    getUserCurrentLocation();
    
  }

  @override
  Widget build(BuildContext context) {
    print("in build");
    return SafeArea(
      child: Scaffold(
        body: currentLocation == null
            ? Text("Loading")
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentLocation!.latitude, currentLocation!.latitude),
                    zoom: 18),
                compassEnabled: true,
                markers: {
                  Marker(
                    markerId: MarkerId("CurrentLocation"),
                    position: LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                  ),
                  Marker(
                    markerId: MarkerId("Source"),
                    position: sourceLocation!,
                  ),
                  Marker(
                    markerId: MarkerId("Destination"),
                    position: destinationLocation!,
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                polylines: {
                  Polyline(
                    polylineId: PolylineId('route'),
                    points: polyLineCoordinates,
                    color: Styling.primaryColor,
                    width: 6,
                  )
                },
              ),
      ),
    );
  }
}
