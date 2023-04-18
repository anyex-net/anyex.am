import 'dart:async';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Base/UserManager.dart';
import 'package:amclient_flutter/Login/Http/LoginHttpRequest.dart';
import 'package:amclient_flutter/Login/Model/LoginCommonRegionResponseModel.dart';
import 'package:amclient_flutter/Setting/Http/SettingHttpRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neveruseless/neveruseless.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
class SettingSecurityInfoBindGAView extends StatefulWidget {
  final arguments;
  const SettingSecurityInfoBindGAView({Key? key, this.arguments}) : super(key: key);

  @override
  _SettingSecurityInfoBindGAViewState createState() => _SettingSecurityInfoBindGAViewState();
}

class _SettingSecurityInfoBindGAViewState extends State<SettingSecurityInfoBindGAView> {
  Timer? _timerPhone;
  int _countdownTimePhone = 0;


  //随机验证码
  final TextEditingController _kaptchaCodeTextController = TextEditingController();
  //短信验证码
  final TextEditingController _phoneCodeTextController = TextEditingController();
  //GA验证码
  final TextEditingController _gaCodeController = TextEditingController();
  //展示用验证码
  String _kaptchaCode = '';

  //防止疯狂点击
  bool _canTuach = true;
  //短信验证码按钮标题
  String _sendMessagePhoneTitle = '获取验证码' ;

  //手机号
  String? _mobNo = '';
  //国家
  String? _country = '';

  //GAS
  String _gaSecretKey = '';
  String _gaInfo = '';

  @override
  void initState() {
    super.initState();
    _mobNo = personMap['phone'];
    _country = personMap['country'];
    _LoginCommonKaptchaHttp(SMS_VALID_OTHER);
    _SettingAccountSecurityBindGoogleAuthBuildGASecretKeyHttp();
  }

  @override
  void dispose() {
    if(_timerPhone != null){
      _timerPhone!.cancel();
    }
    super.dispose();

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
    }else{
      try{
        showMyCustomText(response['message']);
      }catch(e){
        showMyCustomText('[获取随机验证码]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //绑定 发送短信码
  Future _SettingAccountSecurityBindGoogleAuthSmsSendHttp() async{//{String mobNo = '',String kaptcha = '',String country = ''}
    var response = await SettingAccountSecurityBindGoogleAuthSmsSend(kaptcha: _kaptchaCodeTextController.text,mobNo: _mobNo!,country: _country!);
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

  //绑定 获取私钥
  Future _SettingAccountSecurityBindGoogleAuthBuildGASecretKeyHttp() async{
    var response = await SettingAccountSecurityBindGoogleAuthBuildGASecretKey();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
         _gaSecretKey = response['object']['gaSecretKey'];
         _gaInfo = response['object']['gaInfo'];
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[获取私钥]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取私钥]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //确认 绑定谷歌
  Future _SettingAccountSecurityBindGoogleAuthHttp() async{//{String gaCode = '',String gaSecretKey = '',String smsCode = ''}
    var response = await SettingAccountSecurityBindGoogleAuth(gaCode: _gaCodeController.text,gaSecretKey: _gaSecretKey,smsCode: _phoneCodeTextController.text);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200) {
        setState(() {
          showMyCustomText('绑定谷歌验证器成功');
          neverBus.emit('SettingSecurityInfoUpdate');
          Navigator.pop(context);
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[绑定谷歌]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[绑定谷歌]遇到问题，请检查网络或重新刷新');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
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
                        child: const Text('绑定谷歌验证器',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
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
                    border: Border.all(width: 1, color: const Color.fromRGBO(255, 153, 37, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  padding:const  EdgeInsets.fromLTRB(10, 3, 10, 3),
                  child: Row(
                    children: [
                      const Icon(Icons.error,color: Colors.orange,size: 18,),
                      Expanded(
                        child: Container(
                          child:const Text("谷歌验证器是一款动态口令工具，工作原理类似短信动态验证。绑定后每30s生成一个动态验证码，验证码可用于登录、提现、修改安全设置等操作的安全验证。",style: TextStyle(fontSize: 13,color: Colors.black),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: const Text('1:下载谷歌验证器APP',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: const Text('iOS用户登录App Store搜索“Authenticator”下载。安卓用户登录应用商店或使用手机浏览器搜索“谷歌验证器”下载。',style: TextStyle(fontSize: 13,color: Colors.black),),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 20, 10, 10),
                  child: const Text('2:在谷歌验证器中添加密钥并备份',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: const Text('打开谷歌验证器，扫描下方二维码或手动输入下述密钥添加验证令牌。',style: TextStyle(fontSize: 13,color: Colors.black),),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImage(
                        data: _gaInfo,
                        version: QrVersions.auto,
                        size: 100.0,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(_gaSecretKey,style: const TextStyle(color: Colors.black,fontSize: 14),),
                              alignment: Alignment.centerLeft,
                            ),
                            GestureDetector(
                              child: Container(
                                child: const Text('复制秘钥',style: TextStyle(color: APP_MainGreenColor,fontSize: 14),),
                                alignment: Alignment.centerLeft,
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                FocusScope.of(context).requestFocus(FocusNode());
                                Clipboard.setData(ClipboardData(text: _gaSecretKey));
                                showMyCustomText('复制成功');
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: const Text('3:输入短信验证码',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                ),
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
                      labelStyle: const TextStyle(color: Colors.grey),
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
                            _LoginCommonKaptchaHttp(SMS_VALID_OTHER);
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
                    keyboardType: const TextInputType.numberWithOptions(

                    ),
                    style: const TextStyle(color: Colors.black,fontSize: 13),
                  ),
                ),
                const SizedBox(height: 10,),
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
                                hintText: '短信验证码',
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
                                    _SettingAccountSecurityBindGoogleAuthSmsSendHttp();
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
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 20, 10, 10),
                  child: const Text('3:输入谷歌验证器中6位验证码',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black),),
                ),
                Container(
                  child: const Text('谷歌验证码',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//随机验证码
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
                      suffixStyle: TextStyle(color: Colors.grey,fontSize: 13),
                      hintText: '请输入谷歌验证码',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                    ),
                    controller: _gaCodeController,
                    autocorrect:false,
                    keyboardType: const TextInputType.numberWithOptions(
                    ),
                    style: const TextStyle(color: Colors.black,fontSize: 13),
                  ),
                ),
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
                          if(_kaptchaCodeTextController.text == ''){
                            showMyCustomText("请输入随机验证码");
                            return;
                          }
                          if(_phoneCodeTextController.text == ''){
                            showMyCustomText("请输入短信验证码");
                            return;
                          }
                          if(_gaCodeController.text == ''){
                            showMyCustomText("请输入谷歌验证码");
                            return;
                          }
                          _SettingAccountSecurityBindGoogleAuthHttp();
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

}

