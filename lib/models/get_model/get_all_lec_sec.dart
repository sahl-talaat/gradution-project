// class AllLecModel {
//   String? status;
//   AllLecDataModel? data;

//   AllLecModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = AllLecDataModel.fromJson(json['data']);
//   }
// }

// class AllLecDataModel {
//   List<String> Lecture = [];
//   AllLecDataModel.fromJson(Map<String, dynamic> json) {
//     json['lecture'].forEach((element) {
//       Lecture.add(element);
//     });
//   }
// }

// ///////////////////////////////////////////////

// class AllSecModel {
//   String? status;
//   AllSecDataModel? data;
//   //AllLecSecDataModel? data;

//   AllSecModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = AllSecDataModel.fromJson(json['data']);
//   }
// }

// class AllSecDataModel {
//   List<String> Section = [];
//   AllSecDataModel.fromJson(Map<String, dynamic> json) {
//     json['lecture'].forEach((element) {
//       Section.add(element);
//     });
//   }
// }

class AllLecModel {
  String? status;
  List<LecDataModel>? lectures = [];
  AllLecModel.formJson(Map<String, dynamic> json) {
    status = json['status'];
    json['lectures'].forEach((element) {
      lectures!.add(LecDataModel.fromJson(element));
    });
  }
}

class LecDataModel {
  String? date;
  String? iddb;
  String? course;
  String? name;
  List<LecAttModel>? attendance = [];
  LecDataModel.fromJson(Map<String, dynamic> json) {
    iddb = json['iddb'];
    date = json['date'];
    course = json['course'];
    name = json['name'];
    json['attendance'].forEach((element) {
      attendance!.add(LecAttModel.fromJson(element));
    });
  }
}

class LecAttModel {
  String? iddb;
  String? studentName;
  String? studentId;
  LecAttModel.fromJson(Map<String, dynamic> json) {
    iddb = json['_id'];
    studentId = json['studentId'];
    studentName = json['studentName'];
  }
}

//////////////////////////////
/////////////////////////////
/////////////////////////////

class AllSecModel {
  String? status;
  List<SecDataModel>? sections = [];
  AllSecModel.formJson(Map<String, dynamic> json) {
    status = json['status'];
    json['sections'].forEach((element) {
      sections!.add(SecDataModel.fromJson(element));
      //sections = SecDataModel.fromJson(json['sections']);
    });
  }
}

class SecDataModel {
  String? date;
  String? iddb;
  String? course;
  String? name;
  List<SecAttModel>? attendance = [];
  SecDataModel.fromJson(Map<String, dynamic> json) {
    iddb = json['iddb'];
    date = json['date'];
    course = json['course'];
    name = json['name'];
    json['attendance'].forEach((element) {
      attendance!.add(SecAttModel.fromJson(element));
    });
  }
}

class SecAttModel {
  String? iddb;
  String? studentName;
  String? studentId;
  SecAttModel.fromJson(Map<String, dynamic> json) {
    iddb = json['iddb'];
    studentId = json['studentId'];
    studentName = json['studentName'];
  }
}
