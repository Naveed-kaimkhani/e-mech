import 'package:e_mech/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../style/images.dart';
import '../widgets/user_screen_widget/services_n_setting_header.dart';

class Services extends StatelessWidget {
  Divider k = const Divider(
    color: Color.fromARGB(255, 174, 171, 171), //color of divider
    height: 4, //height spacing of divider
    thickness: 1, //thickness of divier line
    indent: 25, //spacing at the start of divider
    endIndent: 25, //spacing at the end of divider
  );
  Services({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ServicesNSettingHeader(text: 'Services Available'),
          SizedBox(
            height: 10.h,
          ),
          services_screen_widgets(
            text: "Petrol",
            imageURL: Images.petrol,
            routeName: RoutesName.PetrolProviders,
          ),
          k,
          services_screen_widgets(
            text: "Puncture",
            imageURL: Images.wheel,
            routeName: "",
          ),
          k,
          services_screen_widgets(
            text: "General Mechanic",
            imageURL: Images.mechanic_pic,
            routeName: "",
          ),
          k,
        ],
      ),
    );
  }
}

class services_screen_widgets extends StatelessWidget {
  String text;
  String imageURL;
  String routeName;
  services_screen_widgets({
    required this.routeName,
    required this.imageURL,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        child: ListTile(
          title: Text(text),
          leading: Image.asset(imageURL),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }
}
