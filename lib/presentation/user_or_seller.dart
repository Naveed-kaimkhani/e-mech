import 'package:e_mech/presentation/user_screens/user_signup.dart';
import 'package:e_mech/presentation/seller_screens/selller_signup.dart';
import 'package:e_mech/presentation/widgets/user_seller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/images.dart';
class UserSellerScreen extends StatelessWidget {
  const UserSellerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF5AD0D),
//        appBar: custom_appbar(),
        body: Stack(
          children: [
            Container(
              height: 833.h,
              width: 428.w,
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 139.h,
                  ),
                  UserSellerComponent(
                    height: 189.01.h,
                    width: 199.w,
                    image: 'assets/user.png',
                    text: "User",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserSignup(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 112.h,
                  ),
                  UserSellerComponent(
                      height: 189.01.h,
                      width: 199.w,
                      image: Images.seller,
                      text: "Seller",
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>const SellerSignUp(),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
