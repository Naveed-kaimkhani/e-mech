import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../style/custom_text_style.dart';

class UserHomePageHeader extends StatelessWidget {
  const UserHomePageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90.h,
        width: 355.w,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hi Faisal',
                  style: CustomTextStyle.font_25,
                ),
                Text(
                  'Find Mechanic Now',
                  style: CustomTextStyle.font_20,
                ),
              ],
            )
          ],
        ));
  }
}
