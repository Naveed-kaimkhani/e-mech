// import 'package:e_mech/style/styling.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../style/styling.dart';

class MapLoading extends StatelessWidget {
  const MapLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Loading Map...",
          style: CustomTextStyle.font_14_red,
        ),
        SizedBox(
          height: 10,
        ),
        const SpinKitWave(
          color: Styling.primaryColor,
          size: 50.0,
        ),
      ],
    );
  }
}
