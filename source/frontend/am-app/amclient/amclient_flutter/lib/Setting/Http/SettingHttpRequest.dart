import 'package:amclient_flutter/Base/HttpRequest.dart';
//设置 账户管理
SettingAccountAccountInfo() async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/accountInfo";
  Map<String, String> data = {
    // "\"token\"": "\"" + _token + "\"",
    // "token="+_token,
  };
  // String data = _token;
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//绑定邮箱 发送邮箱验证码
SettingAccountSecurityBindEmailSend({String email = '',String kaptcha = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/bindEmail/emailSend";
  Map<String, String> data = {
    "\"email\"": "\"" + email + "\"",
    "\"kaptcha\"": "\"" + kaptcha + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//绑定邮箱 发送短信验证码
SettingAccountSecurityBindEmailSmsSend({String mobNo = '',String kaptcha = '',String country = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/bindEmail/smsSend";
  Map<String, String> data = {
    "\"mobNo\"": "\"" + mobNo + "\"",
    "\"kaptcha\"": "\"" + kaptcha + "\"",
    "\"country\"": "\"" + country + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//绑定邮箱确认
SettingAccountSecurityBindEmailConfirm({String email = '',String emailCode = '',String smsCode = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/bindEmail";
  Map<String, String> data = {
    "\"email\"": "\"" + email + "\"",
    "\"emailCode\"": "\"" + emailCode + "\"",
    "\"smsCode\"": "\"" + smsCode + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//绑定手机 发送短信验证码
SettingAccountSecurityBindPhoneSmsSend({String mobNo = '',String kaptcha = '',String country = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/bindPhone/smsSend";
  Map<String, String> data = {
    "\"mobNo\"": "\"" + mobNo + "\"",
    "\"kaptcha\"": "\"" + kaptcha + "\"",
    "\"country\"": "\"" + country + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//绑定手机 确认
SettingAccountSecurityBindPhone({String mobNo = '',String country = '',String smsCode = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/bindPhone";
  Map<String, String> data = {
    "\"mobNo\"": "\"" + mobNo + "\"",
    "\"country\"": "\"" + country + "\"",
    "\"smsCode\"": "\"" + smsCode + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//绑定GA 发送短信验证码
SettingAccountSecurityBindGoogleAuthSmsSend({String mobNo = '',String kaptcha = '',String country = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/bindGoogleAuth/smsSend";
  Map<String, String> data = {
    "\"mobNo\"": "\"" + mobNo + "\"",
    "\"kaptcha\"": "\"" + kaptcha + "\"",
    "\"country\"": "\"" + country + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//绑定GA 获取私钥
SettingAccountSecurityBindGoogleAuthBuildGASecretKey() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/bindGoogleAuth/buildGASecretKey";
  Map<String, String> data = {
    // "\"mobNo\"": "\"" + mobNo + "\"",
    // "\"kaptcha\"": "\"" + kaptcha + "\"",
    // "\"country\"": "\"" + country + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//绑定GA 获取私钥
SettingAccountSecurityBindGoogleAuth({String gaCode = '',String gaSecretKey = '',String smsCode = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/bindGoogleAuth";
  Map<String, String> data = {
    "\"gaCode\"": "\"" + gaCode + "\"",
    "\"gaSecretKey\"": "\"" + gaSecretKey + "\"",
    "\"smsCode\"": "\"" + smsCode + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//密码设置 修改登录密码
SettingAccountSecurityChangeLoginPwd({String newPassword = '',String oldPassword = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/changeLoginPwd";
  Map<String, String> data = {
    "\"newPassword\"": "\"" + newPassword + "\"",
    "\"oldPassword\"": "\"" + oldPassword + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}


//密码设置 修改资金密码
SettingAccountSecurityChangeCashPwd({String cashPwd = '',String gacode = '',String loginPwd = '',String smsCode =''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/changeCashPwd";
  Map<String, String> data = {
    "\"cashPwd\"": "\"" + cashPwd + "\"",
    "\"gaCode\"": "\"" + gacode + "\"",
    "\"loginPwd\"": "\"" + loginPwd + "\"",
    "\"smsCode\"": "\"" + smsCode + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//登录日志
SettingAccountSecurityLoginLogs() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/loginLogs";
  Map<String, String> data = {
    // "\"cashPwd\"": "\"" + cashPwd + "\"",
    // "\"gaCode\"": "\"" + gacode + "\"",
    // "\"loginPwd\"": "\"" + loginPwd + "\"",
    // "\"smsCode\"": "\"" + smsCode + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//安全设置历史
SettingAccountSecuritySettingLogs() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/account/security/settingLogs";
  Map<String, String> data = {
    // "\"cashPwd\"": "\"" + cashPwd + "\"",
    // "\"gaCode\"": "\"" + gacode + "\"",
    // "\"loginPwd\"": "\"" + loginPwd + "\"",
    // "\"smsCode\"": "\"" + smsCode + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}