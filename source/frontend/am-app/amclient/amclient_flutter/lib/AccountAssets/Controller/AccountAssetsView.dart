import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/DigitalCurrency/Http/DigitalCurrencyHttpRequest.dart';
import 'package:amclient_flutter/DigitalCurrency/Model/DigitalCurrencyExchangeApiResponseModel.dart';
import 'package:amclient_flutter/DigitalCurrency/Model/DigitalCurrencyResponseModel.dart';
import 'package:amclient_flutter/NPFutures/Http/NPFuturesHttpRequest.dart';
import 'package:amclient_flutter/NPFutures/Model/NPFuturesIndexResponseModel.dart';
import 'package:amclient_flutter/NPSpot/Http/NPSpotHttpRequest.dart';
import 'package:amclient_flutter/WPFutures/Http/WPFuturesHttpRequest.dart';
import 'package:amclient_flutter/WPFutures/Model/WPFuturesIndexResponseModel.dart';
import 'package:amclient_flutter/WPSpot/Http/WPSpotHttpRequest.dart';
import 'package:amclient_flutter/WPSpot/Model/WPSpotIndexResponseModel.dart';
import 'package:amclient_flutter/main.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neveruseless/never/neverBus.dart';
import 'package:neveruseless/never/neverDoubleTryOrZero.dart';
class AccountAssetsView extends StatefulWidget {
  final arguments;
  const AccountAssetsView({Key? key, this.arguments}) : super(key: key);

  @override
  _AccountAssetsViewState createState() => _AccountAssetsViewState();
}

class _AccountAssetsViewState extends State<AccountAssetsView>  with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  //外盘期货资金账号资金信息
  List<WpFuturesFundDataListData>? _wpFuturesFundDataList = [];

  //外盘现货资金账号资金信息
  List<WpSpotTradingAccountListData>? _wpSpotTradingAccountList = [];

  //内盘期货资金账号资金信息
  List<NpfuturesTradingAccountListData>? _npFuturesTradingAccountList = [];

  //内盘期货资金账号资金信息
  List<NpfuturesTradingAccountListData>? _npSpotTradingAccountList = [];

  //账户 资产
  List<DigitalCurrencyAccountDetailsSocketModel>? _accountDetailsList =[];

  //API列表
  late List<DigitalCurrencyExchangeApiResponseData> _apiList = [];
  String _indexApi = '';


  @override
  void initState() {
    super.initState();
    _reloadEveryWhere();
    neverBus.on('pageController', (object) {
      if(!mounted){
        return;
      }
      setState(() {
        if(object == '/AccountAssetsView') {
          print("打开账户资产页面");
          _reloadEveryWhere();
        }else{

        }
      });
    });
    neverBus.on('LoginSuccess', (object){
      if(!mounted){
        return;
      }
      _reloadEveryWhere();
    });
    neverBus.on('AccountAssetsIndexReload', (object){
      if(!mounted){
        return;
      }
      _reloadEveryWhere();
    });
  }

  @override
  void dispose() {
    neverBus.off("pageController");
    neverBus.off("LoginSuccess");
    neverBus.off("AccountAssetsIndexReload");
    super.dispose();
  }

  //查询外盘期货资金账号资金信息
  Future _WPFuturesWpfuturesFundDataDataHttp() async{
    var response = await WPFuturesWpfuturesFundDataData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _wpFuturesFundDataList = WpFuturesFundDataResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询外盘期货资金信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询外盘期货资金信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询外盘现货资金账户息表
  Future _WpSpotTradingAccountDataHttp() async{
    var response = await WpSpotTradingAccountData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _wpSpotTradingAccountList = WpSpotTradingAccountResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询内盘现货资金信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询内盘现货资金信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询内盘期货资金账户息表
  Future _NpfuturesNpfuturesTradingAccountDataHttp() async{
    var response = await NpfuturesNpfuturesTradingAccountData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _npFuturesTradingAccountList = NpfuturesTradingAccountResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询内盘期货资金信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询内盘期货资金信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询内盘现货资金账户息表
  Future _NpSpotTradingAccountDataHttp() async{
    var response = await NpSpotTradingAccountData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _npSpotTradingAccountList = NpfuturesTradingAccountResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询内盘现货资金信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询内盘现货资金信息]遇到问题，请检查网络或重新刷新');
      }
    }
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
          try{
            if(_apiList.isNotEmpty){
              _indexApi = _apiList.first.apiKey!;
              _DigitalcurrencyOkexTradeFundGetBalanceHttp();
            }else{
              showMyCustomText("请先绑定数字货币API");
            }
          }catch(e){
            _indexApi = '';
            showMyCustomText("用户APIKey获取失败，请检查网络或重新刷新");
          }
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('用户APIKey获取失败，请检查网络或重新刷新');
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('用户APIKey获取失败，请检查网络或重新刷新');
      }
    }
  }

  //查询数字货币资产
  Future _DigitalcurrencyOkexTradeFundGetBalanceHttp() async{
    var response = await DigitalcurrencyOkexTradeFundGetBalance(apiKey: _indexApi);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == "200"){
        setState(() {
          _accountDetailsList =  DigitalCurrencyAccountSocketModel.fromJson(response['data'][0]).details;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询数字货币资金信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询数字货币资金信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("账户资产"),
        ),
        body:Container(
          color: Colors.black,
          alignment: Alignment.center,
          child:EasyRefresh(
            behavior: MyCustomScrollBehavior(),
            child:ListView(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  decoration:const BoxDecoration(
                    color: APP_MainBGColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: APP_MainBarColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),topRight: Radius.circular(5.0)),
                        ),
                        child: const Text("数字货币资产",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        color: APP_MainBGColor,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: const Text("资产",style: TextStyle(fontSize: 12,color: Colors.grey),),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: const Text("币种权益",style: TextStyle(fontSize: 12,color: Colors.grey),),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: const Text("可用保证金",style: TextStyle(fontSize: 12,color: Colors.grey),),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: const Text("占用",style: TextStyle(fontSize: 12,color: Colors.grey),),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: const Text("未平仓收益",style: TextStyle(fontSize: 12,color: Colors.grey),),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: const Text("负债",style: TextStyle(fontSize: 12,color: Colors.grey),),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                            ),
                          ],
                        ),

                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          return Container(
                            color: APP_MainBGColor,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(_accountDetailsList![index].ccy!,style: const TextStyle(fontSize: 13,color: Colors.white),),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountDetailsList![index].eq!), 5)).toString(),style: const TextStyle(fontSize: 13,color: Colors.white),),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountDetailsList![index].availEq!), 5)).toString(),style: const TextStyle(fontSize: 13,color: Colors.white),),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountDetailsList![index].frozenBal!), 5)).toString(),style: const TextStyle(fontSize: 13,color: Colors.white),),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountDetailsList![index].upl!), 5)).toString(),style: const TextStyle(fontSize: 13,color: Colors.white),),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountDetailsList![index].crossLiab!) + neverDoubleTryOrZero(_accountDetailsList![index].isoLiab!), 5)).toString(),style: const TextStyle(fontSize: 13,color: Colors.white),),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          );
                        },
                        itemCount: _accountDetailsList!.length,
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
                Container(
                  margin:const  EdgeInsets.fromLTRB(5, 5, 5, 0),
                  decoration: const BoxDecoration(
                    color: APP_MainBGColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration:const  BoxDecoration(
                          color: APP_MainBarColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),topRight: Radius.circular(5.0)),
                        ),
                        child:const Text("外盘期货资产",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
                        alignment: Alignment.centerLeft,
                        padding:const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,index){

                          String _profitRate = '0.0'; //盈利率
                          if(neverDoubleTryOrZero(_wpFuturesFundDataList![index].preBalance!) == 0.0){
                            _profitRate = '0.0%';
                          }else{
                            _profitRate = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(_wpFuturesFundDataList![index].balance!) - neverDoubleTryOrZero(_wpFuturesFundDataList![index].preBalance!)) / neverDoubleTryOrZero(_wpFuturesFundDataList![index].preBalance!) * 100, 2)).toString() + "%";
                          }

                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: const BoxDecoration(
                              color:  APP_MainBarColor,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5, //阴影范围
                                    spreadRadius: 0.1, //阴影浓度
                                    color: Colors.black, //阴影颜色
                                    offset:Offset(3,3)
                                ),
                              ],
                            ),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("资金账号:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpFuturesFundDataList![index].accountNo!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("币种:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpFuturesFundDataList![index].currencyNo!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: const Text("风险率:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Container(
                                                child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_wpFuturesFundDataList![index].accountMaintenanceMargin!) / (neverDoubleTryOrZero(_wpFuturesFundDataList![index].accountMaintenanceMargin!) + neverDoubleTryOrZero(_wpFuturesFundDataList![index].available!)) *100  ,2)).toString() + "%",style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("资金调整:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpFuturesFundDataList![index].cashAdjustValue!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("出金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpFuturesFundDataList![index].cashOutValue!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("入金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpFuturesFundDataList![index].cashInValue!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),

                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("今权益:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpFuturesFundDataList![index].equity!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("今可用:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpFuturesFundDataList![index].available!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("今可提:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpFuturesFundDataList![index].canDraw!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: const Text("今资金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Container(
                                                child: Text(_wpFuturesFundDataList![index].balance!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: const Text("保证金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Container(
                                                child: Text(_wpFuturesFundDataList![index].accountIntialMargin!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: const Text("维持保证金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Container(
                                                child: Text(_wpFuturesFundDataList![index].accountMaintenanceMargin!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: const Text("逐笔浮盈:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Container(
                                                child: Text(_wpFuturesFundDataList![index].positionProfit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("逐笔平盈:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpFuturesFundDataList![index].closeProfit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: const Text("净盈亏:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Container(
                                                child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_wpFuturesFundDataList![index].balance!) - neverDoubleTryOrZero(_wpFuturesFundDataList![index].preBalance!), 2)).toString(),style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: const Text("权利金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Container(
                                                child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_wpFuturesFundDataList![index].premiumIncome!) - neverDoubleTryOrZero(_wpFuturesFundDataList![index].premiumPay!), 2)).toString() ,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: const Text("盈利率:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Container(
                                                child: Text(_profitRate,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: const Text("",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                            ),

                          );
                        },

                        itemCount: _wpFuturesFundDataList!.length,

                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
                Container(
                  margin:const  EdgeInsets.fromLTRB(5, 5, 5, 0),
                  decoration: const BoxDecoration(
                    color: APP_MainBGColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration:const  BoxDecoration(
                          color: APP_MainBarColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),topRight: Radius.circular(5.0)),
                        ),
                        child: const Text("外盘现货资产",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: const BoxDecoration(
                              color:  APP_MainBarColor,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5, //阴影范围
                                    spreadRadius: 0.1, //阴影浓度
                                    color: Colors.black, //阴影颜色
                                    offset:Offset(3,3)
                                ),
                              ],
                            ),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("资金账号:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpSpotTradingAccountList![index].investorID!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded( // 1
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("币种:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpSpotTradingAccountList![index].currencyID!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded( // 1
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("可用资金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpSpotTradingAccountList![index].available!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row( //1
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("今日出金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpSpotTradingAccountList![index].withdraw!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded( // 1
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("今日入金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpSpotTradingAccountList![index].deposit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row( // 1
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("手续费:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpSpotTradingAccountList![index].commission!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),

                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("冻结金额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpSpotTradingAccountList![index].frozenCash!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("冻结手续费:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpSpotTradingAccountList![index].frozenCommission!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded( // 1
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("可取资金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_wpSpotTradingAccountList![index].withdrawQuota!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),




                                ],
                              ),
                              alignment: Alignment.center,
                            ),
                          );
                        },
                        itemCount: _wpSpotTradingAccountList!.length,
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
                Container(
                  margin:const  EdgeInsets.fromLTRB(5, 5, 5, 0),
                  decoration: const BoxDecoration(
                    color: APP_MainBGColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration:const  BoxDecoration(
                          color: APP_MainBarColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),topRight: Radius.circular(5.0)),
                        ),
                        child: const Text("内盘期货资产",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: const BoxDecoration(
                              color:  APP_MainBarColor,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5, //阴影范围
                                    spreadRadius: 0.1, //阴影浓度
                                    color: Colors.black, //阴影颜色
                                    offset:Offset(3,3)
                                ),
                              ],
                            ),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("资金账号:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].investorID!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("币种:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].currencyID!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: const Text("",style: TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("上次结算准备金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].preBalance!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("上次信用额度:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].preCredit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("上次质押金额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].preMortgage!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("质押金额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].mortgage!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("今日出金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].withdraw!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("今日入金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].deposit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("静态权益:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].preBalance!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("平仓盈亏:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].closeProfit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("持仓盈亏:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].positionProfit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("权利金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].mortgage!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("手续费:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].commission!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("上次货币质入金额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].preFundMortgageIn!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("上次货币质出金额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].preFundMortgageOut!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("货币质入金额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].fundMortgageIn!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("货币质出金额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].fundMortgageOut!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("动态权益:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].balance!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("占用保证金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].currMargin!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("冻结保证金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].frozenMargin!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("冻结手续费:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].frozenCommission!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("交割保证金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].deliveryMargin!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("信用金额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].credit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("货币质押余额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].fundMortgageAvailable!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("可用资金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].available!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("保底资金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].preBalance!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("可取资金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].withdrawQuota!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("可质押货币金额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].mortgageableFund!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("特殊产品占用保证金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].specProductMargin!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("特殊产品冻结保证金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].specProductFrozenMargin!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("特殊产品手续费:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].specProductCommission!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("特殊产品冻结手续费:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].specProductFrozenCommission!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("特殊产品持仓盈亏:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].specProductPositionProfit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("特殊产品平仓盈亏:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npFuturesTradingAccountList![index].specProductCloseProfit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: const Text("",style: TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                            ),
                          );
                        },
                        itemCount: _npFuturesTradingAccountList!.length,
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
                Container(
                  margin:const  EdgeInsets.fromLTRB(5, 5, 5, 0),
                  decoration: const BoxDecoration(
                    color: APP_MainBGColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration:const  BoxDecoration(
                          color: APP_MainBarColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),topRight: Radius.circular(5.0)),
                        ),
                        child: const Text("内盘现货资产",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: const BoxDecoration(
                              color:  APP_MainBarColor,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5, //阴影范围
                                    spreadRadius: 0.1, //阴影浓度
                                    color: Colors.black, //阴影颜色
                                    offset:Offset(3,3)
                                ),
                              ],
                            ),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("资金账号:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npSpotTradingAccountList![index].investorID!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded( // 1
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("币种:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npSpotTradingAccountList![index].currencyID!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded( // 1
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("可用资金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npSpotTradingAccountList![index].available!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row( //1
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("今日出金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npSpotTradingAccountList![index].withdraw!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded( // 1
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("今日入金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npSpotTradingAccountList![index].deposit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row( // 1
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: const Text("手续费:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npSpotTradingAccountList![index].commission!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),

                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("冻结金额:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npSpotTradingAccountList![index].frozenCash!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("冻结手续费:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npSpotTradingAccountList![index].frozenCommission!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded( // 1
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: const Text("可取资金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                                Container(
                                                  child: Text(_npSpotTradingAccountList![index].withdrawQuota!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  ),




                                ],
                              ),
                              alignment: Alignment.center,
                            ),
                          );
                        },
                        itemCount: _npSpotTradingAccountList!.length,
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ],
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
                  _reloadEveryWhere();
                }
              });
            },
            onLoad: null,
          ),
        ),
      ),
    );
  }

  void _reloadEveryWhere(){
    _WPFuturesWpfuturesFundDataDataHttp();
    _WpSpotTradingAccountDataHttp();
    _NpfuturesNpfuturesTradingAccountDataHttp();
    _NpSpotTradingAccountDataHttp();
    _DigitalcurrencyExchangeapiListHttp();
  }
}
