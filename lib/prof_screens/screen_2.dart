import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/models/login_model.dart';
import 'package:CU_Attendance/prof_screens/screen_1.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/navigator/nav.dart';

class ScreenTwoProf extends StatefulWidget {
  String role;
  ScreenTwoProf({Key? key, required this.role}) : super(key: key);

  @override
  State<ScreenTwoProf> createState() => _ScreenTwoProfState();
}

class _ScreenTwoProfState extends State<ScreenTwoProf> {
  @override
  Widget build(BuildContext context) {
    LoginModel user = AppCubit.get(context).loginModel!;
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        List attendence = widget.role == 'TA'
            ? cubit.allSecModel!.sections!
                .firstWhere((s) => s.name == cubit.currentSection)
                .attendance!
            : AppCubit.get(context)
                .allLecModel!
                .lectures!
                .firstWhere((l) => l.name == cubit.currentLecture)
                .attendance!;
        return Scaffold(
          appBar: AppBar(
            title: Text(AppCubit.get(context).currentCousre!),
            leading: IconButton(
                onPressed: () {
                  navigateAndFinish(context, ScreenOneProf());
                },
                icon: Icon(Icons.arrow_back)),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0, left: 16.0, top: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(cubit.isDoctor && !cubit.isTA
                            ? 'attendance ${AppCubit.get(context).currentLecture}'
                            : 'attendance ${AppCubit.get(context).currentSection}'),
                        flex: 3,
                      ),
                      Expanded(
                        child: Text('${attendence.length} students'),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.blue,
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: attendence.length,
                      itemBuilder: (context, i) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  '${attendence[i].studentId}',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue),
                                ),
                                Text('   '),
                                Text(
                                  '${attendence[i].studentName}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        XFile? image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image != null) {
                          await cubit.uploadProfileImage(
                              token: user.token!, photo: image);
                          print(AppCubit.get(context).url);
                          if (cubit.isDoctor && !cubit.isTA) {
                            await cubit.takeAttLecture(
                              token: user.token!,
                              courseName: cubit.currentCousre!,
                              lectureName: cubit.currentLecture!,
                            );
                            await cubit.getAllLec(
                                token: user.token!,
                                courseName: cubit.currentCousre!);
                          } else {
                            await cubit.takeAttSection(
                              token: user.token!,
                              courseName: cubit.currentCousre!,
                              sectionName: cubit.currentSection!,
                            );
                            await cubit.getAllSec(
                                token: user.token!,
                                courseName: cubit.currentCousre!);
                          }
                        }
                      },
                      child: Text('take attendance')),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
