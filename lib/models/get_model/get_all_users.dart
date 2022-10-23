class GetAllUsersModel {
  String? status;
  int? nomOfUsers;
  AllUsersDataModel? data;

  GetAllUsersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    nomOfUsers = json['result'];
    data = AllUsersDataModel.formJson(json['data']);
  }
}

class AllUsersDataModel {
  List<InsideDataModel> userData = [];
  AllUsersDataModel.formJson(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      userData.add(InsideDataModel.fromJson(element));
    });
  }
}

class InsideDataModel {
  String? photo;
  List? attendanceImages;
  List? courses;
  String? iddb;
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? role;
  String? passwordChangedAt;

  InsideDataModel.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    courses = json['courses'];
    attendanceImages = json['attendanceImages'];
    iddb = json['_id'];
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    passwordChangedAt = json['passwordChangedAt'];
  }
}
