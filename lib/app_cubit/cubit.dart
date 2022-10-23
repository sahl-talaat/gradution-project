import 'package:CU_Attendance/app_cubit/states.dart';
import 'package:CU_Attendance/first_screens/login_screen.dart';
import 'package:CU_Attendance/models/get_model/get_all_courses.dart';
import 'package:CU_Attendance/models/get_model/get_all_lec_sec.dart';
import 'package:CU_Attendance/models/get_model/get_all_users.dart';
import 'package:CU_Attendance/models/login_model.dart';
import 'package:CU_Attendance/models/post_model/forgot_pass_model.dart';
import 'package:CU_Attendance/shared/network/end_points.dart';
import 'package:CU_Attendance/shared/network/local/cach_hilper.dart';
import 'package:CU_Attendance/shared/network/remote/dio_hilper.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../admin/admin_home.dart';
import '../first_screens/home_screen.dart';
import '../models/login_model.dart';
import '../shared/navigator/nav.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStete());

  static AppCubit get(context) => BlocProvider.of(context);

////////////////////////////////////////////////////////////
  /// Authentication
////////////////////////////////////////////////////////////
  bool studentImageNotFound1 = false;
  bool studentImageNotFound2 = false;
  bool studentImageNotFound3 = false;
  bool isDoctor = false;
  bool isStudent = false;
  bool isTA = false;
  bool isADmin = false;
  String? token;

  /// post >> login
  LoginModel? loginModel;
  int? loginStatus;
  Future<void> login({
    required BuildContext context,
    required String userId,
    required String password,
    bool loggedInUserFound = false,
  }) async {
    emit(AppLoginLoadingState());
    await DioHelper.postData(
      url: LOGIN,
      data: {
        'userId': userId,
        'password': password,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      token = loginModel!.token;
      if (loginModel!.data!.courses!.length == 0) {
        studentImageNotFound1 = true;
        studentImageNotFound2 = true;
        studentImageNotFound3 = true;
      } else if (loginModel!.data!.courses!.length == 1) {
        studentImageNotFound2 = true;
        studentImageNotFound3 = true;
      } else if (loginModel!.data!.courses!.length == 2) {
        studentImageNotFound3 = true;
      } else {
        url1 = loginModel!.data!.attendanceImages![0];
        url2 = loginModel!.data!.attendanceImages![1];
        url3 = loginModel!.data!.attendanceImages![2];
      }

      loginStatus = value.statusCode;
      CachHelper.saveData(key: 'isLoggedIn', value: true);
      CachHelper.saveData(key: 'userId', value: userId);
      CachHelper.saveData(key: 'password', value: password);

      if (loginModel!.data!.role == 'TA') {
        isTA = true;
      }
      if (loginModel!.data!.role == 'student') {
        isStudent = true;
      }
      if (loginModel!.data!.role == 'admin') {
        isADmin = true;
      }
      if (loginModel!.data!.role == 'professor') {
        isDoctor = true;
      }
      if (isADmin) {
        navigateAndFinish(context, AdminHome());
      } else {
        navigateAndFinish(context, Home());
      }
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        loginStatus = int.parse(message);
      }
      emit(AppLoginErrorState(error.toString()));
      if (loggedInUserFound) {
        navigateAndFinish(context, Login());
      }
    });
  }

  /// get >> log out
  void logOut({
    BuildContext? context,
    required String token,
  }) {
    emit(AppLogOutLoadingState());
    isDoctor = false;
    isStudent = false;
    isADmin = false;
    isTA = false;
    CachHelper.deleteData(key: 'isLoggedIn');
    CachHelper.deleteData(key: 'userId');
    CachHelper.deleteData(key: 'password');
  }

  /// post >> forgot password
  ForgotPassModel? forgotPass;
  int? forgotPasswordStatus;
  Future<void> forgotPassword({
    BuildContext? context,
    String? email,
  }) async {
    emit(AppForgotPassLoadingState());
    await DioHelper.postData(url: FORGOTPASS, data: {'email': email})
        .then((value) {
      forgotPass = ForgotPassModel.fromJson(value.data);
      forgotPasswordStatus = value.statusCode;
      emit(AppForgotPassSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        forgotPasswordStatus = int.parse(message);
      }
      emit(AppForgotPassErrorState(error.toString()));
    });
  }

  /// patch >> reset password
  int? resestPassStatus;
  Future<void> resestPass({
    BuildContext? context,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(AppLoginLoadingState());
    await DioHelper.updateData(url: forgotPass!.url!, data: {
      'password': password,
      'passwordConfirm': passwordConfirm,
    }).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      CachHelper.saveData(key: 'isLoggedIn', value: true);
      CachHelper.saveData(key: 'userId', value: loginModel!.data!.userId);
      CachHelper.saveData(key: 'password', value: password);
      emit(AppLoginSuccessState());
      resestPassStatus = value.statusCode;
      if (loginModel!.data!.role == 'admin' && state is AppLoginSuccessState) {
        navigateAndFinish(context, AdminHome());
      } else {
        navigateAndFinish(context, Home());
      }
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        resestPassStatus = int.parse(message);
      }
      emit(AppLoginErrorState(error.toString()));
    });
  }

//////////////////////////////////////////////////////
  /// Users
///////////////////////////////////////////////////////

  /// get >> Get All Users
  int? getAllUsersStatus;
  GetAllUsersModel? getAllUsersModel;
  Future<void> getAllUsers({
    BuildContext? context,
    required String? token,
  }) async {
    emit(GetAllUsersLoadingStete());
    await DioHelper.getData(url: GETALLUSERS, token: token).then((value) {
      getAllUsersModel = GetAllUsersModel.fromJson(value.data);
      emit(GetAllUsersSuccessStete());
      getAllUsersStatus = value.statusCode;
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        getAllUsersStatus = int.parse(message);
      }
      emit(GetAllUsersErrorStete(error: error.toString()));
    });
  }

  /// get >> get enroll courses
  int? courseEnrolledStatus;
  Future<void> courseEnrolled({
    required String token,
  }) async {
    await DioHelper.getData(url: COURSESENROLL, token: token).then((value) {
      loginModel!.data!.courses = value.data['courses'];
      courseEnrolledStatus = value.statusCode;
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        courseEnrolledStatus = int.parse(message);
      }
    });
  }

  /// post >> creat user
  int? creatUserStatus;
  Future<void> creatUser({
    required String? token,
    required String? userId,
    required String? name,
    required String? email,
    required String? phone,
    required String? role,
    required String? password,
    required String? passwordConfirm,
  }) async {
    emit(CreatUserLoadingStete());
    await DioHelper.postData(
      url: CREATUSER,
      data: {
        'userId': userId,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'password': password,
        'passwordConfirm': passwordConfirm,
      },
      token: token,
    ).then((value) {
      creatUserStatus = value.statusCode;
      emit(CreatUserSuccessStete());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        creatUserStatus = int.parse(message);
      }
      emit(CreatUserErrorStete(error: error.toString()));
    });
  }

  /// delete >> delete user
  int? deleteUserStatus;
  Future<void> deleteUser({
    required String? token,
    required String? id,
  }) async {
    emit(DeleteUsersLoadingStete());
    await DioHelper.deleteData(url: '$DELUSER/$id', token: token).then((value) {
      deleteUserStatus = value.statusCode;
      emit(DeleteUsersSuccessStete());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        deleteUserStatus = int.parse(message);
      }
      emit(DeleteUsersErrorStete(error: error.toString()));
    });
  }

  /// post >> Enroll User
  int? enrollUserStatus;
  Future<void> enrollUser({
    required String? token,
    required String? userId,
    required String? courseName,
  }) async {
    emit(EnrollUserLoadingState());
    await DioHelper.postData(
            url: ENROLLUSER,
            data: {
              'userId': userId,
              'courseName': courseName,
            },
            token: token)
        .then((value) {
      enrollUserStatus = value.statusCode;
      emit(EnrollUserSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        enrollUserStatus = int.parse(message);
      }
      emit(EnrollUserErrorState(error: error.toString()));
    });
  }

  /// post >> Enroll User
  int? unEnrollUserStatus;
  Future<void> unEnrollUser({
    required String? token,
    required String? userId,
    required String? courseName,
  }) async {
    emit(UnenrollUserLoadingState());
    await DioHelper.postData(
            url: UNENROLLUSER,
            data: {
              'userId': userId,
              'courseName': courseName,
            },
            token: token)
        .then((value) {
      unEnrollUserStatus = value.statusCode;
      emit(UnenrollUserSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        unEnrollUserStatus = int.parse(message);
      }
      emit(UnenrollUserErrorState(error: error.toString()));
    });
  }

  /// patch >> update password
  int? updatePassStatus;
  Future<void> updateUserPass({
    required String token,
    required String oldPass,
    required String newPass,
    required String confirm,
  }) async {
    emit(UpdatePasswordLoadingState());
    await DioHelper.updateData(
            url: UBDATEUSERPASS,
            data: {
              'passwordCurrent': oldPass,
              'password': newPass,
              'passwordConfirm': confirm,
            },
            token: token)
        .then((value) {
      updatePassStatus = value.statusCode;
      emit(UpdatePasswordSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        updatePassStatus = int.parse(message);
      }
      emit(UpdatePasswordErrorState(error: error.toString()));
    });
  }

  /// cloud profile data
  bool imageOne = false;
  String? url1;
  bool imageTwo = false;
  String? url2;
  bool imageThree = false;
  String? url3;
  bool imagesIsUploaded = false;
  String? url;
  Future<void> uploadProfileImage({
    required String token,
    required XFile photo,
  }) async {
    final cloudinary = CloudinaryPublic(
      'dfx1fdoup',
      'tn7suyas',
      //cache: true,
    );
    try {
      CloudinaryResponse response =
          await cloudinary.uploadFile(CloudinaryFile.fromFile(
        photo.path,
        resourceType: CloudinaryResourceType.Image,
      ));
      if (imageOne) {
        url1 = response.url;
        studentImageNotFound1 = false;
        imageOne = false;
      }
      if (imageTwo) {
        url2 = response.url;
        studentImageNotFound2 = false;

        imageTwo = false;
      }
      if (imageThree) {
        url3 = response.url;
        studentImageNotFound3 = false;

        imageThree = false;
      } else {
        url = response.url;
      }
    } on CloudinaryException catch (e) {}
  }

  /// patch >> update current user data (photo)
  int? updateUserDataStatus;
  Future<void> updateUserData({
    required String token,
    String? url,
    String? phone,
    String? email,
  }) async {
    emit(UpdateUserDataLoadingState());
    var data = {};
    if (url != null) {
      data['url'] = url;
    }
    if (phone != null) {
      data['phone'] = phone;
    }
    if (email != null) {
      data['email'] = email;
    }

    await DioHelper.updateData(url: UPDATEUSERDATA, data: data, token: token)
        .then((value) {
      updateUserDataStatus = value.statusCode;
      if (url != null) {
        loginModel!.data!.photo = value.data['data']['user']['photo'];
      }
      if (email != null) {
        loginModel!.data!.email = value.data['data']['user']['email'];
      }
      if (phone != null) {
        loginModel!.data!.phone = value.data['data']['user']['phone'];
      }
      emit(UpdateUserDataSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        updateUserDataStatus = int.parse(message);
      }
      emit(UpdateUserDataErrorState(error: error.toString()));
    });
  }

  /// uploadAttendanceImages
  int? uploadAttendanceImagesStatus;
  Future<void> uploadAttendanceImages({
    required String token,
    required String url1,
    required String url2,
    required String url3,
  }) async {
    emit(UpdateUserDataLoadingState());
    await DioHelper.postData(
            url: '/users/uploadAttendanceImages',
            data: {
              'url1': url1,
              'url2': url2,
              'url3': url3,
            },
            token: token)
        .then((value) {
      uploadAttendanceImagesStatus = value.statusCode;
      loginModel!.data!.attendanceImages =
          value.data['user']['attendanceImages'];
      emit(UpdateUserDataSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        uploadAttendanceImagesStatus = int.parse(message);
      }
      emit(UpdateUserDataErrorState(error: error.toString()));
    });
  }

  /// past >> enrol current user to course
  int? enrollCourseToUserStatus;
  Future<void> enrollCourseToUser({
    BuildContext? context,
    required String token,
    required String courseName,
  }) async {
    emit(EnrollTocourseLoadingState());
    await DioHelper.postData(
            url: ENROLLCOURSETOUSER,
            data: {'courseName': courseName},
            token: token)
        .then(
      (value) {
        enrollCourseToUserStatus = value.statusCode;
        emit(EnrollTocourseSuccessState());
      },
    ).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        enrollCourseToUserStatus = int.parse(message);
      }
      emit(EnrollTocourseErrorState(error: error.toString()));
    });
  }

  /// past >> unenrol current user to course
  int? unEnrollCourseToUserStatus;
  Future<void> unEnrollCourseToUser({
    BuildContext? context,
    required String token,
    required String courseName,
  }) async {
    emit(EnrollTocourseLoadingState());
    await DioHelper.postData(
            url: UNENROLLCOURSETOUSER,
            data: {'courseName': courseName},
            token: token)
        .then(
      (value) {
        unEnrollCourseToUserStatus = value.statusCode;
        loginModel!.data!.courses = value.data['data']['user']['courses'];
        emit(EnrollTocourseSuccessState());
      },
    ).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        unEnrollCourseToUserStatus = int.parse(message);
      }
      emit(EnrollTocourseErrorState(error: error.toString()));
    });
  }

/////////////////////////////////////////////////////////
  /// Courses
/////////////////////////////////////////////////////////
  /// get >> Get All Courses
  int? getAllCoursesStatus;
  GetAllCoursesModel? getallCoursesModel;
  Future<void> getAllCourses({
    BuildContext? context,
    required String? token,
  }) async {
    emit(GetAllCoursesLoadingStete());
    await DioHelper.getData(url: GETALLCOURSES, token: token).then((value) {
      getAllCoursesStatus = value.statusCode;
      emit(GetAllCoursesSuccessStete());

      getallCoursesModel = GetAllCoursesModel.fromJson(value.data);
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        getAllCoursesStatus = int.parse(message);
      }
      emit(GetAllCoursesErrorStete(error: error.toString()));
    });
  }

  // creat course
  int? createCourseState;
  Future<void> createCourse({
    required String token,
    required String courseId,
    required String courseName,
  }) async {
    emit(CreateCoursesLoadingStete());
    await DioHelper.postData(
            url: CREATECOURSE,
            data: {
              'courseId': courseId,
              'courseName': courseName,
            },
            token: token)
        .then((value) {
      createCourseState = value.statusCode;
      emit(CreateCoursesSuccessStete());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        createCourseState = int.parse(message);
      }
      emit(CreateCoursesErrorStete(error: error.toString()));
    });
  }

  // update course
  int? updateCourseStatus;
  Future<void> updateCourse({
    required String token,
    required String currentCourse,
    required String courseName,
  }) async {
    await DioHelper.updateData(
            url: '$UPDATECOURSE/$currentCourse',
            data: {'courseName': courseName},
            token: token)
        .then((value) {
      updateCourseStatus = value.statusCode;
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        updateCourseStatus = int.parse(message);
      }
    });
  }

  /// delete course
  int? deleteCourseStatus;
  Future<void> deleteCourse({
    required String? token,
    required String? name,
  }) async {
    emit(DeleteCourseLoadingStete());
    await DioHelper.deleteData(url: '$DELCOURSE/$name', token: token)
        .then((value) {
      deleteCourseStatus = value.statusCode;
      emit(DeleteCourseSuccessStete());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        deleteCourseStatus = int.parse(message);
      }
      emit(DeleteCourseErrorStete(error: error.toString()));
    });
  }

  /////////////////////////////////////////////////////////
  /// Lectures
/////////////////////////////////////////////////////////
  /// get >> get all lectures
  AllLecModel? allLecModel;
  Future<void> getAllLec({
    required String? token,
    required String courseName,
  }) async {
    emit(GetAllLecLoadingStete());
    await DioHelper.getData(url: '$GETALLLEC/$courseName', token: token)
        .then((value) {
      allLecModel = AllLecModel.formJson(value.data);
      emit(GetAllLecSuccessStete());
    }).catchError((error) {
      emit(GetAllLecErrorStete(error: error.toString()));
    });
  }

  /// post >> creat lecture
  int? createSessionStatus;
  String? currentCousre;
  Future<void> createLec({
    required String token,
    required String courseName,
  }) async {
    emit(CreateLecLoadingStete());
    await DioHelper.postData(
            url: CREATELEC,
            data: {
              'course': courseName,
            },
            token: token)
        .then((value) {
      createSessionStatus = value.statusCode;
      emit(CreateLecSuccessStete());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        createSessionStatus = int.parse(message);
      }
      emit(CreateLecErrorStete(error: error.toString()));
    });
  }

  /// take attendance lecture
  int? takeAttLectureStatus;
  String? currentLecture;
  Future<void> takeAttLecture({
    required String token,
    required String courseName,
    required String lectureName,
  }) async {
    await DioHelper.postData(
            url: '$TAKEATTLEC1/$courseName/$lectureName/$TAKEATTLEC2',
            data: {
              'url': url,
            },
            token: token)
        .then((value) {
      takeAttLectureStatus = value.statusCode;
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        takeAttLectureStatus = int.parse(message);
      }
    });
  }

  //delete section
  int? deleteSession;
  Future<void> deleteLecture({
    required String token,
    required String lecture,
    required String courseName,
  }) async {
    await DioHelper.deleteData(
            url: '$DELLEC/$courseName/$lecture', token: token)
        .then((value) {
      deleteSession = value.statusCode;
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        deleteSession = int.parse(message);
      }
    });
  }

/////////////////////////////////////////////////////////
  /// Sections
/////////////////////////////////////////////////////////

  /// get >> get all sections
  AllSecModel? allSecModel;
  Future<void> getAllSec({
    required String? token,
    required String courseName,
  }) async {
    emit(GetAllSecLoadingStete());
    await DioHelper.getData(url: '$GETALLSEC/$courseName', token: token)
        .then((value) {
      allSecModel = AllSecModel.formJson(value.data);
      emit(GetAllSecSuccessStete());
    }).catchError((error) {
      emit(GetAllSecErrorStete(error: error.toString()));
    });
  }

  /// post >> creat section
  Future<void> createSec({
    required String token,
    required String courseName,
  }) async {
    emit(CreateSecLoadingStete());
    await DioHelper.postData(
            url: CREATESEC,
            data: {
              'course': courseName,
            },
            token: token)
        .then((value) {
      createSessionStatus = value.statusCode;
      emit(CreateSecSuccessStete());
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        createSessionStatus = int.parse(message);
      }
      emit(CreateSecErrorStete(error: error.toString()));
    });
  }

  /// take attendance lecture
  int? takeAttSectionStatus;
  String? currentSection;
  Future<void> takeAttSection({
    required String token,
    required String courseName,
    required String sectionName,
  }) async {
    await DioHelper.postData(
            url: '$TAKEATTSEC1/$courseName/$sectionName/$TAKEATTSEC2',
            data: {
              'url': url,
            },
            token: token)
        .then((value) {
      takeAttSectionStatus = value.statusCode;
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        takeAttSectionStatus = int.parse(message);
      }
    });
  }

  //delete section
  Future<void> deleteSection({
    required String token,
    required String section,
    required String courseName,
  }) async {
    await DioHelper.deleteData(
            url: '/sections/$courseName/$section', token: token)
        .then((value) {
      deleteSession = value.statusCode;
    }).catchError((error) {
      if (error is DioError) {
        String message = error.message.split(' ').last;
        message = message.substring(1, 4);
        deleteSession = int.parse(message);
      }
    });
  }
}
