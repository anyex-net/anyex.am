import 'dart:convert';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Market/Http/MarketHttpRequest.dart';
import 'package:amclient_flutter/Market/Model/MarketResponseModel.dart';
import 'package:amclient_flutter/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart';
import 'package:neveruseless/never/neverBus.dart';
import 'package:neveruseless/never/neverDoubleTryOrZero.dart';

class MarketView extends StatefulWidget {
  final arguments;
  const MarketView({Key? key, this.arguments}) : super(key: key);

  @override
  _MarketViewState createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> with AutomaticKeepAliveClientMixin {

  String _selectIndexType = '数字货币';
  final List _selectIndexTypeList = ['数字货币','外盘期货','外盘现货','内盘期货','内盘现货','消息资讯'];


  String _selectDigitalCurrencyIndexType = '币币';
  final List _selectDigitalCurrencyIndexTypeList = ['币币','永续','交割','期权'];

  List<MarketDigitalcurrencyListData>? _indexDigitalList = [];//币币

  List<MarketDigitalcurrencyListData>? _spotList = [];//币币
  List<MarketDigitalcurrencyListData>? _perpetualList = [];//合约
  List<MarketDigitalcurrencyListData>? _futuresList = [];//期货
  List<MarketDigitalcurrencyListData>? _optionsList = [];//期权


  //外盘期货
  List<MarketWpfuturesQuoteWholeListData>? _marketWpfuturesQuoteWholeList = [];

  //外盘现货
  List<MarketNpfuturesDepthMarketListData>? _marketWpSpotDepthMarketList = [];

  //内盘期货
  List<MarketNpfuturesDepthMarketListData>? _marketNpfuturesDepthMarketList = [];

  //内盘现货
  List<MarketNpfuturesDepthMarketListData>? _marketNpSpotDepthMarketList = [];

  //消息资讯
  List<MarketCommonNoticeListData>? _marketCommonNoticeList = [];

  @override
  bool get wantKeepAlive => true;

  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();
  final ScrollController _controller3 = ScrollController();
  final ScrollController _controller4 = ScrollController();
  final ScrollController _controller5 = ScrollController();
  final ScrollController _controller6 = ScrollController();
  final ScrollController _controller7 = ScrollController();
  final ScrollController _controller8 = ScrollController();
  final ScrollController _controller9 = ScrollController();

  @override
  void initState() {
    super.initState();
    _WpfuturesWpfuturesQuoteWholeAllMarketDataHttp();
    neverBus.on('pageController', (object) {
      if(!mounted){
        return;
      }
      setState(() {
        if(object == '/MarketView') {
          print("打开消息资讯界面");
          _reloadEveryWherer();
        }else{

        }
      });
    });
    neverBus.on('LoginSuccess', (object){
      if(!mounted){
        return;
      }
      _reloadEveryWherer();
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  //数字货币全行情
  Future _DigitalcurrencyOkexMarketGetTickersAllHttp() async{
    var response = await DigitalcurrencyOkexMarketGetTickersAll();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        Map _josnData = jsonDecode(response['object']);
        setState(() {
          //币币
          _spotList =  MarketDigitalcurrencyResponseData.fromJson(_josnData).spot;
          //永续
          _perpetualList = MarketDigitalcurrencyResponseData.fromJson(_josnData).swap;
          //交割
          _futuresList = MarketDigitalcurrencyResponseData.fromJson(_josnData).futures;
          //期权
          _optionsList = MarketDigitalcurrencyResponseData.fromJson(_josnData).options;

          if(_selectDigitalCurrencyIndexType == '币币'){
            _indexDigitalList = _spotList;
          }else if (_selectDigitalCurrencyIndexType == '永续'){
            _indexDigitalList = _perpetualList;
          }else if (_selectDigitalCurrencyIndexType == '交割'){
            _indexDigitalList = _futuresList;
          }else if (_selectDigitalCurrencyIndexType == '期权'){
            _indexDigitalList = _optionsList;
          }else{
            _indexDigitalList = _spotList;
          }
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[数字货币全行情]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[数字货币全行情]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货全行情
  Future _WpfuturesWpfuturesQuoteWholeAllMarketDataHttp() async{
    var response = await WpfuturesWpfuturesQuoteWholeAllMarketData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _marketWpfuturesQuoteWholeList = MarketWpfuturesQuoteWholeResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[外盘期货全行情]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[外盘期货全行情]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘现货全行情
  Future _WpSpotDepthMarketDataAllMarketDataHttp() async{
    var response = await WpSpotDepthMarketDataAllMarketData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _marketWpSpotDepthMarketList = MarketNpfuturesDepthMarketResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[内盘现货全行情]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[内盘现货全行情]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //内盘全行情
  Future _NpfuturesNpfuturesDepthMarketDataAllMarketDataHttp() async{
    var response = await NpfuturesNpfuturesDepthMarketDataAllMarketData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _marketNpfuturesDepthMarketList = MarketNpfuturesDepthMarketResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[内盘期货全行情]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[内盘期货全行情]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //内盘全行情
  Future _NpSpotDepthMarketDataAllMarketDataHttp() async{
    var response = await NpSpotDepthMarketDataAllMarketData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _marketNpSpotDepthMarketList = MarketNpfuturesDepthMarketResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[内盘现货全行情]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[内盘现货全行情]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //消息资讯
  Future _CommonNoticeDataHttp() async{
    var response = await CommonNoticeData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _marketCommonNoticeList = MarketCommonNoticeResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[消息资讯]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[消息资讯]遇到问题，请检查网络或重新刷新');
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
          title: const Text('行情资讯', style: TextStyle(fontSize: 17)),
        ),
        body:Container(
          color: const Color.fromRGBO(5, 51, 84, 1),
          child: Column(
            children: [
              Container(
                height: 40,
                color: APP_MainBarColor,
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  controller: _controller1,
                  scrollDirection : Axis.horizontal,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Container(
                        height: 30,
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                color: _selectIndexType == _selectIndexTypeList[index] ? APP_MainGreenColor : Colors.transparent,
                                child: const Text('',style: TextStyle(color: Colors.transparent),),
                                alignment: Alignment.topCenter,
                                height: 4,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(_selectIndexTypeList[index],style: const TextStyle(color: Colors.white),),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  color: _selectIndexType == _selectIndexTypeList[index] ? APP_MainBGColor : Colors.transparent,
                                ),
                              )
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      onTap: (){
                        setState(() {
                          _selectIndexType = _selectIndexTypeList[index];
                          _reloadEveryWherer();
                        });
                      },
                    );
                  },
                  itemCount: _selectIndexTypeList.length,
                ),
              ),
              Offstage(
                offstage: _selectIndexType == '数字货币' ? false : true,
                child: Container(
                  height: 40,
                  color: APP_MainBarColor,
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    controller: _controller2,
                    scrollDirection : Axis.horizontal,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        child: Container(
                          height: 30,
                          child: IntrinsicWidth(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: _selectDigitalCurrencyIndexType == _selectDigitalCurrencyIndexTypeList[index] ? APP_MainGreenColor : Colors.transparent,
                                  child: const Text('',style: TextStyle(color: Colors.transparent),),
                                  alignment: Alignment.topCenter,
                                  height: 4,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_selectDigitalCurrencyIndexTypeList[index],style: const TextStyle(color: Colors.white),),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    color: _selectDigitalCurrencyIndexType == _selectDigitalCurrencyIndexTypeList[index] ? APP_MainBGColor : Colors.transparent,
                                  ),
                                )
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        ),
                        onTap: (){
                          setState(() {
                            _selectDigitalCurrencyIndexType = _selectDigitalCurrencyIndexTypeList[index];
                            if(_selectDigitalCurrencyIndexType == '币币'){
                              _indexDigitalList = _spotList;
                            }else if (_selectDigitalCurrencyIndexType == '永续'){
                              _indexDigitalList = _perpetualList;
                            }else if (_selectDigitalCurrencyIndexType == '交割'){
                              _indexDigitalList = _futuresList;
                            }else if (_selectDigitalCurrencyIndexType == '期权'){
                              _indexDigitalList = _optionsList;
                            }else{
                              _indexDigitalList = _spotList;
                            }


                          });
                        },
                      );
                    },
                    itemCount: _selectDigitalCurrencyIndexTypeList.length,
                  ),
                ),
              ),
              Expanded(
                child:EasyRefresh(
                  behavior: MyCustomScrollBehavior(),
                  child:ListView(
                    controller: _controller3,
                    children: [
                      Offstage(
                        offstage: _selectIndexType == '数字货币' ? false : true,
                        child: _digitalCurrencyView(),
                      ),
                      Offstage(
                        offstage: _selectIndexType == '外盘期货' ? false : true,
                        child: _wpFuturesView(),
                      ),
                      Offstage(
                        offstage: _selectIndexType == '外盘现货' ? false : true,
                        child: _wpSpotView(),
                      ),
                      Offstage(
                        offstage: _selectIndexType == '内盘期货' ? false : true,
                        child: _npFuturesView(),
                      ),
                      Offstage(
                        offstage: _selectIndexType == '内盘现货' ? false : true,
                        child: _npSpotView(),
                      ),
                      Offstage(
                        offstage: _selectIndexType == '消息资讯' ? false : true,
                        child: _commonNoticeView(),
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
                  footer:null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _reloadEveryWherer();
                      }
                    });
                  },
                  onLoad:null,
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  //数字货币全行情
  Widget _digitalCurrencyView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          const Divider(height: 1,color: Colors.grey,),
          IntrinsicHeight(
            child: Row(
              children: [
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("序号",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 1,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("名称",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 4,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最新价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("涨跌额",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("涨跌幅",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("24小时开盘价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("24小时最高价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("24小时最低价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("24小时成交量",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
              ],
            ),
          ),
          const Divider(height: 1,color: Colors.grey,),
          ListView.builder(
            controller: _controller4,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context,index){
              //最新价、涨跌额、涨跌幅
              Color _lastPriceColor = Colors.white;
              double _qCR = ((neverDoubleTryOrZero(_indexDigitalList![index].last!) - neverDoubleTryOrZero(_indexDigitalList![index].open24h!)) / neverDoubleTryOrZero(_indexDigitalList![index].open24h!)) ;
              if(_qCR > 0){
                _lastPriceColor = APP_MainGreenColor;
              }else if(_qCR < 0){
                _lastPriceColor = APP_MainRedColor;
              }else{
                _lastPriceColor = Colors.white;
              }
              return Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((index + 1).toString(),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 1,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_indexDigitalList![index].instId!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 4,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_indexDigitalList![index].last!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((NumUtil.getNumByValueDouble((neverDoubleTryOrZero(_indexDigitalList![index].last!) - neverDoubleTryOrZero(_indexDigitalList![index].open24h!)), 9)).toString(),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((NumUtil.getNumByValueDouble((_qCR * 100), 2)).toString() + "%",style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_indexDigitalList![index].open24h!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_indexDigitalList![index].high24h!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_indexDigitalList![index].low24h!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_transformationNum(neverDoubleTryOrZero(_indexDigitalList![index].volCcy24h!)),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                      ],
                    ),
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                ],
              );
            },
            itemCount: _indexDigitalList == null ? 0 : _indexDigitalList!.length,
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  //外盘期货全行情
  Widget _wpFuturesView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Divider(height: 1,color: Colors.grey,),
          IntrinsicHeight(
            child: Row(
              children: [
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("序号",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 1,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("交易所",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("合约代码",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("合约名称",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最新价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("涨跌额",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("涨跌幅",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("今开",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("昨收",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最高价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最低价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("成交量",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
              ],
            ),
          ),
          const Divider(height: 1,color: Colors.grey,),
          ListView.builder(
            controller: _controller5,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context,index){

              //最新价、涨跌额、涨跌幅
              Color _lastPriceColor = Colors.white;

              double _qCR = neverDoubleTryOrZero(_marketWpfuturesQuoteWholeList![index].qChangeRate!);
              if(_qCR > 0){
                _lastPriceColor = APP_MainGreenColor;
              }else if(_qCR < 0){
                _lastPriceColor = APP_MainRedColor;
              }else{
                _lastPriceColor = Colors.white;
              }


              return Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((index + 1).toString(),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 1,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpfuturesQuoteWholeList![index].exchangeNo!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpfuturesQuoteWholeList![index].commodityNo! + _marketWpfuturesQuoteWholeList![index].contractNo!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpfuturesQuoteWholeList![index].contractName!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpfuturesQuoteWholeList![index].qLastPrice!,style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpfuturesQuoteWholeList![index].qChangeValue!,style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpfuturesQuoteWholeList![index].qChangeRate! + '%',style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpfuturesQuoteWholeList![index].qOpeningPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketWpfuturesQuoteWholeList![index].qOpeningPrice!,_marketWpfuturesQuoteWholeList![index].qPreClosingPrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpfuturesQuoteWholeList![index].qPreClosingPrice!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpfuturesQuoteWholeList![index].qHighPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketWpfuturesQuoteWholeList![index].qHighPrice!,_marketWpfuturesQuoteWholeList![index].qOpeningPrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpfuturesQuoteWholeList![index].qLowPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketWpfuturesQuoteWholeList![index].qLowPrice!,_marketWpfuturesQuoteWholeList![index].qOpeningPrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_transformationNum(neverDoubleTryOrZero(_marketWpfuturesQuoteWholeList![index].qTotalQty!)),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                      ],
                    ),
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                ],
              );
            },
            itemCount: _marketWpfuturesQuoteWholeList == null ? 0 : _marketWpfuturesQuoteWholeList!.length,
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  //外盘现货全行情
  Widget _wpSpotView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Divider(height: 1,color: Colors.grey,),
          IntrinsicHeight(
            child: Row(
              children: [
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("序号",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 1,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("证券代码",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("证券名称",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最新价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("涨跌额",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("涨跌幅",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("今开",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("昨收",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最高价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最低价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("成交量",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
              ],
            ),
          ),
          const Divider(height: 1,color: Colors.grey,),
          ListView.builder(
            controller: _controller9,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context,index){
              //最新价、涨跌额、涨跌幅
              Color _lastPriceColor = Colors.white;

              double _qCR = 0.0;
              if(neverDoubleTryOrZero(_marketWpSpotDepthMarketList![index].openPrice!) == 0.0){
                _qCR = 0.0;
              }else{
                _qCR = ((neverDoubleTryOrZero(_marketWpSpotDepthMarketList![index].lastPrice!) - neverDoubleTryOrZero(_marketWpSpotDepthMarketList![index].openPrice!)) / neverDoubleTryOrZero(_marketWpSpotDepthMarketList![index].openPrice!));
              }
              if(_qCR > 0){
                _lastPriceColor = APP_MainGreenColor;
              }else if(_qCR < 0){
                _lastPriceColor = APP_MainRedColor;
              }else{
                _lastPriceColor = Colors.white;
              }
              return Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((index + 1).toString(),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 1,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpSpotDepthMarketList![index].instrumentID!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpSpotDepthMarketList![index].instrumentName!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpSpotDepthMarketList![index].lastPrice!,style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((NumUtil.getNumByValueDouble((neverDoubleTryOrZero(_marketWpSpotDepthMarketList![index].lastPrice!) - (neverDoubleTryOrZero(_marketWpSpotDepthMarketList![index].openPrice!))), 2)).toString(),style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((NumUtil.getNumByValueDouble(_qCR *100, 2)).toString()+ '%',style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpSpotDepthMarketList![index].openPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketWpSpotDepthMarketList![index].openPrice!,_marketWpSpotDepthMarketList![index].preClosePrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpSpotDepthMarketList![index].preClosePrice!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpSpotDepthMarketList![index].highestPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketWpSpotDepthMarketList![index].highestPrice!,_marketWpSpotDepthMarketList![index].openPrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketWpSpotDepthMarketList![index].lowestPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketWpSpotDepthMarketList![index].lowestPrice!,_marketWpSpotDepthMarketList![index].openPrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_transformationNum(neverDoubleTryOrZero(_marketWpSpotDepthMarketList![index].volume!)),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                      ],
                    ),
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                ],
              );
            },
            itemCount: _marketWpSpotDepthMarketList == null ? 0 : _marketWpSpotDepthMarketList!.length,
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  //内盘期货全行情
  Widget _npFuturesView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Divider(height: 1,color: Colors.grey,),
          IntrinsicHeight(
            child: Row(
              children: [
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("序号",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 1,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("合约代码",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("合约名称",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最新价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("涨跌额",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("涨跌幅",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("今开",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("昨收",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最高价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最低价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("成交量",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
              ],
            ),
          ),
          const Divider(height: 1,color: Colors.grey,),
          ListView.builder(
            controller: _controller6,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context,index){
              //最新价、涨跌额、涨跌幅
              Color _lastPriceColor = Colors.white;

              double _qCR = 0.0;
              if(neverDoubleTryOrZero(_marketNpfuturesDepthMarketList![index].preSettlementPrice!) == 0.0){
                _qCR = 0.0;
              }else{
                _qCR = ((neverDoubleTryOrZero(_marketNpfuturesDepthMarketList![index].lastPrice!) - neverDoubleTryOrZero(_marketNpfuturesDepthMarketList![index].preSettlementPrice!)) / neverDoubleTryOrZero(_marketNpfuturesDepthMarketList![index].preSettlementPrice!));
              }
              if(_qCR > 0){
                _lastPriceColor = APP_MainGreenColor;
              }else if(_qCR < 0){
                _lastPriceColor = APP_MainRedColor;
              }else{
                _lastPriceColor = Colors.white;
              }
              return Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((index + 1).toString(),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 1,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpfuturesDepthMarketList![index].instrumentID!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpfuturesDepthMarketList![index].instrumentName!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpfuturesDepthMarketList![index].lastPrice!,style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((NumUtil.getNumByValueDouble((neverDoubleTryOrZero(_marketNpfuturesDepthMarketList![index].lastPrice!) - (neverDoubleTryOrZero(_marketNpfuturesDepthMarketList![index].openPrice!))), 2)).toString(),style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((NumUtil.getNumByValueDouble(_qCR *100, 2)).toString()+ '%',style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpfuturesDepthMarketList![index].openPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketNpfuturesDepthMarketList![index].openPrice!,_marketNpfuturesDepthMarketList![index].preClosePrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpfuturesDepthMarketList![index].preClosePrice!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpfuturesDepthMarketList![index].highestPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketNpfuturesDepthMarketList![index].highestPrice!,_marketNpfuturesDepthMarketList![index].openPrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpfuturesDepthMarketList![index].lowestPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketNpfuturesDepthMarketList![index].lowestPrice!,_marketNpfuturesDepthMarketList![index].openPrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_transformationNum(neverDoubleTryOrZero(_marketNpfuturesDepthMarketList![index].volume!)),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                      ],
                    ),
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                ],
              );
            },
            itemCount: _marketNpfuturesDepthMarketList == null ? 0 : _marketNpfuturesDepthMarketList!.length,
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  //内盘现货全行情
  Widget _npSpotView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Divider(height: 1,color: Colors.grey,),
          IntrinsicHeight(
            child: Row(
              children: [
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("序号",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 1,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("证券代码",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("证券名称",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最新价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("涨跌额",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("涨跌幅",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("今开",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("昨收",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最高价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("最低价",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("成交量",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 2,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
              ],
            ),
          ),
          const Divider(height: 1,color: Colors.grey,),
          ListView.builder(
            controller: _controller7,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context,index){
              //最新价、涨跌额、涨跌幅
              Color _lastPriceColor = Colors.white;

              double _qCR = 0.0;
              if(neverDoubleTryOrZero(_marketNpSpotDepthMarketList![index].openPrice!) == 0.0){
                _qCR = 0.0;
              }else{
                _qCR = ((neverDoubleTryOrZero(_marketNpSpotDepthMarketList![index].lastPrice!) - neverDoubleTryOrZero(_marketNpSpotDepthMarketList![index].openPrice!)) / neverDoubleTryOrZero(_marketNpSpotDepthMarketList![index].openPrice!));
              }
              if(_qCR > 0){
                _lastPriceColor = APP_MainGreenColor;
              }else if(_qCR < 0){
                _lastPriceColor = APP_MainRedColor;
              }else{
                _lastPriceColor = Colors.white;
              }
              return Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((index + 1).toString(),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 1,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpSpotDepthMarketList![index].instrumentID!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpSpotDepthMarketList![index].instrumentName!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpSpotDepthMarketList![index].lastPrice!,style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((NumUtil.getNumByValueDouble((neverDoubleTryOrZero(_marketNpSpotDepthMarketList![index].lastPrice!) - (neverDoubleTryOrZero(_marketNpSpotDepthMarketList![index].openPrice!))), 2)).toString(),style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text((NumUtil.getNumByValueDouble(_qCR *100, 2)).toString()+ '%',style: TextStyle(fontSize: 12,color: _lastPriceColor),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpSpotDepthMarketList![index].openPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketNpSpotDepthMarketList![index].openPrice!,_marketNpSpotDepthMarketList![index].preClosePrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpSpotDepthMarketList![index].preClosePrice!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpSpotDepthMarketList![index].highestPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketNpSpotDepthMarketList![index].highestPrice!,_marketNpSpotDepthMarketList![index].openPrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_marketNpSpotDepthMarketList![index].lowestPrice!,style: TextStyle(fontSize: 12,color: _contrastColors(_marketNpSpotDepthMarketList![index].lowestPrice!,_marketNpSpotDepthMarketList![index].openPrice!)),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                        Expanded(
                          child: Container(
                            child: Text(_transformationNum(neverDoubleTryOrZero(_marketNpSpotDepthMarketList![index].volume!)),style: const TextStyle(fontSize: 12,color: Colors.white),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          ),
                          flex: 2,
                        ),
                        const VerticalDivider(width: 1,color: Colors.grey,),
                      ],
                    ),
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                ],
              );
            },
            itemCount: _marketNpSpotDepthMarketList == null ? 0 : _marketNpSpotDepthMarketList!.length,
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  //消息资讯
  Widget _commonNoticeView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Divider(height: 1,color: Colors.grey,),
          IntrinsicHeight(
            child: Row(
              children: [
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("序号",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 1,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("标题",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 4,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("发布时间",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 1,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
                Expanded(
                  child: Container(
                    child: const Text("语言",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  ),
                  flex: 1,
                ),
                const VerticalDivider(width: 1,color: Colors.grey,),
              ],
            ),
          ),
          const Divider(height: 1,color: Colors.grey,),
          ListView.builder(
            controller: _controller8,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context,index){
              return GestureDetector(
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          const VerticalDivider(width: 1,color: Colors.grey,),
                          Expanded(
                            child: Container(
                              child: Text((index + 1).toString(),style: const TextStyle(fontSize: 12,color: Colors.white),),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                            ),
                            flex: 1,
                          ),
                          const VerticalDivider(width: 1,color: Colors.grey,),
                          Expanded(
                            child: Container(
                              child: Text(_marketCommonNoticeList![index].title!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                            ),
                            flex: 4,
                          ),
                          const VerticalDivider(width: 1,color: Colors.grey,),
                          Expanded(
                            child: Container(
                              child: Text(formatDate(DateTime.fromMillisecondsSinceEpoch(_marketCommonNoticeList![index].publicDate!),
                                  [yyyy ,'-', mm, '-', dd, ' ',HH, ':', nn, ':', ss]),style: const TextStyle(fontSize: 12,color: Colors.white),),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                            ),
                            flex: 1,
                          ),
                          const VerticalDivider(width: 1,color: Colors.grey,),
                          Expanded(
                            child: Container(
                              child: Text(_marketCommonNoticeList![index].langType!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                            ),
                            flex: 1,
                          ),
                          const VerticalDivider(width: 1,color: Colors.grey,),
                        ],
                      ),
                    ),
                    const Divider(height: 1,color: Colors.grey,),
                  ],
                ),
                behavior: HitTestBehavior.opaque,
                onTap: () async{
                  var response = await CommonNoticeFindByData(_marketCommonNoticeList![index].id!);
                  if (response is Map) {
                    if(!mounted){
                      return;
                    }
                    if(response['code'] == 200){
                      MarketCommonNoticeListData _marketCommonNoticeData = MarketCommonNoticeListData.fromJson(response['object']);
                      AwesomeDialog(
                        context: context,
                        headerAnimationLoop: false,
                        dismissOnBackKeyPress:true,
                        width:MediaQuery.of(context).size.width / 2,
                        dialogType: DialogType.NO_HEADER,
                        animType: AnimType.BOTTOMSLIDE,
                        body: Column(
                          children: [
                            Container(
                              child: Text(_marketCommonNoticeData.title!,style: const TextStyle(fontSize: 15,color:Colors.black,fontWeight: FontWeight.w500),),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                            ),
                            Container(
                              child: Text(formatDate(DateTime.fromMillisecondsSinceEpoch(_marketCommonNoticeData.publicDate!),
                                  [yyyy ,'-', mm, '-', dd, ' ',HH, ':', nn, ':', ss]),style: const TextStyle(fontSize: 12,color: Colors.grey),),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: HtmlWidget(
                                _marketCommonNoticeData.content!,
                                // render a custom widget
                                customWidgetBuilder: (element) {
                                  return null;
                                },
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ).show();



                    }else {
                      try{
                        showMyCustomText(response['message']);
                      }catch(e){
                        showMyCustomText('遇到问题，请检查网络或重新刷新');
                      }
                    }
                  }else {
                    try{
                      showMyCustomText(response.error.toString());
                    }catch(e){
                      showMyCustomText('遇到问题，请检查网络或重新刷新');
                    }
                  }
                },
              );
            },
            itemCount: _marketCommonNoticeList == null ? 0 : _marketCommonNoticeList!.length,
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  //数值转换
  String _transformationNum(double num,{int dec = 0}){
    if(num > 1000000000){//1,000,000,000
      return (NumUtil.getNumByValueDouble(num/1000000000.0, dec)).toString() + 'B';
    }else if(num > 1000000){//1,000,000,000
      return (NumUtil.getNumByValueDouble(num/1000000.0, dec)).toString() + 'M';
    }else if(num > 1000){//1,000,000,000
      return (NumUtil.getNumByValueDouble(num/1000.0, dec)).toString() + 'K';
    }else{
      return (NumUtil.getNumByValueDouble(num, dec)).toString();
    }
  }

  //颜色判定 前比后大 为涨 涨为绿
  Color _contrastColors(String first,String last){
    double _one = neverDoubleTryOrZero(first);
    double _two = neverDoubleTryOrZero(last);

    if(_one > _two){
      return APP_MainGreenColor;
    }else if(_one < _two){
      return APP_MainRedColor;
    }else{
      return Colors.white;
    }
  }

  void _reloadEveryWherer(){
    if(_selectIndexType == '数字货币'){
      _DigitalcurrencyOkexMarketGetTickersAllHttp();
    }else if(_selectIndexType == '外盘期货'){
      _WpfuturesWpfuturesQuoteWholeAllMarketDataHttp();
    }else if(_selectIndexType == '外盘现货'){
      _WpSpotDepthMarketDataAllMarketDataHttp();
    }else if(_selectIndexType == '内盘期货'){
      _NpfuturesNpfuturesDepthMarketDataAllMarketDataHttp();
    }else if(_selectIndexType == '内盘现货'){
      _NpSpotDepthMarketDataAllMarketDataHttp();
    }else if(_selectIndexType == '消息资讯'){
      _CommonNoticeDataHttp();
    }else{

    }
  }
}
