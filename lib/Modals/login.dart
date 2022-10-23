class Login {
  bool? success;
  int? privilege;
  String? token;

  Login({required this.success, required this.privilege, required this.token});

  Login.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    privilege = json['privilege'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['privilege'] = this.privilege;
    data['token'] = this.token;
    return data;
  }
}






/*  Failure response */
// {
//     "success": false,
//     "msg": "Authentication failed. Invalid User."
// }
