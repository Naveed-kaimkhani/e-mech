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
import '../widgets/seller_screen_widget/test.dart';
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
      return await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.bestForNavigation,

      );
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      return null; // or throw the error
    }
  }
// this function fill be used when the seller location is need to update everytime he open the app
  loadLocation() {
    getUserCurrentLocation().then((value) async {

      String adress = await utils.getAddressFromLatLng(
          value!.latitude, value.longitude, context);

      await _firebaseUserRepository.addlatLongToFirebaseDocument(
          value.latitude, value.longitude, adress, 'sellers', context);
    });
    Provider.of<SellerProvider>(context, listen: false)
        .getSellerFromServer(context);
  }

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
                name: "Hii ${seller!.name}",
                text: "All Requst",
              ),
              SizedBox(
                height: 35.h,
              ),
              StreamBuilder<List<RequestModel>>(
                stream: FirebaseUserRepository.getRequests(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const CircularProgressIndicator();
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Request"));
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RequestWidget(
                              requestModel: snapshot.data![index],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
