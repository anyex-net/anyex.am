
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/DigitalCurrency/Controller/DigitalCurrencyExchangeApiAddView.dart';
import 'package:amclient_flutter/DigitalCurrency/Controller/DigitalCurrencyExchangeApiEncryptionView.dart';
import 'package:amclient_flutter/DigitalCurrency/Http/DigitalCurrencyHttpRequest.dart';
import 'package:amclient_flutter/DigitalCurrency/Model/DigitalCurrencyExchangeApiResponseModel.dart';
import 'package:amclient_flutter/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neveruseless/neveruseless.dart';
class DigitalCurrencyExchangeApiView extends StatefulWidget {
  final arguments;
  const DigitalCurrencyExchangeApiView({Key? key, this.arguments}) : super(key: key);

  @override
  _DigitalCurrencyExchangeApiViewState createState() => _DigitalCurrencyExchangeApiViewState();
}

class _DigitalCurrencyExchangeApiViewState extends State<DigitalCurrencyExchangeApiView> {

  String _selectIndexType = "0";//0 API新增 1 API加密因子

  late List<DigitalCurrencyExchangeApiResponseData> _apiList = [];

  final ScrollController _controller1 = ScrollController();

  @override
  void initState() {
    super.initState();
    _DigitalcurrencyExchangeapiListHttp();
    neverBus.on('DigitalCurrencyExchangeApiUpdate', (object) {
      if(mounted){
        _DigitalcurrencyExchangeapiListHttp();
      }
    });
  }

  @override
  void dispose() {
    neverBus.off('DigitalCurrencyExchangeApiUpdate');
    super.dispose();
  }

  //获取用户API配置列表
  Future _DigitalcurrencyExchangeapiListHttp() async{
    var response = await DigitalcurrencyExchangeapiList();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _apiList = DigitalCurrencyExchangeApiResponseModel.fromJson(response).object!;
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('遇到问题，请检查网络或重新刷新');
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('遇到问题，请检查网络或重新刷新');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _desktopView();
  }

  Widget _desktopView(){
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        backgroundColor: APP_MainBGColor,
        body:Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Container(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: APP_MainGreenColor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10, //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.black, //阴影颜色
                                offset:Offset(1,3)
                            ),
                          ],
                        ),
                        child: Text('新增数字货币API',style: TextStyle(color: Colors.white,fontSize: 12),softWrap: true,overflow: TextOverflow.ellipsis,maxLines: 1,),
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        width: 130,
                        alignment: Alignment.center,
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                    ),
                    onTap: (){
                      AwesomeDialog(
                        context: context,
                        headerAnimationLoop: false,
                        dismissOnBackKeyPress:false,
                        width:MediaQuery.of(context).size.width / 1.5,
                        dialogType: DialogType.NO_HEADER,
                        animType: AnimType.BOTTOMSLIDE,
                        body: const DigitalCurrencyExchangeApiAddView(),
                      ).show();
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: APP_MainGreenColor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10, //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.black, //阴影颜色
                                offset:Offset(1,3)
                            ),
                          ],
                        ),
                        child: const Text('设置API加密因子',style: TextStyle(color: Colors.white,fontSize: 12),softWrap: true,overflow: TextOverflow.ellipsis,maxLines: 1,),
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        width: 130,
                        alignment: Alignment.center,
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                    ),
                    onTap: (){
                      AwesomeDialog(
                        context: context,
                        headerAnimationLoop: false,
                        dismissOnBackKeyPress:false,
                        width:MediaQuery.of(context).size.width / 1.5,
                        dialogType: DialogType.NO_HEADER,
                        animType: AnimType.BOTTOMSLIDE,
                        body: const DigitalCurrencyExchangeApiEncryptionView(),
                      ).show();
                    },
                  ),
                ],
              ),
              Expanded(
                child: EasyRefresh(
                  behavior: MyCustomScrollBehavior(),
                  child:ListView.builder(
                    controller: _controller1,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      String _iconUrl = 'image/Overall_APIHuobiIcon.png';
                      if(_apiList[index].exchangeAccount!.contains('OK')){
                        _iconUrl = 'image/Overall_APIOKexIcon.png';
                      }else if(_apiList[index].exchangeAccount!.contains('HB')){
                        _iconUrl = 'image/Overall_APIHuobiIcon.png';
                      }else if(_apiList[index].exchangeAccount!.contains('BN')){
                        _iconUrl = 'image/Overall_APIBian.png';
                      }else{
                        _iconUrl = 'image/Overall_APIHuobiIcon.png';
                      }
                      return Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: APP_MainBarColor,
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            image: DecorationImage(
                              image: AssetImage(_iconUrl),
                              fit: BoxFit.contain,
                              alignment: Alignment.centerRight,
                              colorFilter: ColorFilter.mode(APP_MainBarColor.withOpacity(0.2), BlendMode.dstATop),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 10, //阴影范围
                                  spreadRadius: 0.1, //阴影浓度
                                  color: Colors.black, //阴影颜色
                                  offset:Offset(5,5)
                              ),
                            ],
                          ),
                          padding:const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(129, 145 , 155, 1),
                                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                          ),
                                          child: Image(image: AssetImage(_iconUrl), fit: BoxFit.fitHeight, color: Colors.white,),
                                          width: 40,
                                          height: 40,
                                          padding: const EdgeInsets.all(5),
                                        ),
                                        const SizedBox(width: 5,),
                                        Text(_apiList[index].exchange!,style: const TextStyle(fontSize: 14,color: Colors.white),),
                                        const SizedBox(width: 5,),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(181, 149, 100, 1),
                                            borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                          ),
                                          child: Text(_apiList[index].authorigty!,style: const TextStyle(fontSize: 10),),
                                          padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                                          alignment: Alignment.center,
                                        ),
                                        const SizedBox(width: 5,),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: _apiList[index].wsClientStatus == "1" ? const Color.fromRGBO(15, 159, 131, 1) : const Color.fromRGBO(181, 149, 101, 1) ,
                                            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                          ),
                                          child: Text(_apiList[index].wsClientStatus == "1" ? '已连接' : '连接中',style: const TextStyle(fontSize: 10),),
                                          padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                                          alignment: Alignment.center,
                                        ),
                                      ],
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child:Column(
                                      children: [
                                        const SizedBox(height: 10,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: const Text("账户号:",style: TextStyle(fontSize: 11,color: Colors.white),),
                                              alignment: Alignment.center,
                                            ),
                                            Container(
                                              child:Text(_apiList[index].exchangeAccount!,style: const TextStyle(fontSize: 13,color: Colors.white),),
                                              alignment: Alignment.center,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height:10,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    child: const Text("备注名:",style: TextStyle(fontSize: 10,color: Colors.white),),
                                                    alignment: Alignment.center,
                                                  ),
                                                  Container(
                                                    child:Text(_apiList[index].remark! == "" ? '无' : _apiList[index].remark!,style:const TextStyle(fontSize: 10,color: Colors.white),),
                                                    alignment: Alignment.center,
                                                  ),
                                                  const Image(image: AssetImage('image/Setting_api_repair.png'),width: 15,),
                                                ],
                                              ),
                                              onTap: (){
                                                TextEditingController _remarkController = TextEditingController();
                                                _remarkController.text = _apiList[index].remark!;
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false, // user must tap button!
                                                  builder: (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Text('修改'+ _apiList[index].exchangeAccount!+'备注名',style: const TextStyle(fontSize: 17),),
                                                      content:Container(
                                                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                                        child:Column(
                                                          children: [
                                                            const Text("备注名字符长度限制为5",),
                                                            const SizedBox(height: 10,),
                                                            Container(
                                                              height: 36,
                                                              child: CupertinoTextField(
                                                                controller: _remarkController,
                                                                textAlignVertical:TextAlignVertical.center,
                                                                decoration: const BoxDecoration( // 文本框装饰
                                                                  color: Colors.white, // 文本框颜色
                                                                  borderRadius: BorderRadius.all(Radius.circular(6)), // 输入框圆角设置
                                                                ),
                                                                keyboardType: TextInputType.text,
                                                                style: const TextStyle(color: Colors.black,fontSize: 15),
                                                                placeholder: '请输入备注名',
                                                                placeholderStyle: TextStyle(fontSize: 13,color: Colors.grey[500]),
                                                                inputFormatters: [
                                                                  LengthLimitingTextInputFormatter(5)
                                                                ],
                                                                autocorrect: false,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions:<Widget>[
                                                        CupertinoDialogAction(
                                                          child: const Text('取消',style: TextStyle(color: Color.fromRGBO(215, 85, 82,  1)),),
                                                          onPressed: (){
                                                            _remarkController.text = "";
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                        CupertinoDialogAction(
                                                          child: const Text('确定'),
                                                          onPressed: () async{
                                                            Navigator.of(context).pop();
                                                            var response = await DigitalcurrencyExchangeapiSaveRemark(id:_apiList[index].id!,remark: _remarkController.text,relatedExchangeAccount: _apiList[index].relatedExchangeAccount!);
                                                            if(!mounted){
                                                              return;
                                                            }
                                                            if (response is Map) {
                                                              if (response["code"] == 200) {
                                                                showMyCustomText('备注名修改成功');
                                                                Future.delayed(const Duration(seconds: 1)).then((onValue) async{
                                                                  neverBus.emit('DigitalCurrencyExchangeApiUpdate');
                                                                });
                                                              } else {
                                                                showMyCustomText(response["message"]);
                                                              }
                                                            } else {
                                                              showMyCustomText(response.error.toString());
                                                            }
                                                            _remarkController.text = "";
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            Offstage(
                                              child: const SizedBox(width: 10,),
                                              offstage: _apiList[index].purpose == 'readonly',
                                            ),
                                            Offstage(
                                              child: GestureDetector(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      child: const Text("关联统计账户:",style: TextStyle(fontSize: 10,color: Colors.white),),
                                                      alignment: Alignment.center,
                                                    ),
                                                    Container(
                                                      child:Text(_apiList[index].relatedExchangeAccount == '' ? '无' : _apiList[index].relatedExchangeAccount!,style: const TextStyle(fontSize: 10,color: Colors.white),),
                                                      alignment: Alignment.center,
                                                    ),
                                                    const Image(image: AssetImage('image/Setting_api_repair.png'),width: 15,),
                                                  ],
                                                ),
                                                onTap: (){
                                                  var _relatedExchangeAccount = _apiList[index].relatedExchangeAccount;
                                                  List<DropdownMenuItem<String>> _relatedExchangeAccountListItems = [];//交易账户下拉处理
                                                  String _ex = _apiList[index].exchangeAccount!.substring(0,2);
                                                  List _readOnlyNamelist = [];
                                                  for(int it = 0;it<_apiList.length;it++){
                                                    if(_apiList[it].purpose == 'readonly'){
                                                      _readOnlyNamelist.add(_apiList[it].exchangeAccount!);
                                                    }
                                                  }
                                                  for(int i =0;i<_readOnlyNamelist.length;i++){
                                                    if(_readOnlyNamelist[i].contains(_ex)){
                                                      _relatedExchangeAccountListItems.add(DropdownMenuItem(
                                                        child: Text(_readOnlyNamelist[i], style: const TextStyle(color: Colors.black,fontSize: 13),
                                                        ),
                                                        value: _readOnlyNamelist[i],
                                                      ));
                                                    }
                                                  }
                                                  AwesomeDialog(
                                                      context: context,
                                                      headerAnimationLoop: false,
                                                      dialogType: DialogType.NO_HEADER,
                                                      animType: AnimType.BOTTOMSLIDE,
                                                      width: MediaQuery.of(context).size.width/2,
                                                      body:StatefulBuilder(builder: (context, mSetState){
                                                        return Column(
                                                          children: [
                                                            Container(
                                                              child: const Text('关联交易所统计账户',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                                                              alignment: Alignment.centerLeft,
                                                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.fromLTRB(20, 0,20, 0),
                                                              child: Container(
                                                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                                alignment: Alignment.centerRight,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  //边框圆角设置
                                                                  borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                                  border: Border.all(color: const Color.fromRGBO(15, 159, 131, 1)),
                                                                ),
                                                                child: DropdownButton(
                                                                  items: _relatedExchangeAccountListItems,
                                                                  onChanged: (value) {
                                                                    mSetState(() {
                                                                      _relatedExchangeAccount = value.toString();
                                                                    });
                                                                  },
                                                                  hint:Text(_relatedExchangeAccountListItems.isEmpty ?'请先绑定相应交易所统计账户' : '请选择交易所统计账户',style: const TextStyle(color: Colors.grey,fontSize: 13),),
                                                                  value:  _relatedExchangeAccount == '' ? null :  _relatedExchangeAccount,
                                                                  elevation: 8, //设置阴影的高度
                                                                  isExpanded: true,
                                                                  dropdownColor: Colors.white,
                                                                  icon: const Icon(Icons.arrow_drop_down,color: Colors.black,),
                                                                  underline: Container(height: 0),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 20,),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                GestureDetector(
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
                                                                      color: Colors.grey,
                                                                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                                                    ),
                                                                    child: const Text('取消',style: TextStyle(color: Colors.white),),
                                                                    alignment: Alignment.center,
                                                                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                  ),
                                                                  onTap: (){
                                                                    Navigator.pop(context);
                                                                  },
                                                                ),
                                                                const SizedBox(width: 10,),
                                                                GestureDetector(
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
                                                                      color: Color.fromRGBO(15, 159, 131, 1),
                                                                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                                                    ),
                                                                    child: const Text('确认',style: TextStyle(color: Colors.white),),
                                                                    alignment: Alignment.center,
                                                                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                  ),
                                                                  onTap: () async{
                                                                    if(_relatedExchangeAccount == null || _relatedExchangeAccount == ''){
                                                                      showMyCustomText('请选择关联统计账户');
                                                                      return;
                                                                    }
                                                                    Navigator.pop(context);
                                                                    var response = await DigitalcurrencyExchangeapiSaveRemark(id:_apiList[index].id!,remark:_apiList[index].remark!,relatedExchangeAccount: _relatedExchangeAccount!);
                                                                    if(!mounted){
                                                                      return;
                                                                    }
                                                                    if (response is Map) {
                                                                      if (response["code"] == 200) {
                                                                        showMyCustomText('关联账户设置成功');
                                                                        Future.delayed(const Duration(seconds: 1)).then((onValue) async{
                                                                          neverBus.emit('DigitalCurrencyExchangeApiUpdate');
                                                                        });
                                                                      } else {
                                                                        showMyCustomText(response["message"]);
                                                                      }
                                                                    } else {
                                                                      showMyCustomText(response.error.toString());
                                                                    }
                                                                  },
                                                                ),
                                                                const SizedBox(width: 20,),
                                                              ],
                                                            )
                                                          ],
                                                        );
                                                      })
                                                  ).show();
                                                },
                                              ),
                                              offstage: _apiList[index].purpose == 'readonly',
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  Expanded(
                                    child:  Container(
                                      child: Text(_apiList[index].apiKey!,style: const TextStyle(fontSize: 13,color: Colors.white),),
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    ),
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false, // user must tap button!
                                        builder: (BuildContext context) {

                                          return CupertinoAlertDialog(
                                            title: Text('删除'+ _apiList[index].exchangeAccount! +'API',style: const TextStyle(fontSize: 17),),
                                            content:Container(
                                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                              child:Column(
                                                children: const [
                                                  Text("请确认是否删除此API?",),
                                                ],
                                              ),
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
                                                  var response = await DigitalcurrencyExchangeapiDel(id:_apiList[index].id!);
                                                  if(!mounted){
                                                    return;
                                                  }
                                                  if (response is Map) {
                                                    if (response["code"] == 200) {
                                                      showMyCustomText('API删除成功');
                                                      Future.delayed(const Duration(seconds: 1)).then((onValue) async{
                                                        neverBus.emit('DigitalCurrencyExchangeApiUpdate');
                                                      });
                                                    } else {
                                                      showMyCustomText(response["message"]);
                                                    }
                                                  } else {
                                                    showMyCustomText(response.error.toString());
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      child: const Text('删除',style: TextStyle(fontSize: 11,fontWeight: FontWeight.w400),),
                                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      color: const Color.fromRGBO(215, 85, 82,  1),
                                      alignment: Alignment.center,
                                    ),

                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: _apiList.length,

                  ),
                  header: ClassicalHeader(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    refreshText: '下拉刷新',
                    refreshReadyText: '松开立即刷新',
                    refreshingText: '正在刷新数据..',
                    refreshedText: "刷新完成",
                    refreshFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  ),
                  footer: null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _DigitalcurrencyExchangeapiListHttp();
                      }
                    });
                  },
                  onLoad: null,
                ),
              ),
            ],
          ),
        ),
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
          title: const Text("个人信息"),
        ),
        body:Container(
        ),
      ),
    );
  }

}

