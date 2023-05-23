import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/images.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/firebase_user_repository.dart';
import '../../../domain/entities/request_model.dart';

class RequestWidget extends StatefulWidget {
  // final RequestModel? requestModel;
  RequestWidget({
    Key? key,
    // this.requestModel,
  }) : super(key: key);
  bool? isAccepted = false;
  String text = "Accepted";
  @override
  State<RequestWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
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
            spreadRadius: 5,
            blurRadius: 7,
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
                      height: 35.h,
                      width: 35.w,
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(Images.user),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    // widget.requestModel!.senderName!,
                    "sender name",
                    style: CustomTextStyle.font_20,
                  ),
                ],
              ),
              Icon(
                Icons.phone,
                size: 30,
              )
              // Text(
              //   // widget.requestModel!.sentDate.toString(),
              //   "sent date",
              //   style: CustomTextStyle.font_20,
              // ),
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
                      "Puncture",
                      style: CustomTextStyle.font_14_red,
                    ),
                    Text(
                      "petrol",
                      style: CustomTextStyle.font_14_red,
                    ),
                  ],
                ),
                widget.isAccepted!
                    ? Container(
                        height: 30.h,
                        width: 89.w,
                        padding: const EdgeInsets.all(28.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: Colors.black),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          children: [
                            InkWell(
                              child: request_widget_button(
                                  text: "Cancel", color: Colors.black),
                              onTap: () async {
                                setState(() {
                                  widget.isAccepted = true;
                                });
                                // await _firebaseRepository.acceptConnectionRequest(
                                //     requestModel: widget.requestModel!);
                                // utils.toastMessage("Request Accepted");
                              },
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            InkWell(
                              child: request_widget_button(
                                text: "Accept",
                                color: Styling.primaryColor,
                              ),
                              onTap: () async {
                                setState(() {
                                  widget.isAccepted = true;
                                  widget.text = "Declined";
                                });
                                // await _firebaseRepository.declineConnectionRequest(
                                //     requestModel: widget.requestModel!);

                                utils.toastMessage("Request Declined");
                              },
                            ),
                          ],
                        ),
                      )
              ],
            ),
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
      width: 89.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r), color: color),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
