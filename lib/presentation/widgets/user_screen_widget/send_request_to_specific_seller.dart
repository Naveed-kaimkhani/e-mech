

import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/firebase_user_repository.dart';
import '../../../domain/entities/request_model.dart';
import '../../../domain/entities/seller_model.dart';
import '../../../style/styling.dart';

class SendRequestBttnForSpecificSeller extends StatelessWidget {
  SendRequestBttnForSpecificSeller({
    super.key,
    required this.seller,
    required this.height,
    required this.widht,
    required this.textSize,
  
  });

  final SellerModel seller;
  double height;
  double widht;
  double textSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: InkWell(
            child: Container(
              height: height,
              width: widht,
              // padding: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Styling.primaryColor),
              child: Center(
                child: Text(
                  "Send Request",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            onTap: () async {
              
              utils.toastMessage("Sending Request...");
              RequestModel request = RequestModel(
                serviceId: utils.getRandomid(),
                sentDate: utils.getCurrentDate(),
                sentTime: utils.getCurrentTime(),
                senderLat: seller.lat,
                senderLong: seller.long,
                serviceRequired: seller.service,
                senderName: seller.name,
                senderPhone: seller.phone,
                senderProfileImage: seller.profileImage,
              );
              await FirebaseUserRepository.sendRequestForSpecificService(
                  seller.uid!, request, context);
              utils.openRequestSentDialogue(context);
            }));
  }
}
