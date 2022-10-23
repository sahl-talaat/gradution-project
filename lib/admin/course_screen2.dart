import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/shared/reusable/form_field.dart';
import 'package:CU_Attendance/shared/reusable/flush_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllCorsesPerAdmin extends StatefulWidget {
  AllCorsesPerAdmin({Key? key}) : super(key: key);

  @override
  State<AllCorsesPerAdmin> createState() => _AllCorsesPerAdminState();
}

class _AllCorsesPerAdminState extends State<AllCorsesPerAdmin> {
  GlobalKey<FormState> updatecourseformkey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> updatecoursekey = GlobalKey<ScaffoldState>();
  var coursename = TextEditingController();
  var courseid = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        String? admintoken = AppCubit.get(context).loginModel!.token;
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: updatecoursekey,
          appBar: AppBar(),
          body: state is! GetAllCoursesLoadingStete ||
                  state is DeleteCourseSuccessStete
              ? Container(
                  height: double.infinity,
                  child: ListView.builder(
                      itemCount: AppCubit.get(context)
                          .getallCoursesModel!
                          .data!
                          .courseData
                          .length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            updatecoursekey.currentState!
                                .showBottomSheet((context) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 0.8,
                                    )),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 13.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 10.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Form(
                                  key: updatecourseformkey,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Update Course Information',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      Text(
                                        '${cubit.getallCoursesModel!.data!.courseData[i].courseName}',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      defaultFieldText(
                                        mycontroller: coursename,
                                        keyboardType: TextInputType.text,
                                        label: Text('Course Name'),
                                        onSave: (text) {
                                          coursename.text = text!;
                                        },
                                        validate: (text) {
                                          if (text!.isEmpty) {
                                            return 'field must not be impty';
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(),
                                          onPressed: () async {
                                            await cubit.updateCourse(
                                                token: admintoken!,
                                                currentCourse: cubit
                                                    .getallCoursesModel!
                                                    .data!
                                                    .courseData[i]
                                                    .courseName!,
                                                courseName: coursename.text);
                                            await cubit.getAllCourses(
                                                token: admintoken);
                                            Navigator.of(context).pop();
                                            if (cubit.updateCourseStatus ==
                                                200) {
                                              defaultFlushbar(
                                                  context: context,
                                                  color: Colors.green,
                                                  icon: Icons.inventory_sharp,
                                                  message:
                                                      'Course updated successfuly');
                                            }
                                            if (cubit.updateCourseStatus ==
                                                503) {
                                              defaultFlushbar(
                                                  context: context,
                                                  color: Colors.orange,
                                                  icon: Icons.cell_tower_sharp,
                                                  message:
                                                      'Check your Internet Connection and try again');
                                            }
                                          },
                                          child: Text('Save Changes'))
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                      '${cubit.getallCoursesModel!.data!.courseData[i].courseName}'),
                                  Spacer(),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    '${cubit.getallCoursesModel!.data!.courseData[i].courseName}'),
                                                content: Text(
                                                    'Surely want to delete course ?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancle')),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await cubit.deleteCourse(
                                                            token: admintoken,
                                                            name: cubit
                                                                .getallCoursesModel!
                                                                .data!
                                                                .courseData[i]
                                                                .courseName);
                                                        await cubit
                                                            .getAllCourses(
                                                                token:
                                                                    admintoken);
                                                        Navigator.of(context)
                                                            .pop();
                                                        if (cubit
                                                                .deleteCourseStatus ==
                                                            204) {
                                                          defaultFlushbar(
                                                              context: context,
                                                              color:
                                                                  Colors.green,
                                                              icon: Icons
                                                                  .inventory_sharp,
                                                              message:
                                                                  'Course deleted successfuly');
                                                        }
                                                        if (cubit
                                                                .deleteCourseStatus ==
                                                            503) {
                                                          defaultFlushbar(
                                                              context: context,
                                                              color:
                                                                  Colors.orange,
                                                              icon: Icons
                                                                  .cell_tower_sharp,
                                                              message:
                                                                  'Check your Internet Connection and try again');
                                                        }
                                                      },
                                                      child: Text('OK')),
                                                ],
                                              );
                                            });
                                      },
                                      child: Text('remove')),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }
}
