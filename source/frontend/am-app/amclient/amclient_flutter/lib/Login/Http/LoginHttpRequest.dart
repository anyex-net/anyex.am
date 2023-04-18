
import 'package:amclient_flutter/Base/HttpRequest.dart';

//获取国家和地区
LoginCommonRegion() async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/common/region";
  Map<String, String> data = {

  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//获取谷歌验证码
LoginCommonKaptcha(String scene) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/common/kaptcha";
  Map<String, String> data = {
    "\"scene\"": "\"" + scene + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//注册 发送手机短信
LoginRegisterSmsSend({String country = '',String kaptcha = '',String mobNo = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/register/sms/send";
  Map<String, String> data = {
    "\"country\"": "\"" + country + "\"",
    "\"kaptcha\"": "\"" + kaptcha + "\"",
    "\"mobNo\"": "\"" + mobNo + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//注册 验证手机短信
LoginRegisterSmsCheck({String country = '',String loginPwd = '',String mobNo = '',String smsCode = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/register/sms/check";
  Map<String, String> data = {
    "\"country\"": "\"" + country + "\"",
    "\"loginPwd\"": "\"" + loginPwd + "\"",
    "\"mobNo\"": "\"" + mobNo + "\"",
    "\"smsCode\"": "\"" + smsCode + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//注册 发送邮箱码
LoginRegisterEmailSend({String country = '',String kaptcha = '',String email = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/register/email/send";
  Map<String, String> data = {
    "\"country\"": "\"" + country + "\"",
    "\"kaptcha\"": "\"" + kaptcha + "\"",
    "\"email\"": "\"" + email + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//注册 验证邮箱码
LoginRegisterEmailCheck({String country = '',String email = '',String emailCode = '',String loginPwd = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/register/email/check";
  Map<String, String> data = {
    "\"country\"": "\"" + country + "\"",
    "\"email\"": "\"" + email + "\"",
    "\"emailCode\"": "\"" + emailCode + "\"",
    "\"loginPwd\"": "\"" + loginPwd + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//登录
Login({String loginType = '',String username = '',String password = '',
  String deviceType = 'client',String deviceName = '',String deviceNumber = '',
  String appVersion = '',String buildVersion = '',}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/login";
  Map<String, String> data = {
    "\"loginType\"": "\"" + loginType + "\"",
    "\"username\"": "\"" + username + "\"",
    "\"password\"": "\"" + password + "\"",
    "\"deviceType\"": "\"" + deviceType + "\"",
    "\"deviceName\"": "\"" + deviceName + "\"",
    "\"deviceNumber\"": "\"" + deviceNumber + "\"",
    "\"appVersion\"": "\"" + appVersion + "\"",
    "\"buildVersion\"": "\"" + buildVersion + "\"",
  };

  print(kAddress + '?1111');
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//忘记密码 发送手机短信
LoginForgetSmsSend({String country = '',String kaptcha = '',String mobNo = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/forget/sms/send";
  Map<String, String> data = {
    "\"country\"": "\"" + country + "\"",
    "\"kaptcha\"": "\"" + kaptcha + "\"",
    "\"mobNo\"": "\"" + mobNo + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//忘记密码 验证手机短信
LoginForgetSmsCheck({String country = '',String mobNo = '',String smsCode = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/forget/sms/check";
  Map<String, String> data = {
    "\"country\"": "\"" + country + "\"",
    "\"mobNo\"": "\"" + mobNo + "\"",
    "\"smsCode\"": "\"" + smsCode + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//忘记密码 手机完成重置
LoginForgetSmsResetpass({String country = '',String loginPwd = '',String mobNo = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/forget/sms/resetpass";
  Map<String, String> data = {
    "\"country\"": "\"" + country + "\"",
    "\"loginPwd\"": "\"" + loginPwd + "\"",
    "\"mobNo\"": "\"" + mobNo + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//忘记密码 发送邮箱验证码
LoginForgetEmailSend({String country = '',String kaptcha = '',String email = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/forget/email/send";
  Map<String, String> data = {
    "\"country\"": "\"" + country + "\"",
    "\"kaptcha\"": "\"" + kaptcha + "\"",
    "\"email\"": "\"" + email + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//忘记密码 验证手机短信
LoginForgetEmailCheck({String country = '',String email = '',String emailCode = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/forget/email/check";
  Map<String, String> data = {
    "\"country\"": "\"" + country + "\"",
    "\"email\"": "\"" + email + "\"",
    "\"emailCode\"": "\"" + emailCode + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//忘记密码 验证手机短信
LoginForgetEmailResetpass({String country = '',String loginPwd = '',String email = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/forget/email/resetpass";
  Map<String, String> data = {
    "\"country\"": "\"" + country + "\"",
    "\"loginPwd\"": "\"" + loginPwd + "\"",
    "\"email\"": "\"" + email + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}


//交易所状态
CommonServerExchangeTradeStatus() async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/common/server/exchangeTradeStatus";
  Map<String, String> data = {
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//版本状态
CommonAppversion({String deviceType = 'client',String appVersion = '',String buildVersion = ''}) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/common/appversion";
  Map<String, String> data = {
    "\"deviceType\"": "\"" + deviceType + "\"",
    "\"appVersion\"": "\"" + appVersion + "\"",
    "\"buildVersion\"": "\"" + buildVersion + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//网络测试
UrlCheckHttp(String url) async {
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/common/server/timestamp";
  Map<String, String> data = {
  };
  return await httpHeader(url, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}