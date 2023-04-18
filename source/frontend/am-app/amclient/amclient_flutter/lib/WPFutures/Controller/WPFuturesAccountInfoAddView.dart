import 'dart:io';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/WPFutures/Http/WPFuturesHttpRequest.dart';
import 'package:amclient_flutter/WPFutures/Model/WPFuturesBrokerInfoResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neveruseless/neveruseless.dart';
class WPFuturesAccountInfoAddView extends StatefulWidget {
  final arguments;
  const WPFuturesAccountInfoAddView({Key? key, this.arguments}) : super(key: key);

  @override
  _WPFuturesAccountInfoAddViewState createState() => _WPFuturesAccountInfoAddViewState();
}

class _WPFuturesAccountInfoAddViewState extends State<WPFuturesAccountInfoAddView> {

  late List<WPFuturesBrokerInfoResponseData> _brokerInfoList = [];
  List<DropdownMenuItem<String>> _brokerInfoItems = [];
  var _brokerInfoNo = '';


  //资金账户
  final TextEditingController _accountNoTextController = TextEditingController();
  //新密码
  final TextEditingController _accountPasswordTextController = TextEditingController();
  //新密码确认
  final TextEditingController _accountAuthCodeTextController = TextEditingController();
  //行情资金账号
  final TextEditingController _quoteAccountNoTextController = TextEditingController();
  //行情资金账号密码
  final TextEditingController _quoteAccountPasswordTextController = TextEditingController();
  //行情资金账号授权码
  final TextEditingController _quoteAccountAuthCodeTextController = TextEditingController();
  //行情前置机地址
  final TextEditingController _quoteApiAddrTextController = TextEditingController();
  //交易前置机地址
  final TextEditingController _tradeApiAddrTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _WPFuturesWpfuturesBrokerInfoDataHttp();
  }

  @override
  void dispose() {
    super.dispose();
  }


  //外盘期货 新增API 经纪商编码
  Future _WPFuturesWpfuturesBrokerInfoDataHttp() async{
    var response = await WPFuturesWpfuturesBrokerInfoData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _brokerInfoList = WPFuturesBrokerInfoResponseModel.fromJson(response).object!;
          if(_brokerInfoItems.isNotEmpty){
            _brokerInfoItems.clear();
          }
          for(int i =0;i< _brokerInfoList.length ;i++){
            _brokerInfoItems.add(DropdownMenuItem(
              child: Container(
                child: Text( _brokerInfoList[i].brokerName!,
                  style: const TextStyle(color: Colors.black,fontSize: 13),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              ),
              value: _brokerInfoList[i].brokerNo!,
            ),
            );
          }
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[外盘期货经纪商编码]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[外盘期货经纪商编码]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货 新增API 新增
  Future _WPFuturesWpfuturesAccountInfoSaveHttp() async{//{String accountAuthCode = '',String accountNo = '',String accountPassword = '',String brokerNo = '',}
    var response = await WPFuturesWpfuturesAccountInfoSave(
      accountAuthCode:_accountAuthCodeTextController.text ,
      accountNo: _accountNoTextController.text,
      accountPassword: _accountPasswordTextController.text,
      brokerNo: _brokerInfoNo,
      quoteAccountNo:_quoteAccountNoTextController.text,
      quoteAccountPassword: _quoteAccountPasswordTextController.text,
      quoteAccountAuthCode: _quoteAccountAuthCodeTextController.text,
      quoteApiAddr: _quoteApiAddrTextController.text,
      tradeApiAddr: _tradeApiAddrTextController.text,
    );
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        showMyCustomText("新增外盘期货API成功");
        neverBus.emit("WPFuturesAccountInfoUpdate");
        Navigator.pop(context);
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[新增外盘期货API]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[新增外盘期货API]遇到问题，请检查网络或重新刷新');
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
                          child: const Text('新增外盘期货API',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          child: const Icon(Icons.close,color: Colors.black,),
                          alignment: Alignment.center,
                          padding:const  EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                  Row(
                    children: [
                      Container(
                        child: const Text('经纪商编码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//经纪商编码
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      //边框圆角设置
                      border: Border.all(width: 1, color: APP_MainGreenColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    height: 40,
                    child: DropdownButton(
                      items: _brokerInfoItems,
                      onChanged: (value) {
                        setState(() {
                          _brokerInfoNo = value.toString();
                        });
                      },
                      hint: const Text('请选择经纪商',style: TextStyle(color: Colors.grey,fontSize: 13),),
                      value: _brokerInfoNo == '' ? null : _brokerInfoNo,
                      elevation: 8, //设置阴影的高度
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      icon: const Icon(Icons.arrow_drop_down,color: Colors.black,),
                      underline: Container(height: 0),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        child: const Text('资金账号',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//资金账户
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
                                  hintText: '请输入资金账户',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _accountNoTextController,
                                autocorrect:false,
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.black,fontSize: 13),
                                onChanged: (value){
                                  setState((){
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
                  Row(
                    children: [
                      Container(
                        child: const Text('资金账号密码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//资金账户密码
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
                                  hintText: '请输入资金账号密码',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _accountPasswordTextController,
                                autocorrect:false,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.black,fontSize: 13),
                                onChanged: (value){
                                  setState((){
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
                  Row(
                    children: [
                      Container(
                        child: const Text('资金账号授权码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//资金账户
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
                                  hintText: '请输入资金账号授权码',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _accountAuthCodeTextController,
                                autocorrect:false,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.black,fontSize: 13),
                                onChanged: (value){
                                  setState((){
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
                  Row(
                    children: [
                      Container(
                        child: const Text('行情前置机地址',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//行情前置机地址
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
                                  hintText: '请输入行情前置机地址',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _quoteApiAddrTextController,
                                autocorrect:false,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.black,fontSize: 13),
                                onChanged: (value){
                                  setState((){
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
                  Row(
                    children: [
                      Container(
                        child: const Text('交易前置机地址',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding:const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//交易前置机地址
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
                                  hintText: '请输入交易前置机地址',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _tradeApiAddrTextController,
                                autocorrect:false,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.black,fontSize: 13),
                                onChanged: (value){
                                  setState((){
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
                  Row(
                    children: [
                      Container(
                        child: const Text('行情资金账号',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.transparent),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//资金账户
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
                                  hintText: '请输入行情资金账号',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _quoteAccountNoTextController,
                                autocorrect:false,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.black,fontSize: 13),
                                onChanged: (value){
                                  setState((){
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
                  Row(
                    children: [
                      Container(
                        child: const Text('行情资金账号密码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.transparent),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//资金账户
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
                                  hintText: '请输入行情资金账号密码',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _quoteAccountPasswordTextController,
                                autocorrect:false,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.black,fontSize: 13),
                                onChanged: (value){
                                  setState((){
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
                  Row(
                    children: [
                      Container(
                        child: const Text('行情资金账号授权码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding:const  EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.transparent),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//资金账户
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
                                  hintText: '请输入行情资金账号授权码',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _quoteAccountAuthCodeTextController,
                                autocorrect:false,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.black,fontSize: 13),
                                onChanged: (value){
                                  setState((){
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
                            if(_brokerInfoNo == ''){
                              showMyCustomText("请选择经纪商");
                              return;
                            }
                            if(_accountNoTextController.text == ''){
                              showMyCustomText("请输入资金账户");
                              return;
                            }
                            if(_accountPasswordTextController.text == ''){
                              showMyCustomText("请输入资金账户密码");
                              return;
                            }
                            if(_accountAuthCodeTextController.text == ''){
                              showMyCustomText("请输入资金账户授权码");
                              return;
                            }
                            if(_quoteApiAddrTextController.text == ''){
                              showMyCustomText("请输入行情前置机地址");
                              return;
                            }
                            if(_tradeApiAddrTextController.text == ''){
                              showMyCustomText("请输入交易前置机地址");
                              return;
                            }
                            _WPFuturesWpfuturesAccountInfoSaveHttp();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
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



