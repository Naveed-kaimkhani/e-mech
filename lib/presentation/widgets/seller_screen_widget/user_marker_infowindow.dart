import 'package:e_mech/presentation/widgets/user_screen_widget/call_widget.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/send_request_to_specific_seller.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/request_model.dart';
import '../../../style/custom_text_style.dart';
import '../profile_pic.dart';

class UserMarkerInfoWindow extends StatefulWidget {
  RequestModel seller;

  UserMarkerInfoWindow({super.key, required this.seller});

  @override
  State<UserMarkerInfoWindow> createState() => _UserMarkerInfoWindowState();
}

class _UserMarkerInfoWindowState extends State<UserMarkerInfoWindow> {
  // bool isRequestSend = false;
  String? address='';
getAddress()async{

        address = await utils.getAddressFromLatLng(widget.seller.senderLat!, widget.seller.senderLong!);

}

  @override
  Widget build(BuildContext context) {
    int midIndex =
        address!.length ~/ 2; // Calculate the middle index

    String firstLine = address!.substring(0, midIndex);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding:
            const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
        // padding: EdgeInsets.all(20),
        height: 150.h,
        width: 300.w,
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
                            url: widget.seller.senderProfileImage,
                          )),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // widget.requestModel!.senderName!,
                          widget.seller.senderName ?? "No Sender Name",
                          style: CustomTextStyle.font_20,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Styling.primaryColor,
                              size: 12.h,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              // widget.seller.workshopName!,
                              firstLine,
                              style: CustomTextStyle.font_15_black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // CallWidget(num: widget.seller.phone!, context: context),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 40.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service",
                          style: CustomTextStyle.font_15_black,
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Styling.primaryColor,
                              radius: 5,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              widget.seller.serviceRequired ?? "Service Null",
                              style: CustomTextStyle.font_14_red,
                            ),
                          ],
                        ),
                       
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CallWidget(
                        num: widget.seller.senderPhone!,
                        context: context,
                        radius: 20.r,
                        iconSize: 16.h,
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
