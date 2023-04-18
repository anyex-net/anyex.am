import 'dart:io';

import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/DigitalCurrency/Controller/DigitalCurrencyExchangeApiView.dart';
import 'package:amclient_flutter/NPFutures/Controller/NPFuturesAccountInfoView.dart';
import 'package:amclient_flutter/NPSpot/Controller/NPSpotAccountInfoView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingChangePasswordView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingHistoryView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingKYCView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingPersonalInfoView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingSecurityInfoView.dart';
import 'package:amclient_flutter/WPFutures/Controller/WPFuturesAccountInfoView.dart';
import 'package:amclient_flutter/WPSpot/Controller/WPSpotAccountInfoView.dart';
import 'package:amclient_flutter/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:neveruseless/neveruseless.dart';

class SettingViewController extends StatefulWidget {
  final arguments;
  const SettingViewController({Key? key, this.arguments}) : super(key: key);

  @override
  _SettingViewControllerState createState() => _SettingViewControllerState();
}

class _SettingViewControllerState extends State<SettingViewController> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  int _selectIndexType = 0;

  final _pages = const [
    SettingPersonalInfoView(),
    SettingKYCView(),
    SettingSecurityInfoView(),
    SettingChangePasswordView(),
    SettingHistoryView(),
    DigitalCurrencyExchangeApiView(),
    WPFuturesAccountInfoView(),
    WPSpotAccountInfoView(),
    NPFuturesAccountInfoView(),
    NPSpotAccountInfoView(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _desktopView();
  }

  Widget _desktopView(){
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body:Container(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          color: Colors.black,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  child:Container(
                    decoration: const BoxDecoration(
                      color: APP_MainBGColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectIndexType == 0 ? APP_MainGreenColor : Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child:const  Image(image: AssetImage('image/Setting_AccountInfo.png'),width: 18,),
                                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: const Text("个人信息",style: TextStyle(color: Colors.white,fontSize: 13),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          onTap: (){
                            setState(() {
                              _selectIndexType = 0;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectIndexType == 1 ? APP_MainGreenColor : Colors.transparent,
                                borderRadius:const  BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Image(image: AssetImage('image/Setting_AccountAuth.png'),width: 18,),
                                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: const Text("身份认证",style: TextStyle(color: Colors.white,fontSize: 13),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            setState(() {
                              _selectIndexType = 1;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectIndexType == 2 ? APP_MainGreenColor : Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Image(image: AssetImage('image/Setting_AccountBasic.png'),width: 18,),
                                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: const Text("安全设置",style: TextStyle(color: Colors.white,fontSize: 13),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              padding:const  EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          onTap: (){
                            setState(() {
                              _selectIndexType = 2;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectIndexType == 3 ? APP_MainGreenColor : Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Image(image: AssetImage('image/Setting_AccountSecurity.png'),width: 18,),
                                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: const Text("密码设置",style: TextStyle(color: Colors.white,fontSize: 13),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          onTap: (){
                            setState(() {
                              _selectIndexType = 3;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectIndexType == 4 ? APP_MainGreenColor : Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Image(image: AssetImage('image/Setting_SettingHistory.png'),width: 18,),
                                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: const Text("历史记录",style: TextStyle(color: Colors.white,fontSize: 13),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          onTap: (){
                            setState(() {
                              _selectIndexType = 4;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectIndexType == 5 ? APP_MainGreenColor : Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Image(image: AssetImage('image/Setting_apiAddAll.png'),width: 18,),
                                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: const Text("数字货币API",style: TextStyle(color: Colors.white,fontSize: 13),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          onTap: (){
                            setState(() {
                              _selectIndexType = 5;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectIndexType == 6 ? APP_MainGreenColor : Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Image(image: AssetImage('image/Setting_apiAddAll.png'),width: 18,),
                                    padding:const  EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child:const  Text("外盘期货API",style: TextStyle(color: Colors.white,fontSize: 13),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          onTap: (){
                            setState(() {
                              _selectIndexType = 6;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectIndexType == 7 ? APP_MainGreenColor : Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Image(image: AssetImage('image/Setting_apiAddAll.png'),width: 18,),
                                    padding:const  EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child:const  Text("外盘现货API",style: TextStyle(color: Colors.white,fontSize: 13),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          onTap: (){
                            setState(() {
                              _selectIndexType = 7;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectIndexType == 8 ? APP_MainGreenColor : Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Image(image: AssetImage('image/Setting_apiAddAll.png'),width: 18,),
                                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: const Text("内盘期货API",style: TextStyle(color: Colors.white,fontSize: 13),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          onTap: (){
                            setState(() {
                              _selectIndexType = 8;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectIndexType == 9 ? APP_MainGreenColor : Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Image(image: AssetImage('image/Setting_apiAddAll.png'),width: 18,),
                                    padding:const  EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: const Text("内盘现货API",style: TextStyle(color: Colors.white,fontSize: 13),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          onTap: (){
                            setState(() {
                              _selectIndexType = 9;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child: Container(
                              decoration: const BoxDecoration(
                                color:  APP_MainRedColor,
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Container(
                                child: const Text("退出登录",style: TextStyle(color: Colors.white,fontSize: 13),),
                                alignment: Alignment.center,
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          ),
                          onTap: (){
                            showDialog(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Text('退出登录',style: TextStyle(fontSize: 17),),
                                  content:Container(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child:const Text("是否确认退出此账户",),
                                  ),
                                  actions:<Widget>[
                                    CupertinoDialogAction(
                                      child: const Text('取消',style: TextStyle(color: Color.fromRGBO(215, 85, 82,  1)),),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    ),

                                    CupertinoDialogAction(
                                      child: const Text('确定'),
                                      onPressed: () async{
                                        Navigator.of(context).pop();
                                        neverLocalStorageWrite('kUserDefaultsKeyToken', '');
                                        neverLocalStorageWrite('kUserDefaultsKeyID', '');
                                        navigatorKey.currentState!.pushNamedAndRemoveUntil('/LoginViewController',(route) => false);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                flex: 2,
              ),
              Container(child: const SizedBox(),color: Colors.black,alignment: Alignment.center,width: 5,),
              Flexible(
                flex: 7,
                child: Container(
                  decoration: const BoxDecoration(
                    color: APP_MainBGColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: _pages[_selectIndexType],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
