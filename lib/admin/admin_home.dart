import 'package:CU_Attendance/admin/user_screen1.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_cubit/cubit.dart';
import '../../first_screens/login_screen.dart';
import '../../shared/navigator/nav.dart';
import '../app_screens/profile_screen.dart';
import 'course_screen1.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(
                text: 'User',
              ),
              Tab(
                text: 'Course',
              ),
            ]),
          ),
          drawer: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: ((context, state) {
              String? admintoken = AppCubit.get(context).loginModel!.token;
              return Drawer(
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            '${AppCubit.get(context).loginModel!.data!.name}'),
                      ),
                      accountEmail: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            '${AppCubit.get(context).loginModel!.data!.email}'),
                      ),
                    ),
                    ListTile(
                      title: Text('Profile'),
                      trailing: Icon(Icons.person),
                      onTap: () {
                        navigateAndFinish(context, Profile());
                      },
                    ),
                    ListTile(
                      title: Text('Log Out'),
                      trailing: Icon(Icons.logout),
                      onTap: () {
                        AppCubit.get(context).logOut(token: admintoken!);
                        navigateAndFinish(context, Login());
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
          body: TabBarView(children: [
            UserScreen(),
            CourseScreen(),
          ]),
        ));
  }
}
