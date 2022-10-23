import 'package:CU_Attendance/shared/navigator/nav.dart';
import 'package:CU_Attendance/shared/reusable/flush_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_cubit/cubit.dart';
import '../app_cubit/states.dart';
import '../shared/reusable/form_field.dart';
import 'forgot_pass_screen.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formData = GlobalKey<FormState>();

  var idController = TextEditingController();
  var passwordController = TextEditingController();

  bool isPasswordObsecure = true;
  Icon isPasswordObsecureIcon = const Icon(Icons.visibility);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: key,
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'LOG IN',
                          style: TextStyle(
                              fontSize: 60.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Cairo University Attendance System',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Form(
                    key: formData,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      padding: const EdgeInsets.all(4.0),
                      margin: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40.0,
                          ),
                          defaultFieldText(
                            mycontroller: idController,
                            keyboardType: TextInputType.number,
                            onSave: ((newValue) {
                              idController.text = newValue!;
                            }),
                            validate: ((value) {
                              if (value!.isEmpty) {
                                return 'id must not be empty';
                              }
                            }),
                            preffix: const Icon(Icons.perm_identity_sharp),
                            label: Text('id'),
                          ),
                          defaultFieldText(
                            mycontroller: passwordController,
                            isPassword: isPasswordObsecure,
                            keyboardType: TextInputType.visiblePassword,
                            onSave: ((newValue) {
                              passwordController.text = newValue!;
                            }),
                            validate: ((value) {
                              if (value!.isEmpty) {
                                return 'password must not be empty';
                              }
                            }),
                            sufix: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordObsecure = !isPasswordObsecure;
                                });
                              },
                              icon: isPasswordObsecure
                                  ? isPasswordObsecureIcon
                                  : const Icon(Icons.visibility_off),
                            ),
                            preffix: const Icon(Icons.lock_outline),
                            label: Text('password'),
                          ),
                          Container(
                            height: 50.0,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            width: double.infinity,
                            child: ConditionalBuilder(
                                condition: state is! AppLoginLoadingState,
                                builder: (context) {
                                  return ElevatedButton(
                                      style: ElevatedButton.styleFrom(),
                                      onPressed: () async {
                                        if (formData.currentState!.validate()) {
                                          formData.currentState!.save();
                                          await cubit.login(
                                              context: context,
                                              userId: idController.text,
                                              password:
                                                  passwordController.text);
                                          if (cubit.loginStatus == 401) {
                                            defaultFlushbar(
                                                context: context,
                                                color: Colors.red,
                                                icon: Icons.dangerous_outlined,
                                                message:
                                                    'Incorrect ID or Password');
                                          }
                                          if (cubit.loginStatus == 503) {
                                            defaultFlushbar(
                                                context: context,
                                                color: Colors.orange,
                                                icon: Icons.cell_tower_sharp,
                                                message:
                                                    'Check your Internet Connection and try again');
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'LOGIN',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.0),
                                      ));
                                },
                                fallback: (context) =>
                                    Center(child: CircularProgressIndicator())),
                          ),
                          Container(
                            child: state is AppLoginErrorState
                                ? TextButton(
                                    onPressed: () {
                                      navigatTo(context, ForgotPass());
                                    },
                                    child: Text(
                                      'FORGOT PASSWORD?',
                                      style: TextStyle(fontSize: 12.0),
                                    ))
                                : Container(
                                    height: 0.0,
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                  flex: 4,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
