import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/shared/reusable/flush_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllUsers extends StatefulWidget {
  AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        String? admintoken = AppCubit.get(context).loginModel!.token;
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('all users'),
          ),
          body: state is GetAllUsersSuccessStete
              ? Container(
                  height: double.infinity,
                  child: ListView.builder(
                      itemCount: cubit.getAllUsersModel!.data!.userData.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {},
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                children: [
                                  // Container(
                                  //   height: 50.0,
                                  //   width: 50.0,
                                  // ),

                                  Text(
                                    '${cubit.getAllUsersModel!.data!.userData[i].name}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('  '),
                                  Text(
                                    '${cubit.getAllUsersModel!.data!.userData[i].userId}',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue),
                                  ),
                                  Spacer(),

                                  ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    '${cubit.getAllUsersModel!.data!.userData[i].name}'),
                                                content: Text(
                                                    'Surely want to delete user ?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancle')),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await cubit.deleteUser(
                                                            token: admintoken,
                                                            id: cubit
                                                                .getAllUsersModel!
                                                                .data!
                                                                .userData[i]
                                                                .userId);
                                                        await AppCubit.get(
                                                                context)
                                                            .getAllUsers(
                                                                token:
                                                                    admintoken);
                                                        Navigator.of(context)
                                                            .pop();
                                                        if (cubit
                                                                .deleteUserStatus ==
                                                            204) {
                                                          defaultFlushbar(
                                                              context: context,
                                                              color:
                                                                  Colors.green,
                                                              icon: Icons
                                                                  .inventory_sharp,
                                                              message:
                                                                  'User deleted successfuly');
                                                        }
                                                        if (cubit
                                                                .deleteUserStatus ==
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
