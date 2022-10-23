abstract class AppStates {}

class AppInitialStete extends AppStates {}

/////////////////////////////////////////////////
////////// authentication
//login states
class AppLoginLoadingState extends AppStates {}

class AppLoginSuccessState extends AppStates {}

class AppLoginErrorState extends AppStates {
  final String error;

  AppLoginErrorState(this.error);
}

//log out states
class AppLogOutLoadingState extends AppStates {}

class AppLogOutSuccessState extends AppStates {}

class AppLogOutErrorState extends AppStates {
  final String error;

  AppLogOutErrorState(this.error);
}

//forgot password states
class AppForgotPassLoadingState extends AppStates {}

class AppForgotPassSuccessState extends AppStates {}

class AppForgotPassErrorState extends AppStates {
  final String error;

  AppForgotPassErrorState(this.error);
}

//forgot password states
class AppResetPassLoadingState extends AppStates {}

class AppResetPassSuccessState extends AppStates {}

class AppResetPassErrorState extends AppStates {
  final String error;

  AppResetPassErrorState(this.error);
}

////////////////////////////////////////////////
///////////////// user
////////////////////////////////////////////////
//creat user states
class CreatUserLoadingStete extends AppStates {}

class CreatUserSuccessStete extends AppStates {}

class CreatUserErrorStete extends AppStates {
  String error;
  CreatUserErrorStete({required this.error});
}

//get all users states
class GetAllUsersLoadingStete extends AppStates {}

class GetAllUsersSuccessStete extends AppStates {}

class GetAllUsersErrorStete extends AppStates {
  String error;
  GetAllUsersErrorStete({required this.error});
}

//get courses enroll states
class CoursesEnrollLoadingStete extends AppStates {}

class CoursesEnrollSuccessStete extends AppStates {}

class CoursesEnrollErrorStete extends AppStates {
  String error;
  CoursesEnrollErrorStete({required this.error});
}

// //get users states
// class GetUsersLoadingStete extends AppStates {}

// class GetUsersSuccessStete extends AppStates {}

// class GetUsersErrorStete extends AppStates {
//   String error;
//   GetUsersErrorStete({required this.error});
// }

//delete users states
class DeleteUsersLoadingStete extends AppStates {}

class DeleteUsersSuccessStete extends AppStates {}

class DeleteUsersErrorStete extends AppStates {
  String error;
  DeleteUsersErrorStete({required this.error});
}

//enrol user states
class EnrollUserLoadingState extends AppStates {}

class EnrollUserSuccessState extends AppStates {}

class EnrollUserErrorState extends AppStates {
  String error;
  EnrollUserErrorState({required this.error});
}

//unenrol user states
class UnenrollUserLoadingState extends AppStates {}

class UnenrollUserSuccessState extends AppStates {}

class UnenrollUserErrorState extends AppStates {
  String error;
  UnenrollUserErrorState({required this.error});
}

//unenrol user states
class UpdateUserDataLoadingState extends AppStates {}

class UpdateUserDataSuccessState extends AppStates {}

class UpdateUserDataErrorState extends AppStates {
  String error;
  UpdateUserDataErrorState({required this.error});
}

//enrol user states
class EnrollTocourseLoadingState extends AppStates {}

class EnrollTocourseSuccessState extends AppStates {}

class EnrollTocourseErrorState extends AppStates {
  String error;
  EnrollTocourseErrorState({required this.error});
}

// update password
class UpdatePasswordLoadingState extends AppStates {}

class UpdatePasswordSuccessState extends AppStates {}

class UpdatePasswordErrorState extends AppStates {
  String error;
  UpdatePasswordErrorState({required this.error});
}

////////////////////////////////////////////////
///////////////// courses //////////////////////
////////////////////////////////////////////////
//get all courses states
class GetAllCoursesLoadingStete extends AppStates {}

class GetAllCoursesSuccessStete extends AppStates {}

class GetAllCoursesErrorStete extends AppStates {
  String error;
  GetAllCoursesErrorStete({required this.error});
}

// post creat course
class CreateCoursesLoadingStete extends AppStates {}

class CreateCoursesSuccessStete extends AppStates {}

class CreateCoursesErrorStete extends AppStates {
  String error;
  CreateCoursesErrorStete({required this.error});
}

//delete course states
class DeleteCourseLoadingStete extends AppStates {}

class DeleteCourseSuccessStete extends AppStates {}

class DeleteCourseErrorStete extends AppStates {
  String error;
  DeleteCourseErrorStete({required this.error});
}

////////////// lecture
//get all lec ststes
class GetAllLecLoadingStete extends AppStates {}

class GetAllLecSuccessStete extends AppStates {}

class GetAllLecErrorStete extends AppStates {
  String error;
  GetAllLecErrorStete({required this.error});
}

//creat lec
class CreateLecLoadingStete extends AppStates {}

class CreateLecSuccessStete extends AppStates {}

class CreateLecErrorStete extends AppStates {
  String error;
  CreateLecErrorStete({required this.error});
}

/////////////// sections
//get all sec ststes
class GetAllSecLoadingStete extends AppStates {}

class GetAllSecSuccessStete extends AppStates {}

class GetAllSecErrorStete extends AppStates {
  String error;
  GetAllSecErrorStete({required this.error});
}

//creat sec
class CreateSecLoadingStete extends AppStates {}

class CreateSecSuccessStete extends AppStates {}

class CreateSecErrorStete extends AppStates {
  String error;
  CreateSecErrorStete({required this.error});
}
