import 'dart:convert';
import 'dart:io';

import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/HttpRequest.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Base/UserManager.dart';
import 'package:amclient_flutter/Login/Http/LoginHttpRequest.dart';
import 'package:amclient_flutter/Login/Model/LoginCommonRegionResponseModel.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neveruseless/neveruseless.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../main.dart';
class LoginViewController extends StatefulWidget {
  final arguments;
  const LoginViewController({Key? key, this.arguments}) : super(key: key);

  @override
  _LoginViewControllerState createState() => _LoginViewControllerState();
}

class _LoginViewControllerState extends State<LoginViewController> {

  var _loginType = '0';// 0：手机号登录  1：邮箱登录 2：验证码登录

  bool _isAutoLogin = false;

  bool _isRememberMe = false;

  //手机号
  final TextEditingController _phoneNumberTextController = TextEditingController();

  //国家地区
  List<LoginCommonRegionListModel> _commonRegionList = [];
  final List<DropdownMenuItem<String>> _commonRegionItems = [
    DropdownMenuItem(
      child: Container(
        child: const Text( "+86",
          style: TextStyle(color: Colors.black,fontSize: 13),
        ),
        alignment: Alignment.center,
      ),
      value: '86',
    ),
  ];
  var _local = '86';


  bool _canTouch = true;

  //密码
  final TextEditingController _passwordTextController = TextEditingController();

  String _deviceName = '';
  String _deviceNumber = '';

  @override
  void initState() {
    // doWhenWindowReady(() {
    //   final initialSize = Size(800, 600);
    //   appWindow.size = initialSize;
    //   appWindow.alignment = Alignment.center;
    //   // appWindow.show();
    // });
    super.initState();
    PagePick.nowPageName = '/LoginViewController';

    _deviceName =  Platform.isMacOS ? "macos" : 'windows';
    _deviceNumber = Platform.isMacOS ? "macos" : 'windows';

    _LoginCommonRegionHttp();
    _CommonAppversionHttp();
    _readUserConfiguration();

  }

  @override
  void dispose() {
    super.dispose();
  }

  _readUserConfiguration() async{
    var _tempIsRememberMe = await neverLocalStorageRead("kLoginIsRememberMe");
    if(_tempIsRememberMe.toString() == 'true'){
      _isRememberMe = true;
    }else{
      _isRememberMe = false;
    }
    var _tempUserName = await neverLocalStorageRead("kLoginUserName");
    if(_tempUserName.toString() != "null"){
      _phoneNumberTextController.text = _tempUserName.toString();
    }else{
      _phoneNumberTextController.text = '';
    }

    var _tempUserPass = await neverLocalStorageRead("kLoginUserPassword");
    if(_isRememberMe){
      if(_tempUserPass.toString() != 'null'){
        _passwordTextController.text = _tempUserPass.toString();
      }else{
        _passwordTextController.text = '';
      }
    }else{
      _passwordTextController.text = '';
    }


  }


  //获取 国家地区
  Future _LoginCommonRegionHttp() async{
    var response = await LoginCommonRegion();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _commonRegionList = LoginCommonRegionResponseModel.fromJson(response).list!;
          if(_commonRegionList.isNotEmpty){
            _commonRegionItems.clear();
            for(int i =0;i<_commonRegionList.length;i++){
              _commonRegionItems.add(DropdownMenuItem(
                child: Container(
                  child: Text( "+" + _commonRegionList[i].lCode!,
                    style: const TextStyle(color: Colors.black,fontSize: 13),
                  ),
                  alignment: Alignment.center,
                ),
                value: _commonRegionList[i].lcode!,
              ),
              );
            }
          }
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[获取国家地区]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取国家地区]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //获取 版本状态
  Future _CommonAppversionHttp() async{
    var response = await CommonAppversion(appVersion:httpAppVersion, buildVersion:httpBuildVersion,);
    print(response);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        try{
          String forceUpdate = response['object']['forceUpdate'].toString();
          if(forceUpdate != '0'){
            _progress = 0.0;
            _isPause = false;
            _isStart = false;
            _isDone = false;
            _updateView(forceUpdate);
          }

        }catch(e){

        }
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[版本状态]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[版本状态]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  late DownloaderUtils options;
  late DownloaderCore core;
  var _progress = 0.0;
  bool _isPause = false;
  bool _isStart = false;
  bool _isDone = false;


  void _updateView(String forceUpdate){
    AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      dismissOnBackKeyPress:false,
      width:MediaQuery.of(context).size.width / 2,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.BOTTOMSLIDE,
      body: StatefulBuilder(
          builder: (BuildContext context, StateSetter msetState) {
            return Column(
              children: [
                const Text("APP存在更新，是否进行下载?",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w600),),
                Offstage(
                  offstage: !_isStart,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: LinearPercentIndicator(
                            restartAnimation:false,
                            animation: false,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: _progress,
                            center: Text((NumUtil.getNumByValueDouble((_progress* 100), 2)).toString() + '%'),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: APP_MainGreenColor,
                          ),
                          height: 20,
                        ),
                      ),
                      IconButton(
                        icon: Icon(_isPause ? Icons.not_started_outlined : Icons.pause_circle_outline_rounded),
                        onPressed: (){
                          msetState(() {
                            if(_isPause){ //暂停
                              core.resume();
                            }else{
                              core.pause();
                            }
                            _isPause = !_isPause;
                          });

                        },
                      )
                    ],
                  ),
                ),
                Offstage(
                  offstage: _isStart,
                  child: const SizedBox(height: 20,),
                ),
                Row(
                  children: [
                    const Expanded(child: SizedBox(),flex: 1,),
                    Expanded(
                      child: Offstage(
                        offstage: forceUpdate == "-1",
                        child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
                          onPressed: (){
                            try{
                              if(!core.isCancelled){
                                _progress = 0.0;
                                core.cancel();
                                _isPause = false;
                                _isStart = false;
                                _isDone = false;
                                msetState(() {
                                });
                              }
                            }catch(e){

                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: const Text("取消",maxLines: 1,overflow: TextOverflow.clip,softWrap: true,style: TextStyle(fontSize: 13),),
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(APP_MainGreenColor)),
                        onPressed: () async {
                          if(_isStart){
                            showMyCustomText("已经开始下载,请稍等");
                            return;
                          }
                          String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                          if(selectedDirectory.toString() != '' && selectedDirectory.toString() != 'null'){
                            msetState(() {
                              _isStart = true;
                            });
                            try{
                              core = await Flowder.download('http://bitalk.oss-cn-hangzhou.aliyuncs.com/Anyex.GAMS.zip', DownloaderUtils(
                                progressCallback: (current, total) {
                                  _progress = (current / total) >= 1.0 ? 1.0 : (current / total);
                                  msetState(() {
                                  });
                                },
                                file: File('$selectedDirectory/Anyex.GAMS.zip'),
                                progress: ProgressImplementation(),
                                onDone: () {
                                  showMyCustomHelpText("下载完成,请安装更新");
                                },

                                deleteOnCancel: true,
                              ));
                            }catch(e){
                              msetState(() {
                                _isStart = false;
                                print("下载错误");
                                showMyCustomText("下载错误,请重试或检查网络");
                              });
                            }
                          }else{
                            print("取消");
                            return;
                          }

                        },
                        child: Container(
                          child: const Text("下载",maxLines: 1,overflow: TextOverflow.clip,softWrap: true,style: TextStyle(fontSize: 13),),
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox(),flex: 1,),
                  ],
                ),
                const SizedBox(height: 15,),
              ],
            );
          }),
    ).show();
  }

  //修改URL
  void _updateURLView() async{
    //基础地址
    final TextEditingController _kUserAddress = TextEditingController();
    _kUserAddress.text = kAddress;
    bool _kUserAddressCan = false;

    //外盘地址
    final TextEditingController _kUserWPFuturesAddress = TextEditingController();
    _kUserWPFuturesAddress.text = kWPFuturesAddress;
    bool _kUserWPFuturesAddressCan = false;

    //外盘socket
    final TextEditingController _kUserWPFuturesSocketAddress = TextEditingController();
    _kUserWPFuturesSocketAddress.text = kWPFuturesSocketAddress;

    //内盘地址
    final TextEditingController _kUserNPFuturesAddress = TextEditingController();
    _kUserNPFuturesAddress.text = kNPFuturesAddress;
    bool _kUserNPFuturesAddressCan = false;

    //内盘socket
    final TextEditingController _kUserNPFuturesSocketAddress = TextEditingController();
    _kUserNPFuturesSocketAddress.text = kNPFuturesSocketAddress;

    //数字货币地址
    final TextEditingController _kUserDigitalAddress = TextEditingController();
    _kUserDigitalAddress.text = kDigitalAddress;
    bool _kUserDigitalAddressCan = false;

    //数字货币公共socket
    final TextEditingController _kUserDigitalSocketAddress = TextEditingController();
    _kUserDigitalSocketAddress.text = kDigitalSocketAddress;

    //数字货币私有socket
    final TextEditingController _kUserDigitalSocketPrivateAddress = TextEditingController();
    _kUserDigitalSocketPrivateAddress.text = kDigitalSocketPrivateAddress;


    AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      dismissOnBackKeyPress:false,
      width:MediaQuery.of(context).size.width * 2 / 3,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.BOTTOMSLIDE,
      body: StatefulBuilder(
          builder: (BuildContext context, StateSetter msetURLState) {

            const double _fontSize = 12;
            const double _textHeight = 35;
            Future _UrlCheckHttp(String url,String name) async{
              var response = await UrlCheckHttp(url);
              if (response is Map) {
                if(!mounted){
                  return;
                }
                if(response['code'] == 200){
                  if(name == '基础地址'){
                    _kUserAddressCan = true;
                    // showMyCustomText('基础地址测试通过');
                  }else if(name == '外盘地址'){
                    _kUserWPFuturesAddressCan = true;
                  }else if(name == '内盘地址'){
                    _kUserNPFuturesAddressCan = true;
                  }else if(name == '数字货币'){
                    _kUserDigitalAddressCan = true;
                  }
                }
              }else {
                if(name == '基础地址'){
                  _kUserAddressCan = false;
                  // showMyCustomText('基础地址测试未通过');
                }else if(name == '外盘地址'){
                  _kUserWPFuturesAddressCan = false;
                }else if(name == '内盘地址'){
                  _kUserNPFuturesAddressCan = false;
                }else if(name == '数字货币'){
                  _kUserDigitalAddressCan = false;
                }
              }
            }

            return Container(
              padding:const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    child: const Text("网络设置",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600),),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("基础地址:",style: TextStyle(fontSize: _fontSize,color: Colors.black),),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          height: _textHeight,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              ),
                              hintText: '基础网络地址',
                              hintStyle: const TextStyle(color: Colors.grey,fontSize: _fontSize),
                              suffix: GestureDetector(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: const Text("系统默认",style: TextStyle(color: Colors.white,fontSize: _fontSize),),

                                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                                ),
                                onTap: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  msetURLState(() {
                                    _kUserAddress.text = kAddressSys;
                                  });
                                },
                              ),
                            ),
                            controller: _kUserAddress,
                            autocorrect:false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal : true,
                            ),
                            style: const TextStyle(color: Colors.black,fontSize: _fontSize),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: const Text("还原",style: TextStyle(color: Colors.white,fontSize: _fontSize),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          msetURLState(() {
                            _kUserAddress.text = kAddress;
                          });
                        },
                      ),
                    ],
                  ),//kAddressSys
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("外盘地址:",style: TextStyle(fontSize: _fontSize,color: Colors.black),),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          height: _textHeight,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              ),
                              hintText: '外盘地址',
                              hintStyle: const TextStyle(color: Colors.grey,fontSize: _fontSize),
                              suffix: GestureDetector(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: const Text("系统默认",style: TextStyle(color: Colors.white,fontSize: _fontSize),),

                                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                                ),
                                onTap: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  msetURLState(() {
                                    _kUserWPFuturesAddress.text = kWPFuturesAddressSys;
                                  });
                                },
                              ),
                            ),
                            controller: _kUserWPFuturesAddress,
                            autocorrect:false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal : true,
                            ),
                            style: const TextStyle(color: Colors.black,fontSize: _fontSize),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: const Text("还原",style: TextStyle(color: Colors.white,fontSize: _fontSize),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          msetURLState(() {
                            _kUserWPFuturesAddress.text = kWPFuturesAddress;
                          });
                        },
                      ),
                    ],
                  ),//kWPFuturesAddress
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("外盘Socket地址:",style: TextStyle(fontSize: _fontSize,color: Colors.black),),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          height: _textHeight,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              ),
                              hintText: '外盘Socket地址',
                              hintStyle: const TextStyle(color: Colors.grey,fontSize: _fontSize),
                              suffix: GestureDetector(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: const Text("系统默认",style: TextStyle(color: Colors.white,fontSize: _fontSize),),

                                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                                ),
                                onTap: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  msetURLState(() {
                                    _kUserWPFuturesSocketAddress.text = kWPFuturesSocketAddressSys;
                                  });
                                },
                              ),
                            ),
                            controller: _kUserWPFuturesSocketAddress,
                            autocorrect:false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal : true,
                            ),
                            style: const TextStyle(color: Colors.black,fontSize: _fontSize),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: const Text("还原",style: TextStyle(color: Colors.white,fontSize: _fontSize),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          msetURLState(() {
                            _kUserWPFuturesSocketAddress.text = kWPFuturesSocketAddress;
                          });
                        },
                      ),
                    ],
                  ),//kWPFuturesSocketAddress
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("内盘地址:",style: TextStyle(fontSize: _fontSize,color: Colors.black),),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          height: _textHeight,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              ),
                              hintText: '内盘地址',
                              hintStyle: const TextStyle(color: Colors.grey,fontSize: _fontSize),
                              suffix: GestureDetector(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: const Text("系统默认",style: TextStyle(color: Colors.white,fontSize: _fontSize),),

                                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                                ),
                                onTap: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  msetURLState(() {
                                    _kUserNPFuturesAddress.text = kNPFuturesAddressSys;
                                  });
                                },
                              ),
                            ),
                            controller: _kUserNPFuturesAddress,
                            autocorrect:false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal : true,
                            ),
                            style: const TextStyle(color: Colors.black,fontSize: _fontSize),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: const Text("还原",style: TextStyle(color: Colors.white,fontSize: _fontSize),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          msetURLState(() {
                            _kUserNPFuturesAddress.text = kNPFuturesAddress;
                          });
                        },
                      ),
                    ],
                  ),//kNPFuturesAddress
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("内盘Socket地址:",style: TextStyle(fontSize: _fontSize,color: Colors.black),),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          height: _textHeight,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              ),
                              hintText: '内盘Socket地址',
                              hintStyle: const TextStyle(color: Colors.grey,fontSize: 15),
                              suffix: GestureDetector(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: const Text("系统默认",style: TextStyle(color: Colors.white,fontSize: _fontSize),),

                                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                                ),
                                onTap: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  msetURLState(() {
                                    _kUserNPFuturesSocketAddress.text = kNPFuturesSocketAddressSys;
                                  });
                                },
                              ),
                            ),
                            controller: _kUserNPFuturesSocketAddress,
                            autocorrect:false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal : true,
                            ),
                            style: const TextStyle(color: Colors.black,fontSize: _fontSize),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: const Text("还原",style: TextStyle(color: Colors.white,fontSize: _fontSize),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          msetURLState(() {
                            _kUserNPFuturesSocketAddress.text = kNPFuturesSocketAddress;
                          });
                        },
                      ),
                    ],
                  ),//kNPFuturesSocketAddress
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("数字货币地址:",style: TextStyle(fontSize: _fontSize,color: Colors.black),),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          height: _textHeight,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              ),
                              hintText: '数字货币地址',
                              hintStyle: const TextStyle(color: Colors.grey,fontSize: 15),
                              suffix: GestureDetector(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: const Text("系统默认",style: TextStyle(color: Colors.white,fontSize: _fontSize),),

                                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                                ),
                                onTap: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  msetURLState(() {
                                    _kUserDigitalAddress.text = kDigitalAddressSys;
                                  });
                                },
                              ),
                            ),
                            controller: _kUserDigitalAddress,
                            autocorrect:false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal : true,
                            ),
                            style: const TextStyle(color: Colors.black,fontSize: _fontSize),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: const Text("还原",style: TextStyle(color: Colors.white,fontSize: _fontSize),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          msetURLState(() {
                            _kUserDigitalAddress.text = kDigitalAddress;
                          });
                        },
                      ),
                    ],
                  ),//kDigitalAddress
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("数字货币公共Socket地址:",style: TextStyle(fontSize: _fontSize,color: Colors.black),),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          height: _textHeight,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              ),
                              hintText: '数字货币公共Socket地址',
                              hintStyle: const TextStyle(color: Colors.grey,fontSize: _fontSize),
                              suffix: GestureDetector(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: const Text("系统默认",style: TextStyle(color: Colors.white,fontSize: _fontSize),),

                                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                                ),
                                onTap: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  msetURLState(() {
                                    _kUserDigitalSocketAddress.text = kDigitalSocketAddressSys;
                                  });
                                },
                              ),
                            ),
                            controller: _kUserDigitalSocketAddress,
                            autocorrect:false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal : true,
                            ),
                            style: const TextStyle(color: Colors.black,fontSize: _fontSize),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: const Text("还原",style: TextStyle(color: Colors.white,fontSize: _fontSize),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          msetURLState(() {
                            _kUserDigitalSocketAddress.text = kDigitalSocketAddressSys;
                          });
                        },
                      ),
                    ],
                  ),//kDigitalSocketAddress
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("数字货币私有Socket地址:",style: TextStyle(fontSize: _fontSize,color: Colors.black),),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          height: _textHeight,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              ),
                              hintText: '数字货币私有Socket地址',
                              hintStyle: const TextStyle(color: Colors.grey,fontSize: _fontSize),
                              suffix: GestureDetector(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: const Text("系统默认",style: TextStyle(color: Colors.white,fontSize: _fontSize),),

                                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                                ),
                                onTap: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  msetURLState(() {
                                    _kUserDigitalSocketPrivateAddress.text = kDigitalSocketPrivateAddressSys;
                                  });
                                },
                              ),
                            ),
                            controller: _kUserDigitalSocketPrivateAddress,
                            autocorrect:false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal : true,
                            ),
                            style: const TextStyle(color: Colors.black,fontSize: _fontSize),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: const Text("还原",style: TextStyle(color: Colors.white,fontSize: _fontSize),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),

                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          msetURLState(() {
                            _kUserDigitalSocketPrivateAddress.text = kDigitalSocketPrivateAddress;
                          });
                        },
                      ),
                    ],
                  ),//kDigitalSocketAddress
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: const Text("网络测试",style: TextStyle(color: Colors.white,fontSize: 13),),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(5, 6, 5, 6),

                          ),
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            showMyCustomLoading('网络测试中...');
                            _UrlCheckHttp(_kUserAddress.text,'基础地址');
                            _UrlCheckHttp(_kUserWPFuturesAddress.text,'外盘地址');
                            _UrlCheckHttp(_kUserNPFuturesAddress.text,'内盘地址');
                            _UrlCheckHttp(_kUserDigitalAddress.text,'数字货币');

                            Future.delayed(const Duration(milliseconds: 2000)).then((onValue) async{
                              closeMyCustomBotLoading();
                              if(_kUserAddressCan && _kUserWPFuturesAddressCan && _kUserNPFuturesAddressCan && _kUserDigitalAddressCan){
                                showMyCustomText('网络测试全部通过');
                              }else{
                                showMyCustomText( (_kUserAddressCan ? '' : '基础地址 ') +
                                    (_kUserWPFuturesAddressCan ? '' : '外盘地址 ') +
                                    (_kUserNPFuturesAddressCan ? '' : '内盘地址 ') +
                                    (_kUserDigitalAddressCan ? '' : '数字货币 ') +
                                    '测试未通过');
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: APP_MainGreenColor,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: const Text("保存",style: TextStyle(color: Colors.white,fontSize: 13),),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(5, 6, 5, 6),

                          ),
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            msetURLState(() {
                              if(!_kUserAddress.text.toString().startsWith("http://") &&  !_kUserAddress.text.toString().startsWith("https://")){
                                showMyCustomText("基础地址:请修改添加正确的http://或https://开头");
                                return;
                              }

                              if(!_kUserWPFuturesAddress.text.toString().startsWith("http://") &&  !_kUserWPFuturesAddress.text.toString().startsWith("https://")){
                                showMyCustomText("外盘地址:请修改添加正确的http://或https://开头");
                                return;
                              }

                              if(!_kUserWPFuturesSocketAddress.text.toString().startsWith("ws://") &&  !_kUserWPFuturesSocketAddress.text.toString().startsWith("wss://")){
                                showMyCustomText("外盘Socket地址:请修改添加正确的http://或https://开头");
                                return;
                              }

                              if(!_kUserNPFuturesAddress.text.toString().startsWith("http://") &&  !_kUserNPFuturesAddress.text.toString().startsWith("https://")){
                                showMyCustomText("内盘地址:请修改添加正确的http://或https://开头");
                                return;
                              }

                              if(!_kUserNPFuturesSocketAddress.text.toString().startsWith("ws://") &&  !_kUserNPFuturesSocketAddress.text.toString().startsWith("wss://")){
                                showMyCustomText("内盘Socket地址:请修改添加正确的http://或https://开头");
                                return;
                              }

                              if(!_kUserDigitalAddress.text.toString().startsWith("http://") &&  !_kUserDigitalAddress.text.toString().startsWith("https://")){
                                showMyCustomText("数字货币地址:请修改添加正确的http://或https://开头");
                                return;
                              }

                              if(!_kUserDigitalSocketAddress.text.toString().startsWith("ws://") &&  !_kUserDigitalSocketAddress.text.toString().startsWith("wss://")){
                                showMyCustomText("数字货币公共Socket地址:请修改添加正确的http://或https://开头");
                                return;
                              }

                              if(!_kUserDigitalSocketPrivateAddress.text.toString().startsWith("ws://") &&  !_kUserDigitalSocketPrivateAddress.text.toString().startsWith("wss://")){
                                showMyCustomText("数字货币私有Socket地址:请修改添加正确的http://或https://开头");
                                return;
                              }

                              kAddress = _kUserAddress.text;
                              // print(kAddress);
                              // neverLocalStorageWrite('kUserAddress',_kUserAddress.text.toString());

                              kWPFuturesAddress = _kUserWPFuturesAddress.text;
                              // print(kWPFuturesAddress);
                              // neverLocalStorageWrite('kUserWPFuturesAddress',_kUserWPFuturesAddress.text.toString());

                              kWPFuturesSocketAddress = _kUserWPFuturesSocketAddress.text;
                              // print(kWPFuturesSocketAddress);
                              // neverLocalStorageWrite('kUserWPFuturesSocketAddress',_kUserWPFuturesSocketAddress.text.toString());

                              kNPFuturesAddress = _kUserNPFuturesAddress.text;
                              // print(kNPFuturesAddress);
                              // neverLocalStorageWrite('kUserNPFuturesAddress',_kUserNPFuturesAddress.text.toString());

                              kNPFuturesSocketAddress = _kUserNPFuturesSocketAddress.text;
                              // print(kNPFuturesSocketAddress);
                              // neverLocalStorageWrite('kUserNPFuturesSocketAddress',_kUserNPFuturesSocketAddress.text.toString());

                              kDigitalAddress = _kUserDigitalAddress.text;
                              // print(kDigitalAddress);
                              // neverLocalStorageWrite('kUserDigitalAddress',_kUserDigitalAddress.text.toString());

                              kDigitalSocketAddress = _kUserDigitalSocketAddress.text;
                              // print(kDigitalSocketAddress);
                              // neverLocalStorageWrite('kUserDigitalSocketAddress',_kUserDigitalSocketAddress.text.toString());

                              kDigitalSocketPrivateAddress = _kUserDigitalSocketPrivateAddress.text;
                              // print(kDigitalSocketPrivateAddress);
                              // neverLocalStorageWrite('kUserDigitalSocketPrivateAddress',_kUserDigitalSocketPrivateAddress.text.toString());

                              Map _userUrlMap = {
                                'kUserAddress' : _kUserAddress.text.toString(),
                                'kUserWPFuturesAddress' : _kUserWPFuturesAddress.text.toString(),
                                'kUserWPFuturesSocketAddress' : _kUserWPFuturesSocketAddress.text.toString(),
                                'kUserNPFuturesAddress' : _kUserNPFuturesAddress.text.toString(),
                                'kUserNPFuturesSocketAddress' : _kUserNPFuturesSocketAddress.text.toString(),
                                'kUserDigitalAddress' : _kUserDigitalAddress.text.toString(),
                                'kUserDigitalSocketAddress' : _kUserDigitalSocketAddress.text.toString(),
                                'kUserDigitalSocketPrivateAddress' : _kUserDigitalSocketPrivateAddress.text.toString(),
                              };

                              print(_userUrlMap);
                              String _userUrlStr = jsonEncode(_userUrlMap);
                              neverLocalStorageWrite('kUserUrlMap',_userUrlStr);


                              showMyCustomText("地址修改成功,已实时生效");
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: const Text("关闭",style: TextStyle(color: Colors.white,fontSize: 13),),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(5, 6, 5, 6),

                          ),
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());

                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }),
    ).show();
  }


  //登录
  Future _LoginHttp(String loginType) async{
    var response = await Login(
        loginType: loginType ,
        username: _phoneNumberTextController.text,
        password: _passwordTextController.text,
        deviceName:_deviceName,
        deviceNumber:_deviceNumber,
        appVersion:httpAppVersion,
        buildVersion:httpBuildVersion,
    );
    print(response);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        closeMyCustomBotLoading();
          showMyCustomText('登录成功');

          //记住账户
          neverLocalStorageWrite('kLoginUserName',_phoneNumberTextController.text.toString());
          //记住是否记住密码
          neverLocalStorageWrite('kLoginIsRememberMe',_isRememberMe.toString());
          //记住密码
          if(_isRememberMe){
            neverLocalStorageWrite('kLoginUserPassword',_passwordTextController.text.toString());
          }else{
            neverLocalStorageWrite('kLoginUserPassword',"");
          }

          neverLocalStorageWrite('kUserDefaultsKeyToken', response['object']['token'].toString());
          neverLocalStorageWrite('kUserDefaultsKeyID', response['object']['id'].toString());
          await getUserUnlockInfoWithUnid(unid:response['object']['id'],data: response['object']);
          await getSynchronizeUnlockInfo(unid:response['object']['id']);
          neverBus.emit("LoginSuccess");

          Navigator.pushNamedAndRemoveUntil(context, "/indexViewForDesktopController", (route) => false,);
          // Navigator.pop(context);
      }else {
        closeMyCustomBotLoading();
        setState(() {
          _canTouch = true;
        });
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[登录]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      closeMyCustomBotLoading();
      setState(() {
        _canTouch = true;
      });
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[登录]遇到问题，请检查网络或重新刷新');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        body:GestureDetector(
          child: _desktopView(),
          behavior: HitTestBehavior.opaque,
          onTap: (){
            // _progress = 0.0;
            // _isPause = false;
            // _isStart = false;
            // _isDone = false;
            // _updateView("1");
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
    );
  }

  //桌面端
  Widget _desktopView(){
    return  Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      child: const Image(image: AssetImage('image/Login_MainLogo.png'),fit: BoxFit.contain,),
                      height: 36,
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    ),
                    Container(
                      child: const Image(image: AssetImage('image/Login_LogoWord.png'),fit: BoxFit.contain,),
                      height: 36,
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    ),
                  ],
                ),
                Expanded(child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('全球资产管理系统',style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w500),),
                      Text('Global Asset Management System',style: TextStyle(fontSize: 14,color: Colors.white),),
                    ],
                  ),
                )),
              ],
            ),
            color: const Color.fromRGBO(5, 51, 84, 1),
            alignment: Alignment.center,
          ),
        ),//左侧图标页面
        Expanded(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 50, 0, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                child: Image(image: const AssetImage('image/Login_phone.png'),fit: BoxFit.contain,color:_loginType == '0' ?  Colors.black : Colors.grey,),
                                height: _loginType == '0' ? 25 : 18,
                              ),
                              const SizedBox(width: 5,),
                              Container(
                                child: Text(_loginType == '0' ? '手机登录' : '',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 22),),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            _loginType = '0';
                          });
                        },
                      ),
                      const SizedBox(height: 20,child: VerticalDivider(color: Colors.grey,),),
                      GestureDetector(
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                child: Image(image: const AssetImage('image/Login_email.png'),fit: BoxFit.contain,color:_loginType == '1' ?  Colors.black : Colors.grey,),
                                height: _loginType == '1' ? 25 : 18,
                              ),
                              const SizedBox(width: 5,),
                              Container(
                                child: Text(_loginType == '1' ? '邮箱登录' : '',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 22),),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            _loginType = '1';
                          });
                        },
                      ),
                      // SizedBox(height: 20,child: VerticalDivider(color: Colors.grey,),),
                      // GestureDetector(
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     child: Row(
                      //       children: [
                      //         Container(
                      //           child: Image(image: AssetImage('image/Login_message.png'),fit: BoxFit.contain,color:_loginType == '2' ?  Colors.black : Colors.grey,),
                      //           height: _loginType == '2' ? 25 : 18,
                      //         ),
                      //         SizedBox(width: 5,),
                      //         Container(
                      //           child: Text(_loginType == '2' ? '快捷登录' : '',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22),),
                      //         ),
                      //       ],
                      //     ),
                      //     padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //   ),
                      //   behavior: HitTestBehavior.opaque,
                      //   onTap: (){
                      //     FocusScope.of(context).requestFocus(FocusNode());
                      //     setState(() {
                      //       _loginType = '2';
                      //     });
                      //   },
                      // )

                    ],
                  ),
                ),
                Offstage(
                  child: _loginPhoneTypeView(),
                  offstage: _loginType == '0' ? false : true,
                ),
                Offstage(
                  child: _loginEmailTypeView(),
                  offstage: _loginType == '1' ? false : true,
                ),
                // Offstage(
                //   child: _loginFastTypeView(),
                //   offstage: _loginType == '2' ? false : true,
                // )
              ],
            ),
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }


  //手机登录表单
  Widget _loginPhoneTypeView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(50, 50, 30, 0),
      child: Column(
        children: [
          Container(
            child: Text('手机登录',style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: const TextStyle(color: Colors.grey,fontSize: 15),
                hintText: '手机号码',
                hintStyle: const TextStyle(color: Colors.grey,fontSize: 15),
                prefixIcon: Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: 100,
                  alignment: Alignment.center,
                  child: DropdownButton(
                    items: _commonRegionItems,
                    onChanged: (value) {
                      setState(() {
                        _local = value.toString();
                      });
                    },
                    hint: const Text('86',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    value: _local == '' ? null : _local,
                    elevation: 8, //设置阴影的高度
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down,color: Colors.black,),
                    underline: Container(height: 0),
                  ),
                ),
              ),
              controller: _phoneNumberTextController,
              autocorrect:false,
              keyboardType: const TextInputType.numberWithOptions(
                decimal : true,
              ),
              style: const TextStyle(color: Colors.black,fontSize: 15),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('密码',style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 15),
                hintText: '请输入密码',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
              ),
              controller: _passwordTextController,
              autocorrect:false,
              obscureText: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal : true,
              ),
              style: const TextStyle(color: Colors.black,fontSize: 15),
            ),
          ),
          Row(
            children: [
              _rememberMeView(),
              _autoSignInView(),
            ],
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: _canTouch ? APP_MainGreenColor : Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                boxShadow: const [MyButtonBoxShadow],
              ),
              child: const Text('登录',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
            ),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                if(_phoneNumberTextController.text == ''){
                  showMyCustomText("请输入手机号");
                  return;
                }
                if(_passwordTextController.text == ''){
                  showMyCustomText("请输入密码");
                  return;
                }
                if(_canTouch){
                  _canTouch = false;
                  showMyCustomLoading("登录中...",seconds: 30);
                  Future.delayed(const Duration(seconds: 0)).then((onValue) async{
                    _LoginHttp('pass');
                  });
                }
              });
            },
          ),
          _RegisterAndForgetView(),
        ],
      ),
    );
  }

  //邮箱登录表单
  Widget _loginEmailTypeView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(50, 50, 30, 0),
      child: Column(
        children: [
          Container(
            child: Text('邮箱登录',style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 15),
                hintText: '邮箱地址',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
              ),
              controller: _phoneNumberTextController,
              autocorrect:false,
              keyboardType: const TextInputType.numberWithOptions(
                decimal : true,
              ),
              style: const TextStyle(color: Colors.black,fontSize: 15),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('密码',style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 15),
                hintText: '请输入密码',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
              ),
              controller: _passwordTextController,
              autocorrect:false,
              obscureText: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal : true,
              ),
              style: const TextStyle(color: Colors.black,fontSize: 15),
            ),
          ),
          Row(
            children: [
              _rememberMeView(),
              _autoSignInView(),
            ],
          ),
          GestureDetector(
            child: Container(
              decoration: const BoxDecoration(
                color: APP_MainGreenColor,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [MyButtonBoxShadow],
              ),
              child: const Text('登录',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
            ),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              if(_phoneNumberTextController.text == ''){
                showMyCustomText("请输入邮箱地址");
                return;
              }
              if(_passwordTextController.text == ''){
                showMyCustomText("请输入密码");
                return;
              }
              if(_canTouch){
                _canTouch = false;
                showMyCustomLoading("登录中...",seconds: 30);
                Future.delayed(const Duration(seconds: 0)).then((onValue) async{
                  _LoginHttp('pass');
                });
              }
            },
          ),
          _RegisterAndForgetView(),
        ],
      ),
    );
  }

  //快捷登录表单
  Widget _loginFastTypeView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(50, 50, 30, 0),
      child: Column(
        children: [
          Container(
            child: Text('手机登录',style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: const TextStyle(color: Colors.grey,fontSize: 15),
                hintText: '手机号码',
                hintStyle: const TextStyle(color: Colors.grey,fontSize: 15),
                prefixIcon: Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: 60,
                  alignment: Alignment.center,
                  child: DropdownButton(
                    items: const [
                      DropdownMenuItem(child: Text('+86',style: TextStyle(color: Colors.black,fontSize: 13),),value: '86',),
                      DropdownMenuItem(child: Text('+101',style: TextStyle(color: Colors.black,fontSize: 13),),value: '101',),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _local = value.toString();
                      });
                    },
                    hint: const Text('86',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    value: _local == '' ? null : _local,
                    elevation: 8, //设置阴影的高度
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down,color: Colors.black,),
                    underline: Container(height: 0),
                  ),
                ),
              ),
              controller: _phoneNumberTextController,
              autocorrect:false,
              keyboardType: const TextInputType.numberWithOptions(
                decimal : true,
              ),
              style: const TextStyle(color: Colors.black,fontSize: 15),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('短信验证码',style: TextStyle(fontSize: 15,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 15),
                hintText: '请输入密码',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
              ),
              controller: _passwordTextController,
              autocorrect:false,
              keyboardType: const TextInputType.numberWithOptions(
                decimal : true,
              ),
              style: const TextStyle(color: Colors.black,fontSize: 15),
            ),
          ),
          Row(
            children: [
              _rememberMeView(),
              _autoSignInView(),
            ],
          ),
          GestureDetector(
            child: Container(
              decoration: const BoxDecoration(
                color: APP_MainGreenColor,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [MyButtonBoxShadow],
              ),
              child: const Text('登录',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
            ),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context);
            },
          ),
          _RegisterAndForgetView(),
        ],
      ),
    );
  }

  //注册按钮和忘记密码按钮组
  Widget _RegisterAndForgetView(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: Text('立即注册',style: TextStyle(color: Colors.grey[700]),),
          ),
          behavior: HitTestBehavior.opaque,
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pushNamed(context, '/RegisterViewController');
          },
        ),
        // GestureDetector(
        //   child: Container(
        //     alignment: Alignment.centerLeft,
        //     padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
        //     child: Text('取消登录',style: TextStyle(color: Colors.grey[700]),),
        //   ),
        //   behavior: HitTestBehavior.opaque,
        //   onTap: (){
        //     FocusScope.of(context).requestFocus(FocusNode());
        //     Navigator.pop(context);
        //   },
        // ),
        GestureDetector(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: Text('忘记密码',style: TextStyle(color: Colors.grey[700]),),
          ),
          behavior: HitTestBehavior.opaque,
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pushNamed(context, '/ForgetPasswordViewController');
          },
        ),
        GestureDetector(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: Text('网络设置',style: TextStyle(color: Colors.grey[700]),),
          ),
          behavior: HitTestBehavior.opaque,
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
            _updateURLView();
          },
        )
      ],
    );
  }

  //自动登录按钮组
  Widget _autoSignInView(){
    return Container();
    // return Container(
    //   padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
    //   alignment: Alignment.centerLeft,
    //   child: Row(
    //     children: [
    //       Checkbox(
    //         side:BorderSide(width: 1,color: APP_MainGreenColor,),
    //         checkColor: Colors.white,
    //         onChanged: (value){
    //           setState(() {
    //             _isAutoLogin = !_isAutoLogin;
    //           });
    //         },
    //         value: _isAutoLogin,
    //       ),
    //       Text('自动登录',style: TextStyle(fontSize: 12,color: Colors.grey[700]),)
    //     ],
    //   ),
    // );
  }

  //
  Widget _rememberMeView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Checkbox(
            side:const BorderSide(width: 1,color: APP_MainGreenColor,),
            checkColor: Colors.white,
            onChanged: (value){
              setState(() {
                _isRememberMe = !_isRememberMe;
              });
            },
            value: _isRememberMe,
          ),
          Text('记住密码',style: TextStyle(fontSize: 12,color: Colors.grey[700]),)
        ],
      ),
    );
  }


}



