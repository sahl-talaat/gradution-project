class ForgotPassModel {
  String? status;
  String? message;
  String? url;

  ForgotPassModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    url = json['url'];
  }
}
