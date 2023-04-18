import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/HttpRequest.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/DigitalCurrency/Http/DigitalCurrencyHttpRequest.dart';
import 'package:amclient_flutter/DigitalCurrency/Model/DigitalCurrencyExchangeApiResponseModel.dart';
import 'package:amclient_flutter/DigitalCurrency/Model/DigitalCurrencyResponseModel.dart';
import 'package:amclient_flutter/DigitalCurrency/View/DigitalCurrencyViewWidget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart' as DateFormat;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:k_chart/chart_style.dart';
import 'package:k_chart/entity/k_line_entity.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'package:neveruseless/never/neverBus.dart';
import 'package:neveruseless/never/neverDoubleTryOrZero.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
class DigitalCurrencyView extends StatefulWidget {
  final arguments;
  const DigitalCurrencyView({Key? key, this.arguments}) : super(key: key);

  @override
  _DigitalCurrencyViewState createState() => _DigitalCurrencyViewState();
}
final iv= encrypt.IV.fromUtf8("0102030405060708");

const double kLeftBarWidth = 72.0;
const double kTransactionPanelWidth = 290.0;
const double kSpotWidth = 230.0;
class _DigitalCurrencyViewState extends State<DigitalCurrencyView> with AutomaticKeepAliveClientMixin {

  //缓存文本
  String _localJosnData = '';

  //选择的5大类型-当前类型
  String _selectIndexType = 'spot';
  String _selectIndexCurrency = '';

  //当前选择的交易对
  String _selectIndexInstId = '';
  String _selectIndexInstType = 'SPOT';
  String _selectIndexLast = '';
  String _selectIndexSodUtc8 = '';
  String _selectIndexHigh24h = '';
  String _selectIndexLow24h = '';
  String _selectIndexVolCcy24h = '';
  String _selectIndexVol24h = '';
  String _selectIndexMinSz = '';

  //币对选择页面是否显示
  bool _isShowCurrencyPick = true;

  //API列表
  late List<DigitalCurrencyExchangeApiResponseData> _apiList = [];
  String _indexApi = '';


  List<DigitalCurrencyUnifiedModel>? _spotList = [];//现货
  List<DigitalCurrencyUnifiedModel>? _perpetualList = [];//合约
  List<DigitalCurrencyUnifiedModel>? _futuresList = [];//期货
  List<DigitalCurrencyUnifiedModel>? _marginList = [];//杠杆
  List<DigitalCurrencyUnifiedModel>? _optionsList = [];//期权

  List<DigitalCurrencyUnifiedModel>? _screenList = [];//筛选


  //盘口与实时成交
  String _selectTransactionType = '委托订单';//order 盘口 trade 成交
  final List _selectTransactionTypeName = ['委托订单','最新成交'];

  //个人资产
  String _selectAssetEntrustmentType = '资产';//order 盘口 trade 成交
  final List _selectAssetEntrustmentTypeName = ['当前委托','历史委托','仓位','资产'];

  //交易面板
  String _selectTransactionPanelType = '限价委托';//order 盘口 trade 成交
  final List _selectTransactionPanelTypeName = ['限价委托','市价委托','止盈止损',];

  //最新成交
  List<DigitalCurrencyTradesSocketModel> _tradesList = [];

  //盘口深度
  List _tickAsksList = [];
  List _tickBidsList = [];

  List _tickAsksTotalList = [];
  List _tickBidsTotalList = [];

  int _selectListlength = 0;
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _currencyController = TextEditingController();

  //Socket套件
  bool _isSocektOn = false;
  late IOWebSocketChannel _channel;
  bool _isPrivateSocektOn = false;
  late IOWebSocketChannel _channelPrivate;

  Timer? _timer;
  Timer? _privateTimer;

  //交易面板套件
  final TextEditingController _transactionPriceController = TextEditingController();
  final TextEditingController _transactionNumberController = TextEditingController();
  final TextEditingController _transactionAmountController = TextEditingController();

  //止盈止损
  final TextEditingController _tpslTriggerPxController = TextEditingController();
  final TextEditingController _tpslOrdPxController = TextEditingController();
  final TextEditingController _tpslPxAmountController = TextEditingController();



  //账户 资产
  List<DigitalCurrencyAccountDetailsSocketModel>? _accountDetailsList =[];

  //账户 持仓
  List<DigitalCurrencyPositionsSocketModel>? _accountPositionsList =[];
  final TextEditingController _accountPositionsPriceController = TextEditingController();

  //账户 历史委托
  List<DigitalCurrencyTradeGetOrderHistory> _accountOrderHistoryList = [];

  //账户 当前委托
  List<DigitalCurrencyTradeGetOrderHistory> _accountOrderList = [];

  //账户 最大可买卖 最大交易数量
  String _thisMaxBuy = '-';
  String _thisMaxSell = '-';
  String _thisAvailBuy = '-';
  String _thisAvailSell = '-';

  //K线
  String _selectKlineTimeType = 'candle5m'; // candle1m : 1分     candle5m ：5分     candle15m：15分    candle30m：30分   candle1H：60分   candle1D：24小时
  String _selectKlineTimeTypeName = '5分';//order 盘口 trade 成交
  bool _isTimeLine = false;
  final List _klineTimeTypeAllList = ['分时','1分','5分','15分','30分','60分','1日'];
  MainState _mainState = MainState.MA;
  String _mainStateName = 'MA';//order 盘口 trade 成交
  final List _mainStateList = ["MA", "BOLL", "NONE"];

  SecondaryState _secondaryState = SecondaryState.NONE;
  String _secondaryStateName = 'NONE';//order 盘口 trade 成交
  final List _secondaryStateList = ["NONE", "MACD", "KDJ","RSI","WR","CCI",];//{ MACD, KDJ, RSI, WR, CCI, NONE }

  List<KLineEntity>? _KLineList;

  final ChartStyle _chartStyle = ChartStyle();
  final ChartColors _chartColors = ChartColors();

  //下部面板是否隐藏
  bool _accountWidgetShow = true;

  //盘口最新成交是否隐藏
  bool _spotWidgetHandicapShow = true;

  double _accountWidgetHeadYT = 0.0;
  double _accountWidgetHeight = (window.physicalSize.height * 0.15) > 120.0 ? window.physicalSize.height * 0.15 : 120.0;
  double _accountWidgetHeightT = (window.physicalSize.height * 0.15) > 120.0 ? window.physicalSize.height * 0.15 : 120.0;

  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();
  final ScrollController _controller3 = ScrollController();
  final ScrollController _controller4 = ScrollController();
  final ScrollController _controller5 = ScrollController();
  final ScrollController _controller6 = ScrollController();
  final ScrollController _controller7 = ScrollController();
  final ScrollController _controller8 = ScrollController();
  final ScrollController _controller9 = ScrollController();
  final ScrollController _controller10 = ScrollController();
  final ScrollController _controller11 = ScrollController();
  final ScrollController _controller12 = ScrollController();
  final ScrollController _controller13 = ScrollController();
  final ScrollController _controller14 = ScrollController();


  @override
  void initState() {
    super.initState();
    _readLocalAndFirst(); //优先从缓存中读取
    // _DigitalcurrencyOkexPubilcInstrumentsnHttp(); //仅从HTTP读取
    _channel = IOWebSocketChannel.connect(kDigitalSocketAddress);
    _isSocektOn = true;
    _channelPrivate = IOWebSocketChannel.connect(kDigitalSocketPrivateAddress);
    _isPrivateSocektOn = true;
    _channel.stream.listen(onData, onError: onError, onDone: onDone);
    _channelPrivate.stream.listen(onDataPrivate, onError: onErrorPrivate, onDone: onDonePrivate);
    _DigitalcurrencyExchangeapiListHttp();
    _onSendInstruments();

    //底部栏切换动作 1：点击到当前页面是 应该有一次刷新动作 2：socket应该重连一次，3：离开时关闭socket
    neverBus.on('pageController', (object) {
      if(!mounted){
        return;
      }
      setState(() {
        if(object == '/DigitalCurrencyView') {
          print("打开数字货币界面");
          _DigitalcurrencyExchangeapiListSignHttp();
          if(!_isSocektOn){
            onRest();
          }
          if(!_isPrivateSocektOn){
            onPrivateRest();
          }
        }else{
          if(_isSocektOn){
            try{
              _channel.sink.close();
            }catch(e){
              try{
                _channel.sink.close();
              }catch(e){
                print("数字货币共有类Socket异常未处理关闭");
              }
            }
          }
          if(_isPrivateSocektOn){
            try{
              _channelPrivate.sink.close();
            }catch(e){
              try{
                _channelPrivate.sink.close();
              }catch(e){
                print("数字货币共有类Socket异常未处理关闭");
              }
            }
          }
        }
      });
    });
    neverBus.on('LoginSuccess', (object){
      if(!mounted){
        return;
      }

      if(!_isSocektOn){
        onRest();
      }
      if(!_isPrivateSocektOn){
        onPrivateRest();
      }
    });

    neverBus.on('DigitalTransactionRefresh', (object){
      if(!mounted){
        return;
      }
      if(_indexApi != ''){
        _DigitalcurrencyOkexAccountGetMaximumAvailableTradableAmountHttp(_selectIndexInstId);
        _DigitalcurrencyOkexAccountGtMaximumTradableSizeForInstrumentHttp(_selectIndexInstId);
        _DigitalcurrencyOkexTradeGetOrderHistory7daysHttp();
      }else{
        _DigitalcurrencyExchangeapiListSignHttp();
      }
    });
  }

  //公用 -- 订阅币种
  _onSendInstruments() async{
    String subsStr= "{\"op\" : \"" + "subscribe" + "\"," + "\"args\" : ["
        + "{\"channel\" : \"instruments\",\"instType\" : \"FUTURES\"},"
        + "{\"channel\" : \"instruments\",\"instType\" : \"SPOT\"},"
        + "{\"channel\" : \"instruments\",\"instType\" : \"SWAP\"},"
        + "{\"channel\" : \"instruments\",\"instType\" : \"OPTION\"}"
        + "]" + "\}";
    _channel.sink.add(subsStr);
    _timeToPing();
  }

  //私有 -- 订阅
  _onSendPrivate() async{
    String subsStr= "{\"op\" : \"" + "subscribe" + "\"," + "\"args\" : ["
        + "{\"channel\" : \"positions\",\"instType\" : \"ANY\"},"
        + "{\"channel\" : \"orders\",\"instType\" : \"ANY\"},"
        + "{\"channel\" : \"account\"}"
        + "]" + "\}";
    _channelPrivate.sink.add(subsStr);
  }

  //订阅币种列表内的行情
  _onSendTickersPretreatment(List<DigitalCurrencyUnifiedModel> list) async{
    List<DigitalCurrencyUnifiedModel> _teList = [];
    _teList.addAll(list);
    List<List<DigitalCurrencyUnifiedModel>> _listList = [];
    while(_teList.isNotEmpty){
      if(_teList.length > 20){
        List<DigitalCurrencyUnifiedModel>? _peList = [];
        _peList.addAll(_teList.getRange(0, 20));
        _listList.add(_peList);
        _teList.removeRange(0, 20);
      }else{
        List<DigitalCurrencyUnifiedModel>? _peList = [];
        _peList.addAll(_teList);
        _listList.add(_peList);
        _teList.clear();
      }
    }
    for(int i = 0;i<_listList.length ;i++){
      String subsStr= "{\"op\" : \"" + "subscribe" + "\"," + "\"args\" : [";
      for(int j = 0;j<_listList[i].length;j++){
        subsStr += "{\"channel\" : \"tickers-3s\",\"instId\" : \"" + _listList[i][j].instId! + "\"},";
      }
      subsStr += "]" + "\}";
      subsStr = subsStr.replaceAll('"},]}', '"}]}');
      _channel.sink.add(subsStr);
    }
  }

  //订阅单币种行情
  _onSubscribeTickers(String instId){
    if(_indexApi != ''){
      _DigitalcurrencyOkexAccountGetMaximumAvailableTradableAmountHttp(instId);
      _DigitalcurrencyOkexAccountGtMaximumTradableSizeForInstrumentHttp(instId);
      _DigitalcurrencyOkexTradeGetOrderHistory7daysHttp();
    }
    String subsStr= "{\"op\" : \"" + "subscribe" + "\"," + "\"args\" : ["
        + "{\"channel\" : \"tickers\",\"instId\" : \"" +  instId  + "\"},"
        + "{\"channel\" : \"books\",\"instId\" : \"" +  instId  + "\"},"
        + "{\"channel\" : \"price-limit\",\"instId\" : \"" +  instId  + "\"},"
        + "{\"channel\" : \"trades\",\"instId\" : \"" +  instId  + "\"}"
        + "]" + "\}";
    // print(subsStr);
    _channel.sink.add(subsStr);
    // _onSendKline(_selectIndexInstId);
  }

  //单币种 -- 订阅KLine
  _onSendKline(String instId) async{
    String subsStr= "{\"op\" : \"" + "subscribe" + "\"," + "\"args\" : ["
        + "{\"channel\" : \"" + _selectKlineTimeType + "\",\"instId\" : \"" +  instId  + "\"}"
        + "]" + "\}";
    _channel.sink.add(subsStr);
  }

  //单币种 -- 退订KLine
  _onSendUnKline(String instId) async{
    String subsStr= "{\"op\" : \"" + "unsubscribe" + "\"," + "\"args\" : ["
        + "{\"channel\" : \"" + _selectKlineTimeType + "\",\"instId\" : \"" +  instId  + "\"}"
        + "]" + "\}";
    _channel.sink.add(subsStr);
  }

  //退订单币种行情
  _onUnsubscribeTickers(String instId){
    String subsStr= "{\"op\" : \"" + "unsubscribe" + "\"," + "\"args\" : ["
        + "{\"channel\" : \"tickers\",\"instId\" : \"" +  instId  + "\"},"
        + "{\"channel\" : \"books\",\"instId\" : \"" +  instId  + "\"},"
        + "{\"channel\" : \"trades\",\"instId\" : \"" +  instId  + "\"}"
        + "]" + "\}";
    _channel.sink.add(subsStr);
  }

  onData(event){
    if(!mounted){
      return;
    }

    if(event == 'pong'){
      // print('收到心跳回应' + DateTime.now().toString());
      _timeToPing();
      return;
    }
    try{
      Map _socketData = jsonDecode(event);
      // print(event);

      String _channelType = _socketData['arg']['channel'];
      if(_socketData.containsKey('data')){
        if(_channelType == 'instruments'){//产品订阅
          String _instType =  _socketData['arg']['instType'];
          if(_instType == 'SPOT'){ // 币币 币币又分 币币现货和杠杆
            List<DigitalCurrencyUnifiedModel> _spotTemp = (_socketData['data'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).toList();
            if(_spotTemp.length >= _spotList!.length){
              _spotList = _spotTemp;
              _spotList!.removeWhere((e) => e.state != "live");
              _marginList!.clear();
              _marginList!.addAll(_spotList!.where((e) => (int.tryParse(e.lever.toString()) ?? 0) > 1));
              _onSendTickersPretreatment(_spotList!);
            }else{
              _DigitalcurrencyOkexPubilcInstrumentsnHttp();//socket数组数量不对，直接请求接口完整覆盖
            }
          }
          if(_instType == 'SWAP'){ // 永续
            List<DigitalCurrencyUnifiedModel> _perpetualTemp = (_socketData['data'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).toList();
            if(_perpetualTemp.length >= _perpetualList!.length){
              _perpetualList = _perpetualTemp;
              _perpetualList!.removeWhere((e) => e.state != "live");
              _onSendTickersPretreatment(_perpetualList!);
            }else{
              _DigitalcurrencyOkexPubilcInstrumentsnHttp();//socket数组数量不对，直接请求接口完整覆盖
            }
          }
          if(_instType == 'FUTURES'){ // 交割
            List<DigitalCurrencyUnifiedModel> _futuresTemp = (_socketData['data'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).toList();
            if(_futuresTemp.length >= _futuresList!.length){
              _futuresList = _futuresTemp;
              _futuresList!.removeWhere((e) => e.state != "live");
              _onSendTickersPretreatment(_futuresList!);
            }else{
              _DigitalcurrencyOkexPubilcInstrumentsnHttp();//socket数组数量不对，直接请求接口完整覆盖
            }
          }
          if(_instType == 'OPTION'){ // 期权
            List<DigitalCurrencyUnifiedModel> _optionsTemp = (_socketData['data'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).toList();
            if(_optionsTemp.length >= _optionsList!.length){
              _optionsList = _optionsTemp;
              _optionsList!.removeWhere((e) => e.state != "live");
              _onSendTickersPretreatment(_optionsList!);
            }else{
              _DigitalcurrencyOkexPubilcInstrumentsnHttp();//socket数组数量不对，直接请求接口完整覆盖
            }
          }
        }
        else if(_channelType == 'tickers'){
          DigitalCurrencyUnifiedModel _indexData  =  (_socketData['data'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).first;
          _selectIndexLast = _indexData.last!;
          _selectIndexSodUtc8 = _indexData.sodUtc8!;
          _selectIndexHigh24h = _indexData.high24h!;
          _selectIndexLow24h = _indexData.low24h!;
          _selectIndexVolCcy24h = _indexData.volCcy24h!;
          _selectIndexVol24h = _indexData.vol24h!;
        }
        else if(_channelType == 'tickers-3s'){ // 3s行情订阅
          DigitalCurrencyUnifiedModel _indexData  =  (_socketData['data'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).first;
          // print(_indexData.instType);
          if(_indexData.instType == 'SPOT'){ //币币 杠杆
            int _index = _spotList!.indexWhere((element) => element.instId == _indexData.instId);
            if(_index != -1){
              _spotList![_index].last = _indexData.last;
              _spotList![_index].lastSz = _indexData.lastSz;
              _spotList![_index].askPx = _indexData.askPx;
              _spotList![_index].askSz = _indexData.askSz;
              _spotList![_index].bidPx = _indexData.bidPx;
              _spotList![_index].bidSz = _indexData.bidSz;
              _spotList![_index].open24h = _indexData.open24h;
              _spotList![_index].high24h = _indexData.high24h;
              _spotList![_index].low24h = _indexData.low24h;
              _spotList![_index].sodUtc0 = _indexData.sodUtc0;
              _spotList![_index].sodUtc8 = _indexData.sodUtc8;
              _spotList![_index].volCcy24h = _indexData.volCcy24h;
              _spotList![_index].vol24h = _indexData.vol24h;
              _spotList![_index].ts = _indexData.ts;
            }
          }else if(_indexData.instType == 'SWAP'){ // 永续
            int _index = _perpetualList!.indexWhere((element) => element.instId == _indexData.instId);
            if(_index != -1){
              _perpetualList![_index].last = _indexData.last;
              _perpetualList![_index].lastSz = _indexData.lastSz;
              _perpetualList![_index].askPx = _indexData.askPx;
              _perpetualList![_index].askSz = _indexData.askSz;
              _perpetualList![_index].bidPx = _indexData.bidPx;
              _perpetualList![_index].bidSz = _indexData.bidSz;
              _perpetualList![_index].open24h = _indexData.open24h;
              _perpetualList![_index].high24h = _indexData.high24h;
              _perpetualList![_index].low24h = _indexData.low24h;
              _perpetualList![_index].sodUtc0 = _indexData.sodUtc0;
              _perpetualList![_index].sodUtc8 = _indexData.sodUtc8;
              _perpetualList![_index].volCcy24h = _indexData.volCcy24h;
              _perpetualList![_index].vol24h = _indexData.vol24h;
              _perpetualList![_index].ts = _indexData.ts;
            }
          }else if(_indexData.instType == 'FUTURES'){// 交割
            int _index = _futuresList!.indexWhere((element) => element.instId == _indexData.instId);
            if(_index != -1){
              _futuresList![_index].last = _indexData.last;
              _futuresList![_index].lastSz = _indexData.lastSz;
              _futuresList![_index].askPx = _indexData.askPx;
              _futuresList![_index].askSz = _indexData.askSz;
              _futuresList![_index].bidPx = _indexData.bidPx;
              _futuresList![_index].bidSz = _indexData.bidSz;
              _futuresList![_index].open24h = _indexData.open24h;
              _futuresList![_index].high24h = _indexData.high24h;
              _futuresList![_index].low24h = _indexData.low24h;
              _futuresList![_index].sodUtc0 = _indexData.sodUtc0;
              _futuresList![_index].sodUtc8 = _indexData.sodUtc8;
              _futuresList![_index].volCcy24h = _indexData.volCcy24h;
              _futuresList![_index].vol24h = _indexData.vol24h;
              _futuresList![_index].ts = _indexData.ts;
            }
          }else if(_indexData.instType == 'OPTION'){// 期权
            int _index = _optionsList!.indexWhere((element) => element.instId == _indexData.instId);
            if(_index != -1){
              _optionsList![_index].last = _indexData.last;
              _optionsList![_index].lastSz = _indexData.lastSz;
              _optionsList![_index].askPx = _indexData.askPx;
              _optionsList![_index].askSz = _indexData.askSz;
              _optionsList![_index].bidPx = _indexData.bidPx;
              _optionsList![_index].bidSz = _indexData.bidSz;
              _optionsList![_index].open24h = _indexData.open24h;
              _optionsList![_index].high24h = _indexData.high24h;
              _optionsList![_index].low24h = _indexData.low24h;
              _optionsList![_index].sodUtc0 = _indexData.sodUtc0;
              _optionsList![_index].sodUtc8 = _indexData.sodUtc8;
              _optionsList![_index].volCcy24h = _indexData.volCcy24h;
              _optionsList![_index].vol24h = _indexData.vol24h;
              _optionsList![_index].ts = _indexData.ts;
            }
          }
        }
        else if(_channelType == 'books'){
          if(_socketData['action'] == "snapshot"){
            _tickBidsList.clear();
            _tickBidsList = _socketData['data'][0]['bids'];
            _tickAsksList.clear();
            _tickAsksList = _socketData['data'][0]['asks'];
            if(_tickBidsList.length >30){
              _tickBidsList.removeRange(30, _tickBidsList.length);
            }
            if(_tickAsksList.length >30){
              _tickAsksList.removeRange(30, _tickAsksList.length);
            }
            _tickAsksTotalList.clear();
            _tickBidsTotalList.clear();

            _tickAsksList.forEach((element) {
              _tickAsksTotalList.add(neverDoubleTryOrZero(element[1].toString()));
            });
            _tickBidsList.forEach((element) {
              _tickBidsTotalList.add(neverDoubleTryOrZero(element[1].toString()));
            });
          }
          else if(_socketData['action'] == "update") {
            List _tickBidsListUpdata = _socketData['data'][0]['bids'];
            List _tickAsksListUpdata = _socketData['data'][0]['asks'];

            //第一层判断价格相同的情况 Bids
            for (int i = 0; i < _tickBidsList.length; i++) {
              for (int j = 0; j < _tickBidsListUpdata.length; j++) {
                if (_tickBidsListUpdata[j][0] == _tickBidsList[i][0]) {
                  _tickBidsList.removeAt(i);
                  _tickBidsList.insert(i, _tickBidsListUpdata[j]);
                  _tickBidsListUpdata.removeAt(j);
                }
              }
            }


            for (int i = 0; i < _tickBidsList.length; i++) {
              for (int j = 0; j < _tickBidsListUpdata.length; j++) {
                if (double.parse(_tickBidsListUpdata[j][0]) > double.parse(_tickBidsList[i][0])) {
                  _tickBidsList.insert(i, _tickBidsListUpdata[j]);
                  _tickBidsListUpdata.removeAt(j);
                }
              }
            }

            _tickBidsList.addAll(_tickBidsListUpdata);
            _tickBidsListUpdata.clear();

            if(_tickBidsList.length > 200){
              _tickBidsList.removeRange(200, _tickBidsList.length);
            }

            for (int i = 0; i < _tickBidsList.length; i++) {
              if(_tickBidsList[i] is! List){
                _tickBidsList.removeAt(i);
                break;
              }
              if(_tickBidsList[i].length !=4){
                _tickBidsList.removeAt(i);
                break;
              }
              if (_tickBidsList[i][1] == '0') {
                _tickBidsList.removeAt(i);
              }
            }

            if (_tickBidsList.length > 30) {
              _tickBidsList.removeRange(30, _tickBidsList.length);
            }

            _tickBidsTotalList.clear();
            _tickBidsList.forEach((element) {
              _tickBidsTotalList.add(neverDoubleTryOrZero(element[1].toString()));
            });

            // //第一层判断价格相同的情况 Asks
            for (int i = 0; i < _tickAsksList.length; i++) {
              for (int j = 0; j < _tickAsksListUpdata.length; j++) {
                if (_tickAsksListUpdata[j][0] == _tickAsksList[i][0]) {
                  _tickAsksList.removeAt(i);
                  _tickAsksList.insert(i, _tickAsksListUpdata[j]);
                  _tickAsksListUpdata.removeAt(j);
                }
              }
            }

            for (int i = 0; i < _tickAsksList.length; i++) {
              for (int j = 0; j < _tickAsksListUpdata.length; j++) {
                if (double.parse(_tickAsksListUpdata[j][0]) < double.parse(_tickAsksList[i][0])) {
                  _tickAsksList.insert(i, _tickAsksListUpdata[j]);
                  _tickAsksListUpdata.removeAt(j);
                }
              }
            }

            _tickAsksList.addAll(_tickAsksListUpdata);
            _tickAsksListUpdata.clear();

            if(_tickAsksList.length > 200){
              _tickAsksList.removeRange(200, _tickAsksList.length);
            }

            for (int i = 0; i < _tickAsksList.length; i++) {
              if(_tickAsksList[i] is! List){
                _tickAsksList.removeAt(i);
                break;
              }
              if(_tickAsksList[i].length !=4){
                _tickAsksList.removeAt(i);
                break;
              }
              if (neverDoubleTryOrZero(_tickAsksList[i][1].toString()) == 0.0) {
                _tickAsksList.removeAt(i);
              }
            }

            if (_tickAsksList.length > 30) {
              _tickAsksList.removeRange(30, _tickAsksList.length);
            }
            _tickAsksTotalList.clear();
            _tickAsksList.forEach((element) {
              _tickAsksTotalList.add(neverDoubleTryOrZero(element[1].toString()));
            });

          }
        }
        else if(_channelType == 'trades'){
          DigitalCurrencyTradesSocketModel _tradesData  =  (_socketData['data'] as List).map((i) => DigitalCurrencyTradesSocketModel.fromJson(i)).first;
          if(_selectIndexInstId == _tradesData.instId){
            _tradesList.insert(0, _tradesData);
            if(_tradesList.length > 100){
              _tradesList.removeRange(100, _tradesList.length);
            }
          }else{
            _tradesList.clear();
          }
        }
        else{
          // print(event);
        }
      }


      // _channel.sink.add('ping');
      setState(() {
        if(_selectIndexInstId == ''){
          _selectIndexInstId = _spotList!.first.instId!;
          _selectIndexInstType = _spotList!.first.instType!;
          _selectIndexCurrency = _spotList!.first.baseCcy!;
          _tradesList.clear();
          _onSubscribeTickers(_selectIndexInstId);
        }
        if(_selectIndexType == 'spot'){
          _selectListlength = _spotList!.length;//现货
        }else if(_selectIndexType == 'perpetual'){
          _selectListlength = _perpetualList!.length;//永续
        }else if(_selectIndexType == 'futures'){
          _selectListlength = _futuresList!.length;//交割
        }else if(_selectIndexType == 'margin'){
          _selectListlength = _marginList!.length;//杠杆
        }else if(_selectIndexType == 'options'){
          _selectListlength = _optionsList!.length;//期权
        }else{
          _selectListlength = 0;
        }
      });
    }catch(e){
      print(e);
    }

  }

  //私有Socket接收行情
  onDataPrivate(event){
    if(event == 'pong'){
      // print('私有收到心跳回应' + DateTime.now().toString());
      _privateTimeToPing();
      return;
    }
    try{
      Map _socketData = jsonDecode(event);
      // print(event);

      String _channelType = _socketData['arg']['channel'];
      if(_socketData.containsKey('data')){
        if(_channelType == 'account'){//产品订阅
          DigitalCurrencyAccountSocketModel _indexData  =  (_socketData['data'] as List).map((i) => DigitalCurrencyAccountSocketModel.fromJson(i)).first;
          if(_indexData.details!.isNotEmpty){
            if( _accountDetailsList!.isNotEmpty && _indexData.details!.length < _accountDetailsList!.length){
              List<DigitalCurrencyAccountDetailsSocketModel>? _tempList =[];
              _tempList = _indexData.details;
              for(int i = 0;i<_tempList!.length;i++){
                int _index = _accountDetailsList!.indexWhere((element) => element.ccy == _tempList![i].ccy);
                if(_index != -1){
                  _accountDetailsList![_index] = _tempList[i];
                }else{
                  _accountDetailsList!.add(_tempList[i]);
                }
              }
            }else{
              _accountDetailsList = _indexData.details;
            }
          }
        }
        else if(_channelType == 'positions'){
          _accountPositionsList = (_socketData['data'] as List).map((i) => DigitalCurrencyPositionsSocketModel.fromJson(i)).toList();
        }
        else if(_channelType == 'orders'){
          DigitalCurrencyTradeGetOrderHistory _tempData = (_socketData['data'] as List).map((i) => DigitalCurrencyTradeGetOrderHistory.fromJson(i)).toList().first;
          int _index = _accountOrderList.indexWhere((element) => element.ordId == _tempData.ordId);
          if(_index != -1){
            if(_tempData.state == 'canceled'){
              _accountOrderList.removeAt(_index);
            }else if(_tempData.state == 'filled'){
              _accountOrderList.removeAt(_index);
            }else if(_tempData.state == 'partially_filled'){
              _accountOrderList.removeAt(_index);
              _accountOrderList.insert(_index, _tempData);
            }else{

            }
          }else{
            _accountOrderList.insert(0, _tempData);
          }
        }
        else{

        }
      }
    }catch(e){
      print(e);
    }

  }

  onDone(){
    print("数字货币公有WebSocket错误");
    _isSocektOn = false;
  }

  onDonePrivate(){
    print("数字货币私有WebSocket错误");
    _isPrivateSocektOn = false;
  }

  onRest(){
    print("数字货币WebSocket重连");
    _channel=IOWebSocketChannel.connect(kDigitalSocketAddress);//brokerId=9999
    _isSocektOn = true;
    _channel.stream.listen(onData, onError: onError, onDone: onDone);
    _onSendInstruments();
  }

  onPrivateRest(){
    print("数字货币私有WebSocket重连");
    _channelPrivate=IOWebSocketChannel.connect(kDigitalSocketPrivateAddress);//brokerId=9999
    _isPrivateSocektOn = true;
    _channelPrivate.stream.listen(onDataPrivate, onError: onErrorPrivate, onDone: onDonePrivate);
    if(_indexApi == ''){
      _DigitalcurrencyExchangeapiListHttp();
    }else{
      _DigitalcurrencyOkexPrivateGetWebsocketSignHttp();
    }
  }

  onError(err){
    print("数字货币公有WebSocket错误");
    WebSocketChannelException ex = err;
    print(ex);
    _isSocektOn = false;
  }

  onErrorPrivate(err){
    print("数字货币私有WebSocket错误");
    WebSocketChannelException ex = err;
    print(ex);
    _isPrivateSocektOn = false;
  }

  void _timeToPing(){
    if(_timer != null){
      _timer!.cancel();
    }
    if(_isSocektOn){
      _timer = Timer(const Duration(seconds: 10), (){
        _channel.sink.add('ping');
        // print("ping");
      });
    }
  }

  void _privateTimeToPing(){
    if(_privateTimer != null){
      _privateTimer!.cancel();
    }
    if(_isSocektOn){
      _privateTimer = Timer(const Duration(seconds: 10), (){
        _channelPrivate.sink.add('ping');
        // print("ping");
      });
    }
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer!.cancel();
    }
    if(_privateTimer != null){
      _privateTimer!.cancel();
    }
    neverBus.off('pageController');
    neverBus.off('LoginSuccess');
    neverBus.off('DigitalTransactionRefresh');
    super.dispose();
  }

  //逻辑 ： 读取硬盘中的文件，若不存在或存在错误，请求接口。
  void _readLocalAndFirst() async{
    await _readCounter("DigitalCurrency.txt");
    if(_localJosnData != ''){
      try{
        Map _josnData = jsonDecode(_localJosnData);
        if(_josnData.isEmpty){
          return;
        }
        if(!mounted){
          return;
        }
        setState(() {
          //币币
          _spotList =  DigitalCurrencyListResponseModel.fromJson(_josnData).spot;
          _spotList!.removeWhere((e) => e.state != "live");
          //永续
          _perpetualList = DigitalCurrencyListResponseModel.fromJson(_josnData).swap;
          _perpetualList!.removeWhere((e) => e.state != "live");
          //交割
          _futuresList = DigitalCurrencyListResponseModel.fromJson(_josnData).futures;
          _futuresList!.removeWhere((e) => e.state != "live");
          //杠杆
          _marginList = DigitalCurrencyListResponseModel.fromJson(_josnData).margin;
          _marginList!.removeWhere((e) => e.state != "live");
          //期权
          _optionsList = DigitalCurrencyListResponseModel.fromJson(_josnData).options;
          _optionsList!.removeWhere((e) => e.state != "live");

          if(_selectIndexInstId == ''){
            _selectIndexInstId = _spotList!.first.instId!;
            _selectIndexCurrency = _spotList!.first.baseCcy!;
            _tradesList.clear();
            _onSubscribeTickers(_selectIndexInstId);
            _DigitalcurrencyOkexMarketGetCandlesticksHttp(instId: _selectIndexInstId);
          }
          if(_selectIndexType == 'spot'){
            _selectListlength = _spotList!.length;//现货
          }else if(_selectIndexType == 'perpetual'){
            _selectListlength = _perpetualList!.length;//永续
          }else if(_selectIndexType == 'futures'){
            _selectListlength = _futuresList!.length;//交割
          }else if(_selectIndexType == 'margin'){
            _selectListlength = _marginList!.length;//杠杆
          }else if(_selectIndexType == 'options'){
            _selectListlength = _optionsList!.length;//期权
          }else{
            _selectListlength = 0;
          }
        });
      }catch(e){
        _DigitalcurrencyOkexPubilcInstrumentsnHttp();
      }
    }else{
      _DigitalcurrencyOkexPubilcInstrumentsnHttp();
    }
  }

  //获取 全5类币对
  Future _DigitalcurrencyOkexPubilcInstrumentsnHttp() async{
    var response = await DigitalcurrencyOkexPubilcInstruments();

    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        Map _josnData = jsonDecode(response['object']);
        if(_josnData.isEmpty){
          return;
        }
        _writeCounter('DigitalCurrency.txt',response['object']);
        setState(() {
          //币币
          _spotList =  DigitalCurrencyListResponseModel.fromJson(_josnData).spot;
          _spotList!.removeWhere((e) => e.state != "live");
          //永续
          _perpetualList = DigitalCurrencyListResponseModel.fromJson(_josnData).swap;
          _perpetualList!.removeWhere((e) => e.state != "live");
          //交割
          _futuresList = DigitalCurrencyListResponseModel.fromJson(_josnData).futures;
          _futuresList!.removeWhere((e) => e.state != "live");
          //杠杆
          _marginList = DigitalCurrencyListResponseModel.fromJson(_josnData).margin;
          _marginList!.removeWhere((e) => e.state != "live");
          //期权
          _optionsList = DigitalCurrencyListResponseModel.fromJson(_josnData).options;
          _optionsList!.removeWhere((e) => e.state != "live");

          if(_selectIndexInstId == ''){
            _selectIndexInstId = _spotList!.first.instId!;
            _selectIndexCurrency = _spotList!.first.baseCcy!;
            _tradesList.clear();
            _onSubscribeTickers(_selectIndexInstId);
            _DigitalcurrencyOkexMarketGetCandlesticksHttp(instId: _selectIndexInstId);
          }
          if(_selectIndexType == 'spot'){
            _selectListlength = _spotList!.length;//现货
          }else if(_selectIndexType == 'perpetual'){
            _selectListlength = _perpetualList!.length;//永续
          }else if(_selectIndexType == 'futures'){
            _selectListlength = _futuresList!.length;//交割
          }else if(_selectIndexType == 'margin'){
            _selectListlength = _marginList!.length;//杠杆
          }else if(_selectIndexType == 'options'){
            _selectListlength = _optionsList!.length;//期权
          }else{
            _selectListlength = 0;
          }
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取币对]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取币对]遇到问题，请检查网络或重新刷新');
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
              _DigitalcurrencyOkexPrivateGetWebsocketSignHttp();
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

  //获取用户API配置列表 - 新增后调用
  Future _DigitalcurrencyExchangeapiListSignHttp() async{
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
              print(_indexApi);
            }
          }catch(e){
            _indexApi = '';
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

  //私有类 登录内容获取
  Future _DigitalcurrencyOkexPrivateGetWebsocketSignHttp() async{
    var response = await DigitalcurrencyOkexPrivateGetWebsocketSign( apiKey: _indexApi);

    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        try{
          final key = encrypt.Key.fromUtf8(response['object']['salt']);
          final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
          final encryptedString = encrypter.decrypt64(response['object']['sign'], iv: iv);
          _channelPrivate.sink.add(encryptedString);
          _privateTimeToPing();
          Future.delayed(const Duration(seconds: 1)).then((onValue) async{
            _onSendPrivate();
          });
        }catch(e){
          showMyCustomText("登陆失败,请检查网络");
        }
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取数字货币账户类信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取数字货币账户类信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //历史委托
  Future _DigitalcurrencyOkexTradeGetOrderHistory7daysHttp() async{
    String _instType = '';
    if(_selectIndexType.toUpperCase() == 'OPTIONS'){
      _instType = 'OPTION';
    }else if(_selectIndexType.toUpperCase() == 'PERPETUAL'){
      _instType = 'SWAP';
    }else{
      _instType = _selectIndexType.toUpperCase();
    }
    var response = await DigitalcurrencyOkexTradeGetOrderHistory7days(apiKey: _indexApi,instType: _instType);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == "200"){
        setState(() {
          _accountOrderHistoryList = (response['data'] as List).map((i) => DigitalCurrencyTradeGetOrderHistory.fromJson(i)).toList();
        });
      }else{
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[数字货币历史委托]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[数字货币历史委托]遇到问题，请检查网络或重新刷新');
      }
    }

  }

  //当前委托
  Future _DigitalcurrencyOkexTradeGetOrderListHttp() async{
    var response = await DigitalcurrencyOkexTradeGetOrderList(apiKey: _indexApi);
    print(response);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == "200"){
        setState(() {
          _accountOrderList = (response['data'] as List).map((i) => DigitalCurrencyTradeGetOrderHistory.fromJson(i)).toList();
        });
      }else{
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[数字货币当前委托]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[数字货币当前委托]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //单币种 获取最大可用数量
  Future _DigitalcurrencyOkexAccountGetMaximumAvailableTradableAmountHttp(String instId)async{
    var response = await DigitalcurrencyOkexAccountGetMaximumAvailableTradableAmount(apiKey: _indexApi,instId:instId,tdMode: "cross",ccy: _selectIndexCurrency);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response["code"] == "200"){
        setState(() {
          try{
            String _thisInstId = response['data'][0]['instId'].toString();
            List _thisIdTag = _thisInstId.split("-");
            String _thisNumTT = '';
            String _thisPriceTT = '';
            if(_thisIdTag.length >= 2){
              _thisPriceTT =  _thisIdTag[1] ;
              _thisNumTT =  _thisIdTag.first ;
            }else{
              _thisNumTT = '';
              _thisPriceTT = '';
            }
            _thisAvailBuy = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(response['data'][0]['availBuy'].toString()), 2)).toString() + ' ' + _thisPriceTT;
            _thisAvailSell = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(response['data'][0]['availSell'].toString()), 8)).toString() + ' ' + _thisNumTT;
          }catch(e){
            _thisAvailBuy = "-";
            _thisAvailSell = "-";
          }
        });
      }else{
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[数字货币获取最大可用数量]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[数字货币获取最大可用数量]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //单币种 获取最大可交易数量
  Future _DigitalcurrencyOkexAccountGtMaximumTradableSizeForInstrumentHttp(String instId)async{
    var response = await DigitalcurrencyOkexAccountGtMaximumTradableSizeForInstrument(apiKey: _indexApi,instId:instId,tdMode: "cross",ccy: _selectIndexCurrency);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == "200"){
        setState(() {
          try{
            String _thisInstId = response['data'][0]['instId'].toString();
            List _thisIdTag = _thisInstId.split("-");
            String _thisNumTT = '';
            String _thisPriceTT = '';
            if(_thisIdTag.length >= 2){
              _thisPriceTT =  _thisIdTag[1] ;
              _thisNumTT =  _thisIdTag.first ;
            }else{
              _thisNumTT = '';
              _thisPriceTT = '';
            }
            _thisMaxBuy = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(response['data'][0]['maxBuy'].toString()), 8)).toString() + ' ' + _thisNumTT;
            _thisMaxSell = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(response['data'][0]['maxSell'].toString()), 2)).toString() + ' ' + _thisPriceTT;
          }catch(e){
            _thisMaxBuy = "-";
            _thisMaxSell = "-";
          }
        });
      }else{
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[数字货币获取最大可交易数量]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[数字货币获取最大可交易数量]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //下单
  Future _DigitalcurrencyOkexTradePlaceOrderHttp(String side,String ordType,String sz) async{
    if(_indexApi == ''){
      showMyCustomText("未获取到APIKey,无法执行下单操作");
      return;
    }
    var response = await DigitalcurrencyOkexTradePlaceOrder(
      instId: _selectIndexInstId,
      tdMode: 'cross',
      side:side,
      ordType: ordType,
      sz:sz,
      px:_transactionPriceController.text,
      apiKey: _indexApi,
    );

    _transactionNumberController.text = '';
    _transactionAmountController.text = '';
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == "200"){
        if(response['data'][0]['sCode'].toString() == '0'){
          showMyCustomText("下单成功");
          neverBus.emit('DigitalTransactionRefresh');
        }else{
          showMyCustomText("下单失败");
        }
      }else{
        try{
         showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText(e.toString());
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[数字货币下单]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //委托策略下单
  Future _DigitalcurrencyOkexTradePlaceAlgoOrderHttp(String side,String sz,{String tpTriggerPx = '',String tpOrdPx = '',String slTriggerPx = '',String slOrdPx = ''}) async{
    if(_indexApi == ''){
      showMyCustomText("未获取到APIKey,无法执行下单操作");
      return;
    }
    var response = await DigitalcurrencyOkexTradePlaceAlgoOrder(
      instId: _selectIndexInstId,
      tdMode: 'cross',
      side:side,
      ordType: 'conditional',
      sz:sz,
      apiKey: _indexApi,
      tpTriggerPx:tpTriggerPx,
      tpOrdPx:tpOrdPx,
      slTriggerPx:slTriggerPx,
      slOrdPx:slOrdPx,
    );
    _tpslTriggerPxController.text = '';
    _tpslOrdPxController.text = '';
    _tpslPxAmountController.text = '';
    print(response);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == "200"){
        if(response['data'][0]['sCode'].toString() == '0'){
          showMyCustomText("下单成功");
          neverBus.emit('DigitalTransactionRefresh');
        }else{
          showMyCustomText("下单失败");
        }
      }else{
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText(e.toString());
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('遇到问题，请检查网络或重新刷新');
      }
    }
  }


  //批量撤单
  Future _DigitalcurrencyOkexTradeCancelMultipleOrdersHttp() async{
    if(_indexApi == ''){
      showMyCustomText("未获取到APIKey,无法执行批量撤单操作");
      return;
    }
    var response = await DigitalcurrencyOkexTradeCancelMultipleOrders(apiKey: _indexApi,instId: _selectIndexInstId);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == "200"){
        if(response['data'][0]['sCode'].toString() == '0'){
          showMyCustomText("批量撤单成功");
        }else{
          showMyCustomText("批量撤单失败");
        }
      }else{
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText(e.toString());
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[数字货币批量撤单]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //撤单
  Future _DigitalcurrencyOkexTradeCancelOrderHttp(String instId,String ordId) async{
    if(_indexApi == ''){
      showMyCustomText("未获取到APIKey,无法执行撤单操作");
      return;
    }
    var response = await DigitalcurrencyOkexTradeCancelOrder(apiKey: _indexApi,instId: instId,ordId: ordId);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == "200"){
        if(response['data'][0]['sCode'].toString() == '0'){
          showMyCustomText("撤单成功");
        }else{
          showMyCustomText("撤单失败");
        }
      }else{
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText(e.toString());
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[数字货币撤单]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //获取 KLine
  Future _DigitalcurrencyOkexMarketGetCandlesticksHttp({String instId = ''}) async{
    String _thisBar = '5m';
    if(_selectKlineTimeTypeName == '1分'){
      _thisBar = '1m';
    }else if(_selectKlineTimeTypeName == '5分'){
      _thisBar = '5m';
    }else if(_selectKlineTimeTypeName == '15分'){
      _thisBar = '15m';
    }else if(_selectKlineTimeTypeName == '30分'){
      _thisBar = '30m';
    }else if(_selectKlineTimeTypeName == '60分'){
      _thisBar = '1H';
    }else if(_selectKlineTimeTypeName == '1日'){
      _thisBar = '1D';
    }else if(_selectKlineTimeTypeName == '分时'){
      _thisBar = '1m';
    }
    var response = await DigitalcurrencyOkexMarketGetCandlesticks(instId: instId,bar :_thisBar);
    //
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == "200"){
        setState(() {
          List klineModel = response["data"];
          _KLineList = klineModel.map((item) => KLineEntity.okexfromJson(item)).toList().reversed.toList().cast<KLineEntity>();
          DataUtil.calculate(_KLineList!);
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[数字货币获取Kline]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[数字货币获取Kline]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //获取缓存文件地址
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //读本地缓存文件
  _readCounter(String fileName) async {
    try {
      final path = await _localPath;
      final file = File('$path/$fileName');
      _localJosnData = await file.readAsString();
    } catch (e) {
      _localJosnData = '';
    }
  }

  //写本地缓存文件
  Future<File> _writeCounter(String fileName,dynamic message) async {
    final path = await _localPath;
    final file = File('$path/$fileName');
    return file.writeAsString("$message");
  }


  @override
  Widget build(BuildContext context) {

    String  _selectIndexupDownRateStr = '-';
    Color  _selectIndexupDownRateColor = Colors.white;

    try{
      if(_selectIndexLast != null && _selectIndexSodUtc8 != null && neverDoubleTryOrZero(_selectIndexSodUtc8) != 0) {
        double _upDownRateDobule = (neverDoubleTryOrZero(_selectIndexLast) - neverDoubleTryOrZero(_selectIndexSodUtc8)) / neverDoubleTryOrZero(_selectIndexSodUtc8);
        if(_upDownRateDobule > 0){
          _selectIndexupDownRateStr = '+' + (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _selectIndexupDownRateColor = APP_MainGreenColor;
        }else if(_upDownRateDobule == 0){
          _selectIndexupDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _selectIndexupDownRateColor = Colors.white;
        }else{
          _selectIndexupDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _selectIndexupDownRateColor = APP_MainRedColor;
        }

      }else{
        _selectIndexupDownRateStr = '-';
        _selectIndexupDownRateColor = Colors.white;
      }
    }catch(e){
      _selectIndexupDownRateStr = '-';
      _selectIndexupDownRateColor = Colors.white;
    }

    return SafeArea(
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("数字货币"),
        ),
        body:GestureDetector(
          child: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  decoration: const BoxDecoration(
                    color: APP_MainBarColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: GestureDetector(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Text(_selectIndexInstId,style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                                  ),
                                  Icon(_isShowCurrencyPick ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,color: Colors.white,size: 30,)
                                ],
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  _isShowCurrencyPick = !_isShowCurrencyPick;
                                });
                              },
                            ),
                            alignment: Alignment.center,
                          ),
                          Container(
                            width: 120,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(_selectIndexLast,style: TextStyle(fontSize: 14,color: _selectIndexupDownRateColor,fontWeight: FontWeight.w500),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Text(_selectIndexupDownRateStr,style: TextStyle(fontSize: 13,color: _selectIndexupDownRateColor),),
                                  alignment: Alignment.centerLeft,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: const Text("美元价格",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  alignment: Alignment.center,
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: const Text("\$1.00",style: TextStyle(fontSize: 14,color: Colors.white),),
                                  alignment: Alignment.center,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: const Text("24小时最低价",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  alignment: Alignment.center,
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Text(_selectIndexLow24h,style: const TextStyle(fontSize: 14,color: Colors.white),),
                                  alignment: Alignment.center,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: const Text("24小时最高价",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  alignment: Alignment.center,
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Text(_selectIndexHigh24h,style: const TextStyle(fontSize: 14,color: Colors.white),),
                                  alignment: Alignment.center,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: const Text("24小时成交量",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  alignment: Alignment.center,
                                ),
                                Container(
                                  child: Text(_selectIndexVol24h,style: const TextStyle(fontSize: 14,color: Colors.white),),
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  alignment: Alignment.center,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),//头部选择币种栏
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: const Alignment(-1,0),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: _SpotWidget(),
                              color: Colors.transparent,
                            ),
                            flex: 3,
                          ),
                          Container(
                            width: 280,
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            padding: const EdgeInsets.fromLTRB(2, 0, 3, 5),
                            child: _TransactionPanelWidget(),
                          ),
                        ],
                      ),
                      Offstage(
                        offstage: _isShowCurrencyPick,
                        child: GestureDetector(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: APP_MainViewColor,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10, //阴影范围
                                  spreadRadius: 1, //阴影浓度
                                  color: Colors.black, //阴影颜色
                                  offset:Offset(3,3),
                                ),
                              ],
                            ),
                            width: 350,
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Container(
                                  height:45,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      labelStyle: const TextStyle(color: Colors.grey),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                                      ),
                                      disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                      ),
                                      suffixIcon:_currencyController.text.isNotEmpty ?  IconButton(
                                        onPressed: (){
                                          setState(() {
                                            _currencyController.clear();
                                            _screenList!.clear();
                                          });
                                        },
                                        icon: const Icon(Icons.cancel,size: 14,color: APP_MainGreenColor,),
                                      ) : null,
                                      hintText: '搜索 币种/币对/合约',
                                      hintStyle: const TextStyle(color: Colors.grey,fontSize: 13),
                                    ),
                                    controller: _currencyController,
                                    autocorrect:false,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(color: Colors.white,fontSize: 13),
                                    onChanged: (value){
                                      setState(() {
                                        value = value.toUpperCase();
                                        _sceenListFuture(value);
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  child:Row(
                                    children: [
                                      Expanded(
                                        child:_selectIndexItemView('spot','币币'),
                                      ),
                                      Expanded(
                                        child:_selectIndexItemView('perpetual','永续'),
                                      ),
                                      Expanded(
                                        child:_selectIndexItemView('futures','交割'),
                                      ),
                                      Expanded(
                                        child:_selectIndexItemView('margin','杠杆'),
                                      ),
                                      Expanded(
                                        child:_selectIndexItemView('options','期权'),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(0),
                                  alignment: Alignment.center,
                                ),
                                Offstage(
                                  offstage: (_selectIndexType == 'spot' || _selectIndexType == 'margin') ? false :true,
                                  child: DigitalCurrencyView_SpotAndMarginTitle(),
                                ),
                                Offstage(
                                  offstage: (_selectIndexType == 'perpetual' || _selectIndexType == 'futures') ? false :true,
                                  child: DigitalCurrencyView_PerpetualAndFuturesTitle(),
                                ),
                                Offstage(
                                  offstage: (_selectIndexType == 'options') ? false :true,
                                  child: DigitalCurrencyView_OptionsTitle(),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ListView.builder(
                                      controller: _controller1,
                                      itemBuilder: (context,index){
                                        if(_selectIndexType == 'spot'){
                                          if(_currencyController.text.isNotEmpty){
                                            return _SpotCell(_screenList![index]);
                                          }else{
                                            return _SpotCell(_spotList![index]);
                                          }
                                        }else if(_selectIndexType == 'perpetual'){
                                          if(_currencyController.text.isNotEmpty){
                                            return _PerpetualCell(_screenList![index]);
                                          }else{
                                            return _PerpetualCell(_perpetualList![index]);
                                          }
                                        }else if(_selectIndexType == 'futures'){
                                          if(_currencyController.text.isNotEmpty){
                                            return _FuturesCell(_screenList![index]);
                                          }else{
                                            return _FuturesCell(_futuresList![index]);
                                          }
                                        }else if(_selectIndexType == 'margin'){
                                          if(_currencyController.text.isNotEmpty){
                                            return _MarginCell(_screenList![index]);
                                          }else{
                                            return _MarginCell(_marginList![index]);
                                          }
                                        }else if(_selectIndexType == 'options'){
                                          if(_currencyController.text.isNotEmpty){
                                            return _OptionsCell(_screenList![index]);
                                          }else{
                                            return _OptionsCell(_optionsList![index]);
                                          }
                                        }else{
                                          return Container();
                                        }

                                      },
                                      itemCount: _currencyController.text.isNotEmpty ? _screenList!.length : _selectListlength,
                                    ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          behavior: HitTestBehavior.opaque,
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              _isShowCurrencyPick = true;
            });
          },
        )
      ),
    );
  }


  //合约类型选择按钮组件
  Widget _selectIndexItemView(String type,String typeName){
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(typeName,style: TextStyle(color:_selectIndexType == type ? Colors.white : Colors.grey),),
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            ),
            Container(
              color: _selectIndexType == type ? APP_MainGreenColor : Colors.transparent,
              child: Text(typeName,style: const TextStyle(color: Colors.white),),
              alignment: Alignment.center,
              height: 2,
            )
          ],
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      ),
      behavior: HitTestBehavior.opaque,
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          _selectIndexType = type;
          if(_currencyController.text.isNotEmpty){
            _sceenListFuture(_currencyController.text.toUpperCase());
          }else{
            if(_selectIndexType == 'spot'){
              _onSendTickersPretreatment(_spotList!);
              _selectListlength = _spotList!.length;//现货
            }else if(_selectIndexType == 'perpetual'){
              _onSendTickersPretreatment(_perpetualList!);
              _selectListlength = _perpetualList!.length;//永续
            }else if(_selectIndexType == 'futures'){
              _onSendTickersPretreatment(_futuresList!);
              _selectListlength = _futuresList!.length;//交割
            }else if(_selectIndexType == 'margin'){
              _onSendTickersPretreatment(_marginList!);
              _selectListlength = _marginList!.length;//杠杆
            }else if(_selectIndexType == 'options'){
              _onSendTickersPretreatment(_optionsList!);
              _selectListlength = _optionsList!.length;//期权
            }else{
              _selectListlength = 0;
            }
          }
        });
      },
    );
  }

  void _sceenListFuture(String value){
    if(_selectIndexType == 'spot'){
      _screenList = _spotList!.where((e) => e.instId!.startsWith(value)).toList();
    }else if(_selectIndexType == 'perpetual'){
      _screenList = _perpetualList!.where((e) => e.instId!.startsWith(value)).toList();
    }else if(_selectIndexType == 'futures'){
      _screenList = _futuresList!.where((e) => e.instId!.startsWith(value)).toList();
    }else if(_selectIndexType == 'margin'){
      _screenList = _marginList!.where((e) => e.instId!.startsWith(value)).toList();
    }else if(_selectIndexType == 'options'){
      _screenList = _optionsList!.where((e) => e.instId!.startsWith(value)).toList();
    }else{
      _screenList!.clear();
    }
  }

  //币种列表
  Widget _SpotWidget(){

    String  _selectIndexupDownRateStr = '-';
    Color  _selectIndexupDownRateColor = Colors.white;

    try{
      if(_selectIndexLast != null && _selectIndexSodUtc8 != null && neverDoubleTryOrZero(_selectIndexSodUtc8) != 0) {
        double _upDownRateDobule = (neverDoubleTryOrZero(_selectIndexLast) - neverDoubleTryOrZero(_selectIndexSodUtc8)) / neverDoubleTryOrZero(_selectIndexSodUtc8);
        if(_upDownRateDobule > 0){
          _selectIndexupDownRateStr = '↑';
          _selectIndexupDownRateColor = APP_MainGreenColor;
        }else if(_upDownRateDobule == 0){
          _selectIndexupDownRateStr = ' ';
          _selectIndexupDownRateColor = Colors.white;
        }else{
          _selectIndexupDownRateStr = '↓';
          _selectIndexupDownRateColor = APP_MainRedColor;
        }

      }else{
        _selectIndexupDownRateStr = ' ';
        _selectIndexupDownRateColor = Colors.white;
      }
    }catch(e){
      _selectIndexupDownRateStr = ' ';
      _selectIndexupDownRateColor = Colors.white;
    }

    List _thisIdTag = _selectIndexInstId.split("-");
    String _thisNumTT = '';
    String _thisPriceTT = '';
    if(_thisIdTag.length >= 2){
      _thisPriceTT =  _thisIdTag[1] ;
      _thisNumTT =  _thisIdTag.first ;
    }else{
      _thisNumTT = '';
      _thisPriceTT = '';
    }


    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 30,
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
                                        color: _selectKlineTimeTypeName == _klineTimeTypeAllList[index] ? APP_MainGreenColor : Colors.transparent,
                                        child: const Text('',style: TextStyle(color: Colors.transparent),),
                                        alignment: Alignment.topCenter,
                                        height: 4,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_klineTimeTypeAllList[index],style: const TextStyle(color: Colors.white),),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          color: _selectKlineTimeTypeName == _klineTimeTypeAllList[index] ? APP_MainBGColor : Colors.transparent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              ),
                              onTap: (){
                                setState(() {
                                  _selectKlineTimeTypeName = _klineTimeTypeAllList[index];
                                  if(_isSocektOn){
                                    _onSendUnKline(_selectIndexInstId);
                                  }
                                  if(_selectKlineTimeTypeName == '1分'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "candle1m";
                                  }else if(_selectKlineTimeTypeName == '5分'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "candle5m";
                                  }else if(_selectKlineTimeTypeName == '15分'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "candle15m";
                                  }else if(_selectKlineTimeTypeName == '30分'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "candle30m";
                                  }else if(_selectKlineTimeTypeName == '60分'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "candle1H";
                                  }else if(_selectKlineTimeTypeName == '1日'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "candle1D";
                                  }else if(_selectKlineTimeTypeName == '分时'){
                                    _isTimeLine = true;
                                    _selectKlineTimeType = "candle1m";
                                  }
                                  _DigitalcurrencyOkexMarketGetCandlesticksHttp(instId: _selectIndexInstId);

                                  if(_isSocektOn){
                                    _onSendKline(_selectIndexInstId);
                                  }

                                });
                              },
                            );
                          },
                          itemCount: _klineTimeTypeAllList.length,
                        ),
                        margin: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.fromLTRB(3, 3, 0, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 30,
                                color: APP_MainBarColor,
                                alignment: Alignment.centerLeft,
                                child: ListView.builder(
                                  controller: _controller3,
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
                                                color: _mainStateName == _mainStateList[index] ? APP_MainGreenColor : Colors.transparent,
                                                child: const Text('',style: TextStyle(color: Colors.transparent),),
                                                alignment: Alignment.topCenter,
                                                height: 4,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(_mainStateList[index],style: const TextStyle(color: Colors.white),),
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                  color: _mainStateName == _mainStateList[index] ? APP_MainBGColor : Colors.transparent,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      ),
                                      onTap: (){
                                        setState(() {
                                          _mainStateName = _mainStateList[index];
                                          if(_mainStateName == 'MA'){
                                            _mainState = MainState.MA;
                                          }else if(_mainStateName == 'BOLL'){
                                            _mainState = MainState.BOLL;
                                          }else if(_mainStateName == 'NONE'){
                                            _mainState = MainState.NONE;
                                          }else{

                                          }
                                        });
                                      },
                                    );
                                  },
                                  itemCount: _mainStateList.length,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 30,
                                color: APP_MainBarColor,
                                alignment: Alignment.centerLeft,
                                child: ListView.builder(
                                  controller: _controller4,
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
                                                color: _secondaryStateName == _secondaryStateList[index] ? APP_MainGreenColor : Colors.transparent,
                                                child: const Text('',style: TextStyle(color: Colors.transparent),),
                                                alignment: Alignment.topCenter,
                                                height: 4,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(_secondaryStateList[index],style: const TextStyle(color: Colors.white),),
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                  color: _secondaryStateName == _secondaryStateList[index] ? APP_MainBGColor : Colors.transparent,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      ),
                                      onTap: (){
                                        setState(() {

                                          //{ MACD, KDJ, RSI, WR, CCI, NONE }

                                          _secondaryStateName = _secondaryStateList[index];
                                          if(_secondaryStateName == 'NONE'){
                                            _secondaryState = SecondaryState.NONE;
                                          }else if(_secondaryStateName == 'MACD'){
                                            _secondaryState = SecondaryState.MACD;
                                          }else if(_secondaryStateName == 'KDJ'){
                                            _secondaryState = SecondaryState.KDJ;
                                          }else if(_secondaryStateName == 'RSI'){
                                            _secondaryState = SecondaryState.RSI;
                                          }else if(_secondaryStateName == 'WR'){
                                            _secondaryState = SecondaryState.WR;
                                          }else if(_secondaryStateName == 'CCI'){
                                            _secondaryState = SecondaryState.CCI;
                                          }
                                        });
                                      },
                                    );
                                  },
                                  itemCount: _secondaryStateList.length,
                                ),
                                margin: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: KChartWidget(
                            _KLineList,
                            _chartStyle, // Required for styling purposes
                            _chartColors,// Required for styling purposes
                            // Required，Data must be an ordered list，(history=>now)
                            isLine: _isTimeLine,// Decide whether it is k-line or time-sharing
                            mainState: _mainState,// Decide what the main view shows
                            secondaryState: _secondaryState,// Decide what the sub view shows
                            fixedLength: 4,// Displayed decimal precision
                            timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                            onLoadMore: (bool a) {},// Called when the data scrolls to the end. When a is true, it means the user is pulled to the end of the right side of the data. When a
                            // is false, it means the user is pulled to the end of the left side of the data.
                            maDayList: const [5,10,20],// Display of MA,This parameter must be equal to DataUtil.calculate‘s maDayList
                            bgColor: const [Colors.black, Colors.black],// The background color of the chart is gradient
                            isChinese: true,// Graphic language
                            volHidden: false,// hide volume
                            isOnDrag: (isDrag){
                            },// true is on Drag.Don't load data while Draging.
                            onSecondaryTap:(){},// on secondary rect taped.
                            flingCurve : Curves.decelerate,
                            deviationwidth: -kLeftBarWidth, //自定义的一个偏移量
                            widgetWidth: MediaQuery.of(context).size.width > 595 ?
                            MediaQuery.of(context).size.width - kLeftBarWidth - kTransactionPanelWidth - (_spotWidgetHandicapShow ? kSpotWidth : 35 ) :
                            MediaQuery.of(context).size.width,
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      )
                    ],
                  ),
                ),
                _spotWidgetHandicapShow ? Container(
                  margin: const EdgeInsets.fromLTRB(3, 0, 1, 3),
                  width: 300,
                  color: APP_MainBGColor,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        color: APP_MainBarColor,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _controller5,
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
                                              color: _selectTransactionType == _selectTransactionTypeName[index] ? APP_MainGreenColor : Colors.transparent,
                                              child: const Text('',style: TextStyle(color: Colors.transparent),),
                                              alignment: Alignment.topCenter,
                                              height: 4,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(_selectTransactionTypeName[index],style: const TextStyle(color: Colors.white),),
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                color: _selectTransactionType == _selectTransactionTypeName[index] ? APP_MainBGColor : Colors.transparent,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        _selectTransactionType = _selectTransactionTypeName[index];
                                      });
                                    },
                                  );
                                },
                                itemCount: _selectTransactionTypeName.length,
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                child: Icon(_spotWidgetHandicapShow ? Icons.keyboard_arrow_right_rounded : Icons.keyboard_arrow_left_rounded,color: Colors.white,size: 25,),
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                setState(() {
                                  _spotWidgetHandicapShow = !_spotWidgetHandicapShow;
                                });

                              },
                            ),
                          ],
                        ),
                      ), //头部选择
                      Offstage(
                        offstage: _selectTransactionType == '委托订单' ? false : true,
                        child: DigitalCurrencyView_orderTitle(numTitle: _thisNumTT,priceTitle: _thisPriceTT),
                      ),
                      Offstage(
                        offstage: _selectTransactionType == '最新成交' ? false : true,
                        child: DigitalCurrencyView_tradeTitle(numTitle: _thisNumTT,priceTitle: _thisPriceTT),
                      ),
                      Expanded(
                        child:_selectTransactionType == '委托订单' ?
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: _controller6,
                                  reverse : true,
                                  itemBuilder: (context,index){
                                    String _priceNumStr = '-';
                                    double _priceDouble = neverDoubleTryOrZero(_tickAsksList[index][1].toString());
                                    _priceNumStr = _transformationNum(_priceDouble);
                                    String _total = '0';
                                    try{
                                      double _totalDouble = neverDoubleTryOrZero(_tickAsksTotalList.sublist(0, index+1).reduce((value, element) => value+element).toString());
                                      _total = _transformationNum(_totalDouble);
                                    }catch(e){
                                      _total = '0';
                                    }

                                    return Container(
                                      alignment: Alignment.center,
                                      color: APP_MainBGColor,
                                      width: 300,
                                      child: GestureDetector(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(_tickAsksList[index][0],style: const TextStyle(color: APP_MainRedColor,fontSize: 12),),
                                                alignment: Alignment.centerLeft,
                                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(_priceNumStr,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                                alignment: Alignment.centerRight,
                                                padding: const EdgeInsets.fromLTRB(3, 5, 0, 5),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(_total,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                                alignment: Alignment.centerRight,
                                                padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        behavior: HitTestBehavior.opaque,
                                        onTap: (){
                                          setState(() {
                                            _transactionPriceController.text = _tickAsksList[index][0];
                                          });
                                        },
                                      ),
                                    );
                                  },
                                  itemCount: _tickAsksList.length,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                color: APP_MainBarColor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(_selectIndexLast,style: TextStyle(fontSize: 14,color: _selectIndexupDownRateColor,fontWeight: FontWeight.w500),),
                                      alignment: Alignment.centerLeft,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Text(_selectIndexupDownRateStr,style: TextStyle(fontSize: 13,color: _selectIndexupDownRateColor),),
                                      alignment: Alignment.centerLeft,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: _controller7,
                                  itemBuilder: (context,index){

                                    String _priceNumStr = '-';
                                    double _priceDouble = neverDoubleTryOrZero(_tickBidsList[index][1].toString());
                                    _priceNumStr = _transformationNum(_priceDouble);
                                    String _total = '0';
                                    try{
                                      double _totalDouble = neverDoubleTryOrZero(_tickBidsTotalList.sublist(0, index+1).reduce((value, element) => value+element).toString());
                                      _total = _transformationNum(_totalDouble);
                                    }catch(e){
                                      _total = '0';
                                    }

                                    return Container(
                                      alignment: Alignment.center,
                                      color: APP_MainBGColor,
                                      width: 300,
                                      child: GestureDetector(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(_tickBidsList[index][0],style: const TextStyle(color: APP_MainGreenColor,fontSize: 12),),
                                                alignment: Alignment.centerLeft,
                                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(_priceNumStr,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                                alignment: Alignment.centerRight,
                                                padding: const EdgeInsets.fromLTRB(3, 5, 0, 5),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(_total,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                                alignment: Alignment.centerRight,
                                                padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        behavior: HitTestBehavior.opaque,
                                        onTap: (){
                                          setState(() {
                                            _transactionPriceController.text = _tickBidsList[index][0];
                                          });
                                        },
                                      ),
                                    );
                                  },
                                  itemCount: _tickBidsList.length,
                                ),
                              ),
                            ],
                          ),
                        ):
                        ListView.builder(
                          controller: _controller8,
                          itemBuilder: (context,index){
                            return Container(
                              alignment: Alignment.center,
                              color: APP_MainBGColor,
                              width: 300,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(_tradesList[index].px!,style: TextStyle(color: _tradesList[index].side == 'buy' ? APP_MainGreenColor : APP_MainRedColor,fontSize: 12),),
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(_tradesList[index].sz!,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.fromLTRB(3, 5, 0, 5),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(DateFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(_tradesList[index].ts!) ?? 0),
                                          [DateFormat.HH, ':', DateFormat.nn, ':', DateFormat.ss]),style: const TextStyle(color: Colors.white,fontSize: 12),),
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: _tradesList.length,
                        ),
                      ),
                    ],
                  ),
                ): Container(
                  margin: const EdgeInsets.fromLTRB(3, 0, 1, 3),
                  color: APP_MainBarColor,
                  width: 40,
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    child: Container(
                      child: Icon(_spotWidgetHandicapShow ? Icons.keyboard_arrow_right_rounded : Icons.keyboard_arrow_left_rounded,color: Colors.white,size: 25,),
                      padding: const EdgeInsets.fromLTRB(3, 8, 3, 0),
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      setState(() {
                        _spotWidgetHandicapShow = !_spotWidgetHandicapShow;
                      });

                    },
                  ),
                ),
              ],
            ),
          ),
          flex: 2,
        ),
        _accountWidgetShow ?  _accountWidget() :
        Container(
          padding: const EdgeInsets.fromLTRB(3, 0, 1, 3),
          child: _accountWidgetHead(),
        ),
      ],
    );
  }

  Widget _SpotCell(DigitalCurrencyUnifiedModel data){

    String _upDownRateStr = '-';
    Color _upDownRateColor = Colors.white;

    try{
      if(data.last != null && data.sodUtc8 != null && neverDoubleTryOrZero(data.sodUtc8!) != 0) {
        double _upDownRateDobule = (neverDoubleTryOrZero(data.last!) - neverDoubleTryOrZero(data.sodUtc8!)) / neverDoubleTryOrZero(data.sodUtc8!);
        if(_upDownRateDobule > 0){
          _upDownRateStr = '+' + (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = APP_MainGreenColor;
        }else if(_upDownRateDobule == 0){
          _upDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = Colors.white;
        }else{
          _upDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = APP_MainRedColor;
        }

      }else{
        _upDownRateStr = '-';
        _upDownRateColor = Colors.white;
      }
    }catch(e){
      _upDownRateStr = '-';
      _upDownRateColor = Colors.white;
    }

    return GestureDetector(
      child: Container(
        child:Row(
          children: [
            Expanded(
              child:Container(
                child: Text(data.instId!,style: const TextStyle(color: Colors.white,fontSize: 12),),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
              flex: 2,
            ),
            Expanded(
              child:Container(
                child: Text(data.last! == 'null' ? '-' : data.last!,style: const TextStyle(color: Colors.white,fontSize: 12),),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
            ),
            Expanded(
              child:Container(
                child: Text(_upDownRateStr,style: TextStyle(color: _upDownRateColor,fontSize: 12),),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
            )
          ],
        ),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        alignment: Alignment.center,

      ),
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          if(_selectIndexInstId != ''){
            _onUnsubscribeTickers(_selectIndexInstId);
          }
          _selectIndexInstId = data.instId!;
          _selectIndexMinSz = data.minSz!;
          _selectIndexInstType = data.instType!;
          _selectIndexCurrency = data.baseCcy!;
          _tradesList.clear();
          _onSubscribeTickers(_selectIndexInstId);
          _DigitalcurrencyOkexMarketGetCandlesticksHttp(instId: _selectIndexInstId);
          _isShowCurrencyPick = true;
        });
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  //永续
  Widget _PerpetualCell(DigitalCurrencyUnifiedModel data){

    String _upDownRateStr = '-';
    Color _upDownRateColor = Colors.white;

    try{
      if(data.last != null && data.sodUtc8 != null && neverDoubleTryOrZero(data.sodUtc8!) != 0) {
        double _upDownRateDobule = (neverDoubleTryOrZero(data.last!) - neverDoubleTryOrZero(data.sodUtc8!)) / neverDoubleTryOrZero(data.sodUtc8!);
        if(_upDownRateDobule > 0){
          _upDownRateStr = '+' + (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = APP_MainGreenColor;
        }else if(_upDownRateDobule == 0){
          _upDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = Colors.white;
        }else{
          _upDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = APP_MainRedColor;
        }

      }else{
        _upDownRateStr = '-';
        _upDownRateColor = Colors.white;
      }
    }catch(e){
      _upDownRateStr = '-';
      _upDownRateColor = Colors.white;
    }

    return GestureDetector(
      child: Container(
        child:Row(
          children: [
            Expanded(
              child:Container(
                child: Text(data.instId!,style: const TextStyle(color: Colors.white,fontSize: 12),),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
              flex: 2,
            ),
            Expanded(
              child:Container(
                child: Text(data.last! == 'null' ? '-' : data.last!,style: const TextStyle(color: Colors.white,fontSize: 12),),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
            ),
            Expanded(
              child:Container(
                child: Text(_upDownRateStr,style: TextStyle(color: _upDownRateColor,fontSize: 12),),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
            )
          ],
        ),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        alignment: Alignment.center,

      ),
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          if(_selectIndexInstId != ''){
            _onUnsubscribeTickers(_selectIndexInstId);
          }
          _selectIndexInstId = data.instId!;
          _selectIndexInstType = data.instType!;
          _selectIndexMinSz = data.minSz!;
          _selectIndexCurrency = data.baseCcy!;
          _tradesList.clear();
          _onSubscribeTickers(_selectIndexInstId);
          _DigitalcurrencyOkexMarketGetCandlesticksHttp(instId: _selectIndexInstId);
          _isShowCurrencyPick = true;
        });
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  //交割
  Widget _FuturesCell(DigitalCurrencyUnifiedModel data){
    String _aliasStr = '';
    if(data.alias == 'this_week'){
      _aliasStr = '当周';
    }else if(data.alias == 'next_week'){
      _aliasStr = '次周';
    }else if(data.alias == 'quarter'){
      _aliasStr = '当季';
    }else if(data.alias == 'next_quarter'){
      _aliasStr = '次季';
    }else{
      _aliasStr = '';
    }

    String _upDownRateStr = '-';
    Color _upDownRateColor = Colors.white;

    try{
      if(data.last != null && data.sodUtc8 != null && neverDoubleTryOrZero(data.sodUtc8!) != 0) {
        double _upDownRateDobule = (neverDoubleTryOrZero(data.last!) - neverDoubleTryOrZero(data.sodUtc8!)) / neverDoubleTryOrZero(data.sodUtc8!);
        if(_upDownRateDobule > 0){
          _upDownRateStr = '+' + (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = APP_MainGreenColor;
        }else if(_upDownRateDobule == 0){
          _upDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = Colors.white;
        }else{
          _upDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = APP_MainRedColor;
        }

      }else{
        _upDownRateStr = '-';
        _upDownRateColor = Colors.white;
      }
    }catch(e){
      _upDownRateStr = '-';
      _upDownRateColor = Colors.white;
    }

    return GestureDetector(
      child: Container(
        child:Row(
          children: [
            Expanded(
              child:Container(
                child: Text(data.instId! + ' ' + _aliasStr,style: const TextStyle(color: Colors.white,fontSize: 12),),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
              flex: 2,
            ),
            Expanded(
              child:Container(
                child: Text(data.last! == 'null' ? '-' : data.last!,style: const TextStyle(color: Colors.white,fontSize: 12),),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
            ),
            Expanded(
              child:Container(
                child: Text(_upDownRateStr,style: TextStyle(color: _upDownRateColor,fontSize: 12),),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
            )
          ],
        ),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        alignment: Alignment.center,

      ),
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          if(_selectIndexInstId != ''){
            _onUnsubscribeTickers(_selectIndexInstId);
          }
          _selectIndexInstId = data.instId!;
          _selectIndexInstType = data.instType!;
          _selectIndexMinSz = data.minSz!;
          _selectIndexCurrency = data.baseCcy!;
          _tradesList.clear();
          _onSubscribeTickers(_selectIndexInstId);
          _DigitalcurrencyOkexMarketGetCandlesticksHttp(instId: _selectIndexInstId);
          _isShowCurrencyPick = true;
        });
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  //杠杆
  Widget _MarginCell(DigitalCurrencyUnifiedModel data){

    String _upDownRateStr = '-';
    Color _upDownRateColor = Colors.white;

    try{
      if(data.last != null && data.sodUtc8 != null && neverDoubleTryOrZero(data.sodUtc8!) != 0) {
        double _upDownRateDobule = (neverDoubleTryOrZero(data.last!) - neverDoubleTryOrZero(data.sodUtc8!)) / neverDoubleTryOrZero(data.sodUtc8!);
        if(_upDownRateDobule > 0){
          _upDownRateStr = '+' + (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = APP_MainGreenColor;
        }else if(_upDownRateDobule == 0){
          _upDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = Colors.white;
        }else{
          _upDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = APP_MainRedColor;
        }

      }else{
        _upDownRateStr = '-';
        _upDownRateColor = Colors.white;
      }
    }catch(e){
      _upDownRateStr = '-';
      _upDownRateColor = Colors.white;
    }

    return GestureDetector(
      child: Container(
        child:Row(
          children: [
            Expanded(
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(data.instId!,style: const TextStyle(color: Colors.white,fontSize: 12),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(10, 0, 3, 0),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                    child: Text(data.lever! + 'X',style: const TextStyle(color: Colors.white,fontSize: 10),),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                  )
                ],
              ),
              flex: 2,
            ),
            Expanded(
              child:Container(
                child: Text(data.last! == 'null' ? '-' : data.last!,style: const TextStyle(color: Colors.white,fontSize: 12),),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
            ),
            Expanded(
              child:Container(
                child: Text(_upDownRateStr,style: TextStyle(color: _upDownRateColor,fontSize: 12),),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
            )
          ],
        ),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        alignment: Alignment.center,

      ),
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          if(_selectIndexInstId != ''){
            _onUnsubscribeTickers(_selectIndexInstId);
          }
          _selectIndexInstId = data.instId!;
          _selectIndexInstType = data.instType!;
          _selectIndexMinSz = data.minSz!;
          _selectIndexCurrency = data.baseCcy!;
          _tradesList.clear();
          _onSubscribeTickers(_selectIndexInstId);
          _DigitalcurrencyOkexMarketGetCandlesticksHttp(instId: _selectIndexInstId);
          _isShowCurrencyPick = true;
        });
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  //期权
  Widget _OptionsCell(DigitalCurrencyUnifiedModel data){

    String _upDownRateStr = '-';
    Color _upDownRateColor = Colors.white;

    try{
      if(data.last != null && data.sodUtc8 != null && neverDoubleTryOrZero(data.sodUtc8!) != 0) {
        double _upDownRateDobule = (neverDoubleTryOrZero(data.last!) - neverDoubleTryOrZero(data.sodUtc8!)) / neverDoubleTryOrZero(data.sodUtc8!);
        if(_upDownRateDobule > 0){
          _upDownRateStr = '+' + (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = APP_MainGreenColor;
        }else if(_upDownRateDobule == 0){
          _upDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = Colors.white;
        }else{
          _upDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule *100, 2))!.toStringAsFixed(2) + '%';
          _upDownRateColor = APP_MainRedColor;
        }

      }else{
        _upDownRateStr = '-';
        _upDownRateColor = Colors.white;
      }
    }catch(e){
      _upDownRateStr = '-';
      _upDownRateColor = Colors.white;
    }

    return GestureDetector(
      child: Container(
        child:Row(
          children: [
            Expanded(
              child:Container(
                child: Text(data.settleCcy! + '\n' + data.stk! ,style: const TextStyle(color: Colors.white,fontSize: 12),),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(10, 0, 3, 0),
              ),
              flex: 1,
            ),
            Expanded(
              child:Container(
                child: Text(data.optType == "C" ? "看涨" : '看跌' ,style: const TextStyle(color: Colors.white,fontSize: 12),),
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
              ),
              flex: 1,
            ),
            Expanded(
              child:Container(
                child: Text(data.last! == 'null' ? '-' : data.last!,style: const TextStyle(color: Colors.white,fontSize: 12),),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
            ),
            Expanded(
              child:Container(
                child: Text(_upDownRateStr,style: TextStyle(color: _upDownRateColor,fontSize: 12),),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
            )
          ],
        ),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        alignment: Alignment.center,

      ),
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          if(_selectIndexInstId != ''){
            _onUnsubscribeTickers(_selectIndexInstId);
          }
          _selectIndexInstId = data.instId!;
          _selectIndexInstType = data.instType!;
          _selectIndexMinSz = data.minSz!;
          _selectIndexCurrency = data.baseCcy!;
          _tradesList.clear();
          _onSubscribeTickers(_selectIndexInstId);
          _DigitalcurrencyOkexMarketGetCandlesticksHttp(instId: _selectIndexInstId);
          _isShowCurrencyPick = true;

        });
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  String _transformationNum(double num){
    if(num > 1000000000){//1,000,000,000
      return (NumUtil.getNumByValueDouble(num/1000000000.0, 3)).toString() + 'B';
    }else if(num > 1000000){//1,000,000,000
      return (NumUtil.getNumByValueDouble(num/1000000.0, 3)).toString() + 'M';
    }else if(num > 1000){//1,000,000,000
      return (NumUtil.getNumByValueDouble(num/1000.0, 3)).toString() + 'K';
    }else{
      return (NumUtil.getNumByValueDouble(num, 3)).toString();
    }
  }

  //交易面板
  Widget _TransactionPanelWidget(){

    List _thisIdTag = _selectIndexInstId.split("-");
    String _thisNumTT = '';
    String _thisPriceTT = '';
    String _thisNumInside = '';
    if(_thisIdTag.length >= 2){
      _thisPriceTT =  '(' + _thisIdTag[1] + ')';
      _thisNumTT =  '(' + _thisIdTag.first + ')';
      if(_selectIndexInstType == 'FUTURES' || _selectIndexInstType == 'OPTION' || _selectIndexInstType == 'SWAP'){
        _thisNumInside = '张';
      }else{
        _thisNumInside = _thisIdTag.first;
      }
    }else{
      _thisNumTT = '';
      _thisPriceTT = '';
      _thisNumInside = '';
    }
    return Container(
      color: APP_MainBGColor,
      child: Column(
        children: [
          Container(
            height: 40,
            color: APP_MainBarColor,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
              controller: _controller9,
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
                            color: _selectTransactionPanelType == _selectTransactionPanelTypeName[index] ? APP_MainGreenColor : Colors.transparent,
                            child: const Text('',style: TextStyle(color: Colors.transparent),),
                            alignment: Alignment.topCenter,
                            height: 4,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(_selectTransactionPanelTypeName[index],style: const TextStyle(color: Colors.white),),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              color: _selectTransactionPanelType == _selectTransactionPanelTypeName[index] ? APP_MainBGColor : Colors.transparent,
                            ),
                          )
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  ),
                  onTap: (){
                    setState(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _selectTransactionPanelType = _selectTransactionPanelTypeName[index];
                      _transactionNumberController.text = '';
                      if(_selectTransactionPanelType == '市价委托'){
                        _transactionPriceController.text = '';
                      }
                    });
                  },
                );
              },
              itemCount: _selectTransactionPanelTypeName.length,
            ),
          ), //头部选择
          _selectTransactionPanelType != '止盈止损' ?
          Container(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Column(
              children: [
                Container(
                  child: Text("价格" + _thisPriceTT,style: const TextStyle(fontSize: 12,color: Colors.grey),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                ),
                Container(
                  height: 30,
                  child: TextField(
                    enabled: _selectTransactionPanelType == '限价委托' ? true : false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      suffixText: '',
                      suffixStyle: const TextStyle(color: Colors.white,fontSize: 11),
                      hintText: _selectTransactionPanelType == '限价委托' ? '请输入单价' : '以当前市场最优价格下单',
                      hintStyle: const TextStyle(color: Colors.grey,fontSize: 11),
                    ),
                    controller: _transactionPriceController,
                    autocorrect:false,
                    keyboardType:const  TextInputType.numberWithOptions(
                      decimal : true,
                    ),
                    style: const TextStyle(color: Colors.white,fontSize: 11),
                    onChanged: (value){
                      if(value == ''){
                        _transactionAmountController.text = '';
                      }else{
                        if(_transactionNumberController.text != ''){
                          _transactionAmountController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) * neverDoubleTryOrZero(_transactionNumberController.text)), 8)).toString();
                        }
                      }
                    },
                  ),
                ),
                Container(
                  child: Text("数量" + _thisNumTT,style: const TextStyle(fontSize: 12,color: Colors.grey),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                ),
                Container(
                  height: 30,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      suffixText: '',
                      suffixStyle: const TextStyle(color: Colors.white,fontSize: 11),
                      hintText: '最小交易数量是' + _selectIndexMinSz + _thisNumInside,
                      hintStyle: const TextStyle(color: Colors.grey,fontSize: 11),
                    ),
                    controller: _transactionNumberController,
                    autocorrect:false,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal : true,
                    ),
                    style: const TextStyle(color: Colors.white,fontSize: 11),
                    onChanged: (value){
                      //这个是交易数量的变动
                      //1：价格变动 不影响这个的输入变动
                      //2：数量变动 会联动金额变动
                      //3：金额变动 会联动数量变动
                      if(value == ''){
                        _transactionAmountController.text = '';
                      }else{
                        if(_transactionPriceController.text != ''){
                          _transactionAmountController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) * neverDoubleTryOrZero(_transactionPriceController.text)), 8)).toString();
                        }
                      }
                    },
                  ),
                ),
                Container(
                  child: Text("金额" + _thisPriceTT,style: const TextStyle(fontSize: 12,color: Colors.grey),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                ),
                Container(
                  height: 30,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      suffixText: '',
                      suffixStyle: const TextStyle(color: Colors.white,fontSize: 11),
                      hintText: (_selectTransactionPanelType == '市价委托' && (_selectIndexInstType == 'SPOT')) ? '币币/杠杆市价买入需要输入金额' : '',
                      hintStyle: const TextStyle(color: Colors.grey,fontSize: 11),
                    ),
                    controller: _transactionAmountController,
                    autocorrect:false,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal : true,
                    ),
                    style: const TextStyle(color: Colors.white,fontSize: 11),
                    onChanged: (value){
                      if(value == ''){
                        _transactionNumberController.text = '';
                      }else{
                        if(_transactionPriceController.text != ''){
                          _transactionNumberController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) / neverDoubleTryOrZero(_transactionPriceController.text)), 8)).toString();
                        }
                      }
                    },
                  ),
                ),

                Container(
                  child: Row(
                    children: [
                      Container(
                        child: const Text("可用:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(_thisAvailBuy,style: const TextStyle(fontSize: 11,color: APP_MainGreenColor),),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: const Text("可买:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(_thisMaxBuy,style: const TextStyle(fontSize: 11,color: APP_MainGreenColor),),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                ),

                Container(
                  child: Row(
                    children: [
                      Container(
                        child: const Text("可用:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(_thisAvailSell,style: const TextStyle(fontSize: 11,color: APP_MainRedColor),),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: const Text("可卖:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(_thisMaxSell,style: const TextStyle(fontSize: 11,color: APP_MainRedColor),),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                ),

                const Divider(height: 1,color: Colors.grey,),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child:Container(
                            decoration: const BoxDecoration(
                              color: APP_MainGreenColor,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            alignment: Alignment.center,
                            child: const Text("买入",style: TextStyle(fontSize: 14,color: Colors.white),),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            String _nowType = 'limit';
                            if(_selectTransactionPanelType == '市价委托'){
                              _nowType = 'market';
                            }else{
                              _nowType = 'limit';
                            }

                            if(_selectTransactionPanelType == '限价委托'){
                              if(_transactionPriceController.text == ''){
                                showMyCustomText("请输入交易价格");
                                return;
                              }
                            }

                            if(_selectIndexInstType == 'SPOT' && _nowType == 'market'){
                              if(_transactionAmountController.text == ''){
                                showMyCustomText("币币/杠杆需要输入金额");
                                return;
                              }

                              _DigitalcurrencyOkexTradePlaceOrderHttp("buy",_nowType,_transactionAmountController.text);
                            }else{
                              if(_transactionNumberController.text == ''){
                                showMyCustomText("请输入交易数量");
                                return;
                              }else{
                                if(neverDoubleTryOrZero(_selectIndexMinSz) != 0.0){
                                  if(neverDoubleTryOrZero(_selectIndexMinSz) > neverDoubleTryOrZero(_transactionNumberController.text)){
                                    showMyCustomText("交易数量小于该币种最小交易数量");
                                    return;
                                  }
                                }
                              }

                              _DigitalcurrencyOkexTradePlaceOrderHttp("buy",_nowType,_transactionNumberController.text);
                            }


                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: GestureDetector(
                          child:Container(
                            decoration: const BoxDecoration(
                              color: APP_MainRedColor,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            alignment: Alignment.center,
                            child: const Text("卖出",style: TextStyle(fontSize: 14,color: Colors.white),),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            String _nowType = 'limit';
                            if(_selectTransactionPanelType == '市价委托'){
                              _nowType = 'market';
                            }else{
                              _nowType = 'limit';
                            }
                            
                            if(_selectTransactionPanelType == '限价委托'){
                              if(_transactionPriceController.text == ''){
                                showMyCustomText("请输入交易价格");
                                return;
                              }
                            }
                            if(_transactionNumberController.text == ''){
                              showMyCustomText("请输入交易数量");
                              return;
                            }
                            _DigitalcurrencyOkexTradePlaceOrderHttp("sell",_nowType,_transactionNumberController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1,color: Colors.grey,),
                Container(
                  child: const Text("目前买卖条件为 全仓、10倍杠杆,",style: TextStyle(fontSize: 11,color: Colors.grey),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                ),
              ],
            ),
          ) :
          Container(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Column(
              children: [
                Container(
                  child: Text("触发价格" + _thisPriceTT,style: const TextStyle(fontSize: 12,color: Colors.grey),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                ),
                Container(
                  height: 30,
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      suffixText: '',
                      suffixStyle: TextStyle(color: Colors.white,fontSize: 11),
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 11),
                    ),
                    controller: _tpslTriggerPxController,
                    autocorrect:false,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal : true,
                    ),
                    style: const TextStyle(color: Colors.white,fontSize: 11),
                    onChanged: (value){

                    },
                  ),
                ),
                Container(
                  child: Text("价格" + _thisPriceTT,style: const TextStyle(fontSize: 12,color: Colors.grey),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                ),
                Container(
                  height: 30,
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      suffixText: '',
                      suffixStyle: TextStyle(color: Colors.white,fontSize: 11),
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 11),
                    ),
                    controller: _tpslOrdPxController,
                    autocorrect:false,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal : true,
                    ),
                    style: const TextStyle(color: Colors.white,fontSize: 11),
                    onChanged: (value){

                    },
                  ),
                ),
                Container(
                  child: Text("数量" + _thisNumTT,style: const TextStyle(fontSize: 12,color: Colors.grey),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                ),
                Container(
                  height: 30,
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      suffixText: '',
                      suffixStyle: TextStyle(color: Colors.white,fontSize: 11),
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 11),
                    ),
                    controller: _tpslPxAmountController,
                    autocorrect:false,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal : true,
                    ),
                    style: const TextStyle(color: Colors.white,fontSize: 11),
                    onChanged: (value){

                    },
                  ),
                ),

                Container(
                  child: Row(
                    children: [
                      Container(
                        child: const Text("可用:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(_thisAvailBuy,style: const TextStyle(fontSize: 11,color: APP_MainGreenColor),),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: const Text("可买:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(_thisMaxBuy,style: const TextStyle(fontSize: 11,color: APP_MainGreenColor),),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                ),

                Container(
                  child: Row(
                    children: [
                      Container(
                        child: const Text("可用:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(_thisAvailSell,style: const TextStyle(fontSize: 11,color: APP_MainRedColor),),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: const Text("可卖:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(_thisMaxSell,style: const TextStyle(fontSize: 11,color: APP_MainRedColor),),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                ),
                const Divider(height: 1,color: Colors.grey,),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child:Container(
                            decoration: const BoxDecoration(
                              color: APP_MainGreenColor,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            alignment: Alignment.center,
                            child: const Text("买入",style: TextStyle(fontSize: 14,color: Colors.white),),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){

                            if(_tpslTriggerPxController.text == ''){
                              showMyCustomText("请输入触发价格");
                              return;
                            }

                            if(_tpslOrdPxController.text == ''){
                              showMyCustomText("请输入价格");
                              return;
                            }

                            if(_tpslPxAmountController.text == ''){
                              showMyCustomText("请输入数量");
                              return;
                            }

                            _DigitalcurrencyOkexTradePlaceAlgoOrderHttp('buy',_tpslPxAmountController.text,
                                tpTriggerPx :_tpslTriggerPxController.text,
                                tpOrdPx:_tpslOrdPxController.text,
                                slTriggerPx:_tpslTriggerPxController.text,
                                slOrdPx:_tpslOrdPxController.text,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: GestureDetector(
                          child:Container(
                            decoration: const BoxDecoration(
                              color: APP_MainRedColor,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            alignment: Alignment.center,
                            child: const Text("卖出",style: TextStyle(fontSize: 14,color: Colors.white),),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            if(_tpslTriggerPxController.text == ''){
                              showMyCustomText("请输入触发价格");
                              return;
                            }

                            if(_tpslOrdPxController.text == ''){
                              showMyCustomText("请输入价格");
                              return;
                            }

                            if(_tpslPxAmountController.text == ''){
                              showMyCustomText("请输入数量");
                              return;
                            }

                            //{String tpTriggerPx = '',String tpOrdPx = '',String slTriggerPx = '',String slOrdPx = ''}

                            _DigitalcurrencyOkexTradePlaceAlgoOrderHttp('sell',_tpslPxAmountController.text,
                              tpTriggerPx :_tpslTriggerPxController.text,
                              tpOrdPx:_tpslOrdPxController.text,
                              slTriggerPx:_tpslTriggerPxController.text,
                              slOrdPx:_tpslOrdPxController.text,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1,color: Colors.grey,),
                Container(
                  child: const Text("目前买卖条件为 全仓、10倍杠杆,",style: TextStyle(fontSize: 11,color: Colors.grey),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //仓位
  Widget _accountWidget(){
    return Container(
      padding: const EdgeInsets.fromLTRB(3, 0, 1, 5),
      height: _accountWidgetHeight,
      child: Container(
        alignment: Alignment.center,
        color: APP_MainBGColor,
        child: Column(
          children: [
            _accountWidgetHead(), //头部选择
            Offstage(
              offstage: _selectAssetEntrustmentType == '资产' ? false : true,
              child: Container(
                color: APP_MainBGColor,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text("资产",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("币种权益",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("可用保证金",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("占用",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("未平仓收益",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("负债",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                    ),
                  ],
                ),

              ),
            ),
            Offstage(
              offstage: _selectAssetEntrustmentType == '当前委托' ? false : true,
              child: Container(
                color: APP_MainBGColor,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text("交易品种",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托时间",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("交易方向",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交均价｜委托价",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("已成交量｜委托总量",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("止盈止损",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("订单状态",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: GestureDetector(
                          child: Container(
                            child: const Text("批量撤单",style: TextStyle(fontSize: 10,color: APP_MainGreenColor),),
                            padding: const EdgeInsets.fromLTRB(3, 2, 0, 2),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            _DigitalcurrencyOkexTradeCancelMultipleOrdersHttp();
                          },
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                      flex: 2,
                    ),

                  ],
                ),

              ),
            ),
            Offstage(
              offstage: _selectAssetEntrustmentType == '历史委托' ? false : true,
              child: Container(
                color: APP_MainBGColor,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text("交易品种",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托时间",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("交易方向",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交均价|委托价",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("已成交量|委托总量",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("收益|收益率",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("手续费",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(3, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("订单状态",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                    ),
                  ],
                ),

              ),
            ),
            Expanded(
              child: _selectAssetEntrustmentType == '资产' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child: ListView.builder(
                  controller: _controller10,
                  itemBuilder: (context,index){
                    return Container(
                      color: APP_MainBGColor,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(_accountDetailsList![index].ccy!,style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountDetailsList![index].eq!), 5)).toString(),style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountDetailsList![index].availEq!), 5)).toString(),style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountDetailsList![index].frozenBal!), 5)).toString(),style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountDetailsList![index].upl!), 5)).toString(),style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountDetailsList![index].crossLiab!) + neverDoubleTryOrZero(_accountDetailsList![index].isoLiab!), 5)).toString(),style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                          ),
                        ],
                      ),

                    );
                  },
                  itemCount: _accountDetailsList!.length,
                ),
              ) :
              _selectAssetEntrustmentType == '当前委托' ? Container(
                alignment: Alignment.center,
                padding:const EdgeInsets.all(0),
                child: ListView.builder(
                  controller: _controller11,
                  itemBuilder: (context,index){
                    String _tradingDirection = '';
                    String _tradingDirectionSec = '';
                    if(_accountOrderList[index].posSide == 'long'){
                      if(_accountOrderList[index].side == 'buy'){
                        _tradingDirection = '买入开多';
                      }else if(_accountOrderList[index].side == 'sell'){
                        _tradingDirection = '卖出平多';
                      }else{
                        _tradingDirection = '';
                      }
                    }else if(_accountOrderList[index].posSide == 'short'){
                      if(_accountOrderList[index].side == 'buy'){
                        _tradingDirection = '买入平空';
                      }else if(_accountOrderList[index].side == 'sell'){
                        _tradingDirection = '卖出开空';
                      }else{
                        _tradingDirection = '';
                      }
                    }else{
                      if(_accountOrderList[index].side == 'buy'){
                        _tradingDirection = '买入';
                      }else if(_accountOrderList[index].side == 'sell'){
                        _tradingDirection = '卖出';
                      }else{
                        _tradingDirection = '';
                      }
                    }
                    if(_accountOrderList[index].category == 'full_liquidation'){
                      _tradingDirectionSec = '(强平)';
                    }else if(_accountOrderList[index].category == 'partial_liquidation'){
                      _tradingDirectionSec = '(强减)';
                    }else if(_accountOrderList[index].category == 'delivery'){
                      _tradingDirectionSec = '(交割)';
                    }else{
                      _tradingDirectionSec = '';
                    }

                    List _thisIdTag = _accountOrderList[index].instId!.split("-");
                    String _thisNumTT = '';
                    String _thisPriceTT = '';
                    if(_thisIdTag.length >= 2){
                      _thisPriceTT =  _thisIdTag[1] ;
                      _thisNumTT =  _thisIdTag.first ;
                    }else{
                      _thisNumTT = '';
                      _thisPriceTT = '';
                    }

                    return Container(
                      color: APP_MainBGColor,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(_accountOrderList[index].instId!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(157, 157, 157, 0.3),
                                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                        ),
                                        child: Text(_accountOrderList[index].tdMode == 'cross' ? '全仓' : (_accountOrderHistoryList[index].tdMode == 'isolated' ? '逐仓' : "--"),
                                          style: const TextStyle(fontSize: 9,color: Colors.white),),
                                        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        alignment: Alignment.center,
                                      ),
                                      const SizedBox(width: 5,),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: _accountOrderList[index].side == 'buy' ? const Color.fromRGBO(66, 178, 182, 0.6) : const Color.fromRGBO(215, 85, 82,  0.6),
                                          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                        ),
                                        child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderList[index].lever!), 2))!.toStringAsFixed(2) + 'X', style: const TextStyle(fontSize: 9,color: Colors.white),),
                                        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        alignment: Alignment.center,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(DateFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(_accountOrderList[index].cTime!) ?? 0),
                                  [DateFormat.yyyy ,'-', DateFormat.mm, '-', DateFormat.dd, '\n',DateFormat.HH, ':', DateFormat.nn, ':', DateFormat.ss]),style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(_tradingDirection + _tradingDirectionSec,style: TextStyle(fontSize: 11,color: _accountOrderList[index].side == 'buy' ? const Color.fromRGBO(66, 178, 182, 1) : const Color.fromRGBO(215, 85, 82,  1),),),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(_accountOrderList[index].avgPx! == '' ? '--' : ((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderList[index].avgPx!), 8))!.toString() + ' ' + _thisPriceTT)
                                      ,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                    alignment: Alignment.centerRight,
                                  ),
                                  Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderList[index].px!), 8))!.toString() + ' ' + _thisPriceTT
                                      ,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderList[index].accFillSz!), 3))!.toString() + ' ' + _thisNumTT
                                      ,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                    alignment: Alignment.centerRight,
                                  ),
                                  Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderList[index].sz!), 3))!.toString() + ' ' + _thisNumTT
                                      ,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: const Text("--",style: TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(_accountOrderList[index].state! == 'live' ? "等待成交" : (_accountOrderList[index].state! == 'partially_filled' ?  "部分成交"  : "--"),style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    //边框圆角设置
                                    border: Border.all(width: 1, color: APP_MainGreenColor),
                                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                  child: const Text("撤单",style: TextStyle(fontSize: 11,color: Colors.white),),
                                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                                ),
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  _DigitalcurrencyOkexTradeCancelOrderHttp(_accountOrderList[index].instId!, _accountOrderList[index].ordId!);
                                },
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                            ),
                            flex: 2,
                          ),
                        ],
                      ),

                    );
                  },
                  itemCount: _accountOrderList.length,
                ),
              ) :
              _selectAssetEntrustmentType == '历史委托' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child: ListView.builder(
                  controller: _controller12,
                  itemBuilder: (context,index){
                    String _tradingDirection = '';
                    String _tradingDirectionSec = '';
                    if(_accountOrderHistoryList[index].posSide == 'long'){
                      if(_accountOrderHistoryList[index].side == 'buy'){
                        _tradingDirection = '买入开多';
                      }else if(_accountOrderHistoryList[index].side == 'sell'){
                        _tradingDirection = '卖出平多';
                      }else{
                        _tradingDirection = '';
                      }
                    }else if(_accountOrderHistoryList[index].posSide == 'short'){
                      if(_accountOrderHistoryList[index].side == 'buy'){
                        _tradingDirection = '买入平空';
                      }else if(_accountOrderHistoryList[index].side == 'sell'){
                        _tradingDirection = '卖出开空';
                      }else{
                        _tradingDirection = '';
                      }
                    }else{
                      if(_accountOrderHistoryList[index].side == 'buy'){
                        _tradingDirection = '买入';
                      }else if(_accountOrderHistoryList[index].side == 'sell'){
                        _tradingDirection = '卖出';
                      }else{
                        _tradingDirection = '';
                      }
                    }
                    if(_accountOrderHistoryList[index].category == 'full_liquidation'){
                      _tradingDirectionSec = '(强平)';
                    }else if(_accountOrderHistoryList[index].category == 'partial_liquidation'){
                      _tradingDirectionSec = '(强减)';
                    }else if(_accountOrderHistoryList[index].category == 'delivery'){
                      _tradingDirectionSec = '(交割)';
                    }else{
                      _tradingDirectionSec = '';
                    }

                    List _thisIdTag = _accountOrderHistoryList[index].instId!.split("-");
                    String _feeTT= '';
                    String _thisNumTT = '';
                    String _thisPriceTT = '';
                    String _thisTgTccy = '';
                    if(_thisIdTag.length >= 2){
                      _thisPriceTT =  _thisIdTag[1] ;
                      _thisNumTT =  _thisIdTag.first ;
                      if(_accountOrderHistoryList[index].side == 'buy'){
                        _feeTT= _thisIdTag.first;
                      }else if(_accountOrderHistoryList[index].side == 'sell'){
                        _feeTT= _thisIdTag[1];
                      }else{
                        _feeTT= '';
                      }
                    }else{
                      _thisNumTT = '';
                      _thisPriceTT = '';
                      _feeTT = '';
                    }

                    if(_accountOrderHistoryList[index].ordType!.toString() == 'market'){
                      if(_accountOrderHistoryList[index].tgtCcy!.toString() == 'base_ccy'){
                        _thisTgTccy = _thisIdTag.first;
                      }else if(_accountOrderHistoryList[index].tgtCcy!.toString() == 'quote_ccy'){
                        _thisTgTccy = _thisIdTag[1];
                      }else{
                        _thisTgTccy = _thisIdTag.first;
                      }
                    }else{
                      _thisTgTccy = _thisIdTag.first;
                    }

                    return Container(
                      color: APP_MainBGColor,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(_accountOrderHistoryList[index].instId!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(157, 157, 157, 0.3),
                                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                        ),
                                        child: Text(_accountOrderHistoryList[index].tdMode == 'cross' ? '全仓' : (_accountOrderHistoryList[index].tdMode == 'isolated' ? '逐仓' : "--"),
                                          style: const TextStyle(fontSize: 9,color: Colors.white),),
                                        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        alignment: Alignment.center,
                                      ),
                                      const SizedBox(width: 5,),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: _accountOrderHistoryList[index].side == 'buy' ? const Color.fromRGBO(66, 178, 182, 0.6) : const Color.fromRGBO(215, 85, 82,  0.6),
                                          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                        ),
                                        child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderHistoryList[index].lever!), 2))!.toStringAsFixed(2) + 'X', style: const TextStyle(fontSize: 9,color: Colors.white),),
                                        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        alignment: Alignment.center,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(DateFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(_accountOrderHistoryList[index].cTime!) ?? 0),
                                  [DateFormat.yyyy ,'-', DateFormat.mm, '-', DateFormat.dd, '\n',DateFormat.HH, ':', DateFormat.nn, ':', DateFormat.ss]),style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(_tradingDirection + _tradingDirectionSec,style: TextStyle(fontSize: 11,color: _accountOrderHistoryList[index].side == 'buy' ? const Color.fromRGBO(66, 178, 182, 1) : const Color.fromRGBO(215, 85, 82,  1),),),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderHistoryList[index].avgPx!), 2))!.toString() + ' ' + _thisPriceTT
                                      ,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                    alignment: Alignment.centerRight,
                                  ),
                                  Container(
                                    child: Text(_accountOrderHistoryList[index].ordType! == 'limit' ? ((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderHistoryList[index].px!), 3))!.toString() + ' ' + _thisPriceTT):("市价")
                                      ,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderHistoryList[index].accFillSz!), 3))!.toString() + ' ' + _thisNumTT
                                      ,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                    alignment: Alignment.centerRight,
                                  ),
                                  Container(
                                    child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderHistoryList[index].sz!), 3))!.toString() + ' ' + _thisTgTccy
                                      ,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Container(
                                child: Text(_accountOrderHistoryList[index].pnl! == '0' ? '--' : (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderHistoryList[index].pnl!), 2))!.toString()
                                  ,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                alignment: Alignment.centerRight,
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountOrderHistoryList[index].fee!), 6))!.toString() + ' ' + _feeTT,style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.fromLTRB(3, 5, 0, 5),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(_accountOrderHistoryList[index].state! == 'filled' ? "完全成交" : (_accountOrderHistoryList[index].state! == 'canceled' ?  "已撤单"  : "--"),style: const TextStyle(fontSize: 11,color: Colors.white),),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                            ),
                          ),
                          // Expanded(
                          //   child: Container(
                          //     child: GestureDetector(
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: Colors.transparent,
                          //           //边框圆角设置
                          //           border: Border.all(width: 1, color: APP_MainGreenColor),
                          //           borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          //         ),
                          //         child: Text("查看详情",style: TextStyle(fontSize: 11,color: Colors.white),),
                          //         padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                          //       ),
                          //     ),
                          //     alignment: Alignment.centerRight,
                          //     padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                          //   ),
                          //   flex: 2,
                          // ),
                        ],
                      ),
                    );
                  },
                  itemCount: _accountOrderHistoryList.length,
                ),
              ) :
              _selectAssetEntrustmentType == '仓位' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child: ListView.builder(
                  controller: _controller13,
                  itemBuilder: (context,index){
                    String _thisPosSide = _posSideCheck(_accountPositionsList![index]);
                    String _thisPosTitle = '';
                    Color _thisPosTitleColor = Colors.grey;
                    if(_thisPosSide.contains("多头")){
                      _thisPosTitle = '多 ' + _accountPositionsList![index].lever! + 'X';
                      _thisPosTitleColor = APP_MainGreenColor;
                    }else if(_thisPosSide.contains("空头")){
                      _thisPosTitle = '空 ' + _accountPositionsList![index].lever! + 'X';
                      _thisPosTitleColor = APP_MainRedColor;
                    }
                    return Container(
                      decoration: const BoxDecoration(
                        color: APP_MainBGColor,
                        //边框圆角设置
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5, //阴影范围
                              spreadRadius: 1, //阴影浓度
                              color: Colors.black, //阴影颜色
                              offset:Offset(1,1)
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Text(_accountPositionsList![index].instId!,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.white),),
                                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[700],
                                          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                        ),
                                        child: Text(_accountPositionsList![index].mgnMode == 'cross' ? '全仓' : (_accountPositionsList![index].mgnMode == 'isolated' ? '逐仓' : "--"),
                                        style: const TextStyle(fontSize: 11,color: Colors.white),),
                                        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: _thisPosTitleColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                        ),
                                        child: Text(_thisPosTitle, style: const TextStyle(fontSize: 11,color: Colors.white),),
                                        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        alignment: Alignment.center,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("持仓量",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.fromLTRB(0, 0, 5, 3),
                                          ),
                                          Container(
                                            child: const Text("可平量",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Text(_accountPositionsList![index].pos! + ' 张',style: const TextStyle(fontSize: 11,color: Colors.white),),
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                            ),
                                            Container(
                                              child: Text(_accountPositionsList![index].availPos! + ' 张',style: const TextStyle(fontSize: 11,color: Colors.white),),
                                              alignment: Alignment.centerRight,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("开仓均价",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.fromLTRB(0, 0, 5, 3),
                                          ),
                                          Container(
                                            child: const Text("保证金率",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountPositionsList![index].avgPx!),2)).toString(),style: const TextStyle(fontSize: 11,color: Colors.white),),
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                            ),
                                            Container(
                                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountPositionsList![index].mgnRatio!) * 100, 2)).toString() + '%',style: const TextStyle(fontSize: 11,color: Colors.white),),
                                              alignment: Alignment.centerRight,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("收益",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 3),
                                          ),
                                          Container(
                                            child: const Text("收益率",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountPositionsList![index].upl!), 2)).toString() + ' ' + _accountPositionsList![index].ccy!,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                            ),
                                            Container(
                                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountPositionsList![index].uplRatio!) * 100, 2)).toString() + '%',style: const TextStyle(fontSize: 11,color: Colors.white),),
                                              alignment: Alignment.centerRight,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("初始保证金",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 3),
                                          ),
                                          Container(
                                            child: const Text("初始保证金",style: TextStyle(fontSize: 11,color: Colors.transparent),),
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_accountPositionsList![index].imr!), 2)).toString() + ' ' + _accountPositionsList![index].ccy!,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                            ),
                                            Container(
                                              child: const Text('%',style: TextStyle(fontSize: 11,color: Colors.transparent),),
                                              alignment: Alignment.centerRight,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 80,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          labelStyle: TextStyle(color: Colors.grey),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                          ),
                                          suffixText: '',
                                          suffixStyle: TextStyle(color: Colors.white,fontSize: 11),
                                          hintText: '请输入单价',
                                          hintStyle: TextStyle(color: Colors.grey,fontSize: 11),
                                        ),
                                        controller: _transactionPriceController,
                                        autocorrect:false,
                                        keyboardType: const TextInputType.numberWithOptions(
                                          decimal : true,
                                        ),
                                        style: const TextStyle(color: Colors.white,fontSize: 11),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Container(
                                      height: 30,
                                      width: 80,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          labelStyle: TextStyle(color: Colors.grey),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                          ),
                                          suffixText: '',
                                          suffixStyle: TextStyle(color: Colors.white,fontSize: 11),
                                          hintText: '请输入单价',
                                          hintStyle: TextStyle(color: Colors.grey,fontSize: 11),
                                        ),
                                        controller: _transactionPriceController,
                                        autocorrect:false,
                                        keyboardType: const TextInputType.numberWithOptions(
                                          decimal : true,
                                        ),
                                        style: const TextStyle(color: Colors.white,fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: APP_MainRedColor,
                                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                        ),
                                        height: 30,
                                        width: 80,
                                        child: const Text("平仓",style: TextStyle(fontSize: 12,color: Colors.white),),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    GestureDetector(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: APP_MainRedColor,
                                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                        ),
                                        height: 30,
                                        width: 80,
                                        child: const Text("市价全平",style: TextStyle(fontSize: 12,color: Colors.white),),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: _accountPositionsList!.length,
                ),
              ) :
                  Container(),
            ),
          ],
        ),
      ),
    );
  }

  //下部面板-当前委托/历史成交/持仓/资产 的标题面板
  Widget _accountWidgetHead(){
    return GestureDetector(
      child: Container(
          height: 40,
          color: APP_MainBarColor,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _controller14,
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
                                color: _selectAssetEntrustmentType == _selectAssetEntrustmentTypeName[index] ? APP_MainGreenColor : Colors.transparent,
                                child: const Text('',style: TextStyle(color: Colors.transparent),),
                                alignment: Alignment.topCenter,
                                height: 4,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(_selectAssetEntrustmentTypeName[index],style: const TextStyle(color: Colors.white),),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  color: _selectAssetEntrustmentType == _selectAssetEntrustmentTypeName[index] ? APP_MainBGColor : Colors.transparent,
                                ),
                              )
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      onTap: (){
                        setState(() {
                          _selectAssetEntrustmentType = _selectAssetEntrustmentTypeName[index];
                          if(_selectAssetEntrustmentType == '历史委托'){
                            if(_indexApi == ''){
                              showMyCustomText("未获取到APIKey,请先绑定或重新刷新页面");
                            }else{
                              _DigitalcurrencyOkexTradeGetOrderHistory7daysHttp();
                            }
                          }
                          if(_selectAssetEntrustmentType == '当前委托'){
                            if(_indexApi == ''){
                              showMyCustomText("未获取到APIKey,请先绑定或重新刷新页面");
                            }else{
                              _DigitalcurrencyOkexTradeGetOrderListHttp();
                            }
                          }
                        });
                      },
                    );
                  },
                  itemCount: _selectAssetEntrustmentTypeName.length,
                ),
              ),
              Container(
                child: GestureDetector(
                  child: Container(
                    child: Icon(_accountWidgetShow ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,color: Colors.white,size: 25,),
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    setState(() {
                      _accountWidgetShow = !_accountWidgetShow;
                    });

                  },
                ),
              )
            ],
          )
      ),
      behavior: HitTestBehavior.opaque,
      onVerticalDragDown: (s){
        _accountWidgetHeightT =  _accountWidgetHeight;
      },
      onVerticalDragUpdate: (s){
        _accountWidgetHeadYT = s.localPosition.dy - 20;
        if(_accountWidgetShow){ //
          setState(() {
            double hi = _accountWidgetHeightT - _accountWidgetHeadYT;
            if(hi < 120){
              _accountWidgetHeight = 120;
            }else if (hi > (MediaQuery.of(context).size.height / 2)){
              _accountWidgetHeight = MediaQuery.of(context).size.height / 2;
            }else{
              _accountWidgetHeight = _accountWidgetHeightT - _accountWidgetHeadYT;
            }

          });
        }
      },
      onVerticalDragEnd: (s){
        setState(() {
          _accountWidgetHeightT =  _accountWidgetHeight;
        });
      },
    ); //头部选择
  }


  //仓位细分 - 持仓方向判断
  String _posSideCheck(DigitalCurrencyPositionsSocketModel data){
    if(data.posSide == 'long'){
      return '双向持仓多头';
    }else if(data.posSide == 'short'){
      return '双向持仓空头';
    }else if(data.posSide == 'net'){
      if(data.instType == 'FUTURES' || data.instType == 'SWAP' || data.instType == 'OPTION'){
        if(neverDoubleTryOrZero(data.pos.toString()) > 0){
          return '单向持仓多头';
        }else if(neverDoubleTryOrZero(data.pos.toString()) < 0){
          return '单向持仓空头';
        }else{
          return '';
        }
      }else{
        if(data.posCcy == data.ccy){
          return '单向持仓多头';
        }else if(data.posCcy == 'USDT'){
          return '单向持仓空头';
        }else{
          return '';
        }
      }
    }else{
      return '';
    }
  }

}