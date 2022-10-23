class GetAllCoursesModel {
  String? status;
  int? nomOfCourses;
  AllCoursesDataModel? data;

  GetAllCoursesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    nomOfCourses = json['result'];
    data = AllCoursesDataModel.fromJson(json['data']);
  }
}

class AllCoursesDataModel {
  List<InsideDataModel> courseData = [];
  AllCoursesDataModel.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      courseData.add(InsideDataModel.fromJson(element));
    });
  }
}

class InsideDataModel {
  List? students;
  List? professors;
  List? taS;
  String? idDb;
  String? courseId;
  String? courseName;
  InsideDataModel.fromJson(Map<String, dynamic> json) {
    students = json['students'];
    professors = json['professors'];
    taS = json['TAs'];
    idDb = json['_id'];
    courseId = json['courseId'];
    courseName = json['courseName'];
  }
}
