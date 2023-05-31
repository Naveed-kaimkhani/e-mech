import 'package:e_mech/domain/entities/seller_model.dart';
import 'package:e_mech/presentation/auth_screens/seller_auth/seller_login.dart';
import 'package:e_mech/presentation/auth_screens/user_auth/user_login.dart';
import 'package:e_mech/presentation/controllers/all_sellerdata_provider.dart';
import 'package:e_mech/presentation/controllers/seller_provider.dart';
import 'package:e_mech/presentation/controllers/user_provider.dart';
import 'package:e_mech/presentation/seller_screens/accepted_request.dart';
import 'package:e_mech/presentation/seller_screens/request_screen.dart';
import 'package:e_mech/presentation/seller_screens/seller_homepage.dart';
import 'package:e_mech/presentation/seller_screens/selller_signup.dart';
import 'package:e_mech/presentation/splash_screen.dart';
import 'package:e_mech/presentation/user_or_seller.dart';
import 'package:e_mech/presentation/auth_screens/user_auth/user_signup.dart';
import 'package:e_mech/presentation/user_screens/convert_latlang_toAdress.dart';
import 'package:e_mech/presentation/user_screens/get_user_current_location.dart';
import 'package:e_mech/presentation/user_screens/user_home_page.dart';
import 'package:e_mech/presentation/widgets/seller_screen_widget/accepted_request_widget.dart';
import 'package:e_mech/presentation/widgets/seller_screen_widget/request_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'data/firebase_user_repository.dart';
import 'domain/repositories/users_repository.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // getIt.registerLazySingleton<UsersRepository>(() => FirebaseUserRepository());
  runApp(
      // // MultiProvider(
      // //   providers: [
      // //     ChangeNotifierProvider(
      // //       create: (_) =>
      // //           UserProvider(usersRepository: getIt())..getUser(),
      // //     ),
      // //   ],
      //   child: const MyApp(),
      // ),
      const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
  return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => SellerProvider()),
            ChangeNotifierProvider(create: (_) => AllSellerDataProvider()),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home:SellerLogin(),
          ),
        );
      },
      // child:
    );
  }
}
