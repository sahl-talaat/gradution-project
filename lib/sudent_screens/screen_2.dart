import 'package:CU_Attendance/app_cubit/cubit.dart';
import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../shared/reusable/flush_bar.dart';

class UplouadImagesScreen extends StatefulWidget {
  UplouadImagesScreen({Key? key}) : super(key: key);

  @override
  State<UplouadImagesScreen> createState() => _UplouadImagesScreenState();
}

bool updateScreen = false;

class _UplouadImagesScreenState extends State<UplouadImagesScreen> {
  final imagePicker = ImagePicker();
  XFile? image;
  uploadeImage() async {
    setState(() => updateScreen = true);
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await AppCubit.get(context).uploadProfileImage(
          token: AppCubit.get(context).loginModel!.token!, photo: image);

      setState(() => updateScreen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: ((context, state) {
        LoginModel? userData = AppCubit.get(context).loginModel;
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: !updateScreen
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 40.0,
                          child: Text(
                            'upload images for attendance',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 1.5,
                        color: Colors.blue,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50.0, right: 50.0, top: 8.0, bottom: 8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0)),
                                    onPressed: () async {
                                      setState(() => cubit.imageOne = true);
                                      await uploadeImage();
                                      setState(() => cubit.imageOne = false);
                                    },
                                    child: Text('image one  ')),
                                Image(
                                    height: 100.0,
                                    width: 80.0,
                                    image: NetworkImage(
                                        cubit.studentImageNotFound1
                                            ? 'https://res.cloudinary.com/dfx1fdoup/image/upload/v1658187641/exuwpebqlun4ng4dgfrj.jpg'
                                            : cubit.url1!,
                                        scale: 1.0))
                              ],
                            ),
                            const Divider(
                              thickness: 0.9,
                              color: Colors.blue,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0)),
                                    onPressed: () async {
                                      setState(() => cubit.imageTwo = true);
                                      await uploadeImage();
                                      setState(() => cubit.imageTwo = false);
                                    },
                                    child: Text('image two  ')),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Image(
                                    height: 100.0,
                                    width: 80.0,
                                    image: NetworkImage(
                                        cubit.studentImageNotFound2
                                            ? 'https://res.cloudinary.com/dfx1fdoup/image/upload/v1658187641/exuwpebqlun4ng4dgfrj.jpg'
                                            : cubit.url2!,
                                        scale: 1.0))
                              ],
                            ),
                            const Divider(
                              thickness: 0.9,
                              color: Colors.blue,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0)),
                                    onPressed: () async {
                                      setState(() => cubit.imageThree = true);
                                      await uploadeImage();
                                      setState(() => cubit.imageThree = true);
                                    },
                                    child: Text('image three')),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Image(
                                    height: 100.0,
                                    width: 80.0,
                                    image: NetworkImage(
                                        cubit.studentImageNotFound3
                                            ? 'https://res.cloudinary.com/dfx1fdoup/image/upload/v1658187641/exuwpebqlun4ng4dgfrj.jpg'
                                            : cubit.url3!,
                                        scale: 1.0))
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1.5,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (cubit.url1 == null) {
                              defaultFlushbar(
                                  context: context,
                                  color: Colors.red,
                                  icon: Icons.dangerous_outlined,
                                  message: 'Make sure you upload image one');
                            } else if (cubit.url2 == null) {
                              defaultFlushbar(
                                  context: context,
                                  color: Colors.red,
                                  icon: Icons.dangerous_outlined,
                                  message: 'Make sure you upload image two');
                            } else if (cubit.url3 == null) {
                              defaultFlushbar(
                                  context: context,
                                  color: Colors.red,
                                  icon: Icons.dangerous_outlined,
                                  message: 'Make sure you upload image three');
                            } else {
                              await cubit.uploadAttendanceImages(
                                  token: userData!.token!,
                                  url1: cubit.url1!,
                                  url2: cubit.url2!,
                                  url3: cubit.url3!);
                              if (cubit.uploadAttendanceImagesStatus == 200) {
                                defaultFlushbar(
                                    context: context,
                                    color: Colors.green,
                                    icon: Icons.inventory_sharp,
                                    message: 'Images uploaded successfuly');
                              }
                              if (cubit.uploadAttendanceImagesStatus == 503) {
                                defaultFlushbar(
                                    context: context,
                                    color: Colors.orange,
                                    icon: Icons.cell_tower_sharp,
                                    message:
                                        'Check your Internet Connection and try again');
                              }
                              if (cubit.uploadAttendanceImagesStatus == 500) {
                                defaultFlushbar(
                                    context: context,
                                    color: Colors.red,
                                    icon: Icons.dangerous_outlined,
                                    message:
                                        'Upload images with the right bath in JPG format');
                              }
                            }
                          },
                          child: Text('Uploade images'))
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }
}
