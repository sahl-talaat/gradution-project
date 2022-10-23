import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/models/login_model.dart';
import 'package:CU_Attendance/shared/navigator/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../app_cubit/cubit.dart';
import '../../first_screens/home_screen.dart';
import '../shared/reusable/flush_bar.dart';
import '../shared/reusable/form_field.dart';
import '../admin/admin_home.dart';
import '../sudent_screens/screen_2.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool udatadata = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> updatepasskey = GlobalKey<FormState>();

  GlobalKey<FormState> updateEmailkey = GlobalKey<FormState>();
  GlobalKey<FormState> updatePhonekey = GlobalKey<FormState>();

  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();
  var confirmpassController = TextEditingController();

  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  final imagePicker = ImagePicker();
  XFile? image;
  getData() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      udatadata = true;
      await AppCubit.get(context).uploadProfileImage(
          token: AppCubit.get(context).loginModel!.token!, photo: image);

      await AppCubit.get(context).updateUserData(
          token: AppCubit.get(context).loginModel!.token!,
          url: AppCubit.get(context).url);
      setState(() => udatadata = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        LoginModel? userdata = AppCubit.get(context).loginModel;
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('${userdata!.data!.role}'),
              leading: IconButton(
                  onPressed: () {
                    if (userdata.data!.role == 'admin') {
                      navigateAndFinish(context, AdminHome());
                    } else {
                      navigateAndFinish(context, Home());
                    }
                  },
                  icon: Icon(Icons.arrow_back)),
              actions: [
                cubit.isStudent
                    ? TextButton(
                        onPressed: () {
                          navigatTo(context, UplouadImagesScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'upload attendance images',
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                    : Container()
              ],
            ),
            body: udatadata == false
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  getData();
                                },
                                child: Image(
                                    height: 100.0,
                                    width: 80.0,
                                    image: NetworkImage(
                                        cubit.loginModel!.data!.photo!,
                                        scale: 1.0))),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Name : ${userdata.data!.name}'),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      Text('Email : ${userdata.data!.email}'),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      Text('Phone : ${userdata.data!.phone}'),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      Text('ID : ${userdata.data!.userId}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 0.9,
                          color: Colors.blue,
                        ),
                        Column(
                          children: [
                            Text(
                              'Update Communication Data',
                              style:
                                  TextStyle(fontSize: 18.0, color: Colors.blue),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Form(
                                  key: updateEmailkey,
                                  child: Expanded(
                                    child: defaultFieldText(
                                      mycontroller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      onSave: (text) {
                                        emailController.text = text!;
                                      },
                                      validate: (text) {
                                        if (text!.isEmpty) {
                                          return 'field must not be empty';
                                        }
                                      },
                                      label: Text('Update Email'),
                                      preffix: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0,
                                              horizontal: 30.0)),
                                      onPressed: () async {
                                        if (updateEmailkey.currentState!
                                            .validate()) {
                                          updateEmailkey.currentState!.save();
                                          udatadata = true;
                                          await cubit.updateUserData(
                                              token: userdata.token!,
                                              email: emailController.text);
                                          setState(() => udatadata = false);
                                          if (cubit.updateUserDataStatus ==
                                              200) {
                                            defaultFlushbar(
                                                context: context,
                                                color: Colors.green,
                                                icon: Icons.inventory_sharp,
                                                message:
                                                    'Email updated successfuly');
                                          }
                                          if (cubit.updateUserDataStatus ==
                                              400) {
                                            defaultFlushbar(
                                                context: context,
                                                color: Colors.red,
                                                icon: Icons.dangerous,
                                                message:
                                                    'Please provide a valid email');
                                          }
                                          if (cubit.updateUserDataStatus ==
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
                                      child: Text('Update')),
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Form(
                                  key: updatePhonekey,
                                  child: Expanded(
                                    child: defaultFieldText(
                                      mycontroller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      onSave: (text) {
                                        phoneController.text = text!;
                                      },
                                      validate: (text) {
                                        if (text!.length < 11) {
                                          return 'Phone number must be 11 numbers';
                                        }
                                        if (text.isEmpty) {
                                          return 'field must not be empty';
                                        }
                                      },
                                      label: Text('Update Phone'),
                                      preffix:
                                          Icon(Icons.phone_android_outlined),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.0,
                                              horizontal: 30.0)),
                                      onPressed: () async {
                                        if (updatePhonekey.currentState!
                                            .validate()) {
                                          updatePhonekey.currentState!.save();
                                          udatadata = true;
                                          await cubit.updateUserData(
                                              token: userdata.token!,
                                              phone: phoneController.text);
                                          setState(() => udatadata = false);
                                          if (cubit.updateUserDataStatus ==
                                              200) {
                                            defaultFlushbar(
                                                context: context,
                                                color: Colors.green,
                                                icon: Icons.inventory_sharp,
                                                message:
                                                    'Phone updated successfuly');
                                          }
                                          if (cubit.updateUserDataStatus ==
                                              400) {
                                            defaultFlushbar(
                                                context: context,
                                                color: Colors.red,
                                                icon: Icons.dangerous,
                                                message:
                                                    'Please provide a valid phone numper');
                                          }
                                          if (cubit.updateUserDataStatus ==
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
                                      child: Text('Update')),
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 0.9,
                          color: Colors.blue,
                        ),
                        Form(
                          key: updatepasskey,
                          child: Column(
                            children: [
                              Text(
                                'Update Password',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.blue),
                              ),
                              defaultFieldText(
                                mycontroller: oldpassController,
                                keyboardType: TextInputType.visiblePassword,
                                onSave: (text) {
                                  oldpassController.text = text!;
                                },
                                validate: (text) {
                                  if (text!.isEmpty) {
                                    return 'field must not be empty';
                                  }
                                },
                                isPassword: true,
                                label: Text('Old Password'),
                                preffix: Icon(Icons.key),
                              ),
                              defaultFieldText(
                                mycontroller: newpassController,
                                keyboardType: TextInputType.visiblePassword,
                                onSave: (text) {
                                  newpassController.text = text!;
                                },
                                validate: (text) {
                                  if (text!.isEmpty) {
                                    return 'field must not be empty';
                                  }
                                  if (text.length < 8) {
                                    return 'password is too short';
                                  }
                                },
                                isPassword: true,
                                label: Text('New Password'),
                                preffix: Icon(Icons.key),
                              ),
                              defaultFieldText(
                                mycontroller: confirmpassController,
                                keyboardType: TextInputType.visiblePassword,
                                onSave: (text) {
                                  confirmpassController.text = text!;
                                },
                                validate: (text) {
                                  if (text!.isEmpty) {
                                    return 'field must not be empty';
                                  }
                                  if (text != newpassController.text) {
                                    return 'unmatch password';
                                  }
                                },
                                isPassword: true,
                                label: Text('Confirm Password'),
                                preffix: Icon(Icons.key),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              state is! UpdatePasswordLoadingState
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                        horizontal: 40.0,
                                      )),
                                      onPressed: () async {
                                        print(userdata.data!.name);
                                        if (updatepasskey.currentState!
                                            .validate()) {
                                          updatepasskey.currentState!.save();
                                          await cubit.updateUserPass(
                                            token: userdata.token!,
                                            oldPass: oldpassController.text,
                                            newPass: newpassController.text,
                                            confirm: confirmpassController.text,
                                          );
                                          if (cubit.updatePassStatus == 200) {
                                            defaultFlushbar(
                                                context: context,
                                                color: Colors.green,
                                                icon: Icons.inventory_sharp,
                                                message:
                                                    'Password changed successfuly');
                                          }
                                          if (cubit.updatePassStatus == 401) {
                                            defaultFlushbar(
                                                context: context,
                                                color: Colors.red,
                                                icon: Icons.dangerous_outlined,
                                                message:
                                                    'Your current password is wrong');
                                          }
                                          if (cubit.updatePassStatus == 503) {
                                            defaultFlushbar(
                                                context: context,
                                                color: Colors.orange,
                                                icon: Icons.cell_tower_sharp,
                                                message:
                                                    'Check your Internet Connection and try again');
                                          }
                                        }
                                      },
                                      child: Text('Save Changes'))
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ));
      }),
    );
  }
}
