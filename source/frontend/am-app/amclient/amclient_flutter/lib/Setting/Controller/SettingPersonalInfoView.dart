import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Setting/Http/SettingHttpRequest.dart';
import 'package:amclient_flutter/Setting/Model/SettingPersonalInfoResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:amclient_flutter/Base/UserManager.dart' as UnlockManager;
class SettingPersonalInfoView extends StatefulWidget {
  final arguments;
  const SettingPersonalInfoView({Key? key, this.arguments}) : super(key: key);

  @override
  _SettingPersonalInfoViewState createState() => _SettingPersonalInfoViewState();
}

class _SettingPersonalInfoViewState extends State<SettingPersonalInfoView> {


  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();


  late SettingPersonalInfoResponseData _data ;

  //UID
  String? _uid = '-';

  //用户名
  String? _accountName = '';

  //手机号
  String? _mobNo = '无';

  //邮箱
  String? _email = '无';

  @override
  void initState() {
    super.initState();
    _SettingAccountAccountInfoHttp();
  }

  @override
  void dispose() {
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

          _uid = _data.uid;

          _accountName = _data.accountName;

          _mobNo = _data.mobNo;

          _email = _data.email;

          UnlockManager.personMap.update('email', (value) => _data.email);
          UnlockManager.personMap.update('phone', (value) => _data.mobNo);
          UnlockManager.personMap.update('gaauthKey', (value) => _data.gaauthKey);
          UnlockManager.personMap.update('cashPwd', (value) => _data.cashPwd);
          UnlockManager.personMap.update('securityPolicy', (value) => _data.securityPolicy);
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
      color: APP_MainBGColor,
      alignment: Alignment.center,
      child: ListView(
        controller: _controller1,
        children: [
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
              alignment: Alignment.center,
              child: Container(
                child: const Image(image: AssetImage('image/Login_MainLogo.png'),fit: BoxFit.fitWidth,),
                padding: const EdgeInsets.all(15),
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
              ),
            ),
            onTap: (){
              // _SettingAccountAccountInfoHttp();
            },
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: const Text('用户名',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
            alignment: Alignment.center,
          ),
          Container(child: const SizedBox(),color: Colors.black,alignment: Alignment.center,height: 5,),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 30, 20, 10),
            child: const Text('UID',style: TextStyle(color: Colors.grey,fontSize: 14),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
            child: Text(_uid!,style: const TextStyle(color: Colors.white,fontSize: 16),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
            child: const Text('国家/地区',style: TextStyle(color: Colors.grey,fontSize: 14),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
            child: const Text('中国',style: TextStyle(color: Colors.white,fontSize: 16),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
            child: const Text('手机号码',style: TextStyle(color: Colors.grey,fontSize: 14),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
            child: Text(_mobNo!,style: const TextStyle(color: Colors.white,fontSize: 16),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
            child: const Text('邮箱',style: TextStyle(color: Colors.grey,fontSize: 14),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
            child: Text(_email!,style: const TextStyle(color: Colors.white,fontSize: 16),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
            child: const Text('语言',style: TextStyle(color: Colors.grey,fontSize: 14),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
            child: const Text('中文',style: TextStyle(color: Colors.white,fontSize: 16),),
            alignment: Alignment.centerLeft,
          ),
        ],
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
          title: const Text("个人信息"),
        ),
        body:Container(
          color: APP_MainBGColor,
          alignment: Alignment.center,
          child: ListView(
            controller: _controller2,
            children: [
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                  alignment: Alignment.center,
                  child: Container(
                    child: const Image(image: AssetImage('image/Login_MainLogo.png'),fit: BoxFit.fitWidth,),
                    padding: const EdgeInsets.all(15),
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                  ),
                ),
                onTap: (){
                  // _SettingAccountAccountInfoHttp();
                },
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: const Text('用户名',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
                alignment: Alignment.center,
              ),
              Container(child: const SizedBox(),color: Colors.black,alignment: Alignment.center,height: 5,),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 30, 20, 10),
                child: const Text('UID',style: TextStyle(color: Colors.grey,fontSize: 14),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
                child: Text(_uid!,style: const TextStyle(color: Colors.white,fontSize: 16),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
                child:const  Text('国家/地区',style: TextStyle(color: Colors.grey,fontSize: 14),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
                child: const Text('中国',style: TextStyle(color: Colors.white,fontSize: 16),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
                child: const Text('手机号码',style: TextStyle(color: Colors.grey,fontSize: 14),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
                child: Text(_mobNo!,style: const TextStyle(color: Colors.white,fontSize: 16),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
                child: const Text('邮箱',style: TextStyle(color: Colors.grey,fontSize: 14),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
                child: Text(_email!,style: const TextStyle(color: Colors.white,fontSize: 16),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
                child: const Text('语言',style: TextStyle(color: Colors.grey,fontSize: 14),),
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 0, 20, 10),
                child: const Text('中文',style: TextStyle(color: Colors.white,fontSize: 16),),
                alignment: Alignment.centerLeft,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
