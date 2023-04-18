import 'dart:async';
import 'dart:io';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Setting/Http/SettingHttpRequest.dart';
import 'package:amclient_flutter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neveruseless/never/neverLocalStorage.dart';
class SettingChangePasswordLoginPasswordView extends StatefulWidget {
  final arguments;
  const SettingChangePasswordLoginPasswordView({Key? key, this.arguments}) : super(key: key);

  @override
  _SettingChangePasswordLoginPasswordViewState createState() => _SettingChangePasswordLoginPasswordViewState();
}

class _SettingChangePasswordLoginPasswordViewState extends State<SettingChangePasswordLoginPasswordView> {

  final ScrollController _controller1 = ScrollController();
  //旧密码
  final TextEditingController _oldPasswordTextController = TextEditingController();
  //新密码
  final TextEditingController _newPasswordTextController = TextEditingController();
  //新密码确认
  final TextEditingController _newAPasswordTextController = TextEditingController();

  String _tipString = '';
  Color _tipColor = Colors.white;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();

  }

  Future _SettingAccountSecurityChangeLoginPwdHttp() async{//{String newPass = '',String oldPass = ''}
    var response = await SettingAccountSecurityChangeLoginPwd(newPassword:_newPasswordTextController.text , oldPassword: _oldPasswordTextController.text);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200) {
        setState(() {
          showMyCustomText('修改密码成功,请重新登录');
          neverLocalStorageWrite('kUserDefaultsKeyToken', '');
          neverLocalStorageWrite('kUserDefaultsKeyID', '');
          navigatorKey.currentState!.pushNamedAndRemoveUntil('/LoginViewController',(route) => false);

        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[修改密码]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[修改密码]遇到问题，请检查网络或重新刷新');
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
                        child: const Text('修改登录密码',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
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
                          child:const Text("新密码需要8-24位数字、字母或字符",style: TextStyle(fontSize: 13,color: Colors.black),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('旧密码',style: TextStyle(fontSize: 13,color: Colors.black),),
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
                      hintText: '请输入旧密码',
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
                                hintText: '请输入新密码，8-24位数字、字母或字符',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                              ),
                              controller: _newPasswordTextController,
                              autocorrect:false,
                              obscureText: true,
                              keyboardType: TextInputType.text,
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
                                hintText: '请输入再次新密码，8-24位数字、字母或字符',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                              ),
                              controller: _newAPasswordTextController,
                              autocorrect:false,
                              obscureText: true,
                              keyboardType: TextInputType.text,
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
                          if(_oldPasswordTextController.text == ''){
                            showMyCustomText("请输入旧密码");
                            return;
                          }
                          if(_newPasswordTextController.text == ''){
                            showMyCustomText("请输入新密码");
                            return;
                          }
                          if(_newPasswordTextController.text.length > 24 || _newPasswordTextController.text.length < 8){
                            showMyCustomText('请输入8-24位数字英文或字符');
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
                          _SettingAccountSecurityChangeLoginPwdHttp();
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
                          child:const Text("新密码需要8-24位数字、字母或字符",style: TextStyle(fontSize: 13,color: Colors.black),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('旧密码',style: TextStyle(fontSize: 13,color: Colors.white),),
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
                      hintText: '请输入旧密码',
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
                                hintText: '请输入新密码，8-24位数字、字母或字符',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                              ),
                              controller: _newPasswordTextController,
                              autocorrect:false,
                              obscureText: true,
                              keyboardType: TextInputType.text,
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
                                hintText: '请输入再次新密码，8-24位数字、字母或字符',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                              ),
                              controller: _newAPasswordTextController,
                              autocorrect:false,
                              obscureText: true,
                              keyboardType: TextInputType.text,
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
                            if(_oldPasswordTextController.text == ''){
                              showMyCustomText("请输入旧密码");
                              return;
                            }
                            if(_newPasswordTextController.text == ''){
                              showMyCustomText("请输入新密码");
                              return;
                            }
                            if(_newPasswordTextController.text.length > 24 || _newPasswordTextController.text.length < 8){
                              showMyCustomText('请输入8-24位数字英文或字符');
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
                            _SettingAccountSecurityChangeLoginPwdHttp();
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
      _tipString = '两次密码不相同';
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

