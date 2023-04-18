import 'dart:async';
import 'dart:io';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Login/Http/LoginHttpRequest.dart';
import 'package:amclient_flutter/Setting/Http/SettingHttpRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amclient_flutter/Base/UserManager.dart' as UnlockManager;
import 'package:neveruseless/neveruseless.dart';
class SettingChangePasswordCashPasswordView extends StatefulWidget {
  final arguments;
  const SettingChangePasswordCashPasswordView({Key? key, this.arguments}) : super(key: key);

  @override
  _SettingChangePasswordCashPasswordViewState createState() => _SettingChangePasswordCashPasswordViewState();
}

class _SettingChangePasswordCashPasswordViewState extends State<SettingChangePasswordCashPasswordView> {

  final ScrollController _controller1 = ScrollController();
  //旧 资金密码
  final TextEditingController _oldPasswordTextController = TextEditingController();
  //新 资金密码
  final TextEditingController _newPasswordTextController = TextEditingController();
  //新 资金密码确认
  final TextEditingController _newAPasswordTextController = TextEditingController();

  Timer? _timerPhone;
  int _countdownTimePhone = 0;
  //随机验证码
  final TextEditingController _kaptchaCodeTextController = TextEditingController();
  //短信验证码
  final TextEditingController _phoneCodeTextController = TextEditingController();
  //GA验证码
  final TextEditingController _gaCodeController = TextEditingController();
  //密码
  final TextEditingController _passwordController = TextEditingController();
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



  String _tipString = '';
  Color _tipColor = Colors.white;

  String _securityPolicy = '';
  String _cashPwd = '';

  @override
  void initState() {
    _securityPolicy = UnlockManager.personMap['securityPolicy'].toString();
    _cashPwd = UnlockManager.personMap['cashPwd'].toString();
    _mobNo = UnlockManager.personMap['phone'].toString();
    _country = UnlockManager.personMap['country'].toString();
    print(_cashPwd);
    print(_securityPolicy);
    _LoginCommonKaptchaHttp(SMS_VALID_OTHER);
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();

  }

  Future _SettingAccountSecurityChangeCashPwdHttp() async{//{String cashPwd = '',String gacode = '',String loginPwd = '',String smsCode =''}
    var response = await SettingAccountSecurityChangeCashPwd(cashPwd:_newPasswordTextController.text,gacode: _gaCodeController.text,loginPwd: _passwordController.text,smsCode: _phoneCodeTextController.text);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200) {
        setState(() {
          showMyCustomText(_cashPwd == '' ? '设置资金密码成功' : '修改资金密码成功');
          neverBus.emit('SettingChangePasswordUpdate');
          Navigator.pop(context);
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[资金密码操作]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[资金密码操作]遇到问题，请检查网络或重新刷新');
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
                        child: Text( _cashPwd != '' ? '修改资金密码' : '设置资金密码',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
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
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  child: Row(
                    children: [
                      const Icon(Icons.error,color: Colors.orange,size: 18,),
                      Expanded(
                        child: Container(
                          child:const Text("资金密码于交易时使用,请妥善保存,若可能泄露,请及时修改",style: TextStyle(fontSize: 13,color: Colors.black),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Offstage(
                  offstage: _cashPwd == '' ? true : false,
                  child: Column(
                    children: [
                      Container(
                        child: const Text('旧资金密码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),//旧密码
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
                            hintText: '请输入旧资金密码',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                          ),
                          controller: _oldPasswordTextController,
                          autocorrect:false,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.black,fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),//若资金密码为空 直接设置新密码
                Container(
                  child: const Text('新密码',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//新密码
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
                                hintText: '请输入新资金密码',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                              ),
                              controller: _newPasswordTextController,
                              autocorrect:false,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black,fontSize: 13),
                              onChanged: (value){
                                setState((){
                                  _checkPassword();
                                });
                              },
                            ),
                            flex: 6,
                          ),
                        ],
                      ),
                    )
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('确认新密码',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//新密码确认
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
                                hintText: '请输入再次新资金密码',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                              ),
                              controller: _newAPasswordTextController,
                              autocorrect:false,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black,fontSize: 13),
                              onChanged: (value){
                                setState((){
                                  _checkPassword();
                                });
                              },
                            ),
                            flex: 6,
                          ),
                        ],
                      ),
                    )
                ),
                const SizedBox(height: 10,),
                Offstage(
                  child: Container(
                    child: Text(_tipString,style: TextStyle(fontSize: 13,color: _tipColor),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  ),
                  offstage:  _tipString != '' ? false : true,
                ),//新密码确认提示
                Offstage(
                  offstage: _securityPolicy == '0' ? false : true,
                  child: Column(
                    children: [
                      Container(
                        child: const Text('登录密码',style: TextStyle(fontSize: 13,color: Colors.black),),
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
                            hintText: '请输入登录验证码',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                          ),
                          controller: _passwordController,
                          autocorrect:false,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.black,fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),//0 登录密码
                Offstage(
                  offstage: _securityPolicy == '1' ? false : true,
                  child: Column(
                    children: [
                      Container(
                        child: const Text('随机验证码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
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
                          keyboardType: TextInputType.text,
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
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),//1 手机短信
                Offstage(
                  offstage: _securityPolicy == '2' ? false : true,
                  child: Column(
                    children: [
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
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.black,fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),//2 GA绑定
                Container(
                  padding:const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                          if(_cashPwd != ""){
                            if(_oldPasswordTextController.text == ''){
                              showMyCustomText("请输入旧密码");
                              return;
                            }
                          }
                          if(_newPasswordTextController.text == ''){
                            showMyCustomText("请输入新密码");
                            return;
                          }
                          if(_newAPasswordTextController.text == ''){
                            showMyCustomText("请确认新密码");
                            return;
                          }
                          if(_newAPasswordTextController.text != _newPasswordTextController.text){
                            showMyCustomText("请确认新密码");
                            return;
                          }
                          if(_securityPolicy == '0'){
                            if(_passwordController.text == ''){
                              showMyCustomText('请输入登录密码');
                              return;
                            }
                          }
                          if(_securityPolicy == '1'){
                            if(_kaptchaCodeTextController.text == ''){
                              showMyCustomText('请输入随机验证码');
                              return;
                            }
                            if(_kaptchaCodeTextController.text.toUpperCase() != _kaptchaCode.toUpperCase()){
                              showMyCustomText('随机验证码输入错误,请重试');
                              return;
                            }
                            if(_phoneCodeTextController.text == ''){
                              showMyCustomText('请输入短信验证码');
                              return;
                            }
                          }
                          if(_securityPolicy == '2'){
                            if(_gaCodeController.text == ''){
                              showMyCustomText('请输入谷歌验证码');
                              return;
                            }
                          }
                          _SettingAccountSecurityChangeCashPwdHttp();
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
          title: const Text("修改登录密码"),
        ),
        body:GestureDetector(
          child: Container(
            color: APP_MainBGColor,
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                          child:const Text("资金密码于交易时使用,请妥善保存,若可能泄露,请及时修改",style: TextStyle(fontSize: 13,color: Colors.black),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Offstage(
                  offstage: _cashPwd == '' ? true : false,
                  child: Column(
                    children: [
                      Container(
                        child: const Text('旧资金密码',style: TextStyle(fontSize: 13,color: Colors.white),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),//旧密码
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
                            hintText: '请输入旧资金密码',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                          ),
                          controller: _oldPasswordTextController,
                          autocorrect:false,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.white,fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),//若资金密码为空 直接设置新密码
                Container(
                  child: const Text('新密码',style: TextStyle(fontSize: 13,color: Colors.white),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//新密码
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
                                hintText: '请输入新资金密码',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                              ),
                              controller: _newPasswordTextController,
                              autocorrect:false,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white,fontSize: 13),
                              onChanged: (value){
                                setState((){
                                  _checkPassword();
                                });
                              },
                            ),
                            flex: 6,
                          ),
                        ],
                      ),
                    )
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('确认新密码',style: TextStyle(fontSize: 13,color: Colors.white),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//新密码确认
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
                                hintText: '请输入再次新资金密码',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                              ),
                              controller: _newAPasswordTextController,
                              autocorrect:false,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white,fontSize: 13),
                              onChanged: (value){
                                setState((){
                                  _checkPassword();
                                });
                              },
                            ),
                            flex: 6,
                          ),
                        ],
                      ),
                    )
                ),
                const SizedBox(height: 10,),
                Offstage(
                  child: Container(
                    child: Text(_tipString,style: TextStyle(fontSize: 13,color: _tipColor),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  ),
                  offstage:  _tipString != '' ? false : true,
                ),//新密码确认提示
                Offstage(
                  offstage: _securityPolicy == '0' ? false : true,
                  child: Column(
                    children: [
                      Container(
                        child: const Text('登录密码',style: TextStyle(fontSize: 13,color: Colors.white),),
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
                            hintText: '请输入登录验证码',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                          ),
                          controller: _passwordController,
                          autocorrect:false,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.white,fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),//0 登录密码
                Offstage(
                  offstage: _securityPolicy == '1' ? false : true,
                  child: Column(
                    children: [
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
                                child: Text(_kaptchaCode,style: const TextStyle(fontSize: 13,color: Colors.white),),
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
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.white,fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 10,),
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
                                      hintText: '短信验证码',
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
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),//1 手机短信
                Offstage(
                  offstage: _securityPolicy == '2' ? false : true,
                  child: Column(
                    children: [
                      Container(
                        child: const Text('谷歌验证码',style: TextStyle(fontSize: 13,color: Colors.white),),
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
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.white,fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),//2 GA绑定
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child:GestureDetector(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: const Text('取消',style: TextStyle(fontSize: 14,color: Colors.white),),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
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
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            if(_cashPwd != ""){
                              if(_oldPasswordTextController.text == ''){
                                showMyCustomText("请输入旧密码");
                                return;
                              }
                            }
                            if(_newPasswordTextController.text == ''){
                              showMyCustomText("请输入新密码");
                              return;
                            }
                            if(_newAPasswordTextController.text == ''){
                              showMyCustomText("请确认新密码");
                              return;
                            }
                            if(_newAPasswordTextController.text != _newPasswordTextController.text){
                              showMyCustomText("请确认新密码");
                              return;
                            }
                            if(_securityPolicy == '0'){
                              if(_passwordController.text == ''){
                                showMyCustomText('请输入登录密码');
                                return;
                              }
                            }
                            if(_securityPolicy == '1'){
                              if(_kaptchaCodeTextController.text == ''){
                                showMyCustomText('请输入随机验证码');
                                return;
                              }
                              if(_kaptchaCodeTextController.text.toUpperCase() != _kaptchaCode.toUpperCase()){
                                showMyCustomText('随机验证码输入错误,请重试');
                                return;
                              }
                              if(_phoneCodeTextController.text == ''){
                                showMyCustomText('请输入短信验证码');
                                return;
                              }
                            }
                            if(_securityPolicy == '2'){
                              if(_gaCodeController.text == ''){
                                showMyCustomText('请输入谷歌验证码');
                                return;
                              }
                            }
                            _SettingAccountSecurityChangeCashPwdHttp();
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
        )
      ),
    );

  }

  void _checkPassword(){
    if(_newPasswordTextController.text == '' || _newAPasswordTextController.text == ''){
      _tipString = '';
      _tipColor = Colors.white;
    }
    if(_newAPasswordTextController.text == "" && _newPasswordTextController.text !=''){
      _tipString = '';
      _tipColor = Colors.white;
    }else if(_newPasswordTextController.text != _newAPasswordTextController.text){
      _tipString = '两次资金密码不相同';
      _tipColor = APP_MainRedColor;
    }else if(_newPasswordTextController.text == _newAPasswordTextController.text){
      _tipString = '';
      _tipColor = Colors.white;
    }else{
      _tipString = '';
      _tipColor = Colors.white;
    }
  }
}

