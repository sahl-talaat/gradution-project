//import 'dart:io';

import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/models/login_model.dart';
import 'package:CU_Attendance/prof_screens/screen_2.dart';
import 'package:CU_Attendance/shared/navigator/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../first_screens/home_screen.dart';
import '../shared/reusable/flush_bar.dart';
//import 'package:image_picker/image_picker.dart';

class ScreenOneProf extends StatefulWidget {
  ScreenOneProf({Key? key}) : super(key: key);

  @override
  State<ScreenOneProf> createState() => _ScreenOneProfState();
}

class _ScreenOneProfState extends State<ScreenOneProf> {
  bool updateScreen = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  // final imagepicker = ImagePicker();
  // File? image;
  // Camera() async {
  //   var pickerimage = await imagepicker.pickImage(source: ImageSource.camera);
  //   if (pickerimage != null) {
  //     setState(() {
  //       image = File(pickerimage.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        AppCubit cubit = AppCubit.get(context);
        LoginModel? userData = AppCubit.get(context).loginModel;
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text("${cubit.currentCousre}"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                navigateAndFinish(context, Home());
              },
            ),
          ),
          body: (state is GetAllLecSuccessStete ||
                      state is GetAllSecSuccessStete ||
                      state is CreateLecSuccessStete ||
                      state is CreateSecSuccessStete) &&
                  !updateScreen
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 9.0),
                        child: Text(
                          'show previus attendance',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.blue,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: cubit.isDoctor && !cubit.isTA
                                ? cubit.allLecModel!.lectures!.length
                                : cubit.allSecModel!.sections!.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(cubit.isDoctor &&
                                                  !cubit.isTA
                                              ? '${cubit.allLecModel!.lectures![i].name!}'
                                              : '${cubit.allSecModel!.sections![i].name!}'),
                                          content:
                                              Text('Surely want to delete ?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancle')),
                                            TextButton(
                                                onPressed: () async {
                                                  if (cubit.isDoctor &&
                                                      !cubit.isTA) {
                                                    setState(() =>
                                                        updateScreen = true);
                                                    await cubit.deleteLecture(
                                                        token: userData!.token!,
                                                        lecture: cubit
                                                            .allLecModel!
                                                            .lectures![i]
                                                            .name!,
                                                        courseName: cubit
                                                            .currentCousre!);
                                                    await cubit.getAllLec(
                                                        token: userData.token,
                                                        courseName: cubit
                                                            .currentCousre!);
                                                    setState(() =>
                                                        updateScreen = false);
                                                  } else {
                                                    setState(() =>
                                                        updateScreen = true);
                                                    await cubit.deleteSection(
                                                        token: cubit.token!,
                                                        section: cubit
                                                            .allSecModel!
                                                            .sections![i]
                                                            .name!,
                                                        courseName: cubit
                                                            .currentCousre!);

                                                    await cubit.getAllSec(
                                                        token: userData!.token,
                                                        courseName: cubit
                                                            .currentCousre!);
                                                    setState(() =>
                                                        updateScreen = false);
                                                  }
                                                  Navigator.of(context).pop();
                                                  if (cubit.deleteSession ==
                                                      204) {
                                                    defaultFlushbar(
                                                        context: context,
                                                        color: Colors.green,
                                                        icon: Icons
                                                            .inventory_sharp,
                                                        message: cubit
                                                                    .isDoctor &&
                                                                !cubit.isTA
                                                            ? 'Lecture deleted successfuly'
                                                            : 'Section deleted successfuly');
                                                  }
                                                  if (cubit.deleteSession ==
                                                      503) {
                                                    defaultFlushbar(
                                                        context: context,
                                                        color: Colors.orange,
                                                        icon: Icons
                                                            .cell_tower_sharp,
                                                        message:
                                                            'Check your Internet Connection and try again');
                                                  }
                                                },
                                                child: Text('Delete')),
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                  height: 60.0,
                                  child: Card(
                                    child: ListTile(
                                      title: Text(cubit.isDoctor && !cubit.isTA
                                          ? '${cubit.allLecModel!.lectures![i].name}'
                                          : '${cubit.allSecModel!.sections![i].name}'),
                                      trailing: TextButton(
                                          onPressed: () {
                                            if (cubit.isDoctor && !cubit.isTA) {
                                              cubit.currentLecture = cubit
                                                  .allLecModel!
                                                  .lectures![i]
                                                  .name;
                                            } else {
                                              cubit.currentSection = cubit
                                                  .allSecModel!
                                                  .sections![i]
                                                  .name;
                                            }
                                            navigatTo(
                                                context,
                                                ScreenTwoProf(
                                                    role:
                                                        userData!.data!.role!));
                                          },
                                          child: Text('show attendance')),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 40.0)),
                          onPressed: () async {
                            if (cubit.isDoctor && !cubit.isTA) {
                              await cubit.createLec(
                                  token: userData!.token!,
                                  courseName: cubit.currentCousre!);

                              await cubit.getAllLec(
                                  token: userData.token,
                                  courseName: cubit.currentCousre!);
                            } else {
                              await cubit.createSec(
                                  token: userData!.token!,
                                  courseName: cubit.currentCousre!);

                              await cubit.getAllSec(
                                  token: userData.token,
                                  courseName: cubit.currentCousre!);
                            }
                            if (cubit.createSessionStatus == 200) {
                              defaultFlushbar(
                                  context: context,
                                  color: Colors.green,
                                  icon: Icons.inventory_sharp,
                                  message: cubit.isDoctor && !cubit.isTA
                                      ? 'Lecture added successfuly'
                                      : 'Section added successfuly');
                            }
                            if (cubit.createSessionStatus == 503) {
                              defaultFlushbar(
                                  context: context,
                                  color: Colors.orange,
                                  icon: Icons.cell_tower_sharp,
                                  message:
                                      'Check your Internet Connection and try again');
                            }
                          },
                          child: cubit.isDoctor && !cubit.isTA
                              ? Text('Add Lecture')
                              : Text('Add Section')),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                          cubit.isDoctor && !cubit.isTA
                              ? 'Click on the lecture to delete'
                              : 'Click on the section to delete',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }
}
