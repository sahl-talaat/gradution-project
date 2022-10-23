class LoginModel {
  String? status;
  String? token;
  LoginDataModel? data;

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    data = LoginDataModel.formJson(json['data']);
  }
}

class LoginDataModel {
  List? courses;
  String? photo;
  List? attendanceImages;
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? role;
  LoginDataModel.formJson(Map<String, dynamic> json) {
    courses = json['courses'];
    photo = json['photo'];
    attendanceImages = json['attendanceImages'];
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
  }
}
