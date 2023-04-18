import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/HttpRequest.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Base/MyTextInputFormatter.dart';
import 'package:amclient_flutter/NPFutures/Http/NPFuturesHttpRequest.dart';
import 'package:amclient_flutter/NPFutures/Model/NPFuturesIndexResponseModel.dart';
import 'package:amclient_flutter/NPFutures/Model/NPFuturesSocketModel.dart';
import 'package:amclient_flutter/WPFutures/View/WPFuturesViewWidget.dart';
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

class NPFuturesIndexView extends StatefulWidget {
  final arguments;
  const NPFuturesIndexView({Key? key, this.arguments}) : super(key: key);

  @override
  _NPFuturesIndexViewState createState() => _NPFuturesIndexViewState();
}
class _NPFuturesIndexViewState extends State<NPFuturesIndexView> with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin {

  //币对选择页面是否显示
  bool _isShowCurrencyPick = true;
  //外盘期货交易所信息
  List<NpFuturesExchangeInfoListData>? _npFuturesExchangeList = [];
  //选择的交易所
  String? _selectIndexExchangeNo = '';
  String _tempExchangeNo = '';

  //内盘期货产品信息
  List<NpFuturesExchangeProductListData>? _npFuturesExchangeProductList = [];
  List<NpFuturesExchangeProductListData>? _tempNpFuturesExchangeProductList = [];
  //选择的内盘期货交易所期货品种ID
  String? _selectIndexExchangeProductID = '';
  String _tempExchangeProductID = '';
  //选择的内盘期货交易所期货品种No
  String? _selectIndexExchangeProductNo = '';
  //该品种下的交易货币
  String? _selectIndexTradeCurrency = 'CNY';
  String _tempTradeCurrency = '';

  //内盘期货交易所期货合约信息管理
  List<NpFuturesExchangeInstrumentListData>? _npFuturesExchangeInstrumentList = [];
  List<NpFuturesExchangeInstrumentListData>? _tempNpFuturesExchangeInstrumentList = [];
  //选择的内盘期货交易所期货合约ID
  String? _selectIndexContractNo = '';
  String? _selectIndexContractID = '';
  String _tempContractID = '';
  String? _selectIndexInstrumentID = '';
  //选择的内盘期货交易所期货合约对象
  NpFuturesExchangeInstrumentListData? _selectIndexExchangeInstrumentData;

  //内盘期货资金账号资金信息
  List<NpfuturesTradingAccountListData>? _npFuturesTradingAccountList = [];

  //内盘期货成交
  List<NpfuturesTradeListData>? _npFuturesTradeList = [];
  int _npFuturesTradePage = 1;
  bool? _npFuturesTradehasNextPage = false;

  //内盘期货所有持仓信息
  List<NpfuturesInvestorPositionListData>? _npFuturesInvestorPositionList = [];
  int _npFuturesInvestorPositionPage = 1;
  bool? _npFuturesInvestorPositionhasNextPage = false;

  //内盘期货委托订单
  List<NpfuturesOrderListData>? _npFuturesOrderList= [];
  int _npFuturesOrderInfoPage = 1;
  bool? _npFuturesOrderInfohasNextPage = false;

  //内盘期货历史委托订单
  List<NpfuturesOrderListData>? _npFuturesOrderHisList= [];
  int _npFuturesOrderInfoHisPage = 1;
  bool? _npFuturesOrderInfoHishasNextPage = false;

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
  final List _selectTransactionPanelTypeName = ['限价委托','市价委托'];

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
    _NPFuturesNpfuturesExchangeQryCtpCommonDataHttp();
    _channel = IOWebSocketChannel.connect(kNPFuturesSocketAddress);
    _isSocektOn = true;
    _channel.stream.listen(_onData, onError: _onError, onDone: _onDone);
    //底部栏切换动作 1：点击到当前页面是 应该有一次刷新动作 2：socket应该重连一次，3：离开时关闭socket
    neverBus.on('pageController', (object) {
      if(!mounted){
        return;
      }
      setState(() {
        if(object == '/NPFuturesIndexView') {
          print("打开内盘期货界面");
          setState(() {
            _isShowCurrencyPick = true;
          });
          _NPFuturesNpfuturesExchangeQryCtpCommonDataHttp();
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
      _NPFuturesNpfuturesExchangeQryCtpCommonDataHttp();
      _NpfuturesNpfuturesExchangeInstrumentNpfuturesExchangeContractInitHttp();
    });
    neverBus.on('NPFuturesIndexReload', (object){
      if(!mounted){
        return;
      }
      _NPFuturesNpfuturesExchangeDataHttp();
      _NpfuturesNpfuturesTradingAccountDataHttp();
    });
    _NpfuturesNpfuturesExchangeInstrumentNpfuturesExchangeContractInitHttp();

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

  //初始化内盘期货部分公共数据
  Future _NPFuturesNpfuturesExchangeQryCtpCommonDataHttp() async{
    var response = await NPFuturesNpfuturesExchangeQryCtpCommonData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        _NPFuturesNpfuturesExchangeDataHttp();
        _NpfuturesNpfuturesTradingAccountDataHttp();
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

  //内盘期货交易所信息
  Future _NPFuturesNpfuturesExchangeDataHttp() async{
    var response = await NPFuturesNpfuturesExchangeData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _npFuturesExchangeList = NpFuturesExchangeInfoResponseData.fromJson(response).object;
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

  //内盘期货交易所期货产品表
  Future _NpfuturesNpfuturesExchangeProductDataHttp({String exchangeID = ''}) async{
    var response = await NpfuturesNpfuturesExchangeProductData(exchangeID: exchangeID);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _npFuturesExchangeProductList = NpFuturesExchangeProductResponseData.fromJson(response).object;
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

  //内盘期货交易所期货合约表
  Future _NpfuturesNpfuturesExchangeInstrumentDataHttp({String exchangeID = '',String instrumentID = '',String productID = ''}) async{
    var response = await NpfuturesNpfuturesExchangeInstrumentData(exchangeID: exchangeID,instrumentID:instrumentID,productID:productID);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _npFuturesExchangeInstrumentList = NpFuturesExchangeInstrumentResponseData.fromJson(response).object;
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

  //内盘期货交易所期货合约 -默认款
  Future _NpfuturesNpfuturesExchangeInstrumentNpfuturesExchangeContractInitHttp() async{
    var response = await NpfuturesNpfuturesExchangeInstrumentNpfuturesExchangeContractInit();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        if(response["object"].toString() == 'null'){
          return;
        }
        setState(() {
          _selectIndexExchangeInstrumentData = NpFuturesExchangeInstrumentListData.fromJson(response["object"]);
          _selectIndexExchangeNo = _selectIndexExchangeInstrumentData!.exchangeID;
          _selectIndexExchangeProductNo = _selectIndexExchangeInstrumentData!.productID;
          _selectIndexContractNo = _selectIndexExchangeInstrumentData!.instrumentName;
          _selectIndexInstrumentID = _selectIndexExchangeInstrumentData!.instrumentID;
          _selectIndexContractID = _selectIndexExchangeInstrumentData!.id;
          _selectIndexTradeCurrency = 'CNY';
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

  //查询内盘期货委托订单表
  Future _NpfuturesNpfuturesOrderDataHttp() async{
    var response = await NpfuturesNpfuturesOrderData(page: _npFuturesOrderInfoPage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          if (_npFuturesOrderInfoPage == 1) {
            _npFuturesOrderList = NpfuturesOrderResponseData.fromJson(response).rows;
          } else {
            _npFuturesOrderList!.addAll(NpfuturesOrderResponseData.fromJson(response).rows!.toList());
          }
          _npFuturesOrderInfohasNextPage = NpfuturesOrderResponseData.fromJson(response).hasNext ?? false;
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

  //查询内盘期货历史委托订单表
  Future _NpfuturesNpfuturesOrderHisDataHttp() async{
    var response = await NpfuturesNpfuturesOrderHisData(page: _npFuturesOrderInfoHisPage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          if (_npFuturesOrderInfoHisPage == 1) {
            _npFuturesOrderHisList = NpfuturesOrderResponseData.fromJson(response).rows;
          } else {
            _npFuturesOrderHisList!.addAll(NpfuturesOrderResponseData.fromJson(response).rows!.toList());
          }
          _npFuturesOrderInfoHishasNextPage = NpfuturesOrderResponseData.fromJson(response).hasNext ?? false;
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

  //查询内盘期货成交表
  Future _NpfuturesNpfuturesTradeDataHttp() async{
    var response = await NpfuturesNpfuturesTradeData(page: _npFuturesTradePage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          if (_npFuturesTradePage == 1) {
            _npFuturesTradeList = NpfuturesTradeResponseData.fromJson(response).rows;
          } else {
            _npFuturesTradeList!.addAll(NpfuturesTradeResponseData.fromJson(response).rows!.toList());
          }
          _npFuturesTradehasNextPage = NpfuturesTradeResponseData.fromJson(response).hasNext ?? false;
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

  //查询内盘期货持仓汇总表
  Future _NpfuturesNpfuturesInvestorPositionDataHttp() async{
    var response = await NpfuturesNpfuturesInvestorPositionData(page: _npFuturesInvestorPositionPage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          if (_npFuturesInvestorPositionPage == 1) {
            _npFuturesInvestorPositionList = NpfuturesInvestorPositionResponseData.fromJson(response).rows;
          } else {
            _npFuturesInvestorPositionList!.addAll(NpfuturesInvestorPositionResponseData.fromJson(response).rows!.toList());
          }
          _npFuturesInvestorPositionhasNextPage = NpfuturesInvestorPositionResponseData.fromJson(response).hasNext ?? false;
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

  //内盘期货委托批量撤单
  Future _NpfuturesNpfuturesOrderBatchCancelOrderHttp() async{
    var response = await NpfuturesNpfuturesOrderBatchCancelOrder();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        showMyCustomText("批量撤单成功");
        Future.delayed(const Duration(milliseconds: 300)).then((onValue) async{
          _npFuturesOrderInfoPage = 1;
          _NpfuturesNpfuturesOrderDataHttp();
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

  //内盘期货委托撤单
  Future _NpfuturesNpfuturesOrderOrderActionHttp({String instrumentID = '',String investorID = '',String orderRef = '',String frontID = '',String sessionID = ''}) async{
    var response = await NpfuturesNpfuturesOrderOrderAction(
        instrumentID: instrumentID,
        investorID:investorID,
        orderRef:orderRef,
        frontID:frontID,
        sessionID:sessionID,
    );
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        showMyCustomText("撤单成功");
        Future.delayed(const Duration(milliseconds: 300)).then((onValue) async{
          _npFuturesOrderInfoPage = 1;
          _NpfuturesNpfuturesOrderDataHttp();
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

  //内盘期货委托下单
  Future _NpfuturesNpfuturesOrderOrderInsertHttp({String combHedgeFlag = '',String combOffsetFlag = '',String direction = '', String exchangeID = '',String instrumentID = '',String investorID = '', String limitPrice = '',String orderPriceType = '',String volumeTotalOriginal = '',}) async{
    var response = await NpfuturesNpfuturesOrderOrderInsert(
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


  //Socket订阅语句
  _onSendSocket(){
//_selectIndexExchangeNo!.toUpperCase() + "." + _selectIndexExchangeProductNo!.toUpperCase() + "." + _selectIndexInstrumentID!.toUpperCase()
    if(_selectIndexInstrumentID! == ''){
      print("无数据不发sub");
      return;
    }
    String subsStr= "{\"subs\":\"quote.npfutures.ctp." + _selectIndexInstrumentID! + ".entrust,"
        + "quote.npfutures.ctp." + _selectIndexInstrumentID! + ".trade,"
        + "quote.npfutures.ctp." + _selectIndexInstrumentID! + ".kline." + _selectKlineTimeType
        + "\"}";

    // print(subsStr + DateTime.now().toString());
    _channel.sink.add(subsStr);
  }

  _onSendUnSocket(){
    if(_selectIndexInstrumentID! == ''){
      print("无数据不发unsub");
      return;
    }
    String subsStr= "{\"unsubs\":\"quote.npfutures.ctp." + _selectIndexInstrumentID! + ".entrust,"
        + "quote.npfutures.ctp." + _selectIndexInstrumentID! + ".trade,"
        + "quote.npfutures.ctp." + _selectIndexInstrumentID! + ".kline." + _selectKlineTimeType
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
      if(_initDateMap["ticker"].toString() != '' && _initDateMap["ticker"].toString() != 'null'){
        // print(_initDateMap["ticker"]);
        setState(() {
          Map _socketTickerMap = jsonDecode(_initDateMap["ticker"]);
          _socketTickerModel = NpFuturesSocketTickerModel.fromJson(_socketTickerMap);
        });
      }
      //K线 - 完成
      if(_initDateMap["klines"].toString() != '' && _initDateMap["klines"].toString() != 'null'){
        List _list = jsonDecode(_initDateMap["klines"].toString());
        if(_list.isNotEmpty){
          if(_list.first['commodityCode'].toString() == _selectIndexExchangeProductNo! && _list.first['contractCode'].toString() == _selectIndexInstrumentID! && _list.first['exchange'].toString() == _selectIndexExchangeNo!){
            if(_KLineList == null || _KLineList!.isEmpty || _KLineList!.last.commodityCode.toString() != _selectIndexExchangeProductNo! || _KLineList!.last.contractCode.toString() != _selectIndexInstrumentID! || _KLineList!.last.exchange.toString() != _selectIndexExchangeNo!){
              _KLineList = _list.map((item) => KLineEntity.wpfromJson(item)).toList().cast<KLineEntity>();
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
        if(_initDateMap['topic'] == ("quote.npfutures.ctp." + _selectIndexInstrumentID!)){
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
    print("外盘期货WebSocket错误");
    WebSocketChannelException ex = err;
    print(ex);
    _isSocektOn = false;
  }

  _onDone(){
    print("外盘期货WebSocket断开");
    _isSocektOn = false;
  }

  _onRest(){
    print("外盘期货WebSocket重连");
    _channel=IOWebSocketChannel.connect(kNPFuturesSocketAddress);//brokerId=9999
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
    return SafeArea(
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("内盘期货"),
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
                          child: _selectWpFuturesExchangeView(),
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

  //外盘期货交易所/合约/品种 选择页面
  Widget _selectWpFuturesExchangeView(){
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
        width: 560,
        margin: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: ListView.builder(
                  controller: _controller1,
                  scrollDirection : Axis.vertical,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _tempExchangeNo == _npFuturesExchangeList![index].exchangeID! ? APP_MainGreenColor : APP_MainBarColor,
                          borderRadius:const  BorderRadius.all(Radius.circular(5.0)),
                          boxShadow:const  [
                            BoxShadow(
                                blurRadius: 5, //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.black, //阴影颜色
                                offset:Offset(3,3)
                            ),
                          ],
                        ),
                        child: Container(
                          child: Text(_npFuturesExchangeList![index].exchangeID! + " " + _npFuturesExchangeList![index].exchangeName!
                              + (_tempExchangeNo == _npFuturesExchangeList![index].exchangeID! ? "  >" : '')
                            ,style: const TextStyle(color: Colors.white,fontSize: 11),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        setState(() {
                          _tempExchangeNo = _npFuturesExchangeList![index].exchangeID!;
                          _npFuturesExchangeProductList!.clear();
                          _npFuturesExchangeInstrumentList!.clear();
                          _NpfuturesNpfuturesExchangeProductDataHttp(exchangeID:_npFuturesExchangeList![index].exchangeID!);
                        });
                      },
                    );
                  },
                  itemCount: _npFuturesExchangeList!.length,
                ),
              ),
              flex: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: APP_MainGreenColor,
                //边框圆角设置
                border: Border.all(width: 1, color: const Color.fromRGBO(15, 159, 131, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
              ),
              child: const Text(""),
              alignment: Alignment.center,
              width: 3,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: ListView.builder(
                  controller: _controller2,
                  scrollDirection : Axis.vertical,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _tempExchangeProductID == _npFuturesExchangeProductList![index].id! ? APP_MainGreenColor : APP_MainBarColor,
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 5, //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.black, //阴影颜色
                                offset:Offset(3,3)
                            ),
                          ],
                        ),
                        child: Container(
                          child: Text(_npFuturesExchangeProductList![index].productName!
                              + (_tempExchangeProductID == _npFuturesExchangeProductList![index].id! ? "  >" : '')
                            ,style: const TextStyle(color: Colors.white,fontSize: 11),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        setState(() {
                          _tempExchangeProductID = _npFuturesExchangeProductList![index].id!;
                          _tempTradeCurrency = _npFuturesExchangeProductList![index].tradeCurrencyID!;
                          _npFuturesExchangeInstrumentList!.clear();
                          _NpfuturesNpfuturesExchangeInstrumentDataHttp(exchangeID: _npFuturesExchangeProductList![index].exchangeID!,productID: _npFuturesExchangeProductList![index].productID!);
                        });
                      },
                    );
                  },
                  itemCount: _npFuturesExchangeProductList!.length,
                ),
              ),
              flex: 9,
            ),
            Container(
              decoration: BoxDecoration(
                color: APP_MainGreenColor,
                //边框圆角设置
                border: Border.all(width: 1, color: const Color.fromRGBO(15, 159, 131, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
              ),
              child: const Text(""),
              alignment: Alignment.center,
              width: 3,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: ListView.builder(
                  controller: _controller3,
                  scrollDirection : Axis.vertical,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _tempContractID == _npFuturesExchangeInstrumentList![index].id! ? APP_MainGreenColor : APP_MainBarColor,
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow:const  [
                            BoxShadow(
                                blurRadius: 5, //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.black, //阴影颜色
                                offset:Offset(3,3)
                            ),
                          ],
                        ),
                        child: Container(
                          child: Text(_npFuturesExchangeInstrumentList![index].instrumentName!,style: const TextStyle(color: Colors.white,fontSize: 11),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        setState(() {

                          if(_selectIndexExchangeNo != "" && _selectIndexExchangeProductNo != "" && _selectIndexInstrumentID != ""){
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

                          _selectIndexExchangeProductID = _tempExchangeProductID;
                          _selectIndexTradeCurrency = _tempTradeCurrency;
                          _selectIndexExchangeProductNo = _npFuturesExchangeInstrumentList![index].productID!;
                          _tempNpFuturesExchangeProductList!.clear();
                          _tempNpFuturesExchangeProductList!.addAll(_npFuturesExchangeProductList!);

                          _selectIndexContractNo = _npFuturesExchangeInstrumentList![index].instrumentName!;
                          _selectIndexInstrumentID = _npFuturesExchangeInstrumentList![index].instrumentID!;
                          _selectIndexContractID = _npFuturesExchangeInstrumentList![index].id!;
                          _tempNpFuturesExchangeInstrumentList!.clear();
                          _tempNpFuturesExchangeInstrumentList!.addAll(_npFuturesExchangeInstrumentList!);

                          _selectIndexExchangeInstrumentData= _npFuturesExchangeInstrumentList![index];

                          if(_selectIndexExchangeNo != "" && _selectIndexExchangeProductNo != "" && _selectIndexInstrumentID != ""){
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
                  },
                  itemCount: _npFuturesExchangeInstrumentList!.length,
                ),
              ),
              flex: 9,
            ),
          ],
        ),
        padding: const EdgeInsets.all(5),
      ),
      behavior: HitTestBehavior.opaque,
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  //外面期货当前选择合约的行情
  Widget _selectTickerView(){

    String _selectTickerHigh = ''; // 今日最高价
    String _selectTickerLow = ''; // 今日最低价
    String _selectTickerLast = ''; // 最新价
    String _selectTickerChangeRate = ''; //涨跌幅
    String _selectTickerTotalQty = ''; // 总成交量
    String _selectTickerOpeningPrice = '';//开盘价
    String _selectTickerOpeningPreSettlePrice = '';//昨日结算价
    String _selectTickerOpeningPreClosingPrice = '';//昨日收盘价
    String _selectTickerOpeningPositionQty = '';//持仓量
    // String _selectTickerOpeningTotalValue = '';//总市值

    if(_socketTickerModel != null){
      _selectTickerLast = _socketTickerModel!.lastPrice!;//最新价

      if(neverDoubleTryOrZero(_socketTickerModel!.preSettlementPrice!) == 0.0){
        _selectTickerChangeRate = '0.0';
      }else{
        _selectTickerChangeRate = ((neverDoubleTryOrZero(_socketTickerModel!.lastPrice!) - neverDoubleTryOrZero(_socketTickerModel!.preSettlementPrice!)) / neverDoubleTryOrZero(_socketTickerModel!.preSettlementPrice!)).toString();//涨跌幅
      }
      _selectTickerHigh = _socketTickerModel!.highestPrice!;//当日最高价
      _selectTickerLow = _socketTickerModel!.lowestPrice!;//当日最低价
      _selectTickerTotalQty = _transformationNum(neverDoubleTryOrZero(_socketTickerModel!.volume!),dec: 2);//当日总成交量
      _selectTickerOpeningPrice = _socketTickerModel!.openPrice!;//开盘价
      _selectTickerOpeningPreSettlePrice = _socketTickerModel!.preSettlementPrice!;//昨日结算价
      _selectTickerOpeningPreClosingPrice = _socketTickerModel!.preClosePrice!;//昨日收盘价
      _selectTickerOpeningPositionQty = _transformationNum(neverDoubleTryOrZero(_socketTickerModel!.openInterest!),dec: 2);//持仓量
      // _selectTickerOpeningTotalValue = _transformationNum(neverDoubleTryOrZero(_socketTickerModel!.qTotalValue!),dec: 2);//总市值
    }else{
      _selectTickerLast = "";//最新价
      _selectTickerChangeRate = "";//涨跌幅
      _selectTickerHigh = "";//当日最高价
      _selectTickerLow = "";//当日最低价
      _selectTickerTotalQty = "";//当日总成交额
      _selectTickerOpeningPrice = "";//开盘价
      _selectTickerOpeningPreSettlePrice = "";//昨日结算价
      _selectTickerOpeningPreClosingPrice = "";//昨日收盘价
      _selectTickerOpeningPositionQty = "";//持仓量
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
                    _tempExchangeProductID = _selectIndexExchangeProductID!;//这个是产品的临时判定
                    _tempTradeCurrency = _selectIndexTradeCurrency!;
                    _npFuturesExchangeProductList!.clear();
                    _npFuturesExchangeProductList!.addAll(_tempNpFuturesExchangeProductList!);
                    _tempContractID = _selectIndexContractID!;//这个是合约的临时判定
                    _npFuturesExchangeInstrumentList!.clear();
                    _npFuturesExchangeInstrumentList!.addAll(_tempNpFuturesExchangeInstrumentList!);
                    _NPFuturesNpfuturesExchangeDataHttp();
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
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("昨日结算价" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")"),style: const TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerOpeningPreSettlePrice,style: const TextStyle(fontSize: 14,color: Colors.white),),
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
                  child: const Text("持仓量" + "(手)" ,style: TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerOpeningPositionQty,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          // Container(
          //   padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Container(
          //         child: Text("总市值" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")"),style: TextStyle(fontSize: 10,color: Colors.grey),),
          //         alignment: Alignment.center,
          //       ),
          //       Container(
          //         child: Text(_selectTickerOpeningTotalValue,style: TextStyle(fontSize: 14,color: Colors.white),),
          //         padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          //         alignment: Alignment.center,
          //       )
          //     ],
          //   ),
          // ),
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
                                      String subsStr= "{\"unsubs\":\"quote.npfutures.ctp." + _selectIndexInstrumentID! + ".kline." + _selectKlineTimeType
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
                                      String subsStr= "{\"subs\":\"quote.npfutures.ctp." + _selectIndexInstrumentID! + ".kline." + _selectKlineTimeType
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
                                    controller: _controller8,
                                    reverse : true,
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

  //交易面板/合约介绍面板
  int _decSize = 8;//全局小数位数
  Widget _TransactionPanelWidget(){

    String _equity = '-';
    String _available = '-';
    String _balanceToPreBalance = '-';
    String _balanceXpreBalance = "-";
    if(_npFuturesTradingAccountList != null && _npFuturesTradingAccountList!.isNotEmpty){
      _equity = _npFuturesTradingAccountList!.first.balance!;
      _available = _npFuturesTradingAccountList!.first.available!;
      _balanceToPreBalance = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_npFuturesTradingAccountList!.first.balance!) - neverDoubleTryOrZero(_npFuturesTradingAccountList!.first.preBalance!), 2)).toString();
      if(neverDoubleTryOrZero(_npFuturesTradingAccountList!.first.preBalance!) == 0.0){
        _balanceXpreBalance = '0.0%';
      }else{
        _balanceXpreBalance = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(_npFuturesTradingAccountList!.first.balance!) - neverDoubleTryOrZero(_npFuturesTradingAccountList!.first.preBalance!)) / neverDoubleTryOrZero(_npFuturesTradingAccountList!.first.preBalance!) * 100, 2)).toString() + '%';
      }
    }else{
      _equity = '-';
      _available = '-';
      _balanceToPreBalance = '-';
      _balanceXpreBalance = "-";
    }

    String _instrumentName = '-';//合约名称
    String _instrumentID = '-';//合约代码
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
      _productClass = _findTrans(_npFuturesTranslate!,"ProductClass",_selectIndexExchangeInstrumentData!.productClass!);//要翻译
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
                    child: ListView.builder(
                      controller: _controller11,
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
                              _selectTransactionPanelType = _selectTransactionPanelTypeName[index];
                              if(_selectTransactionPanelType == '市价委托' || _selectTransactionPanelType == '市价止损'){
                                _transactionPriceController.text = '';
                                _transactionAmountController.text = '';
                              }
                            });
                          },
                        );
                      },
                      itemCount: _selectTransactionPanelTypeName.length,
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
                                hintText: (_selectTransactionPanelType == '限价委托' || _selectTransactionPanelType == '限价止损') ? '请输入单价' : '以当前市场最优价格下单',
                                hintStyle: const TextStyle(color: Colors.grey,fontSize: 11),
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
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: const Text("今权益:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_equity,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: const Text("净盈亏:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_balanceToPreBalance,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
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
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: const Text("盈利率:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_balanceXpreBalance,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                ),
                              ),
                            ],
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
                                      child: const Text("买入开仓",style: TextStyle(fontSize: 14,color: Colors.white),),
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
                                      }
                                      String _orderTypeS = '2';
                                      if(_selectTransactionPanelType == '市价委托'){
                                        _orderTypeS = '1';
                                      }else if(_selectTransactionPanelType == '限价委托'){
                                        _orderTypeS = '2';
                                      }else{
                                        return;
                                      }
                                      _NpfuturesNpfuturesOrderOrderInsertHttp(
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
                                      child: const Text("卖出开仓",style: TextStyle(fontSize: 14,color: Colors.white),),
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
                                      }

                                      String _orderTypeS = '2';
                                      if(_selectTransactionPanelType == '市价委托'){
                                        _orderTypeS = '1';
                                      }else if(_selectTransactionPanelType == '限价委托'){
                                        _orderTypeS = '2';
                                      }else{
                                        return;
                                      }

                                      _NpfuturesNpfuturesOrderOrderInsertHttp(
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
                    child: const Text("合约信息",style: TextStyle(color: Colors.white,fontSize: 13),),
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
                                  child: const Text("合约名称:",style: TextStyle(color: Colors.grey,fontSize: 11),),
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
                                  child: const Text("合约代码:",style: TextStyle(color: Colors.grey,fontSize: 11),),
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
                                  child: const Text("合约数量乘数:",style: TextStyle(color: Colors.grey,fontSize: 11),),
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
                        child: const Text("合约",style: TextStyle(fontSize: 10,color: Colors.grey),),
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
                            _NpfuturesNpfuturesOrderBatchCancelOrderHttp();
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
                        child: const Text("合约",style: TextStyle(fontSize: 10,color: Colors.grey),),
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
                        child: const Text("合约",style: TextStyle(fontSize: 10,color: Colors.grey),),
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
                        child: const Text("合约代码",style: TextStyle(fontSize: 10,color: Colors.grey),),
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
                    Expanded(
                      child: Container(
                        child: const Text("持仓占用",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
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
                                              child: const Text("占用保证金:",style: TextStyle(color: Colors.grey,fontSize: 13),),//交易所保证金
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
                                            Container(//_npFuturesTradingAccountList![index].preBalance!
                                              child: Text(_npFuturesTradingAccountList![index].reserveBalance!,style: const TextStyle(color: Colors.white,fontSize: 13),),
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
                        _NpfuturesNpfuturesTradingAccountDataHttp();
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
                                child: Text(_npFuturesOrderList![index].exchangeID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderList![index].instrumentID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderList![index].orderLocalID!.trim(),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "ComboOffsetFlag", _npFuturesOrderList![index].combOffsetFlag!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "Direction", _npFuturesOrderList![index].direction!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderList![index].limitPrice!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderList![index].volumeTotalOriginal!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding:const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "OrderStatus", _npFuturesOrderList![index].orderStatus!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderList![index].insertDate! + ' ' + _npFuturesOrderList![index].insertTime!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderList![index].statusMsg!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
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
                                      _NpfuturesNpfuturesOrderOrderActionHttp(
                                        instrumentID:_npFuturesOrderList![index].instrumentID!,
                                        investorID:_npFuturesOrderList![index].investorID!,
                                        orderRef:_npFuturesOrderList![index].orderRef!,
                                        frontID: _npFuturesOrderList![index].frontID!,
                                        sessionID: _npFuturesOrderList![index].sessionID!,
                                      );
                                    },
                                  ),
                                  offstage: (_npFuturesOrderList![index].orderStatus! == "1" || _npFuturesOrderList![index].orderStatus! == "3") ? false : true,
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
                    itemCount: _npFuturesOrderList!.length,
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
                  footer: _npFuturesOrderInfohasNextPage!
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
                        _npFuturesOrderInfoPage = 1;
                        _NpfuturesNpfuturesOrderDataHttp();
                      }
                    });
                  },
                  onLoad: _npFuturesOrderInfohasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _npFuturesOrderInfoPage += 1;
                        _NpfuturesNpfuturesOrderDataHttp();
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
                                child: Text(_npFuturesOrderHisList![index].exchangeID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderHisList![index].instrumentID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderHisList![index].orderLocalID!.trim(),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "ComboOffsetFlag", _npFuturesOrderHisList![index].combOffsetFlag!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "Direction", _npFuturesOrderHisList![index].direction!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderHisList![index].limitPrice!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderHisList![index].volumeTotalOriginal!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "OrderStatus", _npFuturesOrderHisList![index].orderStatus!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderHisList![index].insertDate! + ' ' + _npFuturesOrderHisList![index].insertTime!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesOrderHisList![index].statusMsg!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                          ],
                        ),

                      );
                    },
                    itemCount: _npFuturesOrderHisList!.length,
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
                  footer: _npFuturesOrderInfoHishasNextPage!
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
                        _npFuturesOrderInfoHisPage = 1;
                        _NpfuturesNpfuturesOrderHisDataHttp();
                      }
                    });
                  },
                  onLoad: _npFuturesOrderInfoHishasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _npFuturesOrderInfoHisPage += 1;
                        _NpfuturesNpfuturesOrderHisDataHttp();
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
                                child: Text(_npFuturesTradeList![index].investorID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesTradeList![index].exchangeID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesTradeList![index].instrumentID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesTradeList![index].tradeID!.trim(),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "Direction", _npFuturesTradeList![index].direction!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text( _npFuturesTradeList![index].price!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text( _npFuturesTradeList![index].volume!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesTradeList![index].tradeDate! + " " + _npFuturesTradeList![index].tradeTime!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: _npFuturesTradeList!.length,
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
                  footer: _npFuturesTradehasNextPage!
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
                        _npFuturesTradePage = 1;
                        _NpfuturesNpfuturesTradeDataHttp();
                      }
                    });
                  },
                  onLoad: _npFuturesTradehasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _npFuturesTradePage += 1;
                        _NpfuturesNpfuturesTradeDataHttp();
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
                      if(_npFuturesInvestorPositionList![index].posiDirection! == '1'){
                        _todoSell = '卖出';
                        _todoSellColor = Colors.white;
                      }else if(_npFuturesInvestorPositionList![index].posiDirection! == '2'){
                        _todoSell = '多头平仓';
                        _todoSellColor = APP_MainRedColor;
                      }else if(_npFuturesInvestorPositionList![index].posiDirection! == '3'){
                        _todoSell = '空头平仓';
                        _todoSellColor = APP_MainGreenColor;
                      }else{
                        _todoSell = '';
                        _todoSellColor = Colors.white;
                      }

                      return Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesInvestorPositionList![index].investorID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesInvestorPositionList![index].exchangeID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesInvestorPositionList![index].instrumentID!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_npFuturesTranslate!, "PosiDirection", _npFuturesInvestorPositionList![index].posiDirection!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(//PositionDate
                                child: Text(_findTrans(_npFuturesTranslate!, "PositionDate", _npFuturesInvestorPositionList![index].positionDate!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesInvestorPositionList![index].position!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesInvestorPositionList![index].positionCost!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesInvestorPositionList![index].useMargin!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_npFuturesInvestorPositionList![index].positionProfit!,style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500,
                                    color:  neverDoubleTryOrZero(_npFuturesInvestorPositionList![index].positionProfit!) >= 0 ? APP_MainGreenColor : APP_MainRedColor),),
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
                                      _npFuturesInvestorPositionList![index],
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
                    itemCount: _npFuturesInvestorPositionList!.length,
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
                  footer: _npFuturesInvestorPositionhasNextPage!
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
                        _npFuturesInvestorPositionPage = 1;
                        _NpfuturesNpfuturesInvestorPositionDataHttp();
                      }
                    });
                  },
                  onLoad: _npFuturesInvestorPositionhasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _npFuturesInvestorPositionPage += 1;
                        _NpfuturesNpfuturesInvestorPositionDataHttp();
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
                        if(_selectAssetEntrustmentType == '历史成交'){
                          _npFuturesTradePage = 1;
                          _NpfuturesNpfuturesTradeDataHttp();
                        }
                        if(_selectAssetEntrustmentType == '当前委托'){
                          _npFuturesOrderInfoPage = 1;
                          _NpfuturesNpfuturesOrderDataHttp();
                        }
                        if(_selectAssetEntrustmentType == '历史委托'){
                          _npFuturesOrderInfoHisPage = 1;
                          _NpfuturesNpfuturesOrderHisDataHttp();
                        }
                        if(_selectAssetEntrustmentType == '持仓'){
                          _npFuturesInvestorPositionPage = 1;
                          _NpfuturesNpfuturesInvestorPositionDataHttp();
                        }
                        if(_selectAssetEntrustmentType == '资产'){
                          _NpfuturesNpfuturesTradingAccountDataHttp();
                        }
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


  //交易面板/合约介绍面板 弹窗版本
  Widget _TransactionPanelSignalWidget(NpfuturesInvestorPositionListData data,{String todoSell = ''}){

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
                    child: Text( "交易所代码: " + data.exchangeID! + ' 合约代码: ' + data.instrumentID! + ' 最小变动价位:' + data.priceTick!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
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
                        if(_transactionNumberInsideController.text == ''){
                          showMyCustomText("请输入交易数量");
                          return;
                        }


                        double _canPosition = 0.0;
                        if(data.posiDirection! == '2'){//多头持仓下可平数量=持仓数量-空头冻结数量
                          _canPosition = neverDoubleTryOrZero(data.position!) - neverDoubleTryOrZero(data.shortFrozen!);
                        }else if(data.posiDirection! == '3'){//多头持仓下可平数量=持仓数量-空头冻结数量
                          _canPosition = neverDoubleTryOrZero(data.position!) - neverDoubleTryOrZero(data.longFrozen!);
                        }else{
                          _canPosition = neverDoubleTryOrZero(data.position!);
                        }

                        if(neverDoubleTryOrZero(_transactionNumberInsideController.text) > _canPosition){
                          showMyCustomText("下单数量不可大于可平数量");
                          return;
                        }


                        String _direction = '';
                        if(data.posiDirection! == '2') { //2 多头 卖
                          _direction = '1';
                        }else if(data.posiDirection! == '3') { //3 空头 买
                          _direction = '0';
                        }else{
                          _direction = '';
                        }

                        String _combOffsetFlag = '';
                        if(data.positionDate == '1'){
                          _combOffsetFlag = '3';
                        }else if(data.positionDate == '2'){
                          _combOffsetFlag = '1';
                        }else{
                          _combOffsetFlag = '';
                        }

                        Navigator.pop(tContext);

                        // print(_orderPriceType);
                        _NpfuturesNpfuturesOrderOrderInsertHttp(
                          combHedgeFlag:"1",
                          combOffsetFlag:_combOffsetFlag,
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
      _npFuturesTradePage = 1;
      _NpfuturesNpfuturesTradeDataHttp();
    }else if(_selectAssetEntrustmentType == '当前委托'){
      _npFuturesOrderInfoPage = 1;
      _NpfuturesNpfuturesOrderDataHttp();
    }else if(_selectAssetEntrustmentType == '历史委托'){
      _npFuturesOrderInfoHisPage = 1;
      _NpfuturesNpfuturesOrderHisDataHttp();
    }else if(_selectAssetEntrustmentType == '持仓'){
      _npFuturesInvestorPositionPage = 1;
      _NpfuturesNpfuturesInvestorPositionDataHttp();
    }else if(_selectAssetEntrustmentType == '资产'){
      _NpfuturesNpfuturesTradingAccountDataHttp();
    }else{

    }
  }
}