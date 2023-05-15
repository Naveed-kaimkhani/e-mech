import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../style/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer(const Duration(seconds: 3), () {
    //   Navigator.of(context).pushReplacementNamed('/HomeScreen');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 200.w,
            ),
            Image.asset(
              Images.logo,
              height: 200.h,
              width: 200.w,
            ),
            // const Padding(
            //   padding: EdgeInsets.only(top: 350.0),
            // ),
            SizedBox(
              height: 200.w,
            ),
            const Text(
              "Emergency Service Provider",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            // const Text(
            //   "Loading...",
            //   style: TextStyle(fontSize: 16.0, color: Colors.black),
            // ),
         const SpinKitRotatingCircle(
  color: Colors.white,
  size: 50.0,
)
          ],
        ),
      ),
    );
  }
}
