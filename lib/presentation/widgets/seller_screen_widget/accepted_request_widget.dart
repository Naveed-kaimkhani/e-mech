import 'package:e_mech/presentation/auth_screens/user_auth/user_login.dart';
import 'package:e_mech/presentation/seller_screens/seller_user_tracing.dart';
import 'package:e_mech/presentation/widgets/profile_pic.dart';
import 'package:e_mech/presentation/widgets/seller_screen_widget/test.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/images.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/firebase_user_repository.dart';
import '../../../domain/entities/request_model.dart';
import '../../auth_screens/seller_auth/seller_login.dart';

class AcceptedRequestWidget extends StatefulWidget {
  final RequestModel requestModel;
  AcceptedRequestWidget({
    Key? key,
    required this.requestModel,
  }) : super(key: key);
  @override
  State<AcceptedRequestWidget> createState() => _AcceptedRequestWidgetState();
}

class _AcceptedRequestWidgetState extends State<AcceptedRequestWidget> {
  final FirebaseUserRepository _firebaseRepository = FirebaseUserRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
      height: 119.h,
      width: 355.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.redAccent),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, top: 4.h),
                    child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        height: 40.h,
                        width: 40.w,
                        child: ProfilePic(
                          height: 35.h,
                          width: 35.w,
                          url: widget.requestModel.senderProfileImage!,
                        )),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    // widget.requestModel!.senderName!,
                    widget.requestModel.senderName ?? "No Sender Name",
                    style: CustomTextStyle.font_20,
                  ),
                ],
              ),
              const Icon(
                Icons.phone,
                size: 30,
              )
            ],
          ),
          SizedBox(
            height: 6.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Service Required",
                        style: CustomTextStyle.font_15_black,
                      ),
                      Text(
                        widget.requestModel?.serviceRequired ?? "Service Null",
                        style: CustomTextStyle.font_14_red,
                      ),
                      // Text(
                      //   "petrol",
                      //   style: CustomTextStyle.font_14_red,
                      // ),
                    ],
                  ),
                  InkWell(
                    child: request_widget_button(
                      text: "Location",
                      color: Colors.black,
                    ),
                    onTap: () {
                      print("location button prassed");
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SellerUserTracing(
                                  requestModel: widget.requestModel,
                                )),
                      );
                    },
                  )
                ]),
          )
        ],
      ),
    );
  }
}

class request_widget_button extends StatelessWidget {
  String text;
  Color color;
  request_widget_button({
    required this.text,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 90.w,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: color),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
