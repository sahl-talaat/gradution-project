import 'package:CU_Attendance/models/login_model.dart';
import 'package:CU_Attendance/shared/navigator/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_cubit/cubit.dart';
import '../app_cubit/states.dart';
import '../prof_screens/screen_1.dart';
import '../shared/reusable/drawer.dart';
import '../shared/reusable/flush_bar.dart';
import '../sudent_screens/screen_1.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool updateHome = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: ((context, state) {}),
      builder: ((context, state) {
        LoginModel? homeData = AppCubit.get(context).loginModel;
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          drawer: Drawer(
            child: defaultDrawer(
                legnth: homeData!.data!.courses!.length,
                name: homeData.data!.name,
                email: homeData.data!.email,
                context: context),
          ),
          body: !updateHome
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10.0, left: 16.0, top: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Name : ${homeData.data!.name}'),
                            flex: 3,
                          ),
                          Expanded(
                            child: Text('ID : ${homeData.data!.userId} '),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.blue,
                    ),
                    Text('Courses'),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: homeData.data!.courses!.length,
                            itemBuilder: ((context, i) {
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              Text(homeData.data!.courses![i]),
                                          content: Text(
                                              'Surely want to unenroll course ?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancle')),
                                            TextButton(
                                                onPressed: () async {
                                                  setState(
                                                      () => updateHome = true);
                                                  print(homeData
                                                      .data!.courses![i]);
                                                  await cubit
                                                      .unEnrollCourseToUser(
                                                          token:
                                                              homeData.token!,
                                                          courseName: homeData
                                                              .data!
                                                              .courses![i]);

                                                  setState(
                                                      () => updateHome = false);
                                                  Navigator.of(context).pop();
                                                  if (cubit
                                                          .unEnrollCourseToUserStatus ==
                                                      200) {
                                                    defaultFlushbar(
                                                        context: context,
                                                        color: Colors.green,
                                                        icon: Icons
                                                            .inventory_sharp,
                                                        message:
                                                            'Course unenrolled successfuly');
                                                  }
                                                  if (cubit
                                                          .unEnrollCourseToUserStatus ==
                                                      503) {
                                                    defaultFlushbar(
                                                        context: context,
                                                        color: Colors.orange,
                                                        icon: Icons
                                                            .cell_tower_sharp,
                                                        message:
                                                            'Check your Internet Connection and try again');
                                                  }
                                                  // setState(() => updateCourses = false);
                                                },
                                                child: Text('UnEnrol')),
                                          ],
                                        );
                                      });
                                },
                                child: Card(
                                  child: ListTile(
                                    title:
                                        Text('${homeData.data!.courses![i]}'),
                                    trailing: cubit.isDoctor || cubit.isTA
                                        ? TextButton(
                                            onPressed: () {
                                              cubit.currentCousre =
                                                  homeData.data!.courses![i];
                                              if (cubit.isDoctor) {
                                                cubit.getAllLec(
                                                    token: homeData.token,
                                                    courseName: homeData
                                                        .data!.courses![i]);
                                                navigateAndFinish(
                                                    context, ScreenOneProf());
                                              } else {
                                                cubit.getAllSec(
                                                    token: homeData.token,
                                                    courseName: homeData
                                                        .data!.courses![i]);
                                                navigateAndFinish(
                                                    context, ScreenOneProf());
                                              }
                                            },
                                            child: cubit.isDoctor && !cubit.isTA
                                                ? Text('Lectures')
                                                : Text('Sections'))
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    cubit.currentCousre =
                                                        homeData
                                                            .data!.courses![i];
                                                    cubit.getAllLec(
                                                        token: homeData.token,
                                                        courseName: homeData
                                                            .data!.courses![i]);
                                                    navigatTo(
                                                        context, Lecture());
                                                  },
                                                  child: Text('Lectures')),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    cubit.currentCousre =
                                                        homeData
                                                            .data!.courses![i];
                                                    cubit.getAllSec(
                                                        token: homeData.token,
                                                        courseName: homeData
                                                            .data!.courses![i]);
                                                    navigatTo(
                                                        context, Section());
                                                  },
                                                  child: Text('Sections')),
                                            ],
                                          ),
                                  ),
                                ),
                              );
                            })),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Click on the course to cancel enroll',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }
}
