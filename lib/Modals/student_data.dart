class StudentData {
  Result? result;

  StudentData({this.result});

  StudentData.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  int? lateCount;
  int? fineCount;
  List<String>? entry;
  String? sId;
  String? name;
  String? stdNo;
  int? year;
  String? branch;
  String? email;
  int? mobile;
  String? img;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Result(
      {this.lateCount,
        this.fineCount,
        this.entry,
        this.sId,
        this.name,
        this.stdNo,
        this.year,
        this.branch,
        this.email,
        this.mobile,
        this.img,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Result.fromJson(Map<String, dynamic> json) {
    lateCount = json['lateCount'];
    fineCount = json['fineCount'];
    entry = json['entry'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    stdNo = json['stdNo'];
    year = json['year'];
    branch = json['branch'];
    email = json['email'];
    mobile = json['mobile'];
    img = json['img'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lateCount'] = lateCount;
    data['fineCount'] = fineCount;
    data['entry'] = entry;
    data['_id'] = sId;
    data['name'] = name;
    data['stdNo'] = stdNo;
    data['year'] = year;
    data['branch'] = branch;
    data['email'] = email;
    data['mobile'] = mobile;
    data['img'] = img;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}