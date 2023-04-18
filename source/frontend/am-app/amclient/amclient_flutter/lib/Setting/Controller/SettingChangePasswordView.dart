import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Setting/Controller/SettingChangePasswordCashPasswordView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingChangePasswordLoginPasswordView.dart';
import 'package:amclient_flutter/Setting/Http/SettingHttpRequest.dart';
import 'package:amclient_flutter/Setting/Model/SettingPersonalInfoResponseModel.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:amclient_flutter/Base/UserManager.dart' as UnlockManager;
import 'package:neveruseless/neveruseless.dart';
class SettingChangePasswordView extends StatefulWidget {
  final arguments;
  const SettingChangePasswordView({Key? key, this.arguments}) : super(key: key);

  @override
  _SettingChangePasswordViewState createState() => _SettingChangePasswordViewState();
}

class _SettingChangePasswordViewState extends State<SettingChangePasswordView> {

  late SettingPersonalInfoResponseData _data ;
  String _securityPolicy = '';
  String _cashPwd = '';
  final ScrollController _controller1 = ScrollController();

  @override
  void initState() {
    super.initState();
    _securityPolicy = UnlockManager.personMap['securityPolicy'].toString();
    _cashPwd = UnlockManager.personMap['cashPwd'].toString();
    _SettingAccountAccountInfoHttp();
    neverBus.on('SettingChangePasswordUpdate', (object) {
      if(mounted){
        _SettingAccountAccountInfoHttp();
      }
    });
  }

  @override
  void dispose() {
    neverBus.off('SettingChangePasswordUpdate');
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

        UnlockManager.personMap.update('cashPwd', (value) => _data.cashPwd);
        await UnlockManager.getSynchronizeUnlockInfo(unid: _data.id!);

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
    return _desktopView();
  }

  Widget _desktopView(){
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
                                child: const Image(image: AssetImage('image/Setting_AccountSecurity.png'),fit: BoxFit.contain,color: APP_MainGreenColor,),
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
                                      child: const Text('登录密码',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                                    ),
                                    Container(
                                      child: const Text('修改登录密码',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    GestureDetector(
                      child: Container(
                        child: const Text('修改',style: TextStyle(decoration: TextDecoration.underline,decorationColor: APP_MainGreenColor,color: APP_MainGreenColor),),
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
                          body: const SettingChangePasswordLoginPasswordView(),
                        ).show();
                      },
                    )
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
                                child: const Image(image: AssetImage('image/Setting_AccountSecurity.png'),fit: BoxFit.contain,color: APP_MainGreenColor,),
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
                                      child: const Text('资金密码',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                                    ),
                                    Container(
                                      child: const Text('修改资金密码',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    GestureDetector(
                      child: Container(
                        child: Text( _cashPwd != '' ? '修改' : '设置',style: const TextStyle(decoration: TextDecoration.underline,decorationColor: APP_MainGreenColor,color: APP_MainGreenColor),),
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
                          body: const SettingChangePasswordCashPasswordView(),
                        ).show();
                      },
                    )
                  ],
                ),//绑定手机
              ],
            ),
          )
      ),
    );
  }

  Widget _mobileView(){
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          iconTheme:const IconThemeData(
              color: Colors.white
          ),
          title: const Text("密码设置"),
        ),
        body:Container(
            color: APP_MainBGColor,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: ListView(
              controller: _controller1,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                child: const Image(image: AssetImage('image/Setting_AccountSecurity.png'),fit: BoxFit.contain,color: APP_MainGreenColor,),
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
                                      child: const Text('登录密码',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                                    ),
                                    Container(
                                      child: const Text('修改登录密码',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    GestureDetector(
                      child: Container(
                        child: const Text('修改',style: TextStyle(decoration: TextDecoration.underline,decorationColor: APP_MainGreenColor,color: APP_MainGreenColor),),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        Navigator.pushNamed(context, '/SettingChangePasswordLoginPasswordView');
                      },
                    )
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
                                child: const Image(image: AssetImage('image/Setting_AccountSecurity.png'),fit: BoxFit.contain,color: APP_MainGreenColor,),
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
                                      child: const Text('资金密码',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                                    ),
                                    Container(
                                      child: const Text('修改资金密码',style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    GestureDetector(
                      child: Container(
                        child: Text( _cashPwd != '' ? '修改' : '设置',style: const TextStyle(decoration: TextDecoration.underline,decorationColor: APP_MainGreenColor,color: APP_MainGreenColor),),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        Navigator.pushNamed(context, '/SettingChangePasswordCashPasswordView');
                      },
                    )
                  ],
                ),//绑定手机
              ],
            ),
        ),
      ),
    );
  }
}

