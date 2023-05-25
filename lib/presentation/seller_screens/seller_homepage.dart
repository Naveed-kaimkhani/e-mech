import 'package:e_mech/presentation/widgets/seller_screen_widget/request_widget.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../data/firebase_user_repository.dart';
import '../../domain/entities/request_model.dart';
import '../../domain/entities/seller_model.dart';
import '../controllers/seller_provider.dart';
import '../controllers/user_provider.dart';
import '../widgets/user_homepage_header.dart';

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

      await _firebaseUserRepository.addlatLongToFirebaseDocument(
          value.latitude, value.longitude, adress, 'sellers', context);
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
    // loadLocation();
  }

  @override
  Widget build(BuildContext context) {
    SellerModel? seller =
        Provider.of<SellerProvider>(context, listen: false).seller;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              UserHomePageHeader(
                name: "naveed",
                text: "All Requst",
              ),
              SizedBox(
                height: 35.h,
              ),
              FutureBuilder(
                builder: (ctx, AsyncSnapshot<List<RequestModel>> snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: Text("No Request"));
                  } else if (snapshot.hasError) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.data!.length == 0) {
                    return const Center(child: Text("No Request"));
                  } else {
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            // the number of items in the list
                            itemCount: snapshot.data!.length,

                            // display each item of the product list
                            itemBuilder: (context, index) {
                              return RequestWidget();
                            }));
                  }
                },
                future: FirebaseUserRepository.getRequests(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
