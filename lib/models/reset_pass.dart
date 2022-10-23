// class LoginModel {
//   String? status;
//   String? message;
//   String? token;
//   String? photo;
//   List? courses;
//   String? userId;
//   String? name;
//   String? email;
//   String? phone;
//   String? role;
//   //UserData? data;

//   LoginModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'] != null ? json['message'] : null;
//     token = json['token'] != null ? json['token'] : null;
//     photo = json['data']['user']['photo'] != null
//         ? json['data']['user']['photo']
//         : null;
//     courses = json['data']['user']['courses'] != null
//         ? json['data']['user']['courses']
//         : null;

//     userId = json['data']['user']['userId'] != null
//         ? json['data']['user']['userId']
//         : null;
//     name = json['data']['user']['name'] != null
//         ? json['data']['user']['name']
//         : null;
//     email = json['data']['user']['email'] != null
//         ? json['data']['user']['email']
//         : null;
//     phone = json['data']['user']['phone'] != null
//         ? json['data']['user']['phone']
//         : null;
//     role = json['data']['user']['role'] != null
//         ? json['data']['user']['role']
//         : null;
//   }
// }

// // class UserData {
// //   String? photo;
// //   List? courses;
// //   String? dbid;
// //   String? userId;
// //   String? name;
// //   String? email;
// //   String? phone;
// //   String? role;
// //   String? password;
// //   String? dbnone;

// //   UserData({
// //     this.photo,
// //     this.courses,
// //     this.dbid,
// //     this.userId,
// //     this.name,
// //     this.email,
// //     this.phone,
// //     this.role,
// //     this.password,
// //     this.dbnone,
// //   });

// //   UserData.fromJson(Map<String, dynamic> json) {
// //     photo = json['photo'];
// //     courses = json['courses'];
// //     dbid = json['_id'];
// //     userId = json['userId'];
// //     name = json['name'];
// //     email = json['email'];
// //     phone = json['phone'];
// //     role = json['role'];
// //     password = json['password'];
// //     dbnone = json['__v'];
// //   }
// // }
