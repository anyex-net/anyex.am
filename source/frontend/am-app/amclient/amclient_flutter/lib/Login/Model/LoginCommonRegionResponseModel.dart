class LoginCommonRegionResponseModel{

  List<LoginCommonRegionListModel>? list = [];

  LoginCommonRegionResponseModel({this.list});

  factory LoginCommonRegionResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return LoginCommonRegionResponseModel(
      list: (json['object'] as List)
          .map((i) => LoginCommonRegionListModel.fromJson(i))
          .toList(),
    );
  }
}

class LoginCommonRegionListModel{
  final String? id;
  final String? sCode;
  final String? lCode;
  final String? enName;
  final String? cnName;
  final String? area;
  final String? sortNum;
  final String? scode;
  final String? lcode;

  LoginCommonRegionListModel({this.id, this.sCode, this.lCode, this.enName, this.cnName, this.area, this.sortNum, this.scode, this.lcode});

  factory LoginCommonRegionListModel.fromJson(Map<dynamic, dynamic> json) {
    return LoginCommonRegionListModel(
      id : json['id'].toString(),
      sCode : json['sCode'].toString(),
      lCode : json['lCode'].toString(),
      enName : json['enName'].toString(),
      cnName : json['cnName'].toString(),
      area : json['area'].toString(),
      sortNum : json['sortNum'].toString(),
      scode : json['scode'].toString(),
      lcode : json['lcode'].toString(),
    );
  }
}