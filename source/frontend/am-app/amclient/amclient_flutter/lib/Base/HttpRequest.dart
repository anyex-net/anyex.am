import 'dart:convert';
import 'dart:io';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/main.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

import 'package:neveruseless/neveruseless.dart';

// import 'package:amclient_flutter/Base/UserManager.dart' as UnlockManager;
//测试地址
const String kAddressSys = "http://192.168.31.56:8092";
const String kWPFuturesAddressSys = "http://192.168.31.56:8092";
const String kWPFuturesSocketAddressSys = "ws://192.168.31.56:8087";
const String kNPFuturesAddressSys = "http://192.168.31.56:8092";
const String kNPFuturesSocketAddressSys = "ws://192.168.31.56:8087";
const String kDigitalAddressSys = "http://192.168.31.56:8092";
const String kDigitalSocketAddressSys = 'wss://wspri.coinall.ltd:8443/ws/v5/public?brokerId=9999';
const String kDigitalSocketPrivateAddressSys = 'wss://wspri.coinall.ltd:8443/ws/v5/private?brokerId=9999';


// const String kAddress = "http://192.168.31.9:8082";
// const String kWPFuturesAddress = "http://192.168.31.9:8082";
// const String kWPFuturesSocketAddress = "ws://192.168.31.9:8087";
// const String kNPFuturesAddress = "http://192.168.31.9:8082";
// const String kNPFuturesSocketAddress = "ws://192.168.31.9:8087";
// const String kDigitalAddress = "http://192.168.31.9:8082";
// const String kDigitalSocketAddress = 'wss://wspri.coinall.ltd:8443/ws/v5/public?brokerId=9999';
// const String kDigitalSocketPrivateAddress = 'wss://wspri.coinall.ltd:8443/ws/v5/private?brokerId=9999';

//生产地址
// const String kAddress   = "http://amapp.bitalk.com";


String kAddress = kAddressSys;
String kWPFuturesAddress = kWPFuturesAddressSys;
String kWPFuturesSocketAddress = kWPFuturesSocketAddressSys;
String kNPFuturesAddress = kNPFuturesAddressSys;
String kNPFuturesSocketAddress = kNPFuturesSocketAddressSys;
String kDigitalAddress = kDigitalAddressSys;
String kDigitalSocketAddress = kDigitalSocketAddressSys;
String kDigitalSocketPrivateAddress = kDigitalSocketPrivateAddressSys;

const httpAppVersion = '1.0.0';
const httpBuildVersion = 'build1';
const httpDeviceType = 'client';


//每次升级APP版本的操作如下：
//1：flutter clean
//2：安卓项目 /app/build.gradle 中的  versionName  修改版本
//3：上面的 androidVersion 修改版本
//4：redPackegAndroidVersion  redPackegAndroidBuild 修改为iOS对应版本f
//5：iOS端在Xcode中修改版本

httpHeader(String baseUrl,String url,String signMessage,String timestamp,{String HttpTypes = 'POST'}) async {

  var _tokenT = await neverLocalStorageRead("kUserDefaultsKeyToken");
  String _token = _tokenT.toString();
  if(_token.toString() == "null"){
    _token = '';
  }
  var dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 100000,
    receiveTimeout: 100000,
    // 5s
    headers: {
      HttpHeaders.userAgentHeader: 'anyex',
      HttpHeaders.acceptLanguageHeader : "zh-Hans-CN;q=1, en-CN;q=0.9",
      "token" : _token,
      HttpHeaders.acceptHeader : "*/*",
      HttpHeaders.contentTypeHeader : "application/x-www-form-urlencoded",
      'test-net-work-tag' : '1',//虚拟盘
      // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
    },
    followRedirects: false,
    validateStatus: (status) { return status! < 500 ; }
    // queryParameters:  {
    //   'format' : 'JSON',
    //   'charset': 'UTF-8',
    //   'version': '1.0',
    //   'appVersion': _version,
    //   'timestamp' : timestamp,
    //   'content' : signMessage
    // },
  ));
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client){
    client.badCertificateCallback=(cert, host, port){
      return true;
    };
  };
  //抓包代理
 // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
 //   // config the http client
 //   client.findProxy = (uri) {
 //     //proxy all request to localhost:8888
 //     return "PROXY localhost:8888";
 //   };
 //   // you can also create a new HttpClient to dio
 //   // return new HttpClient();
 // };
  try {
    Response _response ;
    if(HttpTypes == 'POST'){
      _response = await dio.post(
        url,
        data: signMessage,
        options: Options(
          contentType: Headers.jsonContentType,
          headers:{
            "token" : _token
          },
        ),
      );
    }else if(HttpTypes == 'GET'){
      _response = await dio.get(
        url,
        options: Options(
          contentType: Headers.jsonContentType,
          headers:{
            "token" : _token
          },
        ),
      );
    }else if(HttpTypes == 'GETBODY'){
      _response = await dio.get(
        url,
        queryParameters : jsonDecode(signMessage),
        options: Options(
          contentType: Headers.jsonContentType,
          headers:{
            "token" : _token
          },
        ),
      );
    }else{
      _response = await dio.post(
        url,
        data: signMessage,
        options: Options(
          contentType: Headers.jsonContentType,
          headers:{
            "token" : _token
          },
        ),
      );
    }
    // print(url);
    // print(_response);
    try{
      Map<String, dynamic> _responseData = convert.jsonDecode(_response.toString());
      if(_responseData.containsKey("code")){
        if((_responseData["code"] == 200 || _responseData["code"] == 2001) ){
          return _responseData;
        }else if(_responseData['code'] == 2023 || _responseData['code'] == 2000) {
          if(PagePick.nowPageName != '/LoginViewController'){
            showMyCustomText(_responseData['message']);
            PagePick.nowPageName = '/LoginViewController';
            navigatorKey.currentState!.pushNamedAndRemoveUntil('/LoginViewController', (route) => false,arguments: {
              // 'username' : UnlockManager.personMap['accountName'],
            });
          }
        }else{
          return _responseData;
        }
      }else{
        return _responseData;
      }
    }catch(e){
      showMyCustomText('解析有问题，检查DIO组');
    }
  } on DioError catch (e) {
    // print(e);
    // if (e.type == DioErrorType.connectTimeout) {
    //   e.error = '连接超时';
    // } else if (e.type == DioErrorType.sendTimeout) {
    //   e.error = '请求超时';
    // } else if (e.type == DioErrorType.receiveTimeout) {
    //   e.error = '响应超时';
    // } else if (e.type == DioErrorType.response) {
    //   e.error = '请求异常';
    // } else if (e.type == DioErrorType.cancel) {
    //   e.error = '请求取消';
    // } else {
    //   e.error = '请求错误,请检查网络或重新刷新';
    // }
    return e.error;
  }
}
