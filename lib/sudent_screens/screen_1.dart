import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../first_screens/home_screen.dart';
import '../../models/login_model.dart';
import '../../shared/navigator/nav.dart';

//lecture attendance for student
class Lecture extends StatefulWidget {
  Lecture({Key? key}) : super(key: key);

  @override
  State<Lecture> createState() => _LectureState();
}

class _LectureState extends State<Lecture> {
  List<Icon> iconAttend = [
    Icon(
      Icons.check,
      color: Colors.green,
    ),
    Icon(
      Icons.close,
      color: Colors.red,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        LoginModel? user = AppCubit.get(context).loginModel;
        return Scaffold(
          appBar: AppBar(
            title: Text('${AppCubit.get(context).currentCousre}'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                navigateAndFinish(context, Home());
              },
            ),
          ),
          body: Container(
            child: state is GetAllLecSuccessStete
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 10.0),
                        child: Text('Show Lecture Attendane'),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.blue,
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Center(child: Text('lecture'))),
                          Expanded(child: Center(child: Text('date'))),
                          Expanded(child: Center(child: Text('attend?'))),
                        ],
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.blue,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.72,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: AppCubit.get(context)
                                .allLecModel!
                                .lectures!
                                .length,
                            itemBuilder: ((context, i) {
                              var attendedStdIds = AppCubit.get(context)
                                  .allLecModel!
                                  .lectures![i]
                                  .attendance!
                                  .map((e) => e.studentId);
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Center(
                                              child: Text(
                                                  '${AppCubit.get(context).allLecModel!.lectures![i].name}'))),
                                      Expanded(
                                          child: Center(
                                              child: Text(
                                                  '${AppCubit.get(context).allLecModel!.lectures![i].date!.substring(0, 10)}'))),
                                      Expanded(
                                        child: Center(
                                            child: (attendedStdIds.contains(
                                                    user!.data!.userId))
                                                ? iconAttend[0]
                                                : iconAttend[1]),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 0.2,
                                    color: Colors.blue,
                                  ),
                                ],
                              );
                            })),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      }),
    );
  }
}

class Section extends StatefulWidget {
  Section({Key? key}) : super(key: key);

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  List<Icon> iconAttend = [
    Icon(
      Icons.check,
      color: Colors.green,
    ),
    Icon(
      Icons.close,
      color: Colors.red,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    LoginModel? user = AppCubit.get(context).loginModel;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${AppCubit.get(context).currentCousre}'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                navigateAndFinish(context, Home());
              },
            ),
          ),
          body: Container(
            child: state is GetAllSecSuccessStete
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 10.0),
                        child: Text('Show Section Attendane'),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.blue,
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Center(child: Text('section'))),
                          Expanded(child: Center(child: Text('date'))),
                          Expanded(child: Center(child: Text('attend?'))),
                        ],
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.blue,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.72,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: AppCubit.get(context)
                                .allSecModel!
                                .sections!
                                .length,
                            itemBuilder: ((context, i) {
                              var attendedStdIds = AppCubit.get(context)
                                  .allSecModel!
                                  .sections![i]
                                  .attendance!
                                  .map((e) => e.studentId);
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Center(
                                              child: Text(
                                                  '${AppCubit.get(context).allSecModel!.sections![i].name}'))),
                                      Expanded(
                                          child: Center(
                                              child: Text(
                                                  '${AppCubit.get(context).allSecModel!.sections![i].date!.substring(0, 10)}'))),
                                      Expanded(
                                        child: Center(
                                            child: (attendedStdIds.contains(
                                                    user!.data!.userId))
                                                ? iconAttend[0]
                                                : iconAttend[1]),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 0.2,
                                    color: Colors.blue,
                                  ),
                                ],
                              );
                            })),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      }),
    );
  }
}
