class SettingHistorySettingLogsResponseModel{

  final int? code;
  final String? message;
  final List<SettingHistorySettingLogsListModel>? object;

  SettingHistorySettingLogsResponseModel({this.code, this.message, this.object});

  factory SettingHistorySettingLogsResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return SettingHistorySettingLogsResponseModel(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => SettingHistorySettingLogsListModel.fromJson(i))
          .toList(),
    );
  }
}

class SettingHistorySettingLogsListModel{
  final String? id;
  final String? systemName;
  final String? accountId;
  final String? accountName;
  final String? opType;
  final String? ipAddr;
  final String? regionName;
  final String? url;
  final String? content;
  final String? remark;
  final int? createDate;
  final String? timeStart;
  final String? timeEnd;

  SettingHistorySettingLogsListModel({this.id, this.systemName, this.accountId, this.accountName, this.opType, this.ipAddr, this.regionName, this.url, this.content, this.remark, this.createDate, this.timeStart, this.timeEnd});

  factory SettingHistorySettingLogsListModel.fromJson(Map<dynamic, dynamic> json) {
    return SettingHistorySettingLogsListModel(
      id : json['id'].toString(),
      systemName : json['systemName'].toString(),
      accountId : json['accountId'].toString(),
      accountName : json['accountName'].toString(),
      opType : json['opType'].toString(),
      ipAddr : json['ipAddr'].toString(),
      regionName : json['regionName'].toString(),
      url : json['url'].toString(),
      content : json['content'].toString(),
      remark : json['remark'].toString(),
      createDate : json['createDate'],
      timeStart : json['timeStart'].toString(),
      timeEnd : json['timeEnd'].toString(),
    );
  }
}