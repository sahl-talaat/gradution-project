import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/shared/navigator/nav.dart';
import 'package:CU_Attendance/shared/reusable/flush_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/reusable/form_field.dart';
import 'course_screen2.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  // enroll user
  GlobalKey<FormState> enrolluserkey = GlobalKey<FormState>();
  var enrollUserId = TextEditingController();
  var enrollUserCourseName = TextEditingController();
  // create course
  GlobalKey<FormState> createcoursekey = GlobalKey<FormState>();
  var courseId = TextEditingController();
  var courseName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        String? admintoken = AppCubit.get(context).loginModel!.token;
        AppCubit cubit = AppCubit.get(context);
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          AppCubit.get(context)
                              .getAllCourses(token: admintoken);
                          navigatTo(context, AllCorsesPerAdmin());
                        },
                        child: Text('COURSES')),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(15.0))),
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Form(
                  key: createcoursekey,
                  child: Column(
                    children: [
                      const Text('Add Course',
                          style: TextStyle(
                            fontSize: 16.0,
                          )),
                      const SizedBox(
                        height: 8.0,
                      ),
                      defaultFieldText(
                        mycontroller: courseName,
                        isPassword: false,
                        label: Text('Course Name'),
                        onSave: (text) {
                          courseName.text = text!;
                        },
                        validate: (text) {
                          if (text!.isEmpty) {
                            return 'field must not be impty';
                          }
                        },
                      ),
                      defaultFieldText(
                        mycontroller: courseId,
                        isPassword: false,
                        label: Text('Course ID'),
                        onSave: (text) {
                          courseId.text = text!;
                        },
                        validate: (text) {
                          if (text!.isEmpty) {
                            return 'field must not be impty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      state is! CreateCoursesLoadingStete
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 60.0)),
                              onPressed: () async {
                                if (createcoursekey.currentState!.validate()) {
                                  createcoursekey.currentState!.save();
                                  await cubit.createCourse(
                                      token: admintoken!,
                                      courseId: courseId.text,
                                      courseName: courseName.text);

                                  if (cubit.createCourseState == 201) {
                                    defaultFlushbar(
                                        context: context,
                                        color: Colors.green,
                                        icon: Icons.inventory_sharp,
                                        message: 'Course added successfuly');
                                  }
                                  if (cubit.createCourseState == 400) {
                                    defaultFlushbar(
                                        context: context,
                                        color: Colors.red,
                                        icon: Icons.dangerous_outlined,
                                        message: 'Duplicate Course\'s Name');
                                  }
                                  if (cubit.createCourseState == 503) {
                                    defaultFlushbar(
                                        context: context,
                                        color: Colors.orange,
                                        icon: Icons.cell_tower_sharp,
                                        message:
                                            'Check your Internet Connection and try again');
                                  }
                                }
                              },
                              child: const Text('ADD'))
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                      const SizedBox(
                        width: 25.0,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(15.0))),
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                //height: MediaQuery.of(context).size.height * 0.3,
                child: Form(
                  key: enrolluserkey,
                  child: Column(
                    children: [
                      const Text(
                        'Enroll & Unenrol User',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      defaultFieldText(
                        mycontroller: enrollUserId,
                        isPassword: false,
                        label: Text('User ID'),
                        onSave: (text) {
                          enrollUserId.text = text!;
                        },
                        validate: (text) {
                          if (text!.isEmpty) {
                            return 'field must not be impty';
                          }
                        },
                      ),
                      defaultFieldText(
                        mycontroller: enrollUserCourseName,
                        isPassword: false,
                        label: Text('Course Name'),
                        onSave: (text) {
                          enrollUserCourseName.text = text!;
                        },
                        validate: (text) {
                          if (text!.isEmpty) {
                            return 'field must not be impty';
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: state is! EnrollUserLoadingState
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          if (enrolluserkey.currentState!
                                              .validate()) {
                                            enrolluserkey.currentState!.save();
                                            await cubit.enrollUser(
                                                token: admintoken,
                                                userId: enrollUserId.text,
                                                courseName:
                                                    enrollUserCourseName.text);
                                            if (cubit.enrollUserStatus == 200) {
                                              defaultFlushbar(
                                                  context: context,
                                                  color: Colors.green,
                                                  icon: Icons.inventory_sharp,
                                                  message:
                                                      'Course Enrolled to User successfuly');
                                            }
                                            if (cubit.enrollUserStatus == 404) {
                                              defaultFlushbar(
                                                  context: context,
                                                  color: Colors.red,
                                                  icon:
                                                      Icons.dangerous_outlined,
                                                  message:
                                                      'Input value not found');
                                            }
                                            if (cubit.enrollUserStatus == 503) {
                                              defaultFlushbar(
                                                  context: context,
                                                  color: Colors.orange,
                                                  icon: Icons.cell_tower_sharp,
                                                  message:
                                                      'Check your Internet Connection and try again');
                                            }
                                          }
                                        },
                                        child: const Text('ENROLL'))
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      )),
                            const SizedBox(
                              width: 25.0,
                            ),
                            Expanded(
                                child: state is! UnenrollUserLoadingState
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          if (enrolluserkey.currentState!
                                              .validate()) {
                                            enrolluserkey.currentState!.save();
                                            await cubit.unEnrollUser(
                                                token: admintoken,
                                                userId: enrollUserId.text,
                                                courseName:
                                                    enrollUserCourseName.text);
                                            if (cubit.unEnrollUserStatus ==
                                                200) {
                                              defaultFlushbar(
                                                  context: context,
                                                  color: Colors.green,
                                                  icon: Icons.inventory_sharp,
                                                  message:
                                                      'Course unEnrolled to User successfuly');
                                            }
                                            if (cubit.unEnrollUserStatus ==
                                                404) {
                                              defaultFlushbar(
                                                  context: context,
                                                  color: Colors.red,
                                                  icon:
                                                      Icons.dangerous_outlined,
                                                  message:
                                                      'Input value not found');
                                            }
                                            if (cubit.unEnrollUserStatus ==
                                                503) {
                                              defaultFlushbar(
                                                  context: context,
                                                  color: Colors.orange,
                                                  icon: Icons.cell_tower_sharp,
                                                  message:
                                                      'Check your Internet Connection and try again');
                                            }
                                          }
                                        },
                                        child: const Text('UNENROLL'))
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
