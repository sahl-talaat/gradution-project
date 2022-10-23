import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/reusable/flush_bar.dart';
import '../shared/reusable/form_field.dart';

class ForgotPass extends StatefulWidget {
  ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  GlobalKey<FormState> forgetpassFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> resetpassFormKey = GlobalKey<FormState>();

  var emailForgotpassController = TextEditingController();
  var resetPassController = TextEditingController();
  var resetConfirmPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          body: Container(
            color: Colors.blue,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              margin: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 8.0, top: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.white),
              child: Form(
                key: forgetpassFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.blue, fontSize: 20.0),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            defaultFieldText(
                              keyboardType: TextInputType.emailAddress,
                              label: Text('Email'),
                              hint: 'Email',
                              preffix: Icon(Icons.email_outlined),
                              validate: (text) {
                                if (text!.isEmpty) {
                                  return 'email must not be impty';
                                }
                              },
                              onSave: (text) {
                                emailForgotpassController.text = text!;
                              },
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            ConditionalBuilder(
                                condition: state is! AppForgotPassLoadingState,
                                builder: (context) {
                                  return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50.0)),
                                      onPressed: () async {
                                        if (forgetpassFormKey.currentState!
                                            .validate()) {
                                          forgetpassFormKey.currentState!
                                              .save();
                                          await cubit.forgotPassword(
                                              email: emailForgotpassController
                                                  .text);
                                        }
                                        if (cubit.forgotPasswordStatus == 404) {
                                          defaultFlushbar(
                                              context: context,
                                              color: Colors.red,
                                              icon: Icons.dangerous_outlined,
                                              message:
                                                  'There is no User with that email address');
                                        }
                                        if (cubit.forgotPasswordStatus == 503) {
                                          defaultFlushbar(
                                              context: context,
                                              color: Colors.orange,
                                              icon: Icons.cell_tower_sharp,
                                              message:
                                                  'Check your Internet Connection and try again');
                                        }
                                      },
                                      child: const Text(
                                        'Confirm',
                                      ));
                                },
                                fallback: (context) =>
                                    Center(child: CircularProgressIndicator())),
                            SizedBox(
                              height: 5.0,
                            ),
                            Divider(
                              color: Colors.blue,
                              thickness: 1.0,
                            ),
                            Container(
                              child: state is AppForgotPassSuccessState ||
                                      state is AppLoginLoadingState ||
                                      state is AppLoginSuccessState
                                  ? Form(
                                      key: resetpassFormKey,
                                      child: Column(
                                        children: [
                                          defaultFieldText(
                                            mycontroller: resetPassController,
                                            label: Text('Password'),
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            preffix: Icon(Icons.lock_outline),
                                            onSave: (text) {
                                              resetPassController.text = text!;
                                            },
                                            validate: (text) {
                                              if (text!.isEmpty) {
                                                return 'password must not be impty';
                                              }
                                              if (text.length < 8) {
                                                return 'password is too short';
                                              }
                                            },
                                          ),
                                          defaultFieldText(
                                            mycontroller:
                                                resetConfirmPassController,
                                            label: Text('Confirm Password'),
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            preffix: Icon(Icons.lock_outline),
                                            onSave: (text) {
                                              resetConfirmPassController.text =
                                                  text!;
                                            },
                                            validate: (text) {
                                              if (text!.isEmpty) {
                                                return 'feild must not be impty';
                                              }
                                              if (text !=
                                                  resetPassController.text) {
                                                return 'valid password';
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          ConditionalBuilder(
                                              condition: state
                                                  is! AppLoginLoadingState,
                                              builder: (context) {
                                                return ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        30.0)),
                                                    onPressed: () async {
                                                      if (resetpassFormKey
                                                          .currentState!
                                                          .validate()) {
                                                        resetpassFormKey
                                                            .currentState!
                                                            .save();
                                                        await cubit.resestPass(
                                                            context: context,
                                                            password:
                                                                resetPassController
                                                                    .text,
                                                            passwordConfirm:
                                                                resetConfirmPassController
                                                                    .text);
                                                        if (cubit
                                                                .forgotPasswordStatus ==
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
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Save Changes',
                                                    ));
                                              },
                                              fallback: (context) => Center(
                                                  child:
                                                      CircularProgressIndicator())),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: 0.0,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
