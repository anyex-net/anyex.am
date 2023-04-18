import 'dart:async';
import 'dart:io';

import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Login/Http/LoginHttpRequest.dart';
import 'package:amclient_flutter/Login/Model/LoginCommonRegionResponseModel.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
class ForgetPasswordViewController extends StatefulWidget {
  final arguments;
  const ForgetPasswordViewController({Key? key, this.arguments}) : super(key: key);

  @override
  _ForgetPasswordViewControllerState createState() =>
      _ForgetPasswordViewControllerState();
}

class _ForgetPasswordViewControllerState extends State<ForgetPasswordViewController> {

  int _step = 0;

  String _selectType = 'sms';

  //手机号
  final TextEditingController _phoneNumberTextController = TextEditingController();

  //国家地区
  List<LoginCommonRegionListModel> _commonRegionList = [];
  List<DropdownMenuItem<String>> _commonRegionItems = [];
  var _local = '86';

  //展示用验证码
  String _kaptchaCode = '';
  //随机验证码
  final TextEditingController _kaptchaCodeTextController = TextEditingController();
  //短信验证码/邮箱验证码
  final TextEditingController _verificationCodeTextController = TextEditingController();
  //防止疯狂点击
  bool _canTuach = true;
  //短信验证码按钮标题
  String _sendMessageTitle = '获取验证码' ;
  Timer? _timer;
  int _countdownTime = 0;


  //密码
  final TextEditingController _passwordTextController = TextEditingController();
  //确认密码
  final TextEditingController _passwordAgainTextController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _LoginCommonRegionHttp();
    _LoginCommonKaptchaHttp(SMS_VALID_FORGETPASS);
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

  //忘记密码 发送手机短信
  Future _LoginForgetSmsSendHttp() async{//{String country = '',String kaptcha = '',String mobNo = ''}
    var response = await LoginForgetSmsSend(country:_local,kaptcha: _kaptchaCodeTextController.text,mobNo: _phoneNumberTextController.text);
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
          showMyCustomText('[忘记密码发送短信]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[忘记密码发送短信]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //忘记密码 验证手机短信
  Future _LoginForgetSmsCheckHttp() async{//{String country = '',String loginPwd = '',String mobNo = '',String smsCode = ''}
    var response = await LoginForgetSmsCheck(country:_local,mobNo: _phoneNumberTextController.text,smsCode: _verificationCodeTextController.text);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _step = 1;
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[忘记密码验证短信]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[忘记密码验证短信]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //忘记密码 手机完成密码重置
  Future _LoginForgetSmsResetpassHttp() async{//{String country = '',String loginPwd = '',String mobNo = ''}
    var response = await LoginForgetSmsResetpass(country:_local,mobNo: _phoneNumberTextController.text,loginPwd:_passwordTextController.text,);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _step = 2;
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[重置密码]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[重置密码]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //忘记密码 发送邮箱码
  Future _LoginForgetEmailSendHttp() async{//{String country = '',String kaptcha = '',String email = ''}
    var response = await LoginForgetEmailSend(country:_local,kaptcha: _kaptchaCodeTextController.text,email: _phoneNumberTextController.text);
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
          showMyCustomText('[忘记密码发送邮件]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[忘记密码发送邮件]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //忘记密码 验证邮箱码
  Future _LoginForgetEmailCheckHttp() async{//{String country = '',String email = '',String emailCode = '',String loginPwd = ''}
    var response = await LoginForgetEmailCheck(country:_local,email: _phoneNumberTextController.text,emailCode:_verificationCodeTextController.text,);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _step = 1;
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[忘记密码验证邮件]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[忘记密码验证邮件]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //忘记密码 邮箱完成密码重置
  Future _LoginForgetEmailResetpassHttp() async{//{{String country = '',String loginPwd = '',String email = ''}
    var response = await LoginForgetEmailResetpass(country:_local,email: _phoneNumberTextController.text,loginPwd:_passwordTextController.text,);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _step = 2;
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[忘记密码完成验证邮件]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[忘记密码完成验证邮件]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _desktopView();
  }

  //桌面端
  Widget _desktopView(){
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
          title:Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: const Text('重置登录密码',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            alignment: Alignment.center,
          ),
          actions: const [
            IconButton(onPressed: null, icon: Icon(Icons.add,color: Colors.transparent,)),
          ],
        ),
        body:GestureDetector(
          child:Container(
            padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("image/Login_ThisStep.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: const Text('1 ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.white),),
                        alignment: Alignment.center,
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                          child: Column(
                            children: [
                              Container(
                                child: const Text('身份验证',style: TextStyle(fontSize: 15,color: APP_MainGreenColor),),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                              ),
                              const DottedLine(
                                direction: Axis.horizontal,
                                lineThickness: 3.0,
                                dashLength: 10.0,
                                dashColor: APP_MainGreenColor,
                                dashRadius: 5.0,
                                dashGapLength: 5.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 5.0,
                              ),
                              Container(
                                child: const Text('身份验证',style: TextStyle(fontSize: 12,color: Colors.transparent),),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              ),
                            ],
                          )
                      ),
                      const SizedBox(width: 5,),
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(_step >=1 ? "image/Login_ThisStep.png" : 'image/Login_UnThisStep.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: const Text('2 ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),),
                        alignment: Alignment.center,
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                          child: Column(
                            children: [
                              Container(
                                child: Text('设置新密码',style: TextStyle(fontSize: 15,color: _step >= 1 ?  APP_MainGreenColor : Colors.grey),),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                              ),
                              DottedLine(
                                direction: Axis.horizontal,
                                lineThickness: 3.0,
                                dashLength: 10.0,
                                dashColor:  _step >= 1 ?  APP_MainGreenColor : Colors.grey,
                                dashRadius: 5.0,
                                dashGapLength: 5.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 5.0,
                              ),
                              Container(
                                child: const Text('设置新密码',style: TextStyle(fontSize: 12,color: Colors.transparent),),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              ),
                            ],
                          )
                      ),
                      const SizedBox(width: 5,),
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(_step >= 2 ? "image/Login_ThisStep.png" : 'image/Login_UnThisStep.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: const Text('3 ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.white),),
                        alignment: Alignment.center,
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                          child: Column(
                            children: [
                              Container(
                                child: Text('修改成功',style: TextStyle(fontSize: 15,color: _step >= 2  ?  APP_MainGreenColor : Colors.grey),),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                              ),
                              DottedLine(
                                direction: Axis.horizontal,
                                lineThickness: 3.0,
                                dashLength: 10.0,
                                dashColor: _step >= 2 ?  APP_MainGreenColor : Colors.grey,
                                dashRadius: 5.0,
                                dashGapLength: 5.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 5.0,
                              ),
                              Container(
                                child: const Text('修改成功',style: TextStyle(fontSize: 12,color: Colors.transparent),),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(00, 30, 00, 30),
                ),
                _validateFormView(),
              ],
            ),
          ),
          behavior: HitTestBehavior.opaque,
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
    );
  }


  //验证总表单
  Widget _validateFormView(){
    return Column(
      children: [
        Offstage(
          child: _verificationStepOne(),
          offstage: _step == 0 ? false : true,
        ),
        Offstage(
          child: _verificationStepTwo(),
          offstage: _step == 1 ? false : true,
        ),
        Offstage(
          child: _verificationStepComplete(),
          offstage: _step == 2 ? false : true,
        ),
      ],
    );
  }

  //验证逻辑 第一步
  Widget _verificationStepOne(){
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            child: const Text('验证方式',style: TextStyle(fontSize: 17,color: Color.fromRGBO(5, 51, 84, 1)),),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectType == 'sms' ?  const Color.fromRGBO(5, 51, 84, 1) : Colors.grey[400],
                        borderRadius: const BorderRadius.only(topLeft:Radius.circular(5.0),bottomLeft: Radius.circular(5.0)),
                      ),
                      child: const Text('手机',style: TextStyle(color: Colors.white ),),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                      if(_selectType != 'sms'){
                        setState(() {
                          _selectType = 'sms';
                          _phoneNumberTextController.text = '';
                          _kaptchaCodeTextController.text = '';
                          _verificationCodeTextController.text = '';

                          _LoginCommonKaptchaHttp(SMS_VALID_FORGETPASS);
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectType == 'email' ?  const Color.fromRGBO(5, 51, 84, 1) : Colors.grey[400],
                        borderRadius: const BorderRadius.only(topRight:Radius.circular(5.0),bottomRight: Radius.circular(5.0)),
                      ),
                      child: const Text('邮箱',style: TextStyle(color: Colors.white),),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                      if(_selectType != 'email'){
                        setState(() {
                          _selectType = 'email';
                          _phoneNumberTextController.text = '';
                          _kaptchaCodeTextController.text = '';
                          _verificationCodeTextController.text = '';

                          _LoginCommonKaptchaHttp(EMAIL_VALID_FORGETPASS);
                        });
                      }
                    },

                  ),
                ),
              ],
            ),

          ),
          Offstage(
            child: _verificationStepOnePhoneView(),
            offstage: _selectType == 'sms' ? false : true,
          ),
          Offstage(
            child: _verificationStepOneEmailView(),
            offstage: _selectType == 'email' ? false : true,
          ),
        ],
      ),
    );
  }

  //验证逻辑 第一步 手机验证
  Widget _verificationStepOnePhoneView(){
    return Column(
      children: [
        Container(
          child: const Text('验证手机号',style: TextStyle(fontSize: 17,color: Color.fromRGBO(5, 51, 84, 1)),),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              labelStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
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
                  hint: Container(
                    child: const Text('+86',
                      style: TextStyle(color: Colors.black,fontSize: 13),
                    ),
                    alignment: Alignment.center,
                  ),
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
            style: TextStyle(color: Colors.black,fontSize: 15),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: const Text('随机验证码',style: TextStyle(fontSize: 17,color: Color.fromRGBO(5, 51, 84, 1)),),
          alignment: Alignment.centerLeft,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
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
                    _LoginCommonKaptchaHttp(SMS_VALID_FORGETPASS);
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
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: const Text('短信验证码',style: TextStyle(fontSize: 17,color: Color.fromRGBO(5, 51, 84, 1)),),
          alignment: Alignment.centerLeft,
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
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
                            _LoginForgetSmsSendHttp();
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
          child: GestureDetector(
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
                  showMyCustomText('请输入手机号');
                  return;
                }
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
                _LoginForgetSmsCheckHttp();
              });
            },
          ),
          alignment: Alignment.center,
        ),
      ],
    );
  }

  //验证逻辑 第一步 邮箱验证
  Widget _verificationStepOneEmailView(){
    return Column(
      children: [
        Container(
          child: const Text('验证登录邮箱',style: TextStyle(fontSize: 17,color: Color.fromRGBO(5, 51, 84, 1)),),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
              suffixText: '',
              suffixStyle: TextStyle(color: Colors.grey,fontSize: 15),
              hintText: '您的邮箱',
              hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
            ),
            controller: _phoneNumberTextController,
            autocorrect:false,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black,fontSize: 15),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: const Text('随机验证码',style: TextStyle(fontSize: 17,color: Color.fromRGBO(5, 51, 84, 1)),),
          alignment: Alignment.centerLeft,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              labelStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
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
                    _LoginCommonKaptchaHttp(EMAIL_VALID_FORGETPASS);
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
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: const Text('邮箱验证码',style: TextStyle(fontSize: 17,color: Color.fromRGBO(5, 51, 84, 1)),),
          alignment: Alignment.centerLeft,
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
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
                            _LoginForgetEmailSendHttp();
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
          child: GestureDetector(
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
                  showMyCustomText('请输入手机号');
                  return;
                }
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
                _LoginForgetEmailCheckHttp();
              });
            },
          ),
          alignment: Alignment.center,
        ),
      ],
    );
  }

  //验证逻辑 第二步
  Widget _verificationStepTwo(){
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: const Text('设置新密码',style: TextStyle(fontSize: 17,color: Color.fromRGBO(5, 51, 84, 1)),),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '请输入新密码,8-24位数字英文或字符',
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
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(5, 51, 84, 1),width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
                suffixText: '',
                suffixStyle: TextStyle(color: Colors.grey,fontSize: 14),
                hintText: '再次输入新密码',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
              ),
              controller: _passwordAgainTextController,
              autocorrect:false,
              obscureText : true,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.black,fontSize: 14),
            ),
          ),
          Container(
            child: GestureDetector(
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

                  if(_selectType == 'sms'){
                    _LoginForgetSmsResetpassHttp();
                  }else if(_selectType == 'email'){
                    _LoginForgetEmailResetpassHttp();
                  }else{
                    showMyCustomText('验证方式错误,请返回重新选择');
                  }
                });
              },
            ),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }

  //验证逻辑 第三步
  Widget _verificationStepComplete(){
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      padding: const EdgeInsets.fromLTRB(60, 50, 60, 50),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            child: const Text('修改登录密码成功！',style: TextStyle(fontSize: 25,color: Color.fromRGBO(5, 51, 84, 1)),),
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
          ),
          Container(
            child: GestureDetector(
              child: Container(
                decoration: const BoxDecoration(
                  color: APP_MainGreenColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [MyButtonBoxShadow],
                ),
                child: const Text('完成去登录',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
              ),
              behavior: HitTestBehavior.opaque,
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.pop(context);
              },
            ),
            alignment: Alignment.center,
          ),
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
    _timer = Timer.periodic(const Duration(seconds: 1), callback);
  }
}
