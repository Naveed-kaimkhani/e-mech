import 'package:e_mech/presentation/auth_screens/seller_auth/seller_login.dart';
import 'package:e_mech/presentation/auth_screens/user_auth/user_login.dart';
import 'package:e_mech/presentation/auth_screens/user_auth/user_signup.dart';
import 'package:e_mech/presentation/seller_screens/selller_signup.dart';
import 'package:e_mech/presentation/user_screens/petrol_providers.dart';
import 'package:e_mech/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.sellerLogin:
        return _buildRoute(SellerLogin(), settings);

      case RoutesName.userSingup:
        return _buildRoute(UserSignup(), settings);

      case RoutesName.sellerSignup:
        return _buildRoute(SellerSignUp(), settings);

      case RoutesName.userLogin:
        return _buildRoute(UserLogin(), settings);
       
      case RoutesName.PetrolProviders:
        return _buildRoute(PetrolProviders(), settings); 
      default:
        return _buildRoute(const Scaffold(body: Center(
          child: Text("NO Route Found"),
        ),), settings);
    }
  }

  static _buildRoute(Widget widget, RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => widget, settings: settings);
  }
}
