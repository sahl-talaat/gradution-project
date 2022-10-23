import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/shared/navigator/nav.dart';
import 'package:CU_Attendance/shared/reusable/flush_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/reusable/form_field.dart';
import 'user_screen2.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var usertype;
  var usertypeController = TextEditingController();
  var useridController = TextEditingController();
  var usernameController = TextEditingController();
  var userphoneController = TextEditingController();
  var useremailController = TextEditingController();
  var userpasswordController = TextEditingController();
  var confirmpasswordController = TextEditingController();

  GlobalKey<FormState> data = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        String? admintoken = AppCubit.get(context).loginModel!.token;
        AppCubit cubit = AppCubit.get(context);
        return Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            AppCubit.get(context)
                                .getAllUsers(token: admintoken);
                            navigatTo(context, AllUsers());
                          },
                          child: const Text('USERS')),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(15.0))),
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: Form(
                    key: data,
                    child: Column(
                      children: [
                        const Text('Add User',
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                        SizedBox(
                          height: 5.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 40.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                border:
                                    Border.all(color: Colors.blue, width: 1.0)),
                            child: DropdownButton(
                              underline: Container(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              isExpanded: true,
                              elevation: 4,
                              alignment: Alignment.center,
                              hint: Text('  user type'),
                              items: ['student', 'TA', 'professor', 'admin']
                                  .map((e) {
                                return DropdownMenuItem(
                                  child: Text('  $e'),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (text) {
                                setState(() {
                                  usertype = text;
                                });
                              },
                              value: usertype,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        defaultFieldText(
                          mycontroller: useridController,
                          keyboardType: TextInputType.number,
                          isPassword: false,
                          hint: 'User ID',
                          onSave: ((text) {
                            useridController.text = text!;
                          }),
                          validate: ((text) {
                            if (text!.isEmpty) {
                              return 'id must not be empty';
                            }
                          }),
                        ),
                        defaultFieldText(
                          mycontroller: usernameController,
                          keyboardType: TextInputType.text,
                          isPassword: false,
                          hint: 'User Name',
                          onSave: ((text) {
                            usernameController.text = text!;
                          }),
                          validate: ((text) {
                            if (text!.isEmpty) {
                              return 'name must not be empty';
                            }
                          }),
                        ),
                        defaultFieldText(
                          mycontroller: useremailController,
                          keyboardType: TextInputType.emailAddress,
                          isPassword: false,
                          hint: 'User Email',
                          onSave: ((text) {
                            useremailController.text = text!;
                          }),
                          validate: ((text) {
                            if (text!.isEmpty) {
                              return 'email must not be empty';
                            }
                          }),
                        ),
                        defaultFieldText(
                          mycontroller: userphoneController,
                          keyboardType: TextInputType.phone,
                          isPassword: false,
                          hint: 'User Phone',
                          onSave: ((text) {
                            userphoneController.text = text!;
                          }),
                          validate: ((text) {
                            if (text!.isEmpty) {
                              return 'phone must not be empty';
                            }
                            if (text.length < 11) {
                              return 'Phone number must be 11 numbers';
                            }
                          }),
                        ),
                        defaultFieldText(
                          mycontroller: userpasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          isPassword: false,
                          hint: 'User Password',
                          onSave: ((text) {
                            userpasswordController.text = text!;
                          }),
                          validate: ((text) {
                            if (text!.isEmpty) {
                              return 'password must not be empty';
                            }
                            if (text.length < 8) {
                              return 'password is too short';
                            }
                          }),
                        ),
                        defaultFieldText(
                          mycontroller: confirmpasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          isPassword: false,
                          hint: 'Confirm Password',
                          onSave: ((text) {
                            confirmpasswordController.text = text!;
                          }),
                          validate: ((text) {
                            if (text!.isEmpty) {
                              return 'feild must not be impty';
                            }
                            if (text != userpasswordController.text) {
                              return 'unmatch password';
                            }
                          }),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        state is! CreatUserLoadingStete
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 60.0)),
                                onPressed: () async {
                                  print(usertype);
                                  if (data.currentState!.validate()) {
                                    if (usertype == null) {
                                      defaultFlushbar(
                                          context: context,
                                          color: Colors.red,
                                          icon: Icons.dangerous_outlined,
                                          message:
                                              'Choose User Type Form List Button Above');
                                      return;
                                    }
                                    data.currentState!.save();
                                    await cubit.creatUser(
                                      token: admintoken!,
                                      userId: useridController.text,
                                      name: usernameController.text,
                                      email: useremailController.text,
                                      phone: userphoneController.text,
                                      role: usertype,
                                      password: userpasswordController.text,
                                      passwordConfirm:
                                          confirmpasswordController.text,
                                    );
                                    if (cubit.creatUserStatus == 201) {
                                      defaultFlushbar(
                                          context: context,
                                          color: Colors.green,
                                          icon: Icons.inventory_sharp,
                                          message: 'User added successfuly');
                                    }
                                    if (cubit.creatUserStatus == 400) {
                                      defaultFlushbar(
                                          context: context,
                                          color: Colors.red,
                                          icon: Icons.dangerous_outlined,
                                          message: 'Duplicate User\'s Value');
                                    }
                                    if (cubit.creatUserStatus == 503) {
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
