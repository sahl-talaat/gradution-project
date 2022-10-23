import 'package:CU_Attendance/shared/network/local/cach_hilper.dart';
import 'package:CU_Attendance/shared/network/remote/dio_hilper.dart';
import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'first_screens/first_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CachHelper.init();
  isLoggedIn = CachHelper.getData(key: 'isLoggedIn') ?? false;
  userId = CachHelper.getData(key: 'userId');
  password = CachHelper.getData(key: 'password');
  runApp(const MyApp());
}

bool isLoggedIn = false;
String? userId;
String? password;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          //BlocProvider(create: (_) => AppLoginCubit()..user_data),
          BlocProvider(
              create: (_) => AppCubit()
                ..getallCoursesModel
                ..getAllUsersModel
                ..loginModel
                ..forgotPass
                ..allLecModel
                ..allSecModel),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,

            // appBarTheme: AppBarTheme(
            //   titleTextStyle: TextStyle(
            //       color: Colors.black,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 20.0),
            //   //backwardsCompatibility: false,
            //   systemOverlayStyle: SystemUiOverlayStyle(
            //     statusBarColor: Colors.white,
            //     statusBarIconBrightness: Brightness.dark,
            //   ),
            //   backgroundColor: Colors.blue,
            //   elevation: 0.0,
            // ),
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: StartScreen(),
        ));
  }
}
