import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/shared/navigator/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../first_screens/home_screen.dart';
import '../shared/reusable/flush_bar.dart';

class AllCouresesToEnroll extends StatefulWidget {
  const AllCouresesToEnroll({Key? key}) : super(key: key);

  @override
  State<AllCouresesToEnroll> createState() => _AllCouresesToEnrollState();
}

class _AllCouresesToEnrollState extends State<AllCouresesToEnroll> {
  bool updateCourses = false;

  @override
  Widget build(BuildContext context1) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        String? usertoken = AppCubit.get(context).loginModel!.token;
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Enroll'),
            //centerTitle: true,
            leading: IconButton(
                onPressed: () async {
                  navigateAndFinish(context, Home());
                },
                icon: Icon(Icons.arrow_back)),
          ),
          body: (state is GetAllCoursesSuccessStete ||
                      state is EnrollTocourseSuccessState) &&
                  !updateCourses
              ? ListView.builder(
                  itemCount: cubit.getallCoursesModel!.data!.courseData
                      .where((element) => !cubit.loginModel!.data!.courses!
                          .contains(element.courseName))
                      .toList()
                      .length,
                  itemBuilder: ((context, i) {
                    List courses = cubit.getallCoursesModel!.data!.courseData
                        .where((element) => !cubit.loginModel!.data!.courses!
                            .contains(element.courseName))
                        .toList();
                    return Card(
                      child: ListTile(
                        title: Text('${courses[i].courseName}'),
                        subtitle: Text('${courses[i].courseId}'),
                        trailing: TextButton(
                            onPressed: () async {
                              setState(() => updateCourses = true);
                              await cubit.enrollCourseToUser(
                                token: usertoken!,
                                context: context,
                                courseName: courses[i].courseName!,
                              );
                              await AppCubit.get(context1)
                                  .courseEnrolled(token: usertoken);
                              setState(() => updateCourses = false);
                              if (cubit.enrollCourseToUserStatus == 200) {
                                defaultFlushbar(
                                    context: context1,
                                    color: Colors.green,
                                    icon: Icons.inventory_sharp,
                                    message: 'Course enrolled successfuly');
                              }
                              if (cubit.enrollCourseToUserStatus == 503) {
                                defaultFlushbar(
                                    context: context1,
                                    color: Colors.orange,
                                    icon: Icons.cell_tower_sharp,
                                    message:
                                        'Check your internet connection And Try Again');
                              }
                            },
                            child: Text('Enroll')),
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
