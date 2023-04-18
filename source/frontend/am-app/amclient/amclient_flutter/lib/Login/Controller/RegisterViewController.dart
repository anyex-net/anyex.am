import 'dart:async';

import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Login/Http/LoginHttpRequest.dart';
import 'package:amclient_flutter/Login/Model/LoginCommonRegionResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
class RegisterViewController extends StatefulWidget {
  final arguments;
  const RegisterViewController({Key? key, this.arguments}) : super(key: key);

  @override
  _RegisterViewControllerState createState() =>
      _RegisterViewControllerState();
}

class _RegisterViewControllerState extends State<RegisterViewController> {

  //注册类型
  var _registerType = '0';// 0：手机号登录  1：邮箱登录

  //注册步骤
  var _phoneStep = 0;
  var _emailStep = 0;

  //手机号 / 邮箱  通用
  final TextEditingController _phoneNumberTextController = TextEditingController();

  var _local = '86';

  Timer? _timer;
  int _countdownTime = 0;

  //密码
  final TextEditingController _passwordTextController = TextEditingController();
  //确认密码
  final TextEditingController _passwordAgainTextController = TextEditingController();
  //短信验证码/邮箱验证码
  final TextEditingController _verificationCodeTextController = TextEditingController();
  //邀请码
  final TextEditingController _invitationCodeTextController = TextEditingController();
  //随机验证码
  final TextEditingController _kaptchaCodeTextController = TextEditingController();
  //展示用验证码
  String _kaptchaCode = '';

  //防止疯狂点击
  bool _canTuach = true;
  //短信验证码按钮标题
  String _sendMessageTitle = '获取验证码' ;


  //国家地区
  List<LoginCommonRegionListModel> _commonRegionList = [];
  final List<DropdownMenuItem<String>> _commonRegionItems = [
    DropdownMenuItem(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text( '中国',
            style: TextStyle(color: Colors.black,fontSize: 13),
          ),
          Text( '86',
            style: TextStyle(color: Colors.black,fontSize: 13),
          )
        ],
      ),
      value: '86',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _LoginCommonRegionHttp();
  }

  @override
  void dispose() {
    super.dispose();
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_commonRegionList[i].cnName!,
                      style: const TextStyle(color: Colors.black,fontSize: 13),
                    ),
                    Text(_commonRegionList[i].lCode!,
                      style: const TextStyle(color: Colors.black,fontSize: 13),
                    )
                  ],
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

  //获取 随机验证码
  Future _LoginCommonKaptchaHttp(String type) async{
    var response = await LoginCommonKaptcha(type);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          if(response.containsKey('object')){
            _kaptchaCode = response['object'].toString();
          }
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[获取随机验证码]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取随机验证码]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //注册 发送手机短信
  Future _LoginRegisterSmsSendHttp() async{//{String country = '',String kaptcha = '',String mobNo = ''}
    var response = await LoginRegisterSmsSend(country:_local,kaptcha: _kaptchaCodeTextController.text,mobNo: _phoneNumberTextController.text);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _countdownTime = 60;
          startCountdownTimer();
          showMyCustomText('短信发送成功,请注意查收');
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[发送短信]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[发送短信]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //注册 验证手机短信
  Future _LoginRegisterSmsCheckHttp() async{//{String country = '',String loginPwd = '',String mobNo = '',String smsCode = ''}
    var response = await LoginRegisterSmsCheck(country:_local,mobNo: _phoneNumberTextController.text,loginPwd:_passwordTextController.text,smsCode: _verificationCodeTextController.text);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          showMyCustomText('注册成功,请返回登录');
          // Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pop(context);
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[验证短信]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[验证短信]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //注册 发送邮箱码
  Future _LoginRegisterEmailSendHttp() async{//{String country = '',String kaptcha = '',String email = ''}
    var response = await LoginRegisterEmailSend(country:_local,kaptcha: _kaptchaCodeTextController.text,email: _phoneNumberTextController.text);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _countdownTime = 60;
          startCountdownTimer();
          showMyCustomText('邮件发送成功,请注意查收');
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[发送邮件]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[发送邮件]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //注册 验证邮箱码
  Future _LoginRegisterEmailCheckHttp() async{//{String country = '',String email = '',String emailCode = '',String loginPwd = ''}
    var response = await LoginRegisterEmailCheck(country:_local,email: _phoneNumberTextController.text,emailCode:_verificationCodeTextController.text,loginPwd: _passwordTextController.text);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          showMyCustomText('注册成功,请返回登录');
          Navigator.pop(context);
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[验证邮件]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[验证邮件]遇到问题，请检查网络或重新刷新');
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
          body: GestureDetector(
            child:(Platform.isIOS || Platform.isAndroid) ? _mobileView() : _desktopView(),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
          )
      ),
    );
  }

  //桌面端
  Widget _desktopView(){
    return Row(
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('全球资产管理系统',style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w500),),
                      Text('Global Asset Management System',style: TextStyle(fontSize: 14,color: Colors.white),),
                    ],
                  ),
                ),
              ],
            ),
            color: const Color.fromRGBO(5, 51, 84, 1),
            alignment: Alignment.center,
          ),
        ),//左侧图标页面
        Expanded(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed:(){
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.black,),
                          ),
                          const Text('这里是中英文切换')
                        ],
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    ),

                  ],
                ),
                alignment: Alignment.center,
              ),
              Container(
                constraints:  const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.fromLTRB(50, 50, 0, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image(image: const AssetImage('image/Login_phone.png'),fit: BoxFit.contain,color:_registerType == '0' ?  Colors.black : Colors.grey,),
                              height: _registerType == '0' ? 25 : 18,
                            ),
                            const SizedBox(width: 5,),
                            Container(
                              child: Text(_registerType == '0' ? '手机注册' : '',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 22),),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _registerType = '0';

                          _phoneStep = 0;
                          _emailStep = 0;
                          _phoneNumberTextController.text = '';
                          _passwordTextController.text = '';
                          _passwordAgainTextController.text = '';
                          _verificationCodeTextController.text = '';
                          _invitationCodeTextController.text = '';
                          _kaptchaCodeTextController.text = '';
                          _sendMessageTitle = '获取验证码' ;

                          _countdownTime = 0;
                        });
                      },
                    ),
                    const SizedBox(height: 20,child: VerticalDivider(color: Colors.grey,),),
                    GestureDetector(
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image(image: const AssetImage('image/Login_email.png'),fit: BoxFit.contain,color:_registerType == '1' ?  Colors.black : Colors.grey,),
                              height: _registerType == '1' ? 25 : 18,
                            ),
                            const SizedBox(width: 5,),
                            Container(
                              child: Text(_registerType == '1' ? '邮箱注册' : '',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 22),),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _registerType = '1';

                          _phoneStep = 0;
                          _emailStep = 0;
                          _phoneNumberTextController.text = '';
                          _passwordTextController.text = '';
                          _passwordAgainTextController.text = '';
                          _verificationCodeTextController.text = '';
                          _invitationCodeTextController.text = '';
                          _kaptchaCodeTextController.text = '';
                          _sendMessageTitle = '获取验证码' ;

                          _countdownTime = 0;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Offstage(
                child: _registerPhoneTypeView(),
                offstage: _registerType == '0' ? false : true,
              ),
              Offstage(
                child: _registerEmailTypeView(),
                offstage: _registerType == '1' ? false : true,
              ),

            ],
          ),
        ),
      ],
    );
  }

  //移动端
  Widget _mobileView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Container(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed:(){
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.black,),
                        ),
                        const Text('这里是中英文切换')
                      ],
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  ),

                ],
              ),
              alignment: Alignment.center,
            ),
            Expanded(
              child:  ListView(
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
                                  child: Image(image: const AssetImage('image/Login_phone.png'),fit: BoxFit.contain,color:_registerType == '0' ?  Colors.black : Colors.grey,),
                                  height: _registerType == '0' ? 25 : 18,
                                ),
                                const SizedBox(width: 5,),
                                Container(
                                  child: Text(_registerType == '0' ? '手机注册' : '',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 22),),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _registerType = '0';

                              _phoneStep = 0;
                              _emailStep = 0;
                              _phoneNumberTextController.text = '';
                              _passwordTextController.text = '';
                              _passwordAgainTextController.text = '';
                              _verificationCodeTextController.text = '';
                              _invitationCodeTextController.text = '';
                              _kaptchaCodeTextController.text = '';
                              _sendMessageTitle = '获取验证码' ;

                              _countdownTime = 0;
                            });
                          },
                        ),
                        const SizedBox(height: 20,child: VerticalDivider(color: Colors.grey,),),
                        GestureDetector(
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  child: Image(image: const AssetImage('image/Login_email.png'),fit: BoxFit.contain,color:_registerType == '1' ?  Colors.black : Colors.grey,),
                                  height: _registerType == '1' ? 25 : 18,
                                ),
                                const SizedBox(width: 5,),
                                Container(
                                  child: Text(_registerType == '1' ? '邮箱注册' : '',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 22),),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _registerType = '1';

                              _phoneStep = 0;
                              _emailStep = 0;
                              _phoneNumberTextController.text = '';
                              _passwordTextController.text = '';
                              _passwordAgainTextController.text = '';
                              _verificationCodeTextController.text = '';
                              _invitationCodeTextController.text = '';
                              _kaptchaCodeTextController.text = '';
                              _sendMessageTitle = '获取验证码' ;

                              _countdownTime = 0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Offstage(
                    child: _registerPhoneTypeView(),
                    offstage: _registerType == '0' ? false : true,
                  ),
                  Offstage(
                    child: _registerEmailTypeView(),
                    offstage: _registerType == '1' ? false : true,
                  ),
                ],
              ),
            )
          ],
        ),
        alignment: Alignment.center,
      ),
      color: Colors.white,
      alignment: Alignment.center,
    );
  }

  //手机注册表单
  Widget _registerPhoneTypeView(){
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          Offstage(
            child: _registerPhoneTypeFirstView(),
            offstage: _phoneStep == 0 ? false : true,
          ),
          Offstage(
            child: _registerPhoneTypeSecondView(),
            offstage: _phoneStep == 1 ? false : true,
          ),
        ],
      ),
    );
  }

  //手机注册表单 第一步
  Widget _registerPhoneTypeFirstView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(50, 30, 30, 0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text('国家/地区',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              //边框圆角设置
              border: Border.all(width: 1, color: const Color.fromRGBO(14, 149, 131, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(3.0)),
            ),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            alignment: Alignment.center,
            height: 45,
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
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('手机号码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: const TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '手机号码',
                hintStyle: const TextStyle(color: Colors.grey,fontSize: 14),
                prefixIcon: Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 3),
                  width: 70,
                  alignment: Alignment.center,
                  child: Text( "+" + _local,style: const TextStyle(fontSize: 14,color: Colors.black),),
                ),
              ),
              controller: _phoneNumberTextController,
              autocorrect:false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('设置密码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '8-24位数字英文或字符',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
              ),
              controller: _passwordTextController,
              autocorrect:false,
              obscureText : true,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('确认密码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '8-24位数字英文或字符',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
              ),
              controller: _passwordAgainTextController,
              autocorrect:false,
              obscureText : true,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          GestureDetector(
            child: Container(
              decoration:const  BoxDecoration(
                color: APP_MainGreenColor,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [MyButtonBoxShadow],
              ),
              child: const Text('下一步',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
            ),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                if(_phoneNumberTextController.text == ''){
                  showMyCustomText('请输入手机号');
                  return;
                }
                if(_passwordTextController.text == ''){
                  showMyCustomText('请输入密码');
                  return;
                }
                if(_passwordTextController.text.length > 24 || _passwordTextController.text.length < 8){
                  showMyCustomText('请输入8-24位数字英文或字符');
                  return;
                }
                if(_passwordAgainTextController.text == ''){
                  showMyCustomText('请确认密码');
                  return;
                }
                if(_passwordAgainTextController.text != _passwordTextController.text){
                  showMyCustomText('两次密码不相同,请重新输入');
                  return;
                }
                _phoneStep = 1;
                _LoginCommonKaptchaHttp(SMS_VALID_REGISTER);
              });
            },
          ),
        ],
      ),
    );
  }

  //手机注册表单 第二步
  Widget _registerPhoneTypeSecondView(){
    return Container(

      padding: const EdgeInsets.fromLTRB(50, 30, 30, 0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('随机验证码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixIcon:GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    child: Text(_kaptchaCode,style: const TextStyle(fontSize: 13,color: Colors.black),),
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    if(_canTuach){
                      _canTuach = false;
                      Timer(const Duration(seconds: 3), () {
                        // 只在倒计时结束时回调
                        _canTuach = true;
                      });
                      _kaptchaCodeTextController.text = '';
                      _LoginCommonKaptchaHttp(SMS_VALID_REGISTER);
                    }else{
                      showMyCustomText('点击过快,请稍后');
                      return;
                    }
                  },
                ),
                suffixStyle: const TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '请输入随机验证码',
                hintStyle: const TextStyle(color: Colors.grey,fontSize: 14),
              ),
              controller: _kaptchaCodeTextController,
              autocorrect:false,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('短信验证码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: APP_MainGreenColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: APP_MainGreenColor),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        suffixText: '',
                        suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                        hintText: '短信验证码',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                      ),
                      controller: _verificationCodeTextController,
                      autocorrect:false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(color: Colors.black,fontSize: 14),
                    ),
                    flex: 6,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _countdownTime > 0 ? const Color.fromARGB(255, 183, 184, 195) : APP_MainGreenColor,
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Text(_sendMessageTitle,style: const TextStyle(color: Colors.white,fontSize: 12),),
                          alignment: Alignment.center,
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            if(_kaptchaCodeTextController.text == ''){
                              showMyCustomText('请输入随机验证码');
                              return;
                            }
                            if(_kaptchaCodeTextController.text.toUpperCase() != _kaptchaCode.toUpperCase()){
                              showMyCustomText('随机验证码输入错误,请重试');
                              return;
                            }
                            if(_countdownTime > 0){
                              showMyCustomText('请稍等');
                              return;
                            }
                            _verificationCodeTextController.text = '';
                            _LoginRegisterSmsSendHttp();
                          });
                        },
                      ),
                    ),
                    flex: 2,
                  ),
                ],
              ),
            )
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('邀请码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '没有可不填',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
              ),
              controller: _invitationCodeTextController,
              autocorrect:false,
              keyboardType: const TextInputType.numberWithOptions(
                decimal : true,
              ),
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          const SizedBox(height: 30,),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: APP_MainRedColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [MyButtonBoxShadow],
                    ),
                    child: const Text('返回',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    if(mounted){
                      setState(() {
                        _phoneStep = 0;
                        if (_timer != null) {
                          _timer!.cancel();
                        }
                        _sendMessageTitle = '获取验证码' ;
                        _countdownTime = 0;
                        _kaptchaCodeTextController.text = '';
                        _verificationCodeTextController.text = '';
                        _invitationCodeTextController.text = '';
                      });
                    }
                  },
                ),
                flex: 5,
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: APP_MainGreenColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [MyButtonBoxShadow],
                    ),
                    child: const Text('立即注册',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    if(_kaptchaCodeTextController.text == ''){
                      showMyCustomText('请输入随机验证码');
                      return;
                    }
                    if(_kaptchaCodeTextController.text.toUpperCase() != _kaptchaCode.toUpperCase()){
                      showMyCustomText('随机验证码输入错误,请重试');
                      return;
                    }
                    if(_verificationCodeTextController.text == ''){
                      showMyCustomText('请输入短信验证码');
                      return;
                    }
                    _LoginRegisterSmsCheckHttp();
                  },
                ),
                flex: 5,
              )
            ],
          )
        ],
      ),
    );
  }

  //邮箱登录表单
  Widget _registerEmailTypeView(){
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          Offstage(
            child: _registerEmailTypeFirstView(),
            offstage: _emailStep == 0 ? false : true,
          ),
          Offstage(
            child: _registerEmailTypeSecondView(),
            offstage: _emailStep == 1 ? false : true,
          ),
        ],
      ),
    );
  }

  //邮箱注册表单 第一步
  Widget _registerEmailTypeFirstView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(50, 30, 30, 0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text('国家/地区',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              //边框圆角设置
              border: Border.all(width: 1, color: const Color.fromRGBO(14, 149, 131, 1)),
              borderRadius: const BorderRadius.all(Radius.circular(3.0)),
            ),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            alignment: Alignment.center,
            height: 45,
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
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('邮箱',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '邮箱地址',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
              ),
              controller: _phoneNumberTextController,
              autocorrect:false,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('设置密码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '8-24位数字英文或字符',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
              ),
              controller: _passwordTextController,
              autocorrect:false,
              obscureText : true,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('确认密码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '8-24位数字英文或字符',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
              ),
              controller: _passwordAgainTextController,
              autocorrect:false,
              obscureText : true,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          GestureDetector(
            child: Container(
              decoration: const BoxDecoration(
                color: APP_MainGreenColor,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [MyButtonBoxShadow],
              ),
              child: const Text('下一步',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
            ),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                if(_phoneNumberTextController.text == ''){
                  showMyCustomText('请输入邮箱号');
                  return;
                }
                if(_passwordTextController.text == ''){
                  showMyCustomText('请输入密码');
                  return;
                }
                if(_passwordTextController.text.length > 24 || _passwordTextController.text.length < 8){
                  showMyCustomText('请输入8-24位数字英文或字符');
                  return;
                }
                if(_passwordAgainTextController.text == ''){
                  showMyCustomText('请确认密码');
                  return;
                }
                if(_passwordAgainTextController.text != _passwordTextController.text){
                  showMyCustomText('两次密码不相同,请重新输入');
                  return;
                }
                _emailStep = 1;
                _LoginCommonKaptchaHttp(EMAIL_VALID_REGISTER);
              });
            },
          ),
        ],
      ),
    );
  }

  //邮箱注册表单 第二步
  Widget _registerEmailTypeSecondView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(50, 30, 30, 0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('随机验证码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixIcon:GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    child: Text(_kaptchaCode,style: const TextStyle(fontSize: 13,color: Colors.black),),
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    if(_canTuach){
                      _canTuach = false;
                      Timer(const Duration(seconds: 3), () {
                        // 只在倒计时结束时回调
                        _canTuach = true;
                      });
                      _kaptchaCodeTextController.text = '';
                      _LoginCommonKaptchaHttp(EMAIL_VALID_REGISTER);
                    }else{
                      showMyCustomText('点击过快,请稍后');
                      return;
                    }
                  },
                ),
                suffixStyle: const TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '请输入随机验证码',
                hintStyle: const TextStyle(color: Colors.grey,fontSize: 14),
              ),
              controller: _kaptchaCodeTextController,
              autocorrect:false,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('邮箱验证码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: APP_MainGreenColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: APP_MainGreenColor),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          ),
                          suffixText: '',
                          suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                          hintText: '邮箱验证码',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                        ),
                        controller: _verificationCodeTextController,
                        autocorrect:false,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(color: Colors.black,fontSize: 14),
                      ),
                      flex: 6,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _countdownTime > 0 ? const Color.fromARGB(255, 183, 184, 195) : APP_MainGreenColor,
                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Text(_sendMessageTitle,style: const TextStyle(color: Colors.white,fontSize: 12),),
                            alignment: Alignment.center,
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              if(_kaptchaCodeTextController.text == ''){
                                showMyCustomText('请输入随机验证码');
                                return;
                              }
                              if(_kaptchaCodeTextController.text.toUpperCase() != _kaptchaCode.toUpperCase()){
                                showMyCustomText('随机验证码输入错误,请重试');
                                return;
                              }
                              if(_countdownTime > 0){
                                showMyCustomText('请稍等');
                                return;
                              }
                              _verificationCodeTextController.text = '';
                              _LoginRegisterEmailSendHttp();
                            });
                          },
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              )
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('邀请码',style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: APP_MainGreenColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '没有可不填',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
              ),
              controller: _invitationCodeTextController,
              autocorrect:false,
              keyboardType: const TextInputType.numberWithOptions(
                decimal : true,
              ),
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          const SizedBox(height: 30,),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: APP_MainRedColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [MyButtonBoxShadow],
                    ),
                    child: const Text('返回',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    if(mounted){
                      setState(() {
                        _emailStep = 0;
                        if (_timer != null) {
                          _timer!.cancel();
                        }
                        _countdownTime = 0;
                        _sendMessageTitle = '获取验证码' ;
                        _kaptchaCodeTextController.text = '';
                        _verificationCodeTextController.text = '';
                        _invitationCodeTextController.text = '';
                      });
                    }
                  },
                ),
                flex: 5,
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: APP_MainGreenColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [MyButtonBoxShadow],
                    ),
                    child: const Text('立即注册',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    if(_kaptchaCodeTextController.text == ''){
                      showMyCustomText('请输入随机验证码');
                      return;
                    }
                    if(_kaptchaCodeTextController.text.toUpperCase() != _kaptchaCode.toUpperCase()){
                      showMyCustomText('随机验证码输入错误,请重试');
                      return;
                    }
                    if(_verificationCodeTextController.text == ''){
                      showMyCustomText('请输入邮箱验证码');
                      return;
                    }
                    _LoginRegisterEmailCheckHttp();
                  },
                ),
                flex: 5,
              )
            ],
          )
        ],
      ),
    );
  }

  //倒计时
  void startCountdownTimer() {
    var callback = (timer) => {
      if(mounted){
        setState(() {
          if (_countdownTime < 1) {
            _timer!.cancel();
          } else {
            _countdownTime = _countdownTime - 1;
            _sendMessageTitle = _countdownTime.toString() + 's';
            if (_countdownTime == 0) {
              _sendMessageTitle = '重新发送';
            }
          }
        })
      }
    };
    _timer = Timer.periodic(Duration(seconds: 1), callback);
  }
}
