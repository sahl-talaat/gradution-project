class CreatCourse {
  String? status;
  CreatCourse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }
}
