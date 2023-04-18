import 'dart:async';
import 'dart:io';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Base/UserManager.dart';
import 'package:amclient_flutter/Login/Http/LoginHttpRequest.dart';
import 'package:amclient_flutter/Setting/Http/SettingHttpRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:neveruseless/neveruseless.dart';
class SettingSecurityInfoBindEmailView extends StatefulWidget {
  final arguments;
  const SettingSecurityInfoBindEmailView({Key? key, this.arguments}) : super(key: key);

  @override
  _SettingSecurityInfoBindEmailViewState createState() => _SettingSecurityInfoBindEmailViewState();
}

class _SettingSecurityInfoBindEmailViewState extends State<SettingSecurityInfoBindEmailView> {
  Timer? _timerEmail;
  Timer? _timerPhone;
  int _countdownTimeEmail = 0;
  int _countdownTimePhone = 0;

  final ScrollController _controller1 = ScrollController();

  //邮箱
  final TextEditingController _emailTextController = TextEditingController();
  //邮箱验证码
  final TextEditingController _emailCodeTextController = TextEditingController();
  //随机验证码
  final TextEditingController _kaptchaCodeTextController = TextEditingController();
  //随机验证码
  final TextEditingController _phoneCodeTextController = TextEditingController();
  //展示用验证码
  String _kaptchaCode = '';

  //防止疯狂点击
  bool _canTuach = true;
  //邮箱验证码按钮标题
  String _sendMessageEmailTitle = '获取验证码' ;
  //短信验证码按钮标题
  String _sendMessagePhoneTitle = '获取验证码' ;

  //手机号
  String? _mobNo = '';
  //国家
  String? _country = '';

  @override
  void initState() {
    super.initState();
    _mobNo = personMap['phone'];
    _country = personMap['country'];
    _LoginCommonKaptchaHttp(EMAIL_VALID_OTHER);
  }

  @override
  void dispose() {
    if(_timerEmail != null){
      _timerEmail!.cancel();
    }
    if(_timerPhone != null){
      _timerPhone!.cancel();
    }
    super.dispose();
  }

  //邮箱验证码倒计时
  void startCountdownTimerEmail() {
    var callback = (timer) => {
      if(mounted){
        setState(() {
          if (_countdownTimeEmail < 1) {
            _timerEmail!.cancel();
          } else {
            _countdownTimeEmail = _countdownTimeEmail - 1;
            _sendMessageEmailTitle = _countdownTimeEmail.toString() + 's';
            if (_countdownTimeEmail == 0) {
              _sendMessageEmailTitle = '重新发送';
            }
          }
        })
      }
    };
    _timerEmail = Timer.periodic(const Duration(seconds: 1), callback);
  }
  //短信验证码倒计时
  void startCountdownTimerPhone() {
    var callback = (timer) => {
      if(mounted){
        setState(() {
          if (_countdownTimePhone < 1) {
            _timerPhone!.cancel();
          } else {
            _countdownTimePhone = _countdownTimePhone - 1;
            _sendMessagePhoneTitle = _countdownTimePhone.toString() + 's';
            if (_countdownTimePhone == 0) {
              _sendMessagePhoneTitle = '重新发送';
            }
          }
        })
      }
    };
    _timerPhone = Timer.periodic(const Duration(seconds: 1), callback);
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
  //绑定 发送邮箱码
  Future _SettingAccountSecurityBindEmailSendHttp() async{//{String email = '',String kaptcha = ''}
    var response = await SettingAccountSecurityBindEmailSend(kaptcha: _kaptchaCodeTextController.text,email: _emailTextController.text);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _countdownTimeEmail = 60;
          startCountdownTimerEmail();
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
  //绑定 发送短信码
  Future _SettingAccountSecurityBindEmailSmsSendHttp() async{//{String mobNo = '',String kaptcha = '',String country = ''}
    var response = await SettingAccountSecurityBindEmailSmsSend(kaptcha: _kaptchaCodeTextController.text,mobNo: _mobNo!,country: _country!);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _countdownTimePhone = 60;
          startCountdownTimerPhone();
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
  //确认 绑定邮箱
  Future _SettingAccountSecurityBindEmailConfirmHttp() async{//{String email = '',String emailCode = '',String smsCode = ''}
    var response = await SettingAccountSecurityBindEmailConfirm(email: _emailTextController.text,emailCode: _emailCodeTextController.text,smsCode: _phoneCodeTextController.text);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200) {
        setState(() {
          showMyCustomText('绑定邮箱成功');
          neverBus.emit('SettingSecurityInfoUpdate');
          Navigator.pop(context);
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[绑定邮箱]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[绑定邮箱]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _desktopView();
  }

  Widget _desktopView(){
    return  StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text('绑定邮箱',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        child: const Icon(Icons.close,color: Colors.black,),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        FocusScope.of(context).requestFocus(FocusNode());
                        if(_timerEmail != null){
                          _timerEmail!.cancel();
                        }
                        if(_timerPhone != null){
                          _timerPhone!.cancel();
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 241, 226, 1),
                    border: Border.all(width: 1, color:const  Color.fromRGBO(255, 153, 37, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  child: Row(
                    children: [
                      const Icon(Icons.error,color: Colors.orange,size: 18,),
                      Expanded(
                        child: Container(
                          child:const Text("邮箱绑定后不可更换",style: TextStyle(fontSize: 13,color: Colors.black),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('邮箱',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//邮箱
                Container(
                  alignment: Alignment.center,
                  height: 36,
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: APP_MainGreenColor),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      suffixText: '',
                      suffixStyle: TextStyle(color: Colors.grey,fontSize: 13),
                      hintText: '请输入邮箱地址',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                    ),
                    controller: _emailTextController,
                    autocorrect:false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black,fontSize: 13),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('随机验证码',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//随机验证码
                Container(
                  alignment: Alignment.center,
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
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
                            _LoginCommonKaptchaHttp(EMAIL_VALID_OTHER);
                          }else{
                            showMyCustomText('点击过快,请稍后');
                            return;
                          }
                        },
                      ),
                      suffixStyle: const TextStyle(color: Colors.grey,fontSize: 13),
                      hintText: '请输入随机验证码',
                      hintStyle: const TextStyle(color: Colors.grey,fontSize: 13),
                    ),
                    controller: _kaptchaCodeTextController,
                    autocorrect:false,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Colors.black,fontSize: 13),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('邮箱验证码',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//邮箱验证码
                Container(
                    alignment: Alignment.center,
                    height: 36,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: APP_MainGreenColor),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                ),
                                suffixText: '',
                                suffixStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                hintText: '请输入邮箱验证码',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                              ),
                              controller: _emailCodeTextController,
                              autocorrect:false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: const TextStyle(color: Colors.black,fontSize: 13),
                            ),
                            flex: 6,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _countdownTimeEmail > 0 ?const  Color.fromARGB(255, 183, 184, 195) : APP_MainGreenColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Text(_sendMessageEmailTitle,style: const TextStyle(color: Colors.white,fontSize: 12),),
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
                                    if(_countdownTimeEmail > 0){
                                      showMyCustomText('请稍等');
                                      return;
                                    }
                                    _emailCodeTextController.text = '';
                                    _SettingAccountSecurityBindEmailSendHttp();
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
                  child: const Text('验证邮件可能会被误判为垃圾邮件，请注意查收',style: TextStyle(fontSize: 11,color: Colors.grey),),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),
                Container(
                  child: const Text('短信验证码',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//短信验证码
                Container(
                    alignment: Alignment.center,
                    height: 36,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: APP_MainGreenColor),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                ),
                                suffixText: '',
                                suffixStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                hintText: '请输入短信验证码',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                              ),
                              controller: _phoneCodeTextController,
                              autocorrect:false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: const TextStyle(color: Colors.black,fontSize: 13),
                            ),
                            flex: 6,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _countdownTimePhone > 0 ? const Color.fromARGB(255, 183, 184, 195) : APP_MainGreenColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Text(_sendMessagePhoneTitle,style: const TextStyle(color: Colors.white,fontSize: 12),),
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
                                    if(_countdownTimePhone > 0){
                                      showMyCustomText('请稍等');
                                      return;
                                    }
                                    _phoneCodeTextController.text = '';
                                    _SettingAccountSecurityBindEmailSmsSendHttp();
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
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: const Text('取消',style: TextStyle(fontSize: 14,color: Colors.white),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(25, 6, 25, 6),
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          if(_timerEmail != null){
                            _timerEmail!.cancel();
                          }
                          if(_timerPhone != null){
                            _timerPhone!.cancel();
                          }
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: APP_MainGreenColor,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: const Text('确定',style: TextStyle(fontSize: 14,color: Colors.white),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(25, 6, 25, 6),
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          if(_emailTextController.text == ''){
                            showMyCustomText('请输入邮箱地址');
                            return;
                          }
                          if(_emailCodeTextController.text == ''){
                            showMyCustomText("请输入邮箱验证码");
                            return;
                          }
                          if(_phoneCodeTextController.text == ''){
                            showMyCustomText("请输入短信验证码");
                            return;
                          }
                          _SettingAccountSecurityBindEmailConfirmHttp();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          behavior: HitTestBehavior.opaque,
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
        );
      },
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
          title: const Text("绑定邮箱"),
        ),
        body:Container(
          color: APP_MainBGColor,
          alignment: Alignment.center,
          child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20,10),
              child: ListView(
                controller: _controller1,
                children: [
                  const SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 241, 226, 1),
                      border: Border.all(width: 1, color: const Color.fromRGBO(255, 153, 37, 1)),
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                    child: Row(
                      children: [
                        const Icon(Icons.error,color: Colors.orange,size: 18,),
                        Expanded(
                          child: Container(
                            child:const Text("邮箱绑定后不可更换",style: TextStyle(fontSize: 13,color: Colors.black),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    child: const Text('邮箱',style: TextStyle(fontSize: 13,color: Colors.white),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  ),//邮箱
                  Container(
                    alignment: Alignment.center,
                    height: 36,
                    child: TextField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: APP_MainGreenColor),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        suffixText: '',
                        suffixStyle: TextStyle(color: Colors.grey,fontSize: 13),
                        hintText: '请输入邮箱地址',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                      ),
                      controller: _emailTextController,
                      autocorrect:false,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white,fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    child: const Text('随机验证码',style: TextStyle(fontSize: 13,color: Colors.white),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  ),//随机验证码
                  Container(
                    alignment: Alignment.center,
                    height: 36,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding:const  EdgeInsets.fromLTRB(10, 0, 10, 0),
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
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
                              _LoginCommonKaptchaHttp(EMAIL_VALID_OTHER);
                            }else{
                              showMyCustomText('点击过快,请稍后');
                              return;
                            }
                          },
                        ),
                        suffixStyle: const TextStyle(color: Colors.grey,fontSize: 13),
                        hintText: '请输入随机验证码',
                        hintStyle: const TextStyle(color: Colors.grey,fontSize: 13),
                      ),
                      controller: _kaptchaCodeTextController,
                      autocorrect:false,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.white,fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    child: const Text('邮箱验证码',style: TextStyle(fontSize: 13,color: Colors.white),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  ),//邮箱验证码
                  Container(
                      alignment: Alignment.center,
                      height: 36,
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: APP_MainGreenColor),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                  suffixText: '',
                                  suffixStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                  hintText: '请输入邮箱验证码',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _emailCodeTextController,
                                autocorrect:false,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: const TextStyle(color: Colors.white,fontSize: 13),
                              ),
                              flex: 6,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _countdownTimeEmail > 0 ? const Color.fromARGB(255, 183, 184, 195) : APP_MainGreenColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                    ),
                                    child: Text(_sendMessageEmailTitle,style: const TextStyle(color: Colors.white,fontSize: 12),),
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
                                      if(_countdownTimeEmail > 0){
                                        showMyCustomText('请稍等');
                                        return;
                                      }
                                      _emailCodeTextController.text = '';
                                      _SettingAccountSecurityBindEmailSendHttp();
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
                    child:const  Text('验证邮件可能会被误判为垃圾邮件，请注意查收',style: TextStyle(fontSize: 11,color: Colors.white),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  ),
                  Container(
                    child: const Text('短信验证码',style: TextStyle(fontSize: 13,color: Colors.white),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  ),//短信验证码
                  Container(
                      alignment: Alignment.center,
                      height: 36,
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: APP_MainGreenColor),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                  suffixText: '',
                                  suffixStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                  hintText: '请输入短信验证码',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _phoneCodeTextController,
                                autocorrect:false,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: const TextStyle(color: Colors.white,fontSize: 13),
                              ),
                              flex: 6,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _countdownTimePhone > 0 ? const Color.fromARGB(255, 183, 184, 195) : APP_MainGreenColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                    ),
                                    child: Text(_sendMessagePhoneTitle,style: const TextStyle(color: Colors.white,fontSize: 12),),
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
                                      if(_countdownTimePhone > 0){
                                        showMyCustomText('请稍等');
                                        return;
                                      }
                                      _phoneCodeTextController.text = '';
                                      _SettingAccountSecurityBindEmailSmsSendHttp();
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
                  const SizedBox(height: 30,),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: const Text('取消',style: TextStyle(fontSize: 14,color: Colors.white),),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(25, 6, 25, 6),
                            ),
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                              if(_timerEmail != null){
                                _timerEmail!.cancel();
                              }
                              if(_timerPhone != null){
                                _timerPhone!.cancel();
                              }
                              Navigator.pop(context);
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
                              child: const Text('确定',style: TextStyle(fontSize: 14,color: Colors.white),),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(25, 6, 25, 6),
                            ),
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                              if(_emailTextController.text == ''){
                                showMyCustomText('请输入邮箱地址');
                                return;
                              }
                              if(_emailCodeTextController.text == ''){
                                showMyCustomText("请输入邮箱验证码");
                                return;
                              }
                              if(_phoneCodeTextController.text == ''){
                                showMyCustomText("请输入短信验证码");
                                return;
                              }
                              _SettingAccountSecurityBindEmailConfirmHttp();
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),

        ),
      ),
    );

  }
}

