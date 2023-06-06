import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../style/styling.dart';

class CallWidget extends StatelessWidget {
  String num;
  BuildContext context;
  CallWidget({
    required this.num,
    required this.context,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CircleAvatar(
        backgroundColor: Styling.primaryColor,
        radius: 20.h,
        child: Icon(
          Icons.call,
          color: Colors.white,
          size: 24.h,
        ),
      ),
      onTap: () {
        utils.launchphone('03103443527', context);
      },
    );
  }
}
