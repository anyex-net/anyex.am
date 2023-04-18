import 'dart:async';
import 'dart:io';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Base/UserManager.dart' as UnlockManager;
import 'package:amclient_flutter/Setting/Controller/SettingSecurityInfoBindGAView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingSecurityInfoBindPhoneView.dart';
import 'package:amclient_flutter/Setting/Http/SettingHttpRequest.dart';
import 'package:amclient_flutter/Setting/Model/SettingPersonalInfoResponseModel.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neveruseless/neveruseless.dart';
import 'dart:io';

import 'SettingSecurityInfoBindEmailView.dart';
class SettingSecurityInfoView extends StatefulWidget {
  final arguments;
  const SettingSecurityInfoView({Key? key, this.arguments}) : super(key: key);

  @override
  _SettingSecurityInfoViewState createState() => _SettingSecurityInfoViewState();
}

class _SettingSecurityInfoViewState extends State<SettingSecurityInfoView> {


  bool _isHasPhone = false;
  bool _isHasEmial = false;
  bool _isHasGA = false;

  int _level = 0;
  String _levelStr = '低';
  Color _levelColor = Colors.red;

  late SettingPersonalInfoResponseData _data ;
  @override
  void initState() {
    super.initState();
    _safeLevel();
    neverBus.on('SettingSecurityInfoUpdate', (object) {
      if(mounted){
        _SettingAccountAccountInfoHttp();
      }
    });
  }

  void _safeLevel(){
    _isHasPhone = (UnlockManager.personMap['phone'] != 'null' && UnlockManager.personMap['phone'] != '') ? true : false;
    _isHasEmial = (UnlockManager.personMap['email'] != 'null' && UnlockManager.personMap['email'] != '') ? true : false;
    _isHasGA = (UnlockManager.personMap['gaauthKey'] != 'null' && UnlockManager.personMap['gaauthKey'] != '') ? true : false;
    _level = 0;
    if(_isHasPhone){
      _level +=1;
    }
    if(_isHasEmial){
      _level +=1;
    }
    if(_isHasGA){
      _level +=1;
    }

    if(_level == 1){
      _levelStr = '低';
      _levelColor = APP_MainRedColor;
    }else if(_level == 2){
      _levelStr = '中';
      _levelColor = Colors.yellow;
    }else if(_level == 3){
      _levelStr = '高';
      _levelColor = APP_MainGreenColor;
    }else{
      _levelStr = '低';
      _levelColor = APP_MainGreenColor;
    }

  }

  @override
  void dispose() {
    neverBus.off('SettingSecurityInfoUpdate');
    super.dispose();
  }

  //获取用户信息
  Future _SettingAccountAccountInfoHttp() async{
    var response = await SettingAccountAccountInfo();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
          _data = SettingPersonalInfoResponseModel.fromJson(response).object!;

          UnlockManager.personMap.update('email', (value) => _data.email);
          UnlockManager.personMap.update('phone', (value) => _data.mobNo);
          UnlockManager.personMap.update('gaauthKey', (value) => _data.gaauthKey);
          UnlockManager.personMap.update('securityPolicy', (value) => _data.securityPolicy);
          await UnlockManager.getSynchronizeUnlockInfo(unid: _data.id!);

          _safeLevel();

          setState(() {
          });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[获取用户信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取用户信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      color: APP_MainBGColor,
      child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color.fromRGBO(15, 159, 131, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                child: const Image(image: AssetImage('image/Setting_AccountBasic_Level.png'),fit: BoxFit.contain,),
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text('安全等级:' + _levelStr,style: const TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                                  ),
                                  Container(
                                    child: const Text('强烈建议开启双重身份验证',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 5,),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _levelColor,
                                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                              ),
                              height: 5,
                              child: const Text(''),
                              alignment: Alignment.center,
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _level >=2 ? _levelColor : Colors.grey,
                                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                              ),
                              height: 5,
                              child: const Text(''),
                              alignment: Alignment.center,
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _level >=3 ? _levelColor : Colors.grey,
                                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                              ),
                              height: 5,
                              child: const Text(''),
                              alignment: Alignment.center,
                            ),
                          ),
                          const SizedBox(width: 5,),
                        ],
                      ),
                    )
                  ],
                ),//安全等级判定
                Divider(height: 30,color: Colors.grey[700],),
                Row(
                  children: [
                    Expanded(
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                child: const Image(image: AssetImage('image/Setting_AccountBasic_Email.png'),fit: BoxFit.contain,),
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: const Text('邮箱',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                                    ),
                                    Container(
                                      child: const Text('用于登录、提币、找回密码、修改安全设置、管理API时进行安全验证',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    !_isHasEmial ? GestureDetector(
                      child: Container(
                        child:const  Text('绑定',style: TextStyle(decoration: TextDecoration.underline,decorationColor: APP_MainGreenColor,color: APP_MainGreenColor),),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        AwesomeDialog(
                          context: context,
                          headerAnimationLoop: false,
                          dismissOnBackKeyPress:false,
                          width:MediaQuery.of(context).size.width / 1.5,
                          dialogType: DialogType.NO_HEADER,
                          animType: AnimType.BOTTOMSLIDE,
                          body: const SettingSecurityInfoBindEmailView(),
                        ).show();
                      },
                    ) :
                    Container(
                      child: const Text('已绑定',style: TextStyle(decoration: TextDecoration.underline,decorationColor: APP_MainGreenColor,color: APP_MainGreenColor),),
                      alignment: Alignment.center,
                      padding:const EdgeInsets.all(5),
                    ),
                  ],
                ),//绑定邮箱
                Divider(height: 30,color: Colors.grey[700],),
                Row(
                  children: [
                    Expanded(
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                child: const Image(image: AssetImage('image/Setting_AccountBasic_Phone.png'),fit: BoxFit.contain,),
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: const Text('手机',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                                      padding:const  EdgeInsets.fromLTRB(0, 0, 0, 1),
                                    ),
                                    Container(
                                      child:const Text('用于登录、提币、找回密码、修改安全设置、管理API时进行安全验证',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    !_isHasPhone ? GestureDetector(
                      child: Container(
                        child: const Text('绑定',style: TextStyle(decoration: TextDecoration.underline,decorationColor: APP_MainGreenColor,color: APP_MainGreenColor),),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        AwesomeDialog(
                          context: context,
                          headerAnimationLoop: false,
                          dismissOnBackKeyPress:false,
                          width:MediaQuery.of(context).size.width / 1.5,
                          dialogType: DialogType.NO_HEADER,
                          animType: AnimType.BOTTOMSLIDE,
                          body: const SettingSecurityInfoBindPhoneView(),
                        ).show();
                      },
                    ) :
                    Container(
                      child: const Text('已绑定',style: TextStyle(decoration: TextDecoration.underline,decorationColor: APP_MainGreenColor,color: APP_MainGreenColor),),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                    ),

                  ],
                ),//绑定手机
                Divider(height: 30,color: Colors.grey[700],),
                Row(
                  children: [
                    Expanded(
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                child: const Image(image: AssetImage('image/Setting_AccountBasic_GA.png'),fit: BoxFit.contain,),
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: const Text('谷歌验证器',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                                    ),
                                    Container(
                                      child: const Text('用于登录、提币、找回密码、修改安全设置、管理API时进行安全验证',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    !_isHasGA ? GestureDetector(
                      child: Container(
                        child: const Text('绑定',style: TextStyle(decoration: TextDecoration.underline,decorationColor: APP_MainGreenColor,color: APP_MainGreenColor),),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        if(!_isHasEmial){
                          showMyCustomText("请先绑定邮箱后再绑定谷歌验证器");
                          return;
                        }
                        if(!_isHasPhone){
                          showMyCustomText("请先绑定手机号后再绑定谷歌验证器");
                          return;
                        }
                        AwesomeDialog(
                          context: context,
                          headerAnimationLoop: false,
                          dismissOnBackKeyPress:false,
                          width:MediaQuery.of(context).size.width / 1.5,
                          dialogType: DialogType.NO_HEADER,
                          animType: AnimType.BOTTOMSLIDE,
                          body: const SettingSecurityInfoBindGAView(),
                        ).show();
                      },
                    ):
                    Container(
                      child: const Text('已绑定',style: TextStyle(decoration: TextDecoration.underline,decorationColor: APP_MainGreenColor,color: APP_MainGreenColor),),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                    ),
                  ],
                ),//绑定手机
              ],
            ),
          )
      ),
    );
  }



}

