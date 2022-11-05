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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['privilege'] = privilege;
    data['token'] = token;
    return data;
  }
}

/*  Failure response */
// {
//     "success": false,
//     "msg": "Authentication failed. Invalid User."
// }
