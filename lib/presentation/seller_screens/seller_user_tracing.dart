import 'dart:async';
import 'dart:ui' as ui;
import 'package:e_mech/domain/entities/request_model.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  final String apiKey = 'AIzaSyD6sruWDaBsYEfYdMDCuEwTvq_5Mk5bK7o';
  LatLng? sourceLocation = const LatLng(0.0, 0.0);
  LatLng? destinationLocation;
  SellerModel? seller;
  Uint8List? sellerTracingIcon;
  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> polyLineCoordinates = [];
  Position? currentLocation;
  StreamSubscription<Position>? positionStreamSubscription;
  static const double distanceThreshold =
      2; // Minimum distance in meters to trigger an update

  List<Marker> _marker = [];

  void getUserCurrentLocation() async {
    print("in getUserCurrentLocation");
    try {
      await Geolocator.requestPermission();
      // currentLocation = await Geolocator.getCurrentPosition();

      // currentLocation = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.high);
      currentLocation = await convertLatLngToPosition(
          LatLng(sourceLocation!.latitude, sourceLocation!.longitude));
      // utils.hideLoading();
      positionStreamSubscription = Geolocator.getPositionStream().listen(
  (Position position) async {
    print("in position listen");
    GoogleMapController controller = await _controller.future;

    setState(() {
      print("location initialized");
      currentLocation = position;
      print(currentLocation);
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
            zoom: 18,
          ),
        ),
      );
    });
    print("end");
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
    //  await Geolocator.checkPermission();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
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

  Future<Uint8List> getByteFromAssets(String path, int widht) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: widht);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Position> convertLatLngToPosition(LatLng latLng) async {
    return Position(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      isMocked: false,
      floor: null,
    );
  }

  addMarker() async {
    sellerTracingIcon = await getByteFromAssets("assets/man.png", 100);
    // final Uint8List sellerInitialPosition =
    //     await getByteFromAssets(Images.sellerInitialPosition, 100);
    // // final Uint8List sellerTracingIcon=await getByteFromAssets(Images.sellerTracingIcon, 50);

    // _marker.add(
    //   Marker(
    //       markerId: const MarkerId(
    //         "0",
    //       ),
    //       position:
    //           LatLng(currentLocation!.latitude, currentLocation!.longitude),
    //       icon: BitmapDescriptor.fromBytes(sellerTracingIcon),
    //       // icon: BitmapDescriptor.defaultMarker,
    //       infoWindow: const InfoWindow(title: "Current Position")),
    // );
    // _marker.add(
    //   Marker(
    //       markerId: const MarkerId("1"),
    //       position: LatLng(sourceLocation!.latitude, sourceLocation!.longitude),
    //       icon: BitmapDescriptor.fromBytes(sellerInitialPosition),
    //       infoWindow: const InfoWindow(title: "Your Position")),
    // );
    // _marker.add(Marker(
    //     markerId: const MarkerId("2"),
    //     position: destinationLocation!,
    //     infoWindow: const InfoWindow(title: "User Position")));
    // setState(() {});
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    super.dispose();
  }

//   @override
//   void initState() {
//     super.initState();

//     utils.checkConnectivity(context);

// // utils.showLoading(context);
//     seller = Provider.of<SellerProvider>(context, listen: false).seller;
//     sourceLocation = LatLng(seller!.lat!, seller!.long!);
//     destinationLocation =
//         LatLng(widget.requestModel.senderLat!, widget.requestModel.senderLong!);
//     addMarker();
//     getPolyPoints();
//     getUserCurrentLocation();
//   }
@override
void initState() {
  super.initState();

  utils.checkConnectivity(context);

  seller = Provider.of<SellerProvider>(context, listen: false).seller;
  sourceLocation = LatLng(seller!.lat!, seller!.long!);
  destinationLocation =
      LatLng(widget.requestModel.senderLat!, widget.requestModel.senderLong!);
  addMarker();
  getPolyPoints();
   getUserCurrentLocation();
  // Delay the execution of getUserCurrentLocation
  // Future.delayed(Duration.zero, () {
  //   getUserCurrentLocation();
  // });
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: currentLocation == null
            ? const Text("Loading")
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                    zoom: 18),
                compassEnabled: true,
                // markers: Set<Marker>.of(_marker),
                markers: {
                  Marker(
                      markerId: const MarkerId(
                        "0",
                      ),
                      position: LatLng(currentLocation!.latitude,
                          currentLocation!.longitude),
                      icon: BitmapDescriptor.fromBytes(sellerTracingIcon!),
                      // icon: BitmapDescriptor.defaultMarker,
                      infoWindow: const InfoWindow(title: "Current Position")),
                  Marker(
                      markerId: const MarkerId("1"),
                      position: LatLng(
                          sourceLocation!.latitude, sourceLocation!.longitude),
                      icon: BitmapDescriptor.defaultMarker,
                      infoWindow: const InfoWindow(title: "Your Position")),
                  Marker(
                      markerId: const MarkerId("2"),
                      position: destinationLocation!,
                      infoWindow: const InfoWindow(title: "User Position")),
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('route'),
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
