import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/shared/navigator/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_cubit/cubit.dart';
import '../../app_screens/enroll_screen.dart';
import '../../app_screens/profile_screen.dart';
import '../../first_screens/login_screen.dart';

Widget defaultDrawer({
  //required Function  FunctionProfile,
  required BuildContext context,
  required String? name,
  required String? email,
  required int? legnth,
}) =>
    BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        String? usertoken = AppCubit.get(context).loginModel!.token;
        AppCubit cubit = AppCubit.get(context);
        return Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                    cubit.loginModel!.data!.photo! == null
                        ? '${cubit.url}'
                        : cubit.loginModel!.data!.photo!,
                    scale: 1.0,
                  ),
                ),
                accountName: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$name'),
                      Text('$legnth courses'),
                    ],
                  ),
                ),
                accountEmail: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$email'),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('Profile'),
                trailing: Icon(Icons.person),
                onTap: () {
                  navigatTo(context, Profile());
                },
              ),
              ListTile(
                title: Text('Enroll'),
                trailing: Icon(Icons.book),
                onTap: () {
                  AppCubit.get(context).getAllCourses(token: usertoken!);
                  navigatTo(context, AllCouresesToEnroll());
                },
              ),
              ListTile(
                title: Text('Log Out'),
                trailing: Icon(Icons.logout),
                onTap: () {
                  AppCubit.get(context).logOut(token: usertoken!);
                  navigateAndFinish(context, Login());
                },
              ),
            ],
          ),
        );
      }),
    );
