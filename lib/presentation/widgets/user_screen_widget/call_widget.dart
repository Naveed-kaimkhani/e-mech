import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../style/styling.dart';

class CallWidget extends StatelessWidget {
  String num;
  double radius;

  double iconSize;
  BuildContext context;
  CallWidget({
    required this.iconSize,
    required this.radius,
    required this.num,
    required this.context,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CircleAvatar(
        backgroundColor: Styling.primaryColor,
        radius: radius,
        child: Icon(
          Icons.call,
          color: Colors.white,
          size: iconSize,
        ),
      ),
      onTap: () {
        utils.launchphone(num, context);
      },
    );
  }
}
