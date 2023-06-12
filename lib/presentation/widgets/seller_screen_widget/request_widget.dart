import 'package:e_mech/presentation/seller_screens/seller_user_tracing.dart';
import 'package:e_mech/presentation/widgets/profile_pic.dart';
import 'package:e_mech/presentation/widgets/request_widget_button.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/call_widget.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/firebase_user_repository.dart';
import '../../../domain/entities/request_model.dart';

class RequestWidget extends StatefulWidget {
  final RequestModel requestModel;
  RequestWidget({
    Key? key,
    required this.requestModel,
  }) : super(key: key);
  bool? isAccepted = false;
  String text = "Accepted";
  @override
  State<RequestWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
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
            offset: const Offset(0, 3), // changes position of shadow
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
              CallWidget(
                num: widget.requestModel.senderPhone!,
                context: context,
                radius: 24.r,
                iconSize: 18.h,
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
                        widget.requestModel.serviceRequired ?? "Service Null",
                        style: CustomTextStyle.font_14_red,
                      ),
                      // Text(
                      //   "petrol",
                      //   style: CustomTextStyle.font_14_red,
                      // ),
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
                              widget.text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              InkWell(
                                child: RequestWidgetButton(
                                    text: "Delete",
                                    color: Styling.primaryColor),
                                onTap: () async {
                                  setState(() {
                                    widget.isAccepted = true;
                                    widget.text = "Accepted";
                                  });
                                  await FirebaseUserRepository
                                      .deleteRequestDocument(
                                          "Request",
                                          widget.requestModel.documentId!,
                                          context);
                                },
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              InkWell(
                                child: RequestWidgetButton(
                                    text: "Accept", color: Colors.black),
                                onTap: () async {
                                  setState(() {
                                    widget.isAccepted = true;
                                    widget.text = "Accepted";
                                  });
                                  await FirebaseUserRepository.acceptRequest(
                                      widget.requestModel, context);

                                  utils.toastMessage("Request Accepted");
                                },
                              )
                            ],
                          ),
                        ),
                ]),
          )
        ],
      ),
    );
  }
}
