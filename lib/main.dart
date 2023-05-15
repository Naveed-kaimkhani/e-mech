import 'package:e_mech/ui/splash_screen.dart';
import 'package:e_mech/ui/users_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'data/rest_api_users_repository.dart';
import 'domain/repositories/users_repository.dart';

GetIt getIt = GetIt.instance;

void main() async {
  getIt.registerLazySingleton<UsersRepository>(() => RestApiUsersRepository());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              UsersListProvider(usersRepository: getIt())..getUsers(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashScreen(),
        );
      },
      // child:
    );
  }
}
