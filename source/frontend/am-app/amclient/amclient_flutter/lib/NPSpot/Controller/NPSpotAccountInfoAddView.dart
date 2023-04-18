import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/NPFutures/Model/NPFuturesAccountInfoResponseModel.dart';
import 'package:amclient_flutter/NPSpot/Http/NPSpotHttpRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neveruseless/neveruseless.dart';
class NPSpotAccountInfoAddView extends StatefulWidget {
  final arguments;
  const NPSpotAccountInfoAddView({Key? key, this.arguments}) : super(key: key);

  @override
  _NPSpotAccountInfoAddViewState createState() => _NPSpotAccountInfoAddViewState();
}

class _NPSpotAccountInfoAddViewState extends State<NPSpotAccountInfoAddView> {

  late List<NPFuturesBrokerInfoResponseData> _brokerInfoList = [];
  List<DropdownMenuItem<String>> _brokerInfoItems = [];
  var _brokerInfoNo = '';

  //APP代码
  final TextEditingController _appIDTextController = TextEditingController();
  //投资者账户
  final TextEditingController _investorIDTextController = TextEditingController();
  //投资者密码
  final TextEditingController _investorPwdTextController = TextEditingController();
  //认证码
  final TextEditingController _authCodeTextController = TextEditingController();
  //行情前置机地址
  final TextEditingController _mdFrontAddrTextController = TextEditingController();
  //交易前置机地址
  final TextEditingController _tradeFrontAddrTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _NpspotBrokerDataHttp();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //内盘现货 新增API 经销商编码
  Future _NpspotBrokerDataHttp() async{
    var response = await NpspotBrokerData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _brokerInfoList = NPFuturesBrokerInfoResponseModel.fromJson(response).object!;
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
              value: _brokerInfoList[i].brokerID!,
            ),
            );
          }
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[查询内盘现货经纪公司]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询内盘现货经纪公司]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //内盘现货 新增API 新增
  Future _NpSpotAccountInfoSaveHttp() async{//{String accountAuthCode = '',String accountNo = '',String accountPassword = '',String brokerNo = '',}
    var response = await NpSpotAccountInfoSave(
      appID: _appIDTextController.text,
      authCode: _authCodeTextController.text,
      brokerID: _brokerInfoNo,
      investorID:_investorIDTextController.text,
      investorPassword:_investorPwdTextController.text,
      mdFrontAddr:_mdFrontAddrTextController.text,
      tradeFrontAddr:_tradeFrontAddrTextController.text,
    );
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        showMyCustomText("新增内盘现货API成功");
        neverBus.emit("NPFuturesAccountInfoUpdate");
        Navigator.pop(context);
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[新增内盘现货API]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[新增内盘现货API]遇到问题，请检查网络或重新刷新');
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
                          child: const Text('新增内盘现货API',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
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
                  Row(
                    children: [
                      Container(
                        child: const Text('经纪公司代码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//经销商编码
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
                      hint: const Text('请选择经纪公司',style: TextStyle(color: Colors.grey,fontSize: 13),),
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
                        child: const Text('投资者账号',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//投资者账号
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
                                  hintText: '请输入投资者账号',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _investorIDTextController,
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
                        child: const Text('投资者密码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//投资者密码
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
                                  hintText: '请输入投资者密码',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _investorPwdTextController,
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
                        child: const Text('认证码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//认证码
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
                                  hintText: '请输入认证码',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _authCodeTextController,
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
                        child: const Text('APP代码',style: TextStyle(fontSize: 13,color: Colors.black),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Container(
                        child: const Text('*',style: TextStyle(fontSize: 13,color: Colors.red),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      ),
                    ],
                  ),//APP代码
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
                                  hintText: '请输入APP代码',
                                  hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                                ),
                                controller: _appIDTextController,
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
                                controller: _mdFrontAddrTextController,
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
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
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
                                controller: _tradeFrontAddrTextController,
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Container(
                            decoration:const BoxDecoration(
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
                              showMyCustomText("请选择经纪公司");
                              return;
                            }
                            if(_appIDTextController.text == ''){
                              showMyCustomText("请输入APP代码");
                              return;
                            }
                            if(_investorIDTextController.text == ''){
                              showMyCustomText("请输入投资者账号");
                              return;
                            }
                            if(_investorPwdTextController.text == ''){
                              showMyCustomText("请输入投资者密码");
                              return;
                            }
                            if(_authCodeTextController.text == ''){
                              showMyCustomText("请输入认证码");
                              return;
                            }
                            if(_mdFrontAddrTextController.text == ''){
                              showMyCustomText("请输入行情前置机地址");
                              return;
                            }
                            if(_tradeFrontAddrTextController.text == ''){
                              showMyCustomText("请输入交易前置机地址");
                              return;
                            }
                            _NpSpotAccountInfoSaveHttp();
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



