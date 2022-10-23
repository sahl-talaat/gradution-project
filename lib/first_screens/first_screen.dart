import 'package:CU_Attendance/first_screens/login_screen.dart';
import 'package:CU_Attendance/shared/navigator/nav.dart';
import 'package:flutter/material.dart';

import '../app_cubit/cubit.dart';
import '../main.dart';

class StartScreen extends StatefulWidget {
  StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (isLoggedIn && userId != null && password != null) {
        AppCubit.get(context).login(
            context: context,
            userId: userId!,
            password: password!,
            loggedInUserFound: true);
        isLoggedIn = false;
        userId = null;
        password = null;
      } else {
        Future.delayed(Duration(seconds: 3), () {
          navigateAndFinish(context, Login());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 40.0,
            ),
            Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    image: DecorationImage(
                      image: AssetImage('images/1.png'),
                    ))),
            CircularProgressIndicator(),
            Column(
              children: [
                Text(
                  'Attendance',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Text(
                  'System',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}
