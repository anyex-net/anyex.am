import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/HttpRequest.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Base/MyTextInputFormatter.dart';
import 'package:amclient_flutter/NPFutures/Model/NPFuturesIndexResponseModel.dart';
import 'package:amclient_flutter/NPFutures/Model/NPFuturesSocketModel.dart';
import 'package:amclient_flutter/NPSpot/Http/NPSpotHttpRequest.dart';
import 'package:amclient_flutter/WPFutures/View/WPFuturesViewWidget.dart';
import 'package:amclient_flutter/WPSpot/Http/WPSpotHttpRequest.dart';
import 'package:amclient_flutter/WPSpot/Model/WPSpotIndexResponseModel.dart';
import 'package:amclient_flutter/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neveruseless/never/neverBus.dart';
import 'package:neveruseless/never/neverDoubleTryOrZero.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:date_format/date_format.dart' as DateFormat;

const double kLeftBarWidth = 72.0;
const double kTransactionPanelWidth = 290.0;
const double kSpotWidth = 230.0;

class WPSpotIndexView extends StatefulWidget {
  final arguments;
  const WPSpotIndexView({Key? key, this.arguments}) : super(key: key);

  @override
  _WPSpotIndexViewState createState() => _WPSpotIndexViewState();
}
class _WPSpotIndexViewState extends State<WPSpotIndexView> with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin {

  //币对选择页面是否显示
  bool _isShowCurrencyPick = true;
  //外盘现货交易所信息
  List<WpSpotExchangeInfoListData>? _wpSpotExchangeList = []; //_npFutures ExchangeList _wpSpotExchangeList
  //选择的交易所
  String? _selectIndexExchangeNo = '';
  String _tempExchangeNo = '';


  //选择的外盘现货交易所现货品种No
  String? _selectIndexExchangeProductNo = '';
  //该品种下的交易货币
  String? _selectIndexTradeCurrency = 'CNY';
  String _tempTradeCurrency = '';

  //内盘现货交易所现货证券信息管理
  List<WpSpotExchangeInstrumentListData>? _wpSpotExchangeInstrumentList = []; // _npFutures ExchangeInstrumentList _wpSpotExchangeInstrumentList
  List<WpSpotExchangeInstrumentListData>? _tempNpSpotExchangeInstrumentList = [];//_tempNpFutures ExchangeInstrumentList _tempNpSpotExchangeInstrumentList
  //选择的内盘现货交易所现货证券ID
  String? _selectIndexContractNo = '';
  String? _selectIndexContractID = '';
  String? _selectIndexInstrumentID = '';
  //选择的内盘现货交易所现货证券对象
  WpSpotExchangeInstrumentListData? _selectIndexExchangeInstrumentData;
  List<WpSpotExchangeInstrumentListData>? _screenList = [];//筛选
  final TextEditingController _currencyController = TextEditingController();

  //外盘现货资金账号资金信息
  List<WpSpotTradingAccountListData>? _wpSpotTradingAccountList = []; // _wpSpotTradingAccountList

  //外盘现货成交
  List<WpSpotTradeListData>? _wpSpotTradeList = []; //_wpSpotTradeList
  int _wpSpotTradePage = 1; // _wpSpotTradePage
  bool? _wpSpotTradehasNextPage = false; //_wpSpotTradehasNextPage

  //外盘现货所有持仓信息
  List<WpSpotInvestorPositionListData>? _wpSpotInvestorPositionList = []; // _wpSpotInvestorPositionList
  int _wpSpotInvestorPositionPage = 1; // _wpSpotInvestorPositionPage
  bool? _wpSpotInvestorPositionhasNextPage = false; // _wpSpotInvestorPositionhasNextPage

  //外盘现货委托订单
  List<WpSpotOrderListData>? _wpSpotOrderList= []; //  _wpSpotOrderList
  int _wpSpotOrderInfoPage = 1; // _wpSpotOrderInfoPage
  bool? _wpSpotOrderInfohasNextPage = false; // _wpSpotOrderInfohasNextPage

  //外盘现货历史委托订单
  List<WpSpotOrderListData>? _wpSpotOrderHisList= []; //_wpSpotOrderHisList
  int _wpSpotOrderInfoHisPage = 1; //_wpSpotOrderInfoHisPage
  bool? _npSpotOrderInfoHishasNextPage = false; //_npFutures OrderInfoHishasNextPage  _npSpotOrderInfoHishasNextPage

  //Socket Ticker模型
  NpFuturesSocketTickerModel? _socketTickerModel;

  //盘口与实时成交
  String _selectTransactionType = '买卖盘口';//order 盘口 trade 成交
  final List _selectTransactionTypeName = ['买卖盘口','最新成交'];

  //个人资产
  String _selectAssetEntrustmentType = '资产';//order 盘口 trade 成交
  final List _selectAssetEntrustmentTypeName = ['当前委托','历史委托','历史成交','持仓','资产'];

  //交易面板
  String _selectTransactionPanelType = '限价委托';//order 盘口 trade 成交
  // final List _selectTransactionPanelTypeName = ['限价委托','市价委托'];

  //最新成交
  List _tradesList = [];

  //盘口深度
  List _tickAsksList = [];
  List _tickBidsList = [];
  List _tickAsksQtysList = [];
  List _tickBidsQtysList = [];

  //K线
  String _selectKlineTimeType = '2'; // 1 : 1分 2：5分 3：15分 4：30分 5：60分 6：24小时
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


  //交易面板套件
  final TextEditingController _transactionPriceController = TextEditingController();
  final TextEditingController _transactionNumberController = TextEditingController();
  final TextEditingController _transactionAmountController = TextEditingController();


  @override
  bool get wantKeepAlive => true;


  Timer? _timer;
  Timer? _privateTimer;


  //翻译字典
  Map? _npFuturesTranslate = {};

  //Socket套件
  bool _isSocektOn = false;
  late IOWebSocketChannel _channel;

  Animation<double>? _animation;
  AnimationController? _controller;

  var _lastPopTime = DateTime.now();

  //下部面板是否隐藏
  bool _accountWidgetShow = true;

  //盘口最新成交是否隐藏
  bool _spotWidgetHandicapShow = true;


  double _accountWidgetHeadYT = 0.0;
  double _accountWidgetHeight = (window.physicalSize.height * 0.15) > 120.0 ? window.physicalSize.height * 0.15 : 120.0;
  double _accountWidgetHeightT = (window.physicalSize.height * 0.15) > 120.0 ? window.physicalSize.height * 0.15 : 120.0;

  final ScrollController _controller1 = ScrollController();
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
  final ScrollController _controller15 = ScrollController();
  final ScrollController _controller16 = ScrollController();
  final ScrollController _controller17 = ScrollController();
  final ScrollController _controller18 = ScrollController();
  final ScrollController _controller19 = ScrollController();
  final ScrollController _controller20 = ScrollController();

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('Assets/NPFuturesTranslateModel.json').then((value){
      _npFuturesTranslate = json.decode(value);
    });
    _WpSpotExchangeQryOpenCtpCommonDataHttp();
    _channel = IOWebSocketChannel.connect(kWPFuturesSocketAddress);
    _isSocektOn = true;
    _channel.stream.listen(_onData, onError: _onError, onDone: _onDone);
    //底部栏切换动作 1：点击到当前页面是 应该有一次刷新动作 2：socket应该重连一次，3：离开时关闭socket
    neverBus.on('pageController', (object) {
      if(!mounted){
        return;
      }
      setState(() {
        if(object == '/WPSpotIndexView') {
          print("打开外盘现货界面");
          setState(() {
            _isShowCurrencyPick = true;
          });
          _WpSpotExchangeQryOpenCtpCommonDataHttp();
          if(!_isSocektOn){
            _onRest();
          }
        }else{
          if(_isSocektOn){
            try{
              _onSendUnSocket();
              _channel.sink.close();
            }catch(e){
              try{
                _channel.sink.close();
              }catch(e){
                print("内盘Socket异常未处理关闭");
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
      _WpSpotExchangeQryOpenCtpCommonDataHttp();
      _WpSpotExchangeInstrumentInitHttp();
    });
    neverBus.on('WpSpotIndexReload', (object){
      if(!mounted){
        return;
      }
      _WpSpotExchangeDataHttp();
      _WpSpotTradingAccountDataHttp();
    });
    _WpSpotExchangeInstrumentInitHttp();

    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _animation = Tween(begin: 0.0, end: 3.0).animate(_controller!)
      ..addListener(() {
        setState(() {
          if(_controller!.status == AnimationStatus.completed){
            _controller!.reset();
          }
        });
      });

  }

  String _findTrans(Map typeMap , String key,String code){
    if(typeMap.isEmpty){
      return code;
    }
    if(key == ''){
      return code;
    }
    if(code == ''){
      return code;
    }
    try{
      if(typeMap.containsKey(key)){
        List _list = typeMap[key];
        for(int i=0;i<_list.length;i++){
          if(_list[i]['key'] == code) {
            return _list[i]['value'];
          }
        }
        return code;
      }else{
        return code;
      }
    }catch(e){
      return code;
    }
  }

  //初始化外盘现货部分公共数据
  Future _WpSpotExchangeQryOpenCtpCommonDataHttp() async{
    var response = await WpSpotExchangeQryOpenCtpCommonData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        _WpSpotExchangeDataHttp();
        _WpSpotTradingAccountDataHttp();
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
  }

  //外盘现货交易所信息
  Future _WpSpotExchangeDataHttp() async{
    var response = await WpSpotExchangeData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _wpSpotExchangeList = WpSpotExchangeInfoResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询外盘现货交易所]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询外盘现货交易所]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘现货交易所现货证劵表
  Future _WpSpotExchangeInstrumentDataHttp({String exchangeID = '',String instrumentID = '',String productID = ''}) async{
    var response = await WpSpotExchangeInstrumentData(exchangeID: exchangeID,instrumentID:instrumentID,productID:productID);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _wpSpotExchangeInstrumentList = WpSpotExchangeInstrumentResponseData.fromJson(response).object;
          if(_currencyController.text.isNotEmpty){
            _sceenListFuture(_currencyController.text);
          }
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询外盘现货证券]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询外盘现货证券]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘现货交易所现货证劵 -默认款
  Future _WpSpotExchangeInstrumentInitHttp() async{
    var response = await WpSpotExchangeInstrumentInit();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        if(response["object"].toString() == 'null'){
          return;
        }
        setState(() {
          _selectIndexExchangeInstrumentData = WpSpotExchangeInstrumentListData.fromJson(response["object"]);
          _selectIndexExchangeNo = _selectIndexExchangeInstrumentData!.exchangeID;
          _selectIndexExchangeProductNo = _selectIndexExchangeInstrumentData!.productClass;
          _selectIndexContractNo = _selectIndexExchangeInstrumentData!.instrumentName;
          _selectIndexInstrumentID = _selectIndexExchangeInstrumentData!.instrumentID;
          _selectIndexContractID = _selectIndexExchangeInstrumentData!.id;
          _selectIndexTradeCurrency = 'CNY';
          _WpSpotExchangeInstrumentDataHttp(exchangeID: _selectIndexExchangeNo!,);
          _onSendSocket();
        });
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
          showMyCustomText('[查询外盘现货资金账户]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询外盘现货资金账户]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询外盘现货委托订单表
  Future _WpSpotOrderDataHttp() async{
    var response = await WpSpotOrderData(page: _wpSpotOrderInfoPage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          if (_wpSpotOrderInfoPage == 1) {
            _wpSpotOrderList = WpSpotOrderResponseData.fromJson(response).rows;
          } else {
            _wpSpotOrderList!.addAll(WpSpotOrderResponseData.fromJson(response).rows!.toList());
          }
          _wpSpotOrderInfohasNextPage = WpSpotOrderResponseData.fromJson(response).hasNext ?? false;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询外盘现货委托订单]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询外盘现货委托订单]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询外盘现货历史委托订单表
  Future _WpSpotOrderHisDataHttp() async{
    var response = await WpSpotOrderHisData(page: _wpSpotOrderInfoHisPage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          if (_wpSpotOrderInfoHisPage == 1) {
            _wpSpotOrderHisList = WpSpotOrderResponseData.fromJson(response).rows;
          } else {
            _wpSpotOrderHisList!.addAll(WpSpotOrderResponseData.fromJson(response).rows!.toList());
          }
          _npSpotOrderInfoHishasNextPage = WpSpotOrderResponseData.fromJson(response).hasNext ?? false;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询外盘现货历史委托]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询外盘现货历史委托]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询外盘现货成交表
  Future _WpSpotTradeDataHttp() async{
    var response = await WpSpotTradeData(page: _wpSpotTradePage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          if (_wpSpotTradePage == 1) {
            _wpSpotTradeList = WpSpotTradeResponseData.fromJson(response).rows;
          } else {
            _wpSpotTradeList!.addAll(WpSpotTradeResponseData.fromJson(response).rows!.toList());
          }
          _wpSpotTradehasNextPage = WpSpotTradeResponseData.fromJson(response).hasNext ?? false;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询外盘现货成交]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询外盘现货成交]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询外盘现货持仓汇总表
  Future _WpSpotInvestorPositionDataHttp() async{
    var response = await WpSpotInvestorPositionData(page: _wpSpotInvestorPositionPage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          if (_wpSpotInvestorPositionPage == 1) {
            _wpSpotInvestorPositionList = WpSpotInvestorPositionResponseData.fromJson(response).rows;
          } else {
            _wpSpotInvestorPositionList!.addAll(WpSpotInvestorPositionResponseData.fromJson(response).rows!.toList());
          }
          _wpSpotInvestorPositionhasNextPage = WpSpotInvestorPositionResponseData.fromJson(response).hasNext ?? false;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[查询外盘现货持仓]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询外盘现货持仓]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘现货委托批量撤单
  Future _WpSpotOrderBatchCancelOrderHttp() async{
    var response = await WpSpotOrderBatchCancelOrder();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        showMyCustomText("批量撤单成功");
        Future.delayed(const Duration(milliseconds: 300)).then((onValue) async{
          _wpSpotOrderInfoPage = 1;
          _WpSpotOrderDataHttp();
        });
      } else {
        try{
          showMyCustomText("code:"  + response["code"].toString() + " " +  response["message"]);
        }catch(e){
          showMyCustomText(response["message"]);
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[外盘现货批量撤单]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘现货委托撤单
  Future _WpSpotOrderOrderActionHttp({String exchangeID = '',String instrumentID = '',String investorID = '',String orderRef = '',String frontID = '',String sessionID = ''}) async{
    var response = await WpSpotOrderOrderAction(
      instrumentID: instrumentID,
      investorID:investorID,
      orderRef:orderRef,
      frontID:frontID,
      sessionID:sessionID,
      exchangeID:exchangeID,
    );
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        showMyCustomText("撤单成功");
        Future.delayed(const Duration(milliseconds: 300)).then((onValue) async{
          _wpSpotOrderInfoPage = 1;
          _WpSpotOrderDataHttp();
        });
      } else {
        try{
          showMyCustomText("code:"  + response["code"].toString() + " " +  response["message"]);
        }catch(e){
          showMyCustomText(response["message"]);
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[外盘现货委托撤单]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘现货委托下单
  Future _WpSpotOrderOrderInsertHttp({String combHedgeFlag = '',String combOffsetFlag = '',String direction = '', String exchangeID = '',String instrumentID = '',String investorID = '', String limitPrice = '',String orderPriceType = '',String volumeTotalOriginal = '',}) async{
    var response = await WpSpotOrderOrderInsert(
      combHedgeFlag:combHedgeFlag,
      combOffsetFlag:combOffsetFlag,
      direction:direction,
      exchangeID:exchangeID,
      instrumentID:instrumentID,
      investorID:investorID,
      limitPrice:limitPrice,
      orderPriceType:orderPriceType,
      volumeTotalOriginal:volumeTotalOriginal,
    );
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        showMyCustomText("下单成功");
        Future.delayed(const Duration(milliseconds: 300)).then((onValue) async{
          _refreshEveryWhere();
        });
      } else {
        try{
          showMyCustomText("code:"  + response["code"].toString() + " " +  response["message"]);
        }catch(e){
          showMyCustomText(response["message"]);
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

  //外盘现货 订阅外盘现货深度行情
  Future _WpSpotDepthMarketDataSubscribeMarketDataHttp({String ppInstrumentID = ''}) async{
    // print(ppInstrumentID);
    var response = await WpSpotDepthMarketDataSubscribeMarketData(ppInstrumentID: ppInstrumentID);
    // print(response); print("response");
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){

      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[订阅外盘现货深度行情]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[订阅外盘现货深度行情]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘现货 取消订阅外盘现货深度行情
  Future _WpSpotDepthMarketDataUnSubscribeMarketDataHttp({String ppInstrumentID = ''}) async{
    // print(ppInstrumentID);
    var response = await WpSpotDepthMarketDataUnSubscribeMarketData(ppInstrumentID: ppInstrumentID);
    // print(response);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){

      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[取消订阅外盘现货深度行情]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[取消订阅外盘现货深度行情]遇到问题，请检查网络或重新刷新');
      }
    }
  }


  //Socket订阅语句
  _onSendSocket(){
    if(_selectIndexInstrumentID! == ''){
      print("无数据不发sub");
      return;
    }
    String subsStr= "{\"subs\":\"quote.wpspot.openctp." + _selectIndexInstrumentID! + ".entrust,"
        + "quote.wpspot.openctp." + _selectIndexInstrumentID! + ".trade,"
        + "quote.wpspot.openctp." + _selectIndexInstrumentID! + ".kline." + _selectKlineTimeType
        + "\"}";
    print(subsStr + DateTime.now().toString());
    _channel.sink.add(subsStr);
  }

  _onSendUnSocket(){
    if(_selectIndexInstrumentID! == ''){
      print("无数据不发unsub");
      return;
    }
    String subsStr= "{\"unsubs\":\"quote.wpspot.openctp." + _selectIndexInstrumentID! + ".entrust,"
        + "quote.wpspot.openctp." + _selectIndexInstrumentID! + ".trade,"
        + "quote.wpspot.openctp." + _selectIndexInstrumentID! + ".kline." + _selectKlineTimeType
        + "\"}";

    // print(subsStr + DateTime.now().toString());
    _channel.sink.add(subsStr);
  }

  _onData(event){
    if (!mounted) {
      return;
    }
    try{
      if(utf8.decode(event) == 'ping'){
        return;
      }
      // print(utf8.decode(event));
      Map _initDateMap = jsonDecode(utf8.decode(event));
      //最新成交，深度
      if(_initDateMap["depth"].toString() != '' && _initDateMap["depth"].toString() != 'null'){
        setState(() {
          Map _socketDepthMap = jsonDecode(_initDateMap["depth"]);
          _tickAsksList = _socketDepthMap['askPrices'].toString().split(",");
          _tickBidsList = _socketDepthMap['bidPrices'].toString().split(",");
          _tickAsksQtysList = _socketDepthMap['askQtys'].toString().split(",");
          _tickBidsQtysList = _socketDepthMap['bidQtys'].toString().split(",");
        });
      }
      //头部栏
      if(_initDateMap["ticker"].toString() != '' && _initDateMap["ticker"].toString() != 'null' && _initDateMap["ticker"].toString() != '{}'){
        // print(_initDateMap["ticker"]);
        setState(() {
          Map _socketTickerMap = jsonDecode(_initDateMap["ticker"]);
          _socketTickerModel = NpFuturesSocketTickerModel.fromJson(_socketTickerMap);
        });
      }
      //K线 - 完成
      if(_initDateMap["klines"].toString() != '' && _initDateMap["klines"].toString() != 'null'){
        List _list = jsonDecode(_initDateMap["klines"].toString());
        // print(_list);
        if(_list.isNotEmpty){
          // print(_selectIndexExchangeProductNo!);
          // print(_list.first['commodityCode'].toString());

          if(_list.first['commodityCode'].toString() == _selectIndexExchangeProductNo! && _list.first['contractCode'].toString() == _selectIndexInstrumentID! && _list.first['exchange'].toString() == _selectIndexExchangeNo!){
            if(_KLineList == null || _KLineList!.isEmpty || _KLineList!.last.commodityCode.toString() != _selectIndexExchangeProductNo! || _KLineList!.last.contractCode.toString() != _selectIndexInstrumentID! || _KLineList!.last.exchange.toString() != _selectIndexExchangeNo!){
              _KLineList = _list.map((item) => KLineEntity.wpfromJson(item)).toList().cast<KLineEntity>();
              // print(_KLineList);
              if(mounted){
                setState(() {
                  DataUtil.calculate(_KLineList!);
                });
              }
            }else{
              if(_KLineList == null || _KLineList!.isEmpty || _KLineList!.last.timeType.toString() != _selectKlineTimeType){
                _KLineList = _list.map((item) => KLineEntity.wpfromJson(item)).toList().cast<KLineEntity>();
                if(mounted){
                  setState(() {
                    DataUtil.calculate(_KLineList!);
                  });
                }
              }else{
                for(int i =0; i<_list.length;i++){
                  if((_KLineList!.last.time ?? 0) > (int.tryParse(_list[i]['displayTime'].toString()) ?? 0)){
                    break;
                  }else if ((_KLineList!.last.time ?? 0) == (int.tryParse(_list[i]['displayTime'].toString()) ?? 0)){
                    _KLineList!.removeLast();
                    _KLineList!.add(KLineEntity.wpfromJson(_list[i]));
                    if(mounted){
                      setState(() {
                        DataUtil.calculate(_KLineList!);
                      });
                    }
                  }else if ((_KLineList!.last.time ?? 0) < (int.tryParse(_list[i]['displayTime'].toString()) ?? 0)){
                    _KLineList!.add(KLineEntity.wpfromJson(_list[i]));
                    if(_KLineList!.length > 300){
                      _KLineList!.removeAt(0);
                    }
                    if(mounted){
                      setState(() {
                        DataUtil.calculate(_KLineList!);
                      });
                    }
                  }else{
                  }
                }
              }
            }
          }
        }
      }
      //最新成交 - 完成
      if(_initDateMap["trades"].toString() != '' && _initDateMap["trades"].toString() != 'null'){
        if(_initDateMap['topic'] == ("quote.wpspot.openctp." + _selectIndexInstrumentID!)){
          List _list = jsonDecode(_initDateMap["trades"].toString());
          if(_list.isNotEmpty){
            if(_tradesList.isEmpty){
              _tradesList.addAll(_list);
            }else{
              _tradesList.insertAll(0,_list);
              if(_tradesList.length > 200){
                _tradesList.removeRange(200, _tradesList.length);
              }
            }
          }
        }else{
          _tradesList.clear();
        }
      }
    }catch(e){
      print(e);
    }
  }

  _onError(err){
    print("外盘现货WebSocket错误");
    WebSocketChannelException ex = err;
    print(ex);
    _isSocektOn = false;
  }

  _onDone(){
    print("外盘现货WebSocket断开");
    _isSocektOn = false;
  }

  _onRest(){
    print("外盘现货WebSocket重连");
    _channel=IOWebSocketChannel.connect(kWPFuturesSocketAddress);//brokerId=9999
    _isSocektOn = true;
    _channel.stream.listen(_onData, onError: _onError, onDone: _onDone);
    _onSendSocket();
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer!.cancel();
    }
    if(_privateTimer != null){
      _privateTimer!.cancel();
    }
    _controller!.dispose();
    neverBus.off('pageController');
    neverBus.off('LoginSuccess');
    neverBus.off('WPFuturesIndexReload');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("外盘现货"),
          ),
          body:GestureDetector(
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: Column(
                children: [
                  _selectTickerView(),
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
                              width: kTransactionPanelWidth,
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              padding: const EdgeInsets.fromLTRB(2, 0, 3, 3),
                              child: _TransactionPanelWidget(),
                            ),
                          ],
                        ),
                        Offstage(
                          offstage: _isShowCurrencyPick,
                          child: _selectNpSpotExchangeView(),
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

  Widget _selectNpSpotExchangeView(){
    return GestureDetector(
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
                  hintText: '搜索 证券名称/证券代码',
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
              child:ListView.builder(
                controller: _controller3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection : Axis.horizontal,
                itemBuilder: (context,index){
                  return _selectIndexItemView(_wpSpotExchangeList![index]);
                },
                itemCount: _wpSpotExchangeList?.length,
              ),
              height: 50,
              padding: const EdgeInsets.all(0),
              alignment: Alignment.centerLeft,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  controller: _controller1,
                  itemBuilder: (context,index){
                    if(_currencyController.text.isNotEmpty){
                      return _instrumentListCell(_screenList![index]);
                    }else{
                      return _instrumentListCell(_wpSpotExchangeInstrumentList![index]);
                    }
                  },
                  itemCount: _currencyController.text.isNotEmpty ? _screenList!.length : _wpSpotExchangeInstrumentList!.length,
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
    );
  }

  Widget _instrumentListCell(WpSpotExchangeInstrumentListData data){
    return GestureDetector(
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Text(data.instrumentName!,style: TextStyle(color:(_selectIndexInstrumentID == data.instrumentID!) ? APP_MainGreenColor : Colors.white,fontSize: 12),),
                alignment: Alignment.centerLeft,
              ),
            ),
            Expanded(
              child: Container(
                child: Text(data.instrumentID!,style: TextStyle(color:(_selectIndexInstrumentID == data.instrumentID!) ? APP_MainGreenColor : Colors.white,fontSize: 12),),
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      ),
      behavior: HitTestBehavior.opaque,
      onTap: (){
        setState(() {

          if(_selectIndexExchangeNo != "" && _selectIndexExchangeProductNo != "" && _selectIndexInstrumentID != ""){
            _WpSpotDepthMarketDataUnSubscribeMarketDataHttp(ppInstrumentID: _selectIndexInstrumentID!);
            if(_isSocektOn){
              _onSendUnSocket();
            }

          }
          _socketTickerModel = null;
          _tickAsksList.clear();
          _tickBidsList.clear();
          _tradesList.clear();

          _transactionPriceController.text = '';
          _transactionAmountController.text = '';
          _transactionNumberController.text = '';

          _selectIndexExchangeNo = _tempExchangeNo;

          _selectIndexTradeCurrency = _tempTradeCurrency;
          _selectIndexExchangeProductNo = data.productClass!;
          _selectIndexContractNo = data.instrumentName!;
          _selectIndexInstrumentID = data.instrumentID!;
          _selectIndexContractID = data.id!;
          _tempNpSpotExchangeInstrumentList!.clear();
          _tempNpSpotExchangeInstrumentList!.addAll(_wpSpotExchangeInstrumentList!);

          _selectIndexExchangeInstrumentData= data;

          if(_selectIndexExchangeNo != "" && _selectIndexExchangeProductNo != "" && _selectIndexInstrumentID != ""){
            _WpSpotDepthMarketDataSubscribeMarketDataHttp(ppInstrumentID: _selectIndexInstrumentID!);
            if(_isSocektOn){
              _onSendSocket();
            }else{
              _onRest();
            }
          }
          _isShowCurrencyPick = !_isShowCurrencyPick;
        });
      },
    );
  }

  //证券类型选择按钮组件
  Widget _selectIndexItemView(WpSpotExchangeInfoListData data){
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(data.exchangeName!,style: TextStyle(color:_tempExchangeNo == data.exchangeID ? Colors.white : Colors.grey),),
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            ),
            Container(
              color: _tempExchangeNo == data.exchangeID ? APP_MainGreenColor : Colors.transparent,
              child: Text(data.exchangeName!,style: const TextStyle(color: Colors.white),),
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
          _tempExchangeNo = data.exchangeID!;
          _wpSpotExchangeInstrumentList!.clear();
          _WpSpotExchangeInstrumentDataHttp(exchangeID: _tempExchangeNo,);
        });
      },
    );
  }

  void _sceenListFuture(String value){
    try{
      _screenList = _wpSpotExchangeInstrumentList!.where((e) => e.instrumentID!.contains(value)).toList();
      if(_screenList!.isEmpty){
        _screenList = _wpSpotExchangeInstrumentList!.where((e) => e.instrumentName!.contains(value)).toList();
      }else{
        _screenList!.addAll(_wpSpotExchangeInstrumentList!.where((e) => e.instrumentName!.contains(value)).toList());
      }
    }catch(a){
      _screenList = _wpSpotExchangeInstrumentList!.where((e) => e.instrumentID!.contains(value)).toList();
      if(_screenList!.isEmpty){
        _screenList = _wpSpotExchangeInstrumentList!.where((e) => e.instrumentName!.contains(value)).toList();
      }
    }
  }

  //外面现货当前选择证券的行情
  Widget _selectTickerView(){

    String _selectTickerHigh = ''; // 今日最高价
    String _selectTickerLow = ''; // 今日最低价
    String _selectTickerLast = ''; // 最新价
    String _selectTickerChangeRate = ''; //涨跌幅
    String _selectTickerTotalQty = ''; // 总成交量
    String _selectTickerTurnOver = ''; // 当日总成交额
    String _selectTickerOpeningPrice = '';//开盘价
    String _selectTickerOpeningPreClosingPrice = '';//昨日收盘价

    if(_socketTickerModel != null){
      _selectTickerLast = _socketTickerModel!.lastPrice!;//最新价

      if(neverDoubleTryOrZero(_socketTickerModel!.openPrice!) == 0.0){
        _selectTickerChangeRate = '0.0';
      }else{
        _selectTickerChangeRate = ((neverDoubleTryOrZero(_socketTickerModel!.lastPrice!) - neverDoubleTryOrZero(_socketTickerModel!.openPrice!)) / neverDoubleTryOrZero(_socketTickerModel!.openPrice!)).toString();//涨跌幅
      }
      _selectTickerHigh = _socketTickerModel!.highestPrice!;//当日最高价
      _selectTickerLow = _socketTickerModel!.lowestPrice!;//当日最低价
      _selectTickerTotalQty = _transformationNum(neverDoubleTryOrZero(_socketTickerModel!.volume!),dec: 2);//当日总成交量
      _selectTickerTurnOver = _transformationNum(neverDoubleTryOrZero(_socketTickerModel!.turnover!),dec: 2);//当日总成交额
      _selectTickerOpeningPrice = _socketTickerModel!.openPrice!;//开盘价

      _selectTickerOpeningPreClosingPrice = _socketTickerModel!.preClosePrice!;//昨日收盘价
      // _selectTickerOpeningTotalValue = _transformationNum(neverDoubleTryOrZero(_socketTickerModel!.qTotalValue!),dec: 2);//总市值
    }else{
      _selectTickerLast = "";//最新价
      _selectTickerChangeRate = "";//涨跌幅
      _selectTickerHigh = "";//当日最高价
      _selectTickerLow = "";//当日最低价
      _selectTickerTotalQty = "";//当日总成交量
      _selectTickerTurnOver = "";//当日总成交额
      _selectTickerOpeningPrice = "";//开盘价
      _selectTickerOpeningPreClosingPrice = "";//昨日收盘价
      // _selectTickerOpeningTotalValue = "";//总市值
    }


    String  _selectIndexupDownRateStr = '-';
    Color  _selectIndexupDownRateColor = Colors.white;
    try{
      if(_selectTickerChangeRate != "" && _selectTickerChangeRate != null) {
        double _upDownRateDobule = neverDoubleTryOrZero(_selectTickerChangeRate) * 100;
        if(_upDownRateDobule > 0){
          _selectIndexupDownRateStr = '+' + (NumUtil.getNumByValueDouble(_upDownRateDobule, 2))!.toStringAsFixed(2) + '%';
          _selectIndexupDownRateColor = APP_MainGreenColor;
        }else if(_upDownRateDobule == 0){
          _selectIndexupDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule, 2))!.toStringAsFixed(2) + '%';
          _selectIndexupDownRateColor = Colors.white;
        }else{
          _selectIndexupDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule, 2))!.toStringAsFixed(2) + '%';
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

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(3, 3, 3, 3),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: const BoxDecoration(
        color: APP_MainBarColor,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: GestureDetector(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Text(_selectIndexInstrumentID! + (_selectIndexExchangeInstrumentData != null ? ("." + _findTrans(_npFuturesTranslate!,"exchangeID",_selectIndexExchangeInstrumentData!.exchangeID!)) : "") + " " + _selectIndexContractNo!
                      ,style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                  Icon(_isShowCurrencyPick ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,color: Colors.white,size: 25,)
                ],
              ),
              behavior: HitTestBehavior.opaque,
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  _isShowCurrencyPick = !_isShowCurrencyPick;
                  if(_isShowCurrencyPick == false){
                    _tempExchangeNo = _selectIndexExchangeNo!;//这里是交易所的临时判定
                    _tempTradeCurrency = _selectIndexTradeCurrency!;
                    _wpSpotExchangeInstrumentList!.clear();
                    _wpSpotExchangeInstrumentList!.addAll(_tempNpSpotExchangeInstrumentList!);
                    _WpSpotExchangeDataHttp();
                    _WpSpotExchangeInstrumentDataHttp(exchangeID: _tempExchangeNo);
                  }
                });
              },
            ),
            alignment: Alignment.center,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(_selectTickerLast,style: TextStyle(fontSize: 14,color: _selectIndexupDownRateColor,fontWeight: FontWeight.w500),),
                  alignment: Alignment.centerLeft,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(_selectIndexupDownRateStr,style: TextStyle(fontSize: 12,color: _selectIndexupDownRateColor),),
                  alignment: Alignment.centerLeft,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("最低价" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")"),style: const TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(_selectTickerLow,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("最高价" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")"),style: const TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(_selectTickerHigh,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: const Text("成交量"+ "(手)" ,style: TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerTotalQty,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: const Text("成交额(CNY)" ,style: TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerTurnOver,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("今日开盘价" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")") ,style: const TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerOpeningPrice,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("昨日收盘价" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")"),style: const TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerOpeningPreClosingPrice,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
        ],
      ),//头部选择币种栏
    );
  }

  //币种列表 买卖盘口/最新成交
  Widget _SpotWidget(){
    ChartStyle _chartStyle = ChartStyle();
    ChartColors _chartColors = ChartColors();
    return Container(
      child: Column(
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
                                          color: _selectKlineTimeTypeName == _klineTimeTypeAllList[index] ? APP_MainGreenColor : Colors.transparent,
                                          child: const Text('',style: TextStyle(color: Colors.transparent),),
                                          alignment: Alignment.topCenter,
                                          height: 4,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(_klineTimeTypeAllList[index],style: TextStyle(color: Colors.white),),
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
                                    // String _selectKlineTimeType = '2'; // 1 : 1分 2：5分 3：15分 4：30分 5：60分 6：24小时
                                    _selectKlineTimeTypeName = _klineTimeTypeAllList[index];
                                    if(_isSocektOn){
                                      if(_selectIndexInstrumentID! == ''){
                                        print("无数据不发unsub");
                                        return;
                                      }
                                      String subsStr= "{\"unsubs\":\"quote.wpspot.openctp." + _selectIndexInstrumentID! + ".kline." + _selectKlineTimeType
                                          + "\"}";
                                      // print(subsStr);
                                      _channel.sink.add(subsStr);
                                    }
                                    if(_selectKlineTimeTypeName == '1分'){
                                      _isTimeLine = false;
                                      _selectKlineTimeType = "1";
                                    }else if(_selectKlineTimeTypeName == '5分'){
                                      _isTimeLine = false;
                                      _selectKlineTimeType = "2";
                                    }else if(_selectKlineTimeTypeName == '15分'){
                                      _isTimeLine = false;
                                      _selectKlineTimeType = "3";
                                    }else if(_selectKlineTimeTypeName == '30分'){
                                      _isTimeLine = false;
                                      _selectKlineTimeType = "4";
                                    }else if(_selectKlineTimeTypeName == '60分'){
                                      _isTimeLine = false;
                                      _selectKlineTimeType = "5";
                                    }else if(_selectKlineTimeTypeName == '1日'){
                                      _isTimeLine = false;
                                      _selectKlineTimeType = "6";
                                    }else if(_selectKlineTimeTypeName == '分时'){
                                      _isTimeLine = true;
                                      _selectKlineTimeType = "1";
                                    }
                                    if(_isSocektOn){
                                      if(_selectIndexInstrumentID! == ''){
                                        print("无数据不发sub");
                                        return;
                                      }
                                      String subsStr= "{\"subs\":\"quote.wpspot.openctp." + _selectIndexInstrumentID! + ".kline." + _selectKlineTimeType
                                          + "\"}";
                                      // print(subsStr);
                                      _channel.sink.add(subsStr);
                                    }else{
                                      _onRest();
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
                                                  color: _mainStateName == _mainStateList[index] ? APP_MainGreenColor : Colors.transparent,
                                                  child: const Text('',style: TextStyle(color: Colors.transparent),),
                                                  alignment: Alignment.topCenter,
                                                  height: 4,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(_mainStateList[index],style: TextStyle(color: Colors.white),),
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
                                    controller: _controller6,
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
                                                    child: Text(_secondaryStateList[index],style: TextStyle(color: Colors.white),),
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
                                  margin:const  EdgeInsets.fromLTRB(3, 0, 0, 0),
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
                    width: kSpotWidth,
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
                                  controller: _controller7,
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
                          offstage: _selectTransactionType == '买卖盘口' ? false : true,
                          child: WPFuturesView_orderTitle(priceTitle: _selectIndexTradeCurrency!),
                        ),
                        Offstage(
                          offstage: _selectTransactionType == '最新成交' ? false : true,
                          child: WPFuturesView_tradeTitle(priceTitle: _selectIndexTradeCurrency!),
                        ),
                        Expanded(
                          child:_selectTransactionType == '买卖盘口' ?
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    reverse : true,
                                    controller: _controller8,
                                    itemBuilder: (context,index){
                                      String _priceNumStr = '-';
                                      double _priceDouble = neverDoubleTryOrZero(_tickAsksQtysList[index]);
                                      _priceNumStr = _transformationNum(_priceDouble);

                                      return Container(
                                        alignment: Alignment.center,
                                        color: APP_MainBGColor,
                                        width: 300,
                                        child: GestureDetector(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_tickAsksList[index]), 2)).toString(),style: const TextStyle(color: APP_MainRedColor,fontSize: 12),),
                                                  alignment: Alignment.centerLeft,
                                                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(_priceNumStr,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                                  alignment: Alignment.centerRight,
                                                  padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                                                ),
                                              ),
                                            ],
                                          ),
                                          behavior: HitTestBehavior.opaque,
                                          onTap: (){
                                            setState(() {
                                              _transactionPriceController.text = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_tickAsksList[index]), _decSize)).toString() ;
                                            });
                                          },
                                        ),
                                      );
                                    },
                                    itemCount: _tickAsksList.length,
                                  ),
                                ),
                                Container(
                                  padding:const  EdgeInsets.all(1),
                                  color: Colors.black,
                                  child: Container(
                                    child: const SizedBox(height: 1,),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    controller: _controller9,
                                    itemBuilder: (context,index){

                                      String _priceNumStr = '-';
                                      double _priceDouble = neverDoubleTryOrZero(_tickBidsQtysList[index].toString());
                                      _priceNumStr = _transformationNum(_priceDouble);


                                      return Container(
                                        alignment: Alignment.center,
                                        color: APP_MainBGColor,
                                        width: 300,
                                        child: GestureDetector(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_tickBidsList[index]), 2)).toString(),style: const TextStyle(color: APP_MainGreenColor,fontSize: 12),),
                                                  alignment: Alignment.centerLeft,
                                                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(_priceNumStr,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                                  alignment: Alignment.centerRight,
                                                  padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                                                ),
                                              ),
                                            ],
                                          ),
                                          behavior: HitTestBehavior.opaque,
                                          onTap: (){
                                            setState(() {
                                              _transactionPriceController.text = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_tickBidsList[index]), _decSize)).toString() ;
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
                            controller: _controller10,
                            itemBuilder: (context,index){
                              return Container(
                                alignment: Alignment.center,
                                color: APP_MainBGColor,
                                width: 300,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Text(_tradesList[index]["price"].toString(),style: const TextStyle(color: Colors.white,fontSize: 12),),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(_tradesList[index]['qty'].toString(),style: const TextStyle(color: Colors.white,fontSize: 12),),
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.fromLTRB(3, 5, 0, 5),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(DateFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(_tradesList[index]["ts"].toString()) ?? 0),
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
                  )
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
      ),
    );
  }

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

  //交易面板/证券介绍面板
  int _decSize = 8;//全局小数位数
  Widget _TransactionPanelWidget(){

    String _equity = '-';
    String _available = '-';
    String _balanceToPreBalance = '-';
    String _balanceXpreBalance = "-";
    if(_wpSpotTradingAccountList != null && _wpSpotTradingAccountList!.isNotEmpty){
      _equity = _wpSpotTradingAccountList!.first.balance!;
      _available = _wpSpotTradingAccountList!.first.available!;
      _balanceToPreBalance = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_wpSpotTradingAccountList!.first.balance!) - neverDoubleTryOrZero(_wpSpotTradingAccountList!.first.preBalance!), 2)).toString();
      if(neverDoubleTryOrZero(_wpSpotTradingAccountList!.first.preBalance!) == 0.0){
        _balanceXpreBalance = '0.0%';
      }else{
        _balanceXpreBalance = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(_wpSpotTradingAccountList!.first.balance!) - neverDoubleTryOrZero(_wpSpotTradingAccountList!.first.preBalance!)) / neverDoubleTryOrZero(_wpSpotTradingAccountList!.first.preBalance!) * 100, 2)).toString() + '%';
      }
    }else{
      _equity = '-';
      _available = '-';
      _balanceToPreBalance = '-';
      _balanceXpreBalance = "-";
    }

    String _instrumentName = '-';//证券名称
    String _instrumentID = '-';//证券代码
    String _exchangeID = '-';//交易所
    String _productClass = '-';//产品类型
    String _priceTick = '-';//最小变动价位
    String _volumeMultiple = '-';//每手乘数
    String _minmaxMarketOrderVolume = '-';//市价单最大/小下单量
    String _minmaxLimitOrderVolume = '-';//限价单最大/小下单量
    String _createDate = '-';//创建日
    String _openDate = '-';//上市日
    String _expireDate = '-';//到期日
    String _startDelivDate = '-';//开始交割日期
    String _endDelivDate = '-';//结束交割日期

    if(_selectIndexExchangeInstrumentData != null){
      _instrumentName = _selectIndexExchangeInstrumentData!.instrumentName!;
      _instrumentID = _selectIndexExchangeInstrumentData!.instrumentID!;
      _exchangeID = _selectIndexExchangeInstrumentData!.exchangeID!;
      _productClass = '现货';//_findTrans(_npFuturesTranslate!,"ProductClass",_selectIndexExchangeInstrumentData!.productClass!);//要翻译
      _priceTick = _selectIndexExchangeInstrumentData!.priceTick!;

      if(_priceTick == '0.0'){
        _decSize = 8;
      }else{
        if(_priceTick.contains('.')){
          _decSize = _priceTick.length - _priceTick.indexOf(".") - 1;
          if(_priceTick.endsWith(".0")){
            _decSize = _decSize - 1;
          }
        }else{
          _decSize = 0;
        }
      }
      _volumeMultiple = _selectIndexExchangeInstrumentData!.volumeMultiple!;
      _minmaxMarketOrderVolume = _selectIndexExchangeInstrumentData!.maxMarketOrderVolume! + '/' + _selectIndexExchangeInstrumentData!.minMarketOrderVolume!;
      _minmaxLimitOrderVolume = _selectIndexExchangeInstrumentData!.maxLimitOrderVolume! + '/' + _selectIndexExchangeInstrumentData!.minLimitOrderVolume!;
      _createDate = _selectIndexExchangeInstrumentData!.createDate!;
      _openDate = _selectIndexExchangeInstrumentData!.openDate!;
      _expireDate = _selectIndexExchangeInstrumentData!.expireDate!;
      _startDelivDate = _selectIndexExchangeInstrumentData!.startDelivDate!;
      _endDelivDate = _selectIndexExchangeInstrumentData!.endDelivDate!;
    }else{
      _instrumentName = '-';
      _instrumentID = '-';
      _exchangeID = '-';
      _productClass = '-';
      _priceTick = '-';
      _volumeMultiple = '-';
      _minmaxMarketOrderVolume = '-';
      _minmaxLimitOrderVolume = '-';
      _createDate = '-';
      _openDate = '-';
      _expireDate = '-';
      _startDelivDate = '-';
      _endDelivDate = '-';
      _decSize = 8;
    }

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: APP_MainBGColor,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: APP_MainBarColor,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: const Text("交易",style: TextStyle(color: Colors.white),),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    ),
                  ), //头部选择
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: ListView(
                        controller: _controller12,
                        shrinkWrap: true,
                        children: [
                          Container(
                            child: Text("价格(" + _selectIndexTradeCurrency! + ")",style: const TextStyle(fontSize: 12,color: Colors.grey),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          ),
                          Container(
                            height: 30,
                            child: TextField(
                              enabled: true,
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
                              inputFormatters: [
                                TextInput_onlyNum(decimalRange: _decSize,integerRange: 14),
                              ],
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
                            child: const Text("数量(手)",style: TextStyle(fontSize: 12,color: Colors.grey),),
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
                              controller: _transactionNumberController,
                              autocorrect:false,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal : true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                // TextInput_onlyNum(decimalRange: 0,integerRange: 14),
                              ],
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
                            child: Text("金额(" + _selectIndexTradeCurrency! + ")",style: const TextStyle(fontSize: 12,color: Colors.grey),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          ),
                          Container(
                            height: 30,
                            child: TextField(
                              enabled: _selectTransactionPanelType == '限价委托' ? true : false,
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
                              controller: _transactionAmountController,
                              autocorrect:false,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal : true,
                              ),
                              inputFormatters: [
                                TextInput_onlyNum(decimalRange: 8,integerRange: 14),
                              ],
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
                                  child: const Text("今可用:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_available,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                              ],
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
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
                                      if(_selectTransactionPanelType == '限价委托' || _selectTransactionPanelType == '限价止损'){
                                        if(_transactionPriceController.text == ''){
                                          showMyCustomText("请输入交易价格");
                                          return;
                                        }
                                        if(neverDoubleTryOrZero(_priceTick) != 0.0){
                                          double _tokeD = (NumUtil.remainder(neverDoubleTryOrZero(_transactionPriceController.text),neverDoubleTryOrZero(_priceTick))).toDouble();
                                          if(_tokeD != 0.0){
                                            showMyCustomText("请确认输入的价格是最小变动价位的整倍数");
                                            return;
                                          }
                                        }
                                      }

                                      if(_transactionNumberController.text == ''){
                                        showMyCustomText("请输入交易数量");
                                        return;
                                      }else{
                                        if(neverDoubleTryOrZero(_transactionNumberController.text) == 0.0){
                                          showMyCustomText("交易数量应大于100且为100的整倍数");
                                          return;
                                        }else{
                                          double _check = neverDoubleTryOrZero(_transactionNumberController.text) % 100;
                                          if(_check != 0.0){
                                            showMyCustomText("交易数量应大于100且为100的整倍数");
                                            return;
                                          }
                                        }
                                      }


                                      String _orderTypeS = '2';
                                      // if(_selectTransactionPanelType == '市价委托'){
                                      //   _orderTypeS = '1';
                                      // }else if(_selectTransactionPanelType == '限价委托'){
                                      //   _orderTypeS = '2';
                                      // }else{
                                      //   return;
                                      // }
                                      _WpSpotOrderOrderInsertHttp(
                                        combHedgeFlag:"1",
                                        combOffsetFlag:'0',
                                        direction:"0",
                                        exchangeID:_selectIndexExchangeNo!,
                                        instrumentID:_selectIndexExchangeInstrumentData!.instrumentID!,
                                        limitPrice:_transactionPriceController.text,
                                        orderPriceType:_orderTypeS,
                                        volumeTotalOriginal:_transactionNumberController.text,
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
                                      if(_selectTransactionPanelType == '限价委托' || _selectTransactionPanelType == '限价止损'){
                                        if(_transactionPriceController.text == ''){
                                          showMyCustomText("请输入交易价格");
                                          return;
                                        }
                                        if(neverDoubleTryOrZero(_priceTick) != 0.0){
                                          double _tokeD = (NumUtil.remainder(neverDoubleTryOrZero(_transactionPriceController.text),neverDoubleTryOrZero(_priceTick))).toDouble();
                                          if(_tokeD != 0.0){
                                            showMyCustomText("请确认输入的价格是最小变动价位的整倍数");
                                            return;
                                          }
                                        }
                                      }
                                      if(_transactionNumberController.text == ''){
                                        showMyCustomText("请输入交易数量");
                                        return;
                                      }else{
                                        if(neverDoubleTryOrZero(_transactionNumberController.text) == 0.0){
                                          showMyCustomText("交易数量应大于100且为100的整倍数");
                                          return;
                                        }else{
                                          double _check = neverDoubleTryOrZero(_transactionNumberController.text) % 100;
                                          if(_check != 0.0){
                                            showMyCustomText("交易数量应大于100且为100的整倍数");
                                            return;
                                          }
                                        }
                                      }

                                      String _orderTypeS = '2';
                                      // if(_selectTransactionPanelType == '市价委托'){
                                      //   _orderTypeS = '1';
                                      // }else if(_selectTransactionPanelType == '限价委托'){
                                      //   _orderTypeS = '2';
                                      // }else{
                                      //   return;
                                      // }

                                      _WpSpotOrderOrderInsertHttp(
                                        combHedgeFlag:"1",
                                        combOffsetFlag:'0',
                                        direction:"1",
                                        exchangeID:_selectIndexExchangeNo!,
                                        instrumentID:_selectIndexExchangeInstrumentData!.instrumentID!,
                                        limitPrice:_transactionPriceController.text,
                                        orderPriceType:_orderTypeS,
                                        volumeTotalOriginal:_transactionNumberController.text,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              color: APP_MainBGColor,
              margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: APP_MainBarColor,
                    child: const Text("证券信息",style: TextStyle(color: Colors.white,fontSize: 13),),
                    alignment: Alignment.center,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      alignment: Alignment.bottomCenter,
                      child: ListView(
                        controller: _controller13,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("证券名称:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_instrumentName,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("证券代码:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_instrumentID,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("交易所:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_exchangeID,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("产品类型:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_productClass,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("最小变动价位:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_priceTick,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("证券数量乘数:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_volumeMultiple,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("市价单最大/小下单量:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_minmaxMarketOrderVolume,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("限价单最大/小下单量:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_minmaxLimitOrderVolume,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("创建日:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_createDate,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("上市日:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_openDate,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("到期日:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_expireDate,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("交割日期:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_startDelivDate + '-' + _endDelivDate,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //下部面板-当前委托/历史委托/历史成交/持仓/资产
  Widget _accountWidget(){
    return Container(
      padding: const EdgeInsets.fromLTRB(3, 0, 1, 3),
      height: _accountWidgetHeight,
      child: Container(
        alignment: Alignment.center,
        color: APP_MainBGColor,
        child: Column(
          children: [
            _accountWidgetHead(), //头部选择
            Offstage(
              offstage: _selectAssetEntrustmentType == '当前委托' ? false : true,
              child: Container(
                color: APP_MainBGColor,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text("交易所",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("证券",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("本地订单编号",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("订单类型",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托方向",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托价",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托数量",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("订单状态",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托时间",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("详细状态",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: GestureDetector(
                          child: Container(
                            child: const Text("批量撤单",style: TextStyle(fontSize: 10,color: APP_MainGreenColor),),
                            padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            _WpSpotOrderBatchCancelOrderHttp();
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
                        child: const Text("交易所",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("证券",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("本地订单编号",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("订单类型",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托方向",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托价",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托数量",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("订单状态",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托时间",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("详细状态",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: _selectAssetEntrustmentType == '历史成交' ? false : true,
              child: Container(
                color: APP_MainBGColor,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text("投资者代码",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("交易所",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("证券",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交编号",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交方向",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交价格",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交数量(手)",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交时间",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: _selectAssetEntrustmentType == '持仓' ? false : true,
              child: Container(
                color: APP_MainBGColor,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text("投资者代码",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("交易所代码",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("证券代码",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("持仓方向",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("持仓日期",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("持仓数量",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("持仓成本",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    // Expanded(
                    //   child: Container(
                    //     child: const Text("持仓占用",style: TextStyle(fontSize: 10,color: Colors.grey),),
                    //     alignment: Alignment.centerLeft,
                    //     padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    //   ),
                    //   flex: 2,
                    // ),
                    Expanded(
                      child: Container(
                        child: const Text("持仓盈亏",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("操作",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                  ],
                ),

              ),
            ),
            Expanded (
              child: _selectAssetEntrustmentType == '资产' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child: EasyRefresh(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView.builder(
                    controller: _controller14,
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
                        _WpSpotTradingAccountDataHttp();
                      }
                    });
                  },
                  onLoad: null,
                ),
              ) :
              _selectAssetEntrustmentType == '当前委托' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child:EasyRefresh(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView.builder(
                    controller: _controller15,
                    itemBuilder: (context,index){
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderList![index].exchangeID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderList![index].instrumentID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderList![index].orderLocalID!.trim(),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "ComboOffsetFlag", _wpSpotOrderList![index].combOffsetFlag!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "Direction", _wpSpotOrderList![index].direction!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderList![index].limitPrice!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderList![index].volumeTotalOriginal!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding:const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "OrderStatus", _wpSpotOrderList![index].orderStatus!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderList![index].insertDate! + ' ' + _wpSpotOrderList![index].insertTime!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderList![index].statusMsg!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Offstage(
                                  child: GestureDetector(
                                    child: Container(
                                      child: const Text("撤单",style: TextStyle(fontSize: 10,color: APP_MainGreenColor),),
                                      padding: const EdgeInsets.fromLTRB(3, 2, 0, 2),
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: (){
                                      _WpSpotOrderOrderActionHttp(
                                        exchangeID: _wpSpotOrderList![index].exchangeID!,
                                        instrumentID:_wpSpotOrderList![index].instrumentID!,
                                        investorID:_wpSpotOrderList![index].investorID!,
                                        orderRef:_wpSpotOrderList![index].orderRef!,
                                        frontID: _wpSpotOrderList![index].frontID!,
                                        sessionID: _wpSpotOrderList![index].sessionID!,
                                      );
                                    },
                                  ),
                                  offstage: (_wpSpotOrderList![index].orderStatus! == "1" || _wpSpotOrderList![index].orderStatus! == "3") ? false : true,
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
                    itemCount: _wpSpotOrderList!.length,
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
                  footer: _wpSpotOrderInfohasNextPage!
                      ? ClassicalFooter(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    loadText: '上拉刷新',
                    loadReadyText: '松开立即刷新',
                    loadingText: '正在刷新数据..',
                    loadedText: "刷新完成",
                    loadFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  )
                      : null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpSpotOrderInfoPage = 1;
                        _WpSpotOrderDataHttp();
                      }
                    });
                  },
                  onLoad: _wpSpotOrderInfohasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpSpotOrderInfoPage += 1;
                        _WpSpotOrderDataHttp();
                      }
                    });
                  } : null,
                ),
              ) :
              _selectAssetEntrustmentType == '历史委托' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child:EasyRefresh(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView.builder(
                    controller: _controller16,
                    itemBuilder: (context,index){
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderHisList![index].exchangeID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderHisList![index].instrumentID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderHisList![index].orderLocalID!.trim(),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "ComboOffsetFlag", _wpSpotOrderHisList![index].combOffsetFlag!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "Direction", _wpSpotOrderHisList![index].direction!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderHisList![index].limitPrice!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderHisList![index].volumeTotalOriginal!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "OrderStatus", _wpSpotOrderHisList![index].orderStatus!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderHisList![index].insertDate! + ' ' + _wpSpotOrderHisList![index].insertTime!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotOrderHisList![index].statusMsg!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                          ],
                        ),

                      );
                    },
                    itemCount: _wpSpotOrderHisList!.length,
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
                  footer: _npSpotOrderInfoHishasNextPage!
                      ? ClassicalFooter(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    loadText: '上拉刷新',
                    loadReadyText: '松开立即刷新',
                    loadingText: '正在刷新数据..',
                    loadedText: "刷新完成",
                    loadFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  )
                      : null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpSpotOrderInfoHisPage = 1;
                        _WpSpotOrderHisDataHttp();
                      }
                    });
                  },
                  onLoad: _npSpotOrderInfoHishasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpSpotOrderInfoHisPage += 1;
                        _WpSpotOrderHisDataHttp();
                      }
                    });
                  } : null,
                ),
              ) :
              _selectAssetEntrustmentType == '历史成交' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child: EasyRefresh(
                  behavior: MyCustomScrollBehavior(),
                  child:ListView.builder(
                    controller: _controller17,
                    itemBuilder: (context,index){
                      return Container(
                        color: APP_MainBGColor,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotTradeList![index].investorID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotTradeList![index].exchangeID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotTradeList![index].instrumentID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotTradeList![index].tradeID!.trim(),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "Direction", _wpSpotTradeList![index].direction!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text( _wpSpotTradeList![index].price!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text( _wpSpotTradeList![index].volume!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotTradeList![index].tradeDate! + " " + _wpSpotTradeList![index].tradeTime!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: _wpSpotTradeList!.length,
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
                  footer: _wpSpotTradehasNextPage!
                      ? ClassicalFooter(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    loadText: '上拉刷新',
                    loadReadyText: '松开立即刷新',
                    loadingText: '正在刷新数据..',
                    loadedText: "刷新完成",
                    loadFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  )
                      : null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpSpotTradePage = 1;
                        _WpSpotTradeDataHttp();
                      }
                    });
                  },
                  onLoad: _wpSpotTradehasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpSpotTradePage += 1;
                        _WpSpotTradeDataHttp();
                      }
                    });
                  }
                      : null,
                ),
              ) :
              _selectAssetEntrustmentType == '持仓' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child:EasyRefresh(
                  child:ListView.builder(
                    controller: _controller18,
                    itemBuilder: (context,index){

                      String _todoSell = '';
                      Color _todoSellColor = Colors.white;
                      if(_wpSpotInvestorPositionList![index].posiDirection! == '1'){
                        _todoSell = '卖出';
                        _todoSellColor = Colors.white;
                      }else if(_wpSpotInvestorPositionList![index].posiDirection! == '2'){
                        _todoSell = '多头平仓';
                        _todoSellColor = APP_MainRedColor;
                      }else if(_wpSpotInvestorPositionList![index].posiDirection! == '3'){
                        _todoSell = '空头平仓';
                        _todoSellColor = APP_MainGreenColor;
                      }else{
                        _todoSell = '';
                        _todoSellColor = Colors.white;
                      }


                      // print(_wpSpotInvestorPositionList![index].lastPrice!);
                      String _positionProfit = ''; //持仓盈亏
                      if(neverDoubleTryOrZero(_wpSpotInvestorPositionList![index].position!) != 0.0){
                        if(neverDoubleTryOrZero(_wpSpotInvestorPositionList![index].lastPrice!) != 0.0){
                          double pos = (neverDoubleTryOrZero(_wpSpotInvestorPositionList![index].lastPrice!) * neverDoubleTryOrZero(_wpSpotInvestorPositionList![index].position!)) - neverDoubleTryOrZero(_wpSpotInvestorPositionList![index].positionCost!);
                          _positionProfit = (NumUtil.getNumByValueDouble(pos, 2)).toString().toString();
                        }else{
                          _positionProfit = '-';
                        }
                      }else{
                        _positionProfit = '-';
                      }


                      return Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotInvestorPositionList![index].investorID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotInvestorPositionList![index].exchangeID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotInvestorPositionList![index].instrumentID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "PosiDirection", _wpSpotInvestorPositionList![index].posiDirection!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(//PositionDate
                                child: Text(_findTrans(_npFuturesTranslate!, "PositionDate", _wpSpotInvestorPositionList![index].positionDate!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotInvestorPositionList![index].position!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpSpotInvestorPositionList![index].positionCost!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            // Expanded(
                            //   child: Container(
                            //     child: Text(_wpSpotInvestorPositionList![index].useMargin!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                            //     padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            //     alignment: Alignment.centerLeft,
                            //   ),
                            //   flex: 2,
                            // ),
                            Expanded(
                              child: Container(
                                child: Text(_positionProfit,style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500,
                                    color:  neverDoubleTryOrZero(_positionProfit) >= 0 ? APP_MainGreenColor : APP_MainRedColor),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  child: Text(_todoSell,style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: _todoSellColor),),
                                  padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                  alignment: Alignment.centerLeft,
                                ),
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  AwesomeDialog(
                                    context: context,
                                    headerAnimationLoop: false,
                                    dismissOnBackKeyPress:true,
                                    width:MediaQuery.of(context).size.width / 2.5,
                                    dialogType: DialogType.NO_HEADER,
                                    animType: AnimType.BOTTOMSLIDE,
                                    dialogBackgroundColor:APP_MainBarColor,
                                    body: _TransactionPanelSignalWidget(
                                      _wpSpotInvestorPositionList![index],
                                      todoSell:_todoSell,
                                    ),
                                  ).show();
                                },
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: _wpSpotInvestorPositionList!.length,
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
                  footer: _wpSpotInvestorPositionhasNextPage!
                      ? ClassicalFooter(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    loadText: '上拉刷新',
                    loadReadyText: '松开立即刷新',
                    loadingText: '正在刷新数据..',
                    loadedText: "刷新完成",
                    loadFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  )
                      : null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpSpotInvestorPositionPage = 1;
                        _WpSpotInvestorPositionDataHttp();
                      }
                    });
                  },
                  onLoad: _wpSpotInvestorPositionhasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpSpotInvestorPositionPage += 1;
                        _WpSpotInvestorPositionDataHttp();
                      }
                    });
                  }
                      : null,
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
              child:  ListView.builder(
                controller: _controller19,
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
                        _refreshEveryWhere();
                      });
                    },
                  );
                },
                itemCount: _selectAssetEntrustmentTypeName.length,
              ),
            ),
            GestureDetector(
              child: Container(
                child: RotationTransition(
                  turns: _animation!,
                  child: const Icon(Icons.refresh_rounded,color: Colors.white,size: 25,),
                ),
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              ),
              behavior: HitTestBehavior.opaque,
              onTap: (){
                // 防重复提交
                if(DateTime.now().difference(_lastPopTime) > const Duration(seconds: 2)){
                  _lastPopTime = DateTime.now();
                  _controller!.forward();
                  _refreshEveryWhere();
                }else{
                }
                // _refreshEveryWhere();
              },
            ),
            GestureDetector(
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
          ],
        ),
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


  //交易面板/证券介绍面板 弹窗版本
  Widget _TransactionPanelSignalWidget(WpSpotInvestorPositionListData data,{String todoSell = ''}){

    //maker类型
    var _orderPriceType = '2';
    List<DropdownMenuItem<String>> _orderPriceTypeItems =const [
      DropdownMenuItem(child: Text('限价委托',style: TextStyle(color: Colors.white,fontSize: 13),),value: '2',),
      DropdownMenuItem(child: Text('市价委托',style: TextStyle(color: Colors.white,fontSize: 13),),value: '1',),
    ];

    //交易面板套件
    TextEditingController _transactionPriceInsideController = TextEditingController();
    TextEditingController _transactionNumberInsideController = TextEditingController();
    TextEditingController _transactionAmountInsideController = TextEditingController();

    int _decSize = 8;
    String _insidePriceTick = data.priceTick!;
    if(_insidePriceTick == '0.0'){
      _decSize = 8;
    }else{
      if(_insidePriceTick.contains('.')){
        _decSize = _insidePriceTick.length - _insidePriceTick.indexOf(".") - 1;
        if(_insidePriceTick.endsWith(".0")){
          _decSize = _decSize - 1;
        }
      }else{
        _decSize = 0;
      }
    }

    return StatefulBuilder(
        builder: (tContext, mSetState){
          return Container(
            decoration: const BoxDecoration(
              color: APP_MainBGColor,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: ListView(
                controller: _controller20,
                shrinkWrap: true,
                children: [
                  Container(
                    child: Text( "交易所代码: " + data.exchangeID! + ' 证券代码: ' + data.instrumentID! + ' 最小变动价位:' + data.priceTick!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      alignment: Alignment.centerRight,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        //边框圆角设置
                        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                        border: Border.all(color: const Color.fromRGBO(15, 159, 131, 1)),
                      ),
                      child: DropdownButton(
                        items:_orderPriceTypeItems,
                        onChanged: (value) {
                          mSetState(() {
                            _orderPriceType = value.toString();
                            if(_orderPriceType == '1'){
                              _transactionPriceInsideController.text = '';
                            }
                          });
                        },
                        hint: const Text('请选择交易模式',style: TextStyle(color: Colors.grey,fontSize: 13),),
                        value:_orderPriceType == '' ? null : _orderPriceType,
                        elevation: 8, //设置阴影的高度
                        isExpanded: true,
                        dropdownColor: APP_MainBGColor,
                        icon: const Icon(Icons.arrow_drop_down,color: Colors.white,),
                        underline: Container(height: 0),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  ),
                  Container(
                    child: const Text("价格(CNY)",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  ),
                  Container(
                    height: 30,
                    child: TextField(
                      enabled: _orderPriceType == '2' ? true : false,
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
                        hintText: _orderPriceType == '2' ? '请输入单价' : '以当前市场最优价格下单',
                        hintStyle: const TextStyle(color: Colors.grey,fontSize: 11),
                      ),
                      controller: _transactionPriceInsideController,
                      autocorrect:false,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal : true,
                      ),
                      inputFormatters: [
                        TextInput_onlyNum(decimalRange: _decSize,integerRange: 14),
                      ],
                      style: const TextStyle(color: Colors.white,fontSize: 11),
                      onChanged: (value){
                        if(value == ''){
                          _transactionAmountInsideController.text = '';
                        }else{
                          if(_transactionNumberInsideController.text != ''){
                            _transactionAmountInsideController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) * neverDoubleTryOrZero(_transactionNumberInsideController.text)), 8)).toString();
                          }
                        }
                      },
                    ),
                  ),
                  Container(
                    child: const Text("数量(手)",style: TextStyle(fontSize: 12,color: Colors.grey),),
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
                      controller: _transactionNumberInsideController,
                      autocorrect:false,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal : true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // TextInput_onlyNum(decimalRange: 0,integerRange: 14),
                      ],
                      style: const TextStyle(color: Colors.white,fontSize: 11),
                      onChanged: (value){
                        //这个是交易数量的变动
                        //1：价格变动 不影响这个的输入变动
                        //2：数量变动 会联动金额变动
                        //3：金额变动 会联动数量变动
                        if(value == ''){
                          _transactionAmountInsideController.text = '';
                        }else{
                          if(_transactionPriceInsideController.text != ''){
                            _transactionAmountInsideController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) * neverDoubleTryOrZero(_transactionPriceInsideController.text)), 8)).toString();
                          }
                        }
                      },
                    ),
                  ),
                  Offstage(
                    offstage: _orderPriceType == '2' ? false : true,
                    child: Column(
                      children: [
                        Container(
                          child: const Text("金额(CNY)",style: TextStyle(fontSize: 12,color: Colors.grey),),
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
                            controller: _transactionAmountInsideController,
                            autocorrect:false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal : true,
                            ),
                            inputFormatters: [
                              TextInput_onlyNum(decimalRange: 8,integerRange: 14),
                            ],
                            style: const TextStyle(color: Colors.white,fontSize: 11),
                            onChanged: (value){
                              if(value == ''){
                                _transactionNumberInsideController.text = '';
                              }else{
                                if(_transactionPriceInsideController.text != ''){
                                  _transactionNumberInsideController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) / neverDoubleTryOrZero(_transactionPriceInsideController.text)), 8)).toString();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: GestureDetector(
                      child:Container(
                        decoration: BoxDecoration(
                          color: data.posiDirection! == '2' ? APP_MainRedColor : APP_MainGreenColor,
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        alignment: Alignment.center,
                        child: Text(todoSell,style: const TextStyle(fontSize: 14,color: Colors.white),),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        if(_orderPriceType == '2'){
                          if(_transactionPriceInsideController.text == ''){
                            showMyCustomText("请输入交易价格");
                            return;
                          }
                          if(neverDoubleTryOrZero(_insidePriceTick) != 0.0){
                            double _tokeD = (NumUtil.remainder(neverDoubleTryOrZero(_transactionPriceInsideController.text),neverDoubleTryOrZero(_insidePriceTick))).toDouble();
                            if(_tokeD != 0.0){
                              showMyCustomText("请确认输入的价格是最小变动价位的整倍数");
                              return;
                            }
                          }
                        }

                        double _canPosition = 0.0;
                        if(data.posiDirection! == '2'){//多头持仓下可平数量=持仓数量-空头冻结数量
                          _canPosition = neverDoubleTryOrZero(data.position!) - neverDoubleTryOrZero(data.shortFrozen!);
                        }else if(data.posiDirection! == '3'){//多头持仓下可平数量=持仓数量-空头冻结数量
                          _canPosition = neverDoubleTryOrZero(data.position!) - neverDoubleTryOrZero(data.longFrozen!);
                        }else{
                          _canPosition = neverDoubleTryOrZero(data.position!);
                        }


                        if(_transactionNumberInsideController.text == ''){
                          showMyCustomText("请输入交易数量");
                          return;
                        }else{
                          if(neverDoubleTryOrZero(_transactionNumberInsideController.text) == 0.0){
                            showMyCustomText("交易数量应大于100且为100的整倍数");
                            return;
                          }else if(neverDoubleTryOrZero(_transactionNumberInsideController.text) > _canPosition){
                            showMyCustomText("下单数量不可大于可平数量");
                            return;
                          }else{
                            double _check = neverDoubleTryOrZero(_transactionNumberInsideController.text) % 100;
                            if(_check != 0.0){
                              showMyCustomText("交易数量应大于100且为100的整倍数");
                              return;
                            }
                          }
                        }


                        String _direction = '';
                        if(data.posiDirection! == '2') { //2 多头 卖
                          _direction = '1';
                        }else if(data.posiDirection! == '3') { //3 空头 买
                          _direction = '0';
                        }else{
                          _direction = '';
                        }

                        // String _combOffsetFlag = '';
                        // if(data.positionDate == '1'){
                        //   _combOffsetFlag = '3';
                        // }else if(data.positionDate == '2'){
                        //   _combOffsetFlag = '1';
                        // }else{
                        //   _combOffsetFlag = '';
                        // }

                        Navigator.pop(tContext);

                        // print(_orderPriceType);
                        _WpSpotOrderOrderInsertHttp(
                          combHedgeFlag:"1",
                          combOffsetFlag:'1',
                          direction:_direction,
                          exchangeID:data.exchangeID!,
                          instrumentID:data.instrumentID!,
                          limitPrice:_transactionPriceInsideController.text,
                          orderPriceType:_orderPriceType,
                          volumeTotalOriginal:_transactionNumberInsideController.text,
                        );


                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  //到处刷新
  void _refreshEveryWhere(){
    if(_selectAssetEntrustmentType == '历史成交'){
      _wpSpotTradePage = 1;
      _WpSpotTradeDataHttp();
    }else if(_selectAssetEntrustmentType == '当前委托'){
      _wpSpotOrderInfoPage = 1;
      _WpSpotOrderDataHttp();
    }else if(_selectAssetEntrustmentType == '历史委托'){
      _wpSpotOrderInfoHisPage = 1;
      _WpSpotOrderHisDataHttp();
    }else if(_selectAssetEntrustmentType == '持仓'){
      _wpSpotInvestorPositionPage = 1;
      _WpSpotInvestorPositionDataHttp();
    }else if(_selectAssetEntrustmentType == '资产'){
      _WpSpotTradingAccountDataHttp();
    }else{

    }
  }
}